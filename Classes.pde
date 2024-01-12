class Network{
  
  float[][] input_node;
  Layer[] layers;
  
  Network(float[][] input){
    this.input_node = input;
  }
}

class Layer{

  Neuron[] neurons;
  
  Layer(Neuron[] n){
    this.neurons = n;
  }
}

class Neuron {

  Connection[] connections;
  
  float bias;
  float activaiton;
  
  Neuron(Connection[] c, float b){
  
    this.connections = c;
    this.bias = b;
    
    this.activation = 0;
    
  }
  
  
}

class Connection{

  Neuron a;
  Neuron b;
  
  float weight;
  
  Connection(Neuron one, Neuron two, float w){
    this.a = one;
    this.b = two;
    this.weight = w;
  }
  
}
