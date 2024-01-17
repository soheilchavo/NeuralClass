float e = 2.71828;

float sigmoid(float x){
  return 1/(1+pow(e, -x));
}

float inv_tan(float x){
  return 1/tan(x);
}

float sigmoid_prime(float x){
  return sigmoid(1-sigmoid(x));
}

class Neuron {
  
  float bias;
  float del_bias;
  
  float activation_sum;
  
  float activation;
  
  float x;
  float y;
  
  Neuron(float b){
    this.bias = b;
    this.activation = random(1);
    this.del_bias = 0;
    this.activation_sum = 0;
  }
  
  void update_neuron(){
    this.bias += del_bias;
    this.del_bias = 0;
  }
  
  void activate(){
    this.activation = sigmoid(this.activation_sum+this.bias);
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
  
  boolean animation_view = false;
  
  Layer(int n, Layer prev_layer){
    
    this.neurons = new Neuron[n];
    
    for(int i = 0; i < n; i++){
      this.neurons[i] = new Neuron(random(1));
    }
    
    if(prev_layer != null){
      this.connections = new Connection[n*prev_layer.neurons.length];
      
      for(int n_0 = 0; n_0 < n; n_0++){
        
        for(int n_1 = 0; n_1 < prev_layer.neurons.length; n_1++){
          this.connections[n_0*prev_layer.neurons.length + n_1] = new Connection(prev_layer.neurons[n_1], this.neurons[n_0], random(-1,1));
        }
        
      }
    }
    
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
      c.b.activation_sum += c.a.activation*c.weight;
    }
    for(Neuron n: neurons){
      n.activate();
    }
  }
}

class Network{
  
  Layer[] layers;
  
  Network(int input_size, int output_size, int hidden_layers, int neurons_per_layer){
    
    this.layers = new Layer[2 + hidden_layers];
    //Make Input Layer
    layers[0] = new Layer(input_size, null);
    
    //Make Hidden Layers
    for(int i = 1; i <= hidden_layers; i++){
      layers[i] = new Layer(neurons_per_layer, layers[i-1]);
    }
    
    //Make Output Layer
    layers[layers.length-1] = new Layer(output_size, layers[layers.length-2]);
  } 
  
  void update_network(){
    for(Layer l: this.layers){
      l.update_layer();
    }
  }
  
  void feed_forward(float[] set){
    
    //Set first layer neurons to the set
    for(int index = 0; index < set.length; index++){
      this.layers[0].neurons[index].activation = set[index];
    }
  
    //Consecutivley itterate through layers and calculate activations
    for(int l = 1; l < this.layers.length; l++){
      this.layers[l].animation_view = true;
      this.layers[l].calc_activations();
      delay(animation_buffer);
      this.layers[l].animation_view = false;
    }
    
  }
  
  void back_prop(float alpha){
    print(alpha);
  }
  
  void train(float[][] input, int epochs, int batch_size, float alpha){
  
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
