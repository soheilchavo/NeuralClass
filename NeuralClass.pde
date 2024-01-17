String data_directory = "/data";

String classification_type = "Name";

int epochs = 5;
int batch_size = 4;

String activation_function = "Sigmoid";

String loss_function = "Mean_Squared";
float alpha = 0.5;

int neurons_per_layer = 5;
int hidden_layers = 4;

float neuron_size = 35;
float connection_width = 2.4;
float layer_padding = 120;
float neuron_padding = 50;

float network_x = 0;
float network_y = 300;

Network network = null;

int animation_buffer = 100;

void setup(){
  size(800, 700);
  network = new Network(5, 3, hidden_layers, neurons_per_layer);
}

void draw(){
  background(35,35,35);
  drawNeuralNetwork();
}

void drawNeuralNetwork(){
  
  float curr_x = network_x;
  
  strokeWeight(connection_width);
  
  for(Layer l: network.layers){
    curr_x += layer_padding;
    float curr_y = network_y - l.neurons.length*(neuron_padding)/2;
    
    for(Neuron n: l.neurons){
      curr_y += neuron_padding;
      n.x = curr_x;
      n.y = curr_y;
    }
    
    if(l.connections != null){
      for(Connection c: l.connections){
        
        float[] col = new float[] {c.weight*255*-1 + 100, 0, 0};
        if(c.weight > 0) { col = new float[] {0,0,c.weight*255  + 100}; }
        
        stroke(col[0],col[1],col[2]); 
        line(c.a.x, c.a.y, c.b.x, c.b.y);
      }
    }
  }
  
  for(Layer l: network.layers){
    
    stroke(188,188,188);
    if(l.animation_view){
      stroke(255,0,0);
    }
    
    for(Neuron n: l.neurons){
      fill(0, 0, n.activation * 90 + 150);
      circle(n.x, n.y, neuron_size);
      fill(255,255,255);
      textAlign(CENTER);
      
      String activation_text = str(n.activation);
      if(activation_text.length() >= 4){
        activation_text = str(n.activation).substring(0,4);
      }
      
      text(activation_text, n.x, n.y);
    }
  }
  
}

void keyPressed(){
  network.feed_forward(new float[] {0, 1, 2, 45, -4});
}
