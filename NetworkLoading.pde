void generate_network() {
  network = new Network(input_size, output_size, hidden_layers, neurons_per_layer);
  redraw();
}

void save_network() {
  selectOutput("Create Network file", "networkOutputSelected", new File(sketchPath() + "/models"));
}

void load_network() {
  selectInput("Select Network to load.", "networkSelected", new File(sketchPath() + "/models"));
}

//Makes a .nnf file (Neural Network File, I made it up) and stores network and parameters inside
void networkOutputSelected(File selection) {
  String ext = ".nnf";
  if (selection.getName().contains(".nnf")) {
    ext = "";
  }

  PrintWriter output = createWriter(selection.getAbsolutePath() + ext);

  try {
    output.println("#Metadata"); //Write all metadata to the file, the name and size of the model and hyperparameters

    output.println("Name=" + network_name);
    output.println("Layers=" + hidden_layers);
    output.println("NeuronsPerLayer=" + neurons_per_layer);
    output.println("InputSize=" + input_size);
    output.println("OutputSize=" + output_size);
    output.println("Epochs=" + epochs);
    output.println("Alpha=" + alpha);
    output.println("Activation=" + activation);
    output.println("Cost=" + loss);
    output.println("Randomized=" + randomize_weight_and_bias);

    output.println("#Data"); //Write all neurons and connections to the file

    for (int n = 0; n < network.layers.length; n++) { //Itterate through the layers

      output.println("Layer " + n);

      //Write all of this layer's neurons to the file
      output.println("Neurons");

      for (Neuron neuron : network.layers[n].neurons) {

        //String that holds all of the serial numbers for the neurons connected to this one, starting with itself
        String connection_string = str(neuron.serial);
        for (Connection c : neuron.connections) {
          connection_string += "," + c.b.serial;
        }

        output.println("Actvation=" + neuron.activation + ",Bias=" + neuron.bias + ",Serials=" + connection_string);
      }

      //Write all of this layer's connections to the last layer to the file
      //First layer doesen't have any connections to a previous layer, which is why this if statement is here
      if (network.layers[n].connections != null) {
        output.println("Connections");
        for (Connection connection : network.layers[n].connections) {
          output.println("Weight="+connection.weight+",A="+connection.a.serial+",B="+connection.b.serial);
        }
      }
    }

    //The following part of the code checks if the network was corruped in the save --> load process
    output.println("#CorruptionTest");

    //First create a set of random normalized inputs
    output.print("Inputs=");
    float[] test_inputs = random_inputs();
    for(float inp: test_inputs) {
      if (inp != test_inputs[0])
        output.print(",");
      output.print(inp);
    }

    //Feed the outputs through the network
    feed_forward(test_inputs);
    output.println();

    //Store the outputs in the file
    output.print("Outputs=");
    for (int i = 0; i < output_size; i++) {
      if (i > 0)
        output.print(",");
      output.print(network.layers[network.layers.length-1].neurons[i].activation);
    }

    //Any small change in the network will cause the output to change, so if the network loaded gives a different output array, then we know it was corrupted.
  }
  catch(Exception e) {
    println("Could not save network, " + e);
  }

  output.flush();
  output.close();

  println("Saved " + selection.getName() + " Successfully.");
}


