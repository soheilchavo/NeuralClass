//Network Hyperparameters
int epochs = 5; //Number of cycles ran on the training data
int batch_size = 4; //Batch size for training with stochastic gradient descent
float alpha = 0.5; //Learning step taken in backpropogation

String activation_function = "Sigmoid"; //Normalization function for neuron activation, choose from Sigmoid, inverse tan, and relu
String loss_function = "Quadratic"; //Cost function for backpropogation 

int hidden_layers = 3; //Number of layers between the input and output layers
int neurons_per_layer = 12; //Number of neurons in hidden layers

int input_size = 4; //Loaded from dataset, (ex. grayscale image would have 1920*1080 input neurons)
int output_size = 2; //Number of classifications of data

//Data Collection
String data_directory = "/data";
String classification_type = "Name"; //By Name of file or by which Folder data is in

//Network visual parameters
float[] background_col = new float[] {8, 8, 8};

color weight_negative_colour = color(255, 55, 87);
color weight_positive_colour = color(55, 55, 244);

float[] neuron_colour_weight = new float[] {40, 40, 230};
float neuron_bright_offset = 90;

color activation_text_colour = color(0, 0, 0);

float neuron_size = 35;
float connection_width = 2.4;

float layer_padding = 244;
float neuron_padding = 80;

//Coords of the network on screen
float network_x = 0;
float network_y = 300;

int animation_buffer = 100; //Miliseconds of delay between each step of the visualization

//Camera Controls
float zoom = 1;
float x_offset = 0;
float y_offset = 0;

float shift_sensitivity = 10; //How sensitive WASD keys are
float zoom_sensitivity = 0.04; //How sensitive zoom is
float mouse_sensitivity = 1.4; //How sensitive dragging is

Network network = null; //Main Network for the program

void setup(){
  size(500, 500);
  network = new Network(input_size, output_size, hidden_layers, neurons_per_layer);
}

void draw(){
  
  //Draw Background
  background(background_col[0], background_col[1], background_col[2]);
  
  //Translate screen for camera controls
  pushMatrix();
  
  translate(width/2, height/2);   //Center Zooming
  scale(zoom);                    //Center Zooming
  translate(-width/2, -height/2); //Center Zooming
  translate(x_offset, y_offset);  //X and Y offsets
  
  drawNeuralNetwork();
  
  //Undo screen transformations
  popMatrix();
}

void drawNeuralNetwork(){
  
  //Base x value for leftmost layer
  float curr_x = network_x;
  
  
  //Draw the connections and calculate neuron positions on screen
  for(Layer l: network.layers){
    
    //Set base y for layer depending on how many neurons there are (centers the layer)
    float curr_y = network_y - l.neurons.length*(neuron_padding)/2;
    
    //Calculate the position of the neurons (but don't draw them yet since we want them to be on top)
    for(Neuron n: l.neurons){
      n.x = curr_x;
      n.y = curr_y;
      curr_y += neuron_padding;
    }
    
    //Draw the connections
    if(l.connections != null){
      for(Connection c: l.connections){
        
        //Use positive or negative weight colour
        color col = weight_negative_colour;
        if(c.weight > 0) { col = weight_positive_colour; }
        
        //Set width for connection
        strokeWeight(connection_width*abs(c.weight/2));
        //Draw the connection
        stroke(col); 
        line(c.a.x, c.a.y, c.b.x, c.b.y);
      }
    }
    
    //Add layer padding
    curr_x += layer_padding;
  }
  
  //Draw the Neurons
  for(Layer l: network.layers){
    for(Neuron n: l.neurons){
      //Draw Nueron
      fill(n.activation*neuron_colour_weight[0]+neuron_bright_offset, n.activation*neuron_colour_weight[1]+neuron_bright_offset, n.activation*neuron_colour_weight[2]+neuron_bright_offset);
      circle(n.x, n.y, neuron_size);
      
      //Draw activation text
      String activation_text = str(n.activation); //Convert activation to string
      
      if(activation_text.length() >= 4){ //Cut off all the decimals
        activation_text = str(n.activation).substring(0,4);
      }
      
      fill(activation_text_colour);
      textAlign(CENTER);
      textSize(neuron_size*0.3); //Set text size based on neuron size
      text(activation_text, n.x, n.y); //Draw Activation Text
    }
  }
  
}
