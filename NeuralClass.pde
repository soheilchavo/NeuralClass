//Neural Class
//Created by: Soheil Chavoshi, Jan. 29th, 2024

//Instructions for use:
//
//1. Load a network from the "models" folder, or generate one
//
//2. Load the equivilent data from the "data" folder
//
//3. Press "Feedforward" and see the generated guess

import g4p_controls.*;

//Network Parameters
String network_name = "MyNeuralNetwork"; //Name for saving and loading
int hidden_layers = 4; //Number of layers between the input and output layers
int neurons_per_layer = 14; //Number of neurons in hidden layers
int input_size = 5; //Loaded from dataset, (ex. grayscale image would have 1920*1080 input neurons)
int output_size = 2; //Number of classifications of data

//Network Hyperparameters
int epochs = 5; //Number of cycles ran on the training data
int batch_size = 90; //Batch size for training with stochastic gradient descent
float alpha = 0.2; //Learning step taken in backpropogation
boolean randomize_weight_and_bias = true; //Randomizes w/b on network initialization
boolean training = false; //If the program is currently training the network

String[] activation_list = new String[] { "Sigmoid", "Inverse Tan", "Relu" };
String[] loss_list = new String[] { "Linear", "Quadratic"};
int activation = 0; //Normalization function for neuron activation, index for the list above
int loss = 0; //Cost function for backpropogation, index for the list above

//Dataset variables
ArrayList<Sample> training_data;
ArrayList<Sample> testing_data;
Sample curr_sample;

String output_mode = "Sample";
String output_path = "/";
boolean black_and_white = true;

//Network visual parameters
float[] background_col = new float[] {8, 8, 13};

color weight_negative_colour = color(255, 55, 87);
color weight_positive_colour = color(55, 55, 244);

float[] neuron_colour_weight = new float[] {23, 99, 244};
float neuron_bright_offset = 40;

color activation_text_colour = color(0, 0, 0);

Network network = null; //Main Network for the program
String[] output_classes = new String[] { "Toopy", "Bynoo" };
float[] network_output;
int network_guess;

void setup(){
  size(700, 700);
  frameRate(18);
  noLoop();
  
  createGUI();
  update_gui_values();
  generate_network();
}

void draw(){
  background(background_col[0], background_col[1], background_col[2]); //Draw Background
  drawNeuralNetwork();
}

void drawNeuralNetwork(){
  
  //Draw some info text if network is too large to display
  if(max( input_size, hidden_layers, neurons_per_layer ) > 100){
    fill(255);
    textAlign(CENTER);
    textSize(32);
    float base_height = 220;
    
    text("Network is too large to display.", width/2, base_height);
    text("Input Neurons: " + input_size, width/2, base_height + 48);
    text("Output Neurons: " + output_size, width/2, base_height + 48*2);
    text("N/layer: " + neurons_per_layer + ", Hidden layers: " + hidden_layers, width/2, base_height+ 48*3);
    
    text("Classes:", width/2, base_height + 48*4);
    
    String classes_string = output_classes[0];
    for(int i = 1; i < output_classes.length; i++){
      classes_string += ", " + output_classes[i];
    }
    
    textSize(577/classes_string.length());
    text(classes_string, width/2, base_height + 48*5);
    
    return;
  }
  
  float layer_padding = width/(hidden_layers + 3);
  float neuron_padding = height/(max(input_size, output_size, neurons_per_layer)+2);
  float neuron_size = 2000/(neurons_per_layer*(hidden_layers+2));
  float connection_width = 0.1*neuron_size;
  
  float curr_x = layer_padding;//Base x value for leftmost layer
  
  //Draw the connections and calculate neuron positions on screen
  for(Layer l: network.layers){
    
    //Set base y for layer depending on how many neurons there are (centers the layer)
    float curr_y = height/2 - l.neurons.length*(neuron_padding)/2;
    
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
      
      if(n.activation < 0.0099){
        activation_text = "0.00";
      }
      
      fill(activation_text_colour);
      textAlign(CENTER);
      textSize(neuron_size*0.3); //Set text size based on neuron size
      text(activation_text, n.x, n.y); //Draw Activation Text
    }
  }
  
}
//Clamps a value between two numbers
float clamp(float val, float min, float max) {
  if (val < min) 
    return min;
  if (val > max) 
    return max;
  return val;
}
//////////////////////////////////////////////////

//Updates gui with program values
void update_gui_values(){
  EpochField.setText(str(epochs));
  ActivationList.setItems(activation_list, activation);
  LossFunctionList.setItems(loss_list, loss);
  BatchSizeField.setText(str(batch_size));
  RandomizeBox.setSelected(randomize_weight_and_bias);
  AlphaBox.setText(str(alpha));
  LayersBox.setText(str(hidden_layers));
  NeuronsBox.setText(str(neurons_per_layer));
  NetworkGuessLabel.setText("Network Guess: " + output_classes[network_guess]);
}
