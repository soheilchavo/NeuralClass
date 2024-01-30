//Generates a set of random activations for the input layer neurons
float[] random_inputs() {
  float[] out = new float[input_size];
  for (int i = 0; i < input_size; i++) {
    out[i] = random(4);
  }
  return out;
}

ArrayList<Sample> shuffle_data(ArrayList<Sample> input_list) {

  ArrayList<Sample> output_list = new ArrayList<Sample>();

  for (int i = 0; i < input_list.size(); i++) {
    int random_index = int(random(input_list.size()));
    output_list.add(input_list.get(random_index));
    input_list.remove(random_index);
  }

  return output_list;
}

//Finds the index of the item in the array through linear search (array is not sorted)
int index_in_arr(String[] arr, String item) {
  for (int i = 0; i < arr.length; i++) {
    if (arr[i] == item) {
      return i;
    }
  }
  println("index_in_arr function could not find item"); //Warning message to prevent future misundestandings
  return 0;
}

//Feedforwards a single data point to the network
void feed_forward_sample() {
  training = false;
  delay(500);
  feed_forward(curr_sample.get_pixel_data());
  update_gui_values();
  NetworkOutputLabel.setText(get_network_outputs());
}

//Feedforwards a set of data to the network
void feed_forward_set(){
  
  training = false;
  delay(500);
  println("Testing Started.");
  
  try{
    
    int dataset_size = testing_data.size();
    int n_correct = 0;
    int n_incorrect = 0;
    
    PrintWriter output = createWriter(output_path + dataset_name + ".txt");

    for (int i = 0; i < dataset_size; i++) {
      
      //Feedforward the data point
      feed_forward(testing_data.get(i).get_pixel_data());
      
      //Print guess and correct answer
      output.println("Sample: " + i + "/" + dataset_size + ", Guess: " + output_classes[network_guesses[0]] + ", Actual: " + testing_data.get(i).type);
    
      //Check if it was correct or not
      if(output_classes[network_guesses[0]].equals(testing_data.get(i).type))
        n_correct += 1;
      else
        n_incorrect += 1;
    }
    
    //Network accuracy
    String ratio = float_as_truncated_str(100*n_correct/dataset_size, 4);
    
    output.println("Number of correct guesses: " + n_correct);
    output.println("Number of incorrect guesses: " + n_incorrect);
    output.println("Network accuracy: " + ratio + "%");
    
    output.flush();
    output.close();
    
    println("Testing successful, results available in: " + output_path + dataset_name + ".txt");
  }
  
  catch(Exception e) { println("Error testing dataset," + e); }
  
}

//Feeds a set of data through the network and returns results
void feed_forward(float[] set) {

  //Set first layer neurons to the input data (Note, input must match the number of neurons in input layer)
  for (int index = 0; index < set.length; index++) {
    network.layers[0].neurons[index].activation = set[index];
  }

  //Consecutivley itterate through layers and calculate activations
  for (int l = 1; l < network.layers.length; l++) {
    network.layers[l].calc_activations();
  }

  //Set network outputs to output layer
  network_output = new float[output_size];
  network_guesses = new int[network_guesses.length];

  for (int i = 0; i < output_size; i++) {
    network_output[i] = network.layers[network.layers.length-1].neurons[i].activation;
    for(int g = 0; g < network_guesses.length; g++){
      if(network_output[network_guesses[g]] < network_output[i]){
        network_guesses[g] = i;
        break;
      }
    }
  }
}

void backprop(String correct_class) {

  float[] correct_output = new float[output_size];

  for (int i = 0; i < output_size; i++) {
    if (output_classes[i].equals(correct_class)) {
      correct_output[i] = 1;
    } else {
      correct_output[i] = 0;
    }
  }
  
  //Go through layers in reverse order, stop before reaching the last one
  for (int i = network.layers.length-1; i > 0; i--) {
    //Go through all neurons in the layer
    for (int j = 0; j < network.layers[i].neurons.length; j++) {
      Neuron curr_neuron = network.layers[i].neurons[j];
      
      //Calculate delta for last layer's weights and biases
      if(i == network.layers.length-1){
        curr_neuron.delta = loss_function_prime_single(curr_neuron.activation, correct_output[j])*activation_function_prime(curr_neuron.z_val);
        curr_neuron.del_bias.add(curr_neuron.delta);
      }
      else{
        curr_neuron.delta = activation_function_prime(curr_neuron.z_val);
        for(Connection c: curr_neuron.connections_forward)
          curr_neuron.delta *= c.weight*c.b.delta;
        
        curr_neuron.del_bias.add(curr_neuron.delta);
      }
    
      for(Connection c: curr_neuron.connections){
        c.delta = c.a.activation*curr_neuron.delta;
        c.del_weight.add(c.delta);
      }
    }
  }
  if(draw_network_backprop)
    redraw();  
}

void train() {

  training = true;
  
  //The batch we're currently on
  int batch = 0;
  
  //How many batches there are
  int n_batches = int(training_data.size()/batch_size);

  for (int e = 1; e < epochs+1; e++) {
    
    println("Epoch: " + e + " Started");

    if (training == false)
      break;

    //Shuffle training data to prevent overfitting
    training_data = shuffle_data(training_data);

    for (int i = 0; i < training_data.size(); i++) {
      
      //Feed data to network
      feed_forward(training_data.get(i).get_pixel_data());
      
      //Network learns from mistakes
      backprop(training_data.get(i).type);
      
      //Update the network if we've gone through the batch
      if (int(i+1) % batch_size == 0){
        batch += 1;
        println("Epoch: " + e + ", Batch: " + batch + "/" + n_batches);
        network.update_network();
      }
      
      if (training == false)
        break;

    }
    
    //Make any last changes (If data size didn't fit nicely into batch size
    network.update_network();
    
    println("Epoch: " + e + " Complete.");

  }

  if (training == false)
    println("Stopped Training");

  else {
    println("Training Complete.");
    training = false;
  }
}

//Turns float into string and cuts it off at some point
String float_as_truncated_str(float a, int b){
  return str(a).substring(0, min(b, str(a).length()));
}

void print_network_activations(int layer) {
  for (Neuron neuron : network.layers[layer].neurons) {
    println(neuron.activation);
  }
}

void print_network_weights(int layer) {
  for (Connection c : network.layers[layer].connections) {
    println(c.weight);
  }
}

void print_network_dels(int layer) {
  for (Connection c : network.layers[layer].connections) {
    println(c.del_weight);
  }
}

//Gets the top 3 network outputs to display on gui
String get_network_outputs(){
  
  try{
    
    String out = "";
    
    //Go through top 3 guesses and store their activations in the activation list
    float[] activation_list = new float[network_guesses.length];
    for(int i = 0; i < network_guesses.length; i++){
      activation_list[i] = network_output[network_guesses[i]];
    }
    
    //Take the sum of those activations
    float sum = array_sum(activation_list);
    
    //Find out the ratio of each guess to the sum
    for(int i = 0; i < 3; i++){
      out += output_classes[network_guesses[i]] + "  -   " + float_as_truncated_str(100*activation_list[i]/sum, 4) + "% Confidence\n";
    }
    
    return out;
  }
  catch(Exception e){ return "No Output."; }
}
