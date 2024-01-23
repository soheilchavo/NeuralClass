//Generates a set of random activations for the input layer neurons
float[] random_inputs(){
  float[] out = new float[input_size];
  for(int i = 0; i < input_size; i++){
    out[i] = random(4);
  }
  return out;
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
  
  update_gui_values(); //Display network guess
}
  
void backprop(float[] correct_output){
  
  for(int i = 0; i < output_size; i++){
    
    Neuron curr_neuron = network.layers[network.layers.length-1].neurons[i];
  
    ArrayList<Float> del_stack = new ArrayList<Float>(); //Stack that holds all the derrivatives in the chain as we go through the network
    
    del_stack.add(loss_function_prime_single(curr_neuron.activation, correct_output[i]));
    backprop_recursive(del_stack, curr_neuron);
  }
  
  //Update del for all neurons and weights
  network.update_del_values();
  network.update_network(); //TAKE THIS OUT
  
}

void backprop_recursive(ArrayList<Float> stack, Neuron curr_neuron){
  stack.add(activation_function_prime(curr_neuron.activation));
  
  curr_neuron.del_bias += multiply_arraylist_items(stack);
  
  for(Connection c: curr_neuron.connections){
    stack.add(c.a.activation);
    backprop_recursive(new ArrayList<Float>(stack), c.a);
    c.del_weight += multiply_arraylist_items(stack);
  }
}

void train(float[][] input, float[][] output, int epochs){

  int set_size = ceil((input.length)/batch_size);
  
  for(int e = 0; e < epochs; e++){
    
    //Shuffle data
    
    for(int i = 0; i < input.length; i++){
      
      feed_forward(input[i]);
      backprop( output[i]);
      
      if(i % set_size == 0){
        network.update_network();
      }
    }
  }
}

void print_network_activations(Network n){
  for(int l = 0; l < n.layers.length; l++){
    println("\nLayer: " + l);
    for(Neuron neuron: network.layers[l].neurons){
      println(neuron.activation);
    }
  }
}
