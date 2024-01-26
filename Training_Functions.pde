//Generates a set of random activations for the input layer neurons
float[] random_inputs(){
  float[] out = new float[input_size];
  for(int i = 0; i < input_size; i++){
    out[i] = random(4);
  }
  return out;
}

ArrayList<Sample> shuffle_data(ArrayList<Sample> input_list){
  
  ArrayList<Sample> output_list = new ArrayList<Sample>();
  
  for(int i = 0; i < input_list.size(); i++){
    int random_index = int(random(input_list.size()));
    output_list.add(input_list.get(random_index));
    input_list.remove(random_index);
  }
  
  return output_list;
}

//Finds the index of the item in the array through linear search (array is not sorted)
int index_in_arr(String[] arr, String item){
  for(int i = 0; i < arr.length; i++){
    if(arr[i] == item){
      return i;
    }
  }
  println("index_in_arr function could not find item"); //Warning message to prevent future misundestandings
  return 0;
}

void feed_forward_sample(){
  training = false;
  feed_forward(curr_sample.get_pixel_data());
  update_gui_values();
  print_network_activations();
}

//Feeds a set of data through the network and returns results
void feed_forward(float[] set){
  
  //Set first layer neurons to the input data (Note, input must match the number of neurons in input layer)
  for(int index = 0; index < set.length; index++){
    network.layers[0].neurons[index].activation = activation_function(set[index]);
  }

  //Consecutivley itterate through layers and calculate activations
  for(int l = 1; l < network.layers.length; l++){
    network.layers[l].calc_activations();
  }
  
  //Set network outputs to output layer
  network_output = new float[output_size];
  network_guess = 0;
  
  for(int i = 0; i < output_size; i++){
    network_output[i] = network.layers[network.layers.length-1].neurons[i].activation;
    if(network_output[i] > network_output[network_guess]){ network_guess = i; }
  }
  
  update_gui_values(); //Displays network guess
}
  
void backprop(String correct_class){
 
  float[] correct_output = new float[output_size];

  for(int i = 0; i < output_size; i++){
    if(output_classes[i] == correct_class){
      correct_output[i] = 1;
    }
    else{
      correct_output[i] = 0;
    }
  }
  
  //Go through layers in reverse order, stop before reaching the last one
  for(int i = network.layers.length-1; i > 0; i--){
    //println("Layer:" + i);
    //Go through all neurons in the layer
    for(int j = 0; j < network.layers[i].neurons.length; j++){
      Neuron curr_neuron = network.layers[i].neurons[j];
      
      //Calculate initial error
      if(i == network.layers.length-1)
        curr_neuron.error = loss_function_prime_single(curr_neuron.activation, correct_output[j])*activation_function_prime(curr_neuron.z_val);
      
      //Calculates error for hidden layer neurons
      else{
        for(Connection c: curr_neuron.connections_forward){
          curr_neuron.error *= c.b.error*c.weight;
        }
        curr_neuron.error *= activation_function_prime(curr_neuron.z_val);
      }
      
      curr_neuron.del_bias.add(curr_neuron.error);
      
      for(Connection c: curr_neuron.connections){
        c.del_weight.add(curr_neuron.error*c.a.activation);
      }
    } 
  }
  
  network.update_network(); //TAKE THIS OUT
  redraw();
}

void train(){

  training = true;
  int set_size = ceil((training_data.size())/batch_size);
  
  for(int e = 0; e < epochs; e++){
    
    if(training == false)
        break;
    
    training_data = shuffle_data(training_data);
    
    for(int i = 0; i < training_data.size(); i++){

      if(training == false)
        break;
      
      feed_forward(training_data.get(i).get_pixel_data());
      backprop(training_data.get(i).type);
      
      if(i % set_size == 0){
        network.update_network();
      }
      
      println("Epoch: " + e + ", Sample: " + i + "/" + training_data.size());
    }
    println("Epoch: " + e + " Complete.");
    
    network.update_network();
  }
  
  if(training == false)
    println("Stopped Training");
  
  else{
    println("Training Complete.");
    training = false;
  }
}

void print_network_activations(){
  for(int l = 0; l < network.layers.length; l++){
    println("\nLayer: " + l);
    for(Neuron neuron: network.layers[l].neurons){
      println(neuron.activation);
    }
  }
}
