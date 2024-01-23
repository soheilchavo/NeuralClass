int global_serial = 0;

class Neuron {

  int serial; //Unique number assined to neuron (for loading and saving networks)
  
  float activation; //0-1 number range
  float z_val; //Value claculated from weights and biases right before it goes into the activation function
  
  float bias; //A sort of y intercept for the activation function
  float del_bias; //How much the bias will change for each cycle of the chain rule in the output layer
  
  ArrayList<Float> average_bias_del; //Average changes in the bias across the training batch
  
  float activation_sum; //Sum of previous layer's weighted activations
  
  ArrayList<Connection> connections; //Neurons in the previous layer that are connected to this one
  
  //Physical coords for drawing the neuron
  float x;
  float y;
  
  Neuron(){
    this.bias = random(-1, 1);
    this.activation = random(1);
    this.z_val = 0;
    this.del_bias = 0;
    this.average_bias_del = new ArrayList<Float>();
    
    this.activation_sum = 0;
    this.connections = new ArrayList<Connection>();
    global_serial += 1;
    this.serial = global_serial;
  }
  
  void update_neuron(){
    for(float d: this.average_bias_del){
      this.del_bias += d;
    }
    this.del_bias /= this.average_bias_del.size();
    this.bias += del_bias*alpha;
    this.bias = activation_function(this.bias);
    this.del_bias = 0;
    this.average_bias_del = new ArrayList<Float>();
  }
  
  void calculate_activation(){
    this.z_val = this.activation_sum+this.bias;
    this.activation = activation_function(this.z_val);
    this.activation_sum = 0;
  }
  
  void update_del_value(){
    this.average_bias_del.add(del_bias);
    this.del_bias = 0;
  }

}

class Connection{

  float weight; //How much effect this connection has to the neuron it's connecting to
  float del_weight; //How much the weight will change for each cycle of the chain rule in the output layer
  
  ArrayList<Float> average_weight_del; //Average changes in the weight across the training batch
  
  Neuron a;
  Neuron b;
  
  Connection(Neuron one, Neuron two, float w){
    this.weight = w;
    this.del_weight = 0;
    this.average_weight_del = new ArrayList<Float>();
    
    this.a = one;
    this.b = two;
  }
  
  void update_connection(){
    this.del_weight = 0;
    for(float d: this.average_weight_del){
      this.del_weight += d;
    }
    this.del_weight /= this.average_weight_del.size();
    this.weight += del_weight*alpha;
    this.weight = clamp(this.weight, -1, 1);
    
    this.del_weight = 0;
    this.average_weight_del = new ArrayList<Float>();
  }
  
  void update_del_value(){
    this.average_weight_del.add(del_weight);
    this.del_weight = 0;
  }
  
}

class Layer{

  Neuron[] neurons;
  Connection[] connections;
  
  Layer(int n, Layer prev_layer){
    
    //Create empty random neurons
    this.neurons = new Neuron[n];
    for(int i = 0; i < n; i++){
      this.neurons[i] = new Neuron();
    }
   
    //If this is not the first layer
    if(prev_layer != null){
      //Create connections between each neuron in the last layer and in the current one
      this.connections = new Connection[n*prev_layer.neurons.length];
      for(int n_0 = 0; n_0 < n; n_0++){
        for(int n_1 = 0; n_1 < prev_layer.neurons.length; n_1++){
          float weight = 0;
          if(randomize_weight_and_bias)
            weight = random(-1,1);
          this.connections[n_0*prev_layer.neurons.length + n_1] = new Connection(prev_layer.neurons[n_1], this.neurons[n_0], weight);
          this.neurons[n_0].connections.add(this.connections[n_0*prev_layer.neurons.length + n_1]);
        }
      }
    }
    
  }
  
  void update_layer(){
    for(Connection c: connections){
      c.update_connection();
    }
    for(Neuron n: neurons){
      n.update_neuron();
    }
  }
  
  void update_del_values(){
    for(Connection c: connections){
      c.update_del_value();
    }
    for(Neuron n: neurons){
      n.update_del_value();
    }
  }
  
  void calc_activations(){
    for(Connection c: connections){ //Add up all the effects of the connections to this layer
      c.b.activation_sum += c.a.activation*c.weight;
    }
    for(Neuron n: neurons){ //Calculate activations for all neurons in this layer
      n.calculate_activation();
    }
  }
}

class Network{
  
  Layer[] layers;
  
  Network(int input_size, int output_size, int hidden_layers, int neurons_per_layer){
    
    //Make all layers, input layer + output layer + hidden layers
    this.layers = new Layer[2 + hidden_layers];
    
    //Make Input Layer          //null = No Previous Layer
    layers[0] = new Layer(input_size, null);
    
    //Make Hidden Layers
    for(int i = 1; i <= hidden_layers; i++){
      layers[i] = new Layer(neurons_per_layer, layers[i-1]); //layers[i-1] = last layer, in order to create connections
    }
    
    //Make Output Layer                              //Second to last layer
    layers[layers.length-1] = new Layer(output_size, layers[layers.length-2]);
  } 
  
  void update_network(){
    for(int l = 1; l < this.layers.length; l++){
      this.layers[l].update_layer();
    }
  }
  
  void update_del_values(){
    for(int l = 1; l < this.layers.length; l++){
      this.layers[l].update_del_values();
    }
  }
  
  Neuron find_neuron_by_serial(int s, int l){
    for(Neuron n: this.layers[l].neurons){
      if(n.serial == s)
        return n;
    }
    return null;
  }
  
  Connection find_connection_by_serial(int a, int b, int l){
    for(Connection c: this.layers[l].connections){
      if(c.a.serial == a && c.b.serial == b)
        return c;
    }
    return null;
  }
  
  float[] get_layer_activation(int i){
    float[] out = new float[this.layers[i].neurons.length];
    for(int x = 0; x < out.length; x++){
      out[x] = this.layers[i].neurons[x].activation;
    }
    return out;
  }
}