void networkSelected(File selection) {

  println("Loading " + selection.getName());

  try {

    String[] lines = loadStrings(selection.getCanonicalPath()); //Break file into lines

    String current_tag = ""; //Tag we're reading for

    int curr_layer = -1;
    int curr_neuron = 0;
    int curr_connection = 0;

    boolean searching_for_neurons = false;

    float[] input_test = new float[0];
    float[] output_test = new float[0];

    for (String text_line : lines) {

      if (text_line.charAt(0) == '#') { //Change tag
        current_tag = text_line;
        if (current_tag.contains("#Data")) //Reset the network with new parameters
          generate_network();
        
      } 
      else if (text_line.substring(0, 1) != "//") { //Don't read line if it's a comment

        if (current_tag.contains("#Metadata")) {

          int equals_index = text_line.indexOf("=")+1;
          String param = text_line.substring(0, equals_index-1);
          String val = text_line.substring(equals_index);
          
          if(param.contains("Name"))
            network_name = val;
            
          else if(param.contains("Layers"))
            hidden_layers = int(val);
            
          else if(param.contains("NeuronsPerLayer"))
            neurons_per_layer = int(val);
            
          else if(param.contains("InputSize"))
            input_size = int(val);
            
          else if(param.contains("OutputSize"))
            output_size = int(val);
            
          else if(param.contains("Epochs"))
            epochs = int(val);
            
          else if(param.contains("Alpha"))
            alpha = float(val);
            
          else if(param.contains("Activation"))
            activation = int(val);
            
          else if(param.contains("Cost"))
            loss = int(val);
            
          else if(param.contains("Randomized"))
            randomize_weight_and_bias = boolean(val);
            
        } 
        else if (current_tag.contains("#Data")) {

          if (text_line.contains("Layer")) {
            curr_layer += 1;
            curr_neuron = 0;
            curr_connection = 0;
          } else if (text_line.contains("Neurons"))
            searching_for_neurons = true;


          else if (text_line.contains("Connections"))
            searching_for_neurons = false;

          else {

            String[] period_splits = text_line.split(",");

            //Load all Neurons
            if (searching_for_neurons) {
              Neuron neuron = network.layers[curr_layer].neurons[curr_neuron]; //Find neuron to load data into

              neuron.activation = float(period_splits[0].substring(period_splits[0].indexOf('=')+1)); //Load activation
              neuron.bias = float(period_splits[1].substring(period_splits[1].indexOf('=')+1)); //Load bias

              String serial_str = period_splits[2].substring(period_splits[2].indexOf('=')+1); //String of serial numbers
              neuron.serial = int(serial_str.substring(0)); //Set own Serial Number

              neuron.connections = new ArrayList<Connection>(); //initialize connected neurons list

              for (int i = 1; i < serial_str.length(); i++) { //Load every connection in previous layer
                neuron.connections.add(network.find_connection_by_serial(neuron.serial, int(serial_str.charAt(i)), curr_layer));
              }

              curr_neuron += 1;
            }

            //Load all connections
            else if (curr_layer > 0) {
              Connection c = network.layers[curr_layer].connections[curr_connection];

              c.weight = float(period_splits[0].substring(period_splits[0].indexOf('=')+1));
              c.a = network.find_neuron_by_serial(int(period_splits[1].substring(period_splits[1].indexOf('=')+1)), curr_layer-1);
              c.b = network.find_neuron_by_serial(int(period_splits[2].substring(period_splits[2].indexOf('=')+1)), curr_layer);

              curr_connection += 1;
            }
          }
        }

        if (current_tag.contains("#CorruptionTest")) {

          if (text_line.contains("Input")) {
            input_test = new float[input_size];
            String[] period_split = text_line.substring(text_line.indexOf("=")+1).split(",");
              
            for (int i = 0; i < input_size; i++)
              input_test[i] = float(period_split[i]);
              
              
          } 
          else if (text_line.contains("Output")) {
            String[] period_split = text_line.substring(text_line.indexOf("=")+1).split(",");
            output_test = new float[output_size];

            for (int i = 0; i < output_size; i++)
              output_test[i] = float(period_split[i]);
          }
        }
      }
    }
    
    //Test for corruption
    feed_forward(input_test);
    boolean corrupted = false;

    for (int i = 0; i < output_size; i++) {
      if (network.layers[network.layers.length-1].neurons[i].activation != output_test[i]) {
        corrupted = true;
        break;
      }
    }

    if (corrupted == true)
      throw new Exception("network file was corrupted or changed.");

    println("Loaded " + selection.getName() + " Successfully.");
  }
  catch(Exception e) {
    println("Error loading the network, " + e);
  }
  update_gui_values();
}
