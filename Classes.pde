class Neuron {
  
  float activation; //0-1 number range
  
  float bias; //A sort of y intercept for the activation function
  float del_bias; //How much the bias will change in the next cycle for stochastic gradient descent
  
  float activation_sum; //Sum of weights and previous activations for activation function
  
  ArrayList<Neuron> connected_neurons; //Neurons in the previous layer that are connected to this one
  
  //Physical coords for drwaing the neuron
  float x;
  float y;
  
  Neuron(){
    this.bias = random(-1, 1);
    this.activation = random(1);
    this.del_bias = 0;
    this.activation_sum = 0;
    this.connected_neurons = new ArrayList<Neuron>();
  }
  
  void update_neuron(float alpha){
    this.bias += del_bias*alpha;
    this.del_bias = 0;
  }
  
  void calculate_activation(){
    this.activation = sigmoid(this.activation_sum+this.bias);
    this.activation_sum = 0;
  }

}

class Connection{

  float weight; //How much effect this connection has to the neuron it's connecting to
  float del_weight; //How much the weight will change in the next cycle
  
  Neuron a;
  Neuron b;
  
  Connection(Neuron one, Neuron two, float w){
    this.weight = w;
    this.del_weight = 0;
    
    this.a = one;
    this.b = two;
  }
  
  void update_connection(float alpha){
    this.weight += del_weight*alpha;
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
          this.connections[n_0*prev_layer.neurons.length + n_1] = new Connection(prev_layer.neurons[n_1], this.neurons[n_0], random(-1,1));
          this.neurons[n_0].connected_neurons.add(prev_layer.neurons[n_1]);
        }
      }
    }
    
  }
  
  void update_layer(float alpha){
    for(Connection c: connections){
      c.update_connection(alpha);
    }
    for(Neuron n: neurons){
      n.update_neuron(alpha);
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
  
  void update_network(float alpha){
    for(Layer l: this.layers){
      l.update_layer(alpha);
    }
  }
}
