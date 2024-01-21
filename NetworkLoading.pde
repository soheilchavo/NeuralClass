void generate_network(){
  network = new Network(input_size, output_size, hidden_layers, neurons_per_layer);
}

void save_network(){
  selectOutput("Create Network file", "networkOutputSelected");
}

void load_network(){
  selectInput("Select Network to load.", "networkSelected");
}

//Makes a .nnf file (Neural Network File, I made it up) and stores network and parameters inside
void networkOutputSelected(File selection){
  String ext = ".nnf";
  if(selection.getName().contains(".nnf")){
    ext = "";
  }
  
  PrintWriter output = createWriter(selection.getAbsolutePath() + ext);
  
  try{
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
    
    for(int n = 0; n < network.layers.length; n++){ //Itterate through the layers
    
      output.println("Layer " + n);
      
      //Write all of this layer's neurons to the file
      output.println("Neurons");
      
      for(Neuron neuron: network.layers[n].neurons){   
        
        //String that holds all of the serial numbers for the neurons connected to this one, starting with itself
        String connection_string = str(neuron.serial); 
        for(Neuron c: neuron.connected_neurons){
          connection_string += "," + c.serial;
        }
      
        output.println("Actvation=" + neuron.activation + ",Bias=" + neuron.bias + "Serials=" + connection_string);
      }
      
      //Write all of this layer's connections to the last layer to the file
      //First layer doesen't have any connections to a previous layer, which is why this if statement is here
      if(network.layers[n].connections != null){
        output.println("Connections");
        for(Connection connection: network.layers[n].connections){
          output.println("Weight="+connection.weight+",A="+connection.a.serial+",B="+connection.b.serial);
        }
      }
    }
    
    //The following part of the code checks if the network was corruped in the save --> load process
    output.println("#CorruptionTest");
    
    //First create a set of random normalized inputs
    output.print("Inputs=");
    float[] test_inputs = new float[input_size];
    for(int i = 0; i < input_size; i++){
      test_inputs[i] = random(1);
      if(i > 0)
        output.print(",");
      output.print(test_inputs[i]);
    }
    
    //Feed the outputs through the network
    feed_forward(network, test_inputs);
    output.println();
    
    //Store the outputs in the file
    output.print("Outputs=");
    for(int i = 0; i < output_size; i++){
      if(i > 0)
        output.print(",");
      output.print(network.layers[network.layers.length-1].neurons[i].activation);
    }
    
    //Any small change in the network will cause the output to change, so if the network loaded gives a different output array, then we know it was corrupted.
  }
  catch(Exception e) { println("Could not save network, " + e); }

  output.flush();
  output.close();
  
  println("Saved " + selection.getName() + " Successfully.");
}


void networkSelected(File selection){
  
  println("Loading " + selection.getName());
  
  try{
    
    String[] lines = loadStrings(selection.getCanonicalPath()); //Break file into lines
    String current_tag = ""; //Tag we're reading for
    
    int curr_layer = -1;
    int curr_neuron = 0;
    int curr_connection = 0;
    
    boolean searching_for_neurons = false;
    
    float[] input_test = new float[0];
    float[] output_test = new float[0];
    
    for(String text_line: lines){
      
      if(text_line.charAt(0) == '#'){ //Change tag
        current_tag = text_line;
        
        if(current_tag == "#Data") //Reset the network with new parameters
          generate_network();
      }
      
      else if(text_line.substring(0, 1) != "//"){ //Don't read line if it's a comment
        
        if(current_tag == "#Metadata"){
          
          int equals_index = text_line.indexOf("=")-2;
          String param = text_line.substring(0, equals_index);
          String val = text_line.substring(equals_index);
          
          switch(param){
            case "Name":
              network_name = val;
            case "Layers":
              hidden_layers = int(val);
            case "NeuronsPerLayer":
              neurons_per_layer = int(val);
            case "InputSize":
              input_size = int(val);
            case "OutputSize":
              output_size = int(val);
            case "Epochs":
              epochs = int(val);
            case "Alpha":
              alpha = float(val);
            case "Activation":
              activation = val;
            case "Cost":
              loss = val;
            case "Randomized":
              randomize_weight_and_bias = boolean(val);
          }
          
        }
        
        else if(current_tag == "Data"){
        
          if(text_line.contains("Layer"))
            curr_layer += 1;
          
          else if(text_line == "Neurons"){
            searching_for_neurons = true;
            curr_connection = 0;
          }
          
          else if(text_line == "Connections"){
            searching_for_neurons = false;
            curr_neuron = 0;
          }
          
          else{
            
            String[] period_splits = text_line.split(",");
          
            //Load all Neurons
            if(searching_for_neurons){
              
              Neuron neuron = network.layers[curr_layer].neurons[curr_neuron]; //Find neuron to load data into
              
              neuron.activation = float(period_splits[0].substring(period_splits[0].indexOf('='))); //Load activation
              neuron.bias = float(period_splits[1].substring(period_splits[1].indexOf('='))); //Load bias
              
              String serial_str = period_splits[2].substring(period_splits[2].indexOf('=')); //String of serial numbers
              neuron.serial = int(serial_str.substring(0)); //Set own Serial Number
              
              neuron.connected_neurons = new ArrayList<Neuron>(); //initialize connected neurons list
              
              for(int i = 1; i < serial_str.length(); i++){ //Load every connection in previous layer
                neuron.connected_neurons.add(network.find_neuron_by_serial(int(serial_str.charAt(i)), curr_layer));
              }
              
              curr_neuron += 1;
              
            }
            
            //Load all connections
            else{
              
              Connection c = network.layers[curr_layer].connections[curr_connection];
              c.weight = float(period_splits[0].substring(period_splits[0].indexOf('=')));
              c.a = network.find_neuron_by_serial(int(period_splits[1].substring(period_splits[0].indexOf('='))), curr_layer-1);
              c.b = network.find_neuron_by_serial(int(period_splits[2].substring(period_splits[0].indexOf('='))), curr_layer);
              
              curr_connection += 1;
            }
            
          }
          
          
          
        }
        
        else if(current_tag == "CorruptionTest"){
        
          if(text_line.contains("Input")){
            input_test = new float[input_size];
            String[] period_split = text_line.substring(text_line.indexOf("=")).split(",");
            
            for(int i = 0; i < input_size; i++)
              input_test[i] = float(period_split[i]);
            
          }
          
          else if(text_line.contains("Output")){
            String[] period_split = text_line.substring(text_line.indexOf("=")).split(",");
            output_test = new float[output_size];
            
            for(int i = 0; i < input_size; i++)
              output_test[i] = float(period_split[i]);
          
          }
        
        }
        
      }
      
    }
    
    //Test for corruption
    feed_forward(network, input_test);
    boolean corrupted = false;
    
    for(int i = 0; i < output_size; i++){
      if(network.layers[network.layers.length-1].neurons[i].activation != output_test[i]){
        corrupted = true;
        break;
      }
    }
    
    if(corrupted == true)
      throw new Exception("network file was corrupted or changed.");
      
    println("Loaded " + selection.getName() + " Successfully.");
    update_gui_values();
    
  }
  catch(Exception e) { println("Error loading the network, " + e); }
  
}
