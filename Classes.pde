int global_serial = 0; //Serial number for neurons, each one has their own unique number which this variable keeps track of

class Neuron {

  int serial; //Unique number assined to neuron (for loading and saving networks)
  
  float activation; //0-1 number range
  float z_val; //Value claculated from weights and biases right before it goes into the activation function
  
  float bias; //A sort of y intercept for the activation function
  ArrayList<Float> del_bias; //Average changes in the bias across the training batch
  
  float delta; //How wrong the neuron is in backprop
  
  float activation_sum; //Sum of previous layer's weighted activations
  
  ArrayList<Connection> connections; //Neurons in the previous layer that are connected to this one
  ArrayList<Connection> connections_forward; //Neurons in the next layer that are connected to this one
  
  //Physical coords for drawing the neuron
  float x;
  float y;
  
  Neuron(){
    this.bias = 0.5;
    if(randomize_weight_and_bias)
      this.bias = random(-1, 1);
    
    this.activation = random(1);
    this.z_val = 0;
    this.del_bias = new ArrayList<Float>();
    this.delta = 1;
    
    this.activation_sum = 0;
    this.connections = new ArrayList<Connection>();
    this.connections_forward = new ArrayList<Connection>();
    
    global_serial += 1;
    this.serial = global_serial;
  }
  
  //Updates neuron in gradient descent
  void update_neuron(){
    for(float d: this.del_bias)
      this.bias -= (alpha/batch_size)*d;
    this.del_bias = new ArrayList<Float>();
  }
  
  void calculate_activation(){
    this.z_val = this.activation_sum+this.bias;
    this.activation = activation_function(this.z_val);
    this.activation_sum = 0;
  }
  
}

class Connection{

  float weight; //How much effect this connection has to the neuron it's connecting to
  float delta;
  
  ArrayList<Float> del_weight; //Average changes in the weight across the training batch
  
  Neuron a;
  Neuron b;
  
  Connection(Neuron one, Neuron two, float w){
    this.weight = w;
    this.delta = 0;
    this.del_weight = new ArrayList<Float>();
      
    this.a = one;
    this.b = two;
  }
  
  //Updates weight for gradient descent
  void update_connection(){
    for(float d: this.del_weight)
      this.weight -= (alpha/batch_size)*d;
    this.del_weight = new ArrayList<Float>();
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
          prev_layer.neurons[n_1].connections_forward.add(this.connections[n_0*prev_layer.neurons.length + n_1]);
        }
      }
    }
  }
  
  //Updates layer for gradient descent
  void update_layer(){
    for(Connection c: connections){
      c.update_connection();
    }
    for(Neuron n: neurons){
      n.update_neuron();
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
  
  //Gets all activations for a single layer
  float[] get_layer_activation(int i){
    float[] out = new float[this.layers[i].neurons.length];
    for(int x = 0; x < out.length; x++){
      out[x] = this.layers[i].neurons[x].activation;
    }
    return out;
  }
}
