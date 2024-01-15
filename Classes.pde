float e = 2.71828;

float sigmoid(float x){
  return 1/(1+pow(e, -x));
}

float sigmoid_prime(float x){
  return -1/(1+2*(pow(e,-x)+pow(e, -2*x)));
}

class Neuron {
  
  float bias;
  float del_bias;
  
  float activation_sum;
  
  float activation;
  
  Neuron(float b){
    this.bias = b;
    this.activation = 0;
    this.del_bias = 0;
    this.activation_sum = 0;
  }
  
  void update_neuron(){
    this.bias += del_bias;
    this.del_bias = 0;
  }
  
  void calc_activation(){
    this.activation = sigmoid( this. );
  }

}

class Connection{

  float weight;
  float del_weight;
  
  Neuron a;
  Neuron b;
  
  
  Connection(Neuron one, Neuron two, float w){
    this.weight = w;
    this.del_weight = 0;
    
    this.a = one;
    this.b = two;
  }
  
  void update_connection(){
    this.weight += del_weight;
    this.del_weight = 0;
  }
  
}

class Layer{

  Neuron[] neurons;
  Connection[] connections;
  
  Layer(Neuron[] n, Connection[] c){
    this.neurons = n;
    this.connections = c;
  }
  
  void update_layer(){
    for(Neuron n: neurons){
      n.update_neuron();
    }
    
    for(Connection c: connections){
      c.update_connection();
    }
  }
  
  void calc_activations(){
    for(Connection c: connections){
      c.b.activation_sum += c.a.activation;
    }
    for(Connection c: connections){
      c.b.calc_activation();
    }
    
  }
}

class Network{
  
  Layer[] layers;
  
  Network(Layer[] l){
    this.layers = l;
  } 
  
  void update_network(){
    for(Layer l: this.layers){
      l.update_layer();
    }
  }
  
  void feed_forward(float[] input){
  
    for(int l = 1; l < this.layers.length; l++){
      this.layers[l].calc_activations();
    }
    
  }
  
  void train(float[][] input, int epochs, int batch_size, float alpha){
  
    //Set the neurons of the first layer to inputs
    int n_index = 0;
    
    for(float[] set: input){
      for(float f: set){
        this.layers[0].neurons[n_index].activation = f;
        n_index += 1;
      }
    }
    
    int set_size = ceil((input.length)/batch_size);
    
    for(int e = 0; e < epochs; e++){
      
      int i = 0;
      
      for(float[] set: input){
        
        this.feed_forward(set);
        this.back_prop(alpha);
        
        if(i % set_size == 0){
          this.update_network();
        }
        
        i += 1;
      }
    }
  }
}
