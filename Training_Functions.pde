void feed_forward(Network n, float[] set){
  
  //Set first layer neurons to the input data (Note, input must match the number of neurons in input layer)
  for(int index = 0; index < set.length; index++){
    n.layers[0].neurons[index].activation = sigmoid(set[index]);
  }

  //Consecutivley itterate through layers and calculate activations
  for(int l = 1; l < n.layers.length; l++){
    n.layers[l].calc_activations();
  }
  
}
  
void backprop(Network n, float alpha){
  print(n, alpha);
}

void train(Network n, float[][] input, int epochs, int batch_size, float alpha){

  int set_size = ceil((input.length)/batch_size);
  
  for(int e = 0; e < epochs; e++){
    
    int i = 0;
    
    for(float[] set: input){
      
      feed_forward(n, set);
      backprop(n, alpha);
      
      if(i % set_size == 0){
        n.update_network();
      }
      
      i += 1;
    }
  }
}
