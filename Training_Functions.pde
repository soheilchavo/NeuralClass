void print_network_activations(Network n){

  for(int l = 0; l < n.layers.length; l++){
    
    println("\nLayer: " + l);
    
    for(Neuron neuron: network.layers[l].neurons){
      println(neuron.activation);
    }
    
  }
  
}

int index_in_arr(String[] arr, String item){
  for(int i = 0; i < arr.length; i++){
    if(arr[i] == item){
      return i;
    }
  }
  return 0;
}

void feed_forward(Network n, float[] set){
  
  //Set first layer neurons to the input data (Note, input must match the number of neurons in input layer)
  for(int index = 0; index < set.length; index++){
    n.layers[0].neurons[index].activation = activation_function(set[index]);
  }

  //Consecutivley itterate through layers and calculate activations
  for(int l = 1; l < n.layers.length; l++){
    n.layers[l].calc_activations();
  }
  
}
  
void backprop(Network n, float[] correct_output){
  
  //Find Cost for every neuron in output layer
  int output_size = correct_output.length;
  
  for(int i = 0; i < output_size; i++){
    
    float cost = quadratic_cost(n.layers[n.layers.length-1].neurons[i].activation, correct_output[i]);
    
  }
  
}

void train(Network n, float[][] input, float[][] output, int epochs, int batch_size, float alpha){

  int set_size = ceil((input.length)/batch_size);
  
  for(int e = 0; e < epochs; e++){
    
    //Shuffle data
    
    for(int i = 0; i < input.length; i++){
      
      feed_forward(n, input[i]);
      backprop(n, output[i]);
      
      if(i % set_size == 0){
        n.update_network(alpha);
      }
    }
  }
}
