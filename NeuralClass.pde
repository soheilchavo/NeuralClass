//Neural Class
//Created by: Soheil Chavoshi, Jan. 29th, 2024

import g4p_controls.*;

//Network Parameters
String network_name = "MyNeuralNetwork"; //Name for saving and loading
int hidden_layers = 4; //Number of layers between the input and output layers
int neurons_per_layer = 6; //Number of neurons in hidden layers
int input_size = 9; //Loaded from dataset, (ex. grayscale image would have 1920*1080 input neurons)
int output_size = 2; //Number of classifications of data

//Network Hyperparameters
int epochs = 5; //Number of cycles ran on the training data
int batch_size = 4; //Batch size for training with stochastic gradient descent
float alpha = 0.5; //Learning step taken in backpropogation
boolean randomize_weight_and_bias = true; //Randomizes w/b on network initialization
String[] activation_list = new String[] { "Sigmoid", "Inverse Tan", "Relu" };
String[] loss_list = new String[] { "Logistic", "Quadratic"};
int activation = 1; //Normalization function for neuron activation, index for the list above
int loss = 0; //Cost function for backpropogation, index for the list above

//Dataset variables
String data_directory = "/data";
String classification_type = "Name"; //By Name of file or by which Folder data is in

//Network visual parameters
float[] background_col = new float[] {8, 8, 13};

color weight_negative_colour = color(255, 55, 87);
color weight_positive_colour = color(55, 55, 244);

float[] neuron_colour_weight = new float[] {40, 20, 240};
float neuron_bright_offset = 90;

color activation_text_colour = color(0, 0, 0);

float neuron_size = 35;
float neuron_padding = 60;

float connection_width = 2.9;
float layer_padding = 250;

//Coords of the network on screen
float network_x = 0;
float network_y = 300;

//Camera Controls
float zoom = 1.00;
float x_offset = 0.00;
float y_offset = 0.00;

float shift_sensitivity = 10; //How sensitive WASD keys are
float zoom_sensitivity = 0.04; //How sensitive zoom is
float mouse_sensitivity = 1.4; //How sensitive dragging is

Network network = null; //Main Network for the program

void setup(){
  size(500, 500);
  frameRate(18);
  
  createGUI();
  update_gui_values();
  generate_network();
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

  fill(255,255,255);
  textAlign(LEFT);
  textSize(11);
  String zoom_string = str(zoom).substring(0, 3);
  String x_off_string = str(x_offset).substring(0, 3);
  String y_off_string = str(y_offset).substring(0, 3);
  
  text(zoom_string + "x zoom factor, x:"+ x_off_string + ", y:" + y_off_string, 0, 10); //Draw Activation Text

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
}
