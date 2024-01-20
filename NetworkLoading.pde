void generate_network(){
  network = new Network(input_size, output_size, hidden_layers, neurons_per_layer);
}

void save_network(){
  selectOutput("Create Network file", "networkOutputSelected");
}


//Makes a .nnf file (Neural Network File) and stores network and parameters inside
void networkOutputSelected(File selection){
  PrintWriter output = createWriter(selection.getAbsolutePath() + ".nnf");
  
  try{
    output.println("#Metadata");
    
    output.println("Name=" + network_name);
    output.println("Layers=" + hidden_layers);
    output.println("NeuronsPerLayer=" + neurons_per_layer);
    output.println("InputSize=" + input_size);
    output.println("OutputSize=" + output_size);
    
    output.println("#HyperParameters");
    output.println("Epochs=" + epochs);
    output.println("Alpha=" + alpha);
    output.println("Activation=" + activation);
    output.println("Cost=" + loss);
    output.println("Randomized=" + randomize_weight_and_bias);
    
    output.println("#Data");
    
    for(int n = 0; n < network.layers.length; n++){
      output.println("Layer " + n);
      output.println("Neurons");
      for(Neuron neuron: network.layers[n].neurons){     
        String connection_string = str(neuron.serial);
        for(Neuron c: neuron.connected_neurons){
          connection_string += "," + c.serial;
        }
        output.println("Actvation=" + neuron.activation + ",Bias=" + neuron.bias + "Serials=" + connection_string);
      }
      
      if(network.layers[n].connections != null){
        output.println("Connections");
        for(Connection connection: network.layers[n].connections){
          output.println("Weight="+connection.weight+",A="+connection.a.serial+",B="+connection.b.serial);
        }
      }
    }
  }
  catch(Exception e) { println("Could not save network, " + e); }

  output.flush();
  output.close();
}

void load_network(){
  selectInput("Select Network to load.", "networkSelected");
}

void networkSelected(File selection){
  print(selection + " selected");
}
