//Class for each data sample
class Sample{
  
  File image_file;
  String type; //The output class, ex. 0-9 for MNIST dataset
  
  Sample(File s){
    this.image_file = s;
  }
  
  Sample(File s, String c){
    this.image_file = s;
    this.type = c;
  }
  
  //Condenses all pixels into a 1D float[]
  float[] get_pixel_data(){
    
    PImage image = loadImage(this.image_file.getPath());
    
    if(black_and_white){
      
      image.loadPixels();
      float[] output_pixels = new float[image.pixels.length];
      
      for(int i = 0; i < image.pixels.length; i++)
        output_pixels[i] = brightness(image.pixels[i])/255;
      
      return output_pixels;
    }
    
    //Creates 3x the neurons for r, g, and b values
    else{
      
      image.loadPixels();
      float[] output_pixels = new float[image.pixels.length*3];
      int x = 0;
      
      for(int i = 0; i < image.pixels.length; i++){
        output_pixels[x] = red(image.pixels[i])/255;
        output_pixels[x+1] = green(image.pixels[i])/255;
        output_pixels[x+2] = blue(image.pixels[i])/255;
        x += 3;
      }
      return output_pixels;
    }
  }
  
}

void select_training_dataset(){
  selectFolder("Select Training Dataset Folder", "training_dataset_selected", new File(sketchPath() + "/data"));
}

void training_dataset_selected(File selection){
  
  if(selection == null)
    return;
  
  dataset_name = selection.getName();
  
  println("Loading Dataset: " + selection.getName());
  
  try{
    
    training_data = new ArrayList<Sample>();
    
    output_size = selection.listFiles().length;
    output_classes = new String[output_size]; 
    
    //Itterate through each file in the folders and create a new Sample Object from it
    for(int i = 0; i < selection.listFiles().length; i++){
      
      File f = selection.listFiles()[i]; //Get all files in this classes folder
      output_classes[i] = f.getName(); //Set the output classes to 
      
      for(File s: f.listFiles()){
        training_data.add(new Sample(s, f.getName()));
      }
    }
    
    //Set input size using the first data sample
    curr_sample = training_data.get(0);
    PImage sample_image = loadImage(curr_sample.image_file.getPath());
    input_size = sample_image.width*sample_image.height;
    
    //Create 3x as many neurons for r, g, and b
    if(black_and_white == false)
      input_size *= 3;
    
    //Set n/l proportional to the input size
    neurons_per_layer = int(input_size*2/3);
    
    //Regenerate Network
    generate_network();
  }
  catch(Exception e) { println("Training data failed to load, most likley improper formatting, " + e); }    
  
  println("Successfully Loaded: " + selection.getName() + ", Ready to begin training");
}

void select_sample_data(){
  selectInput("Select Test Sample", "sample_data_selected", new File(sketchPath() + "/data"));
}

void sample_data_selected(File selection){
  curr_sample = new Sample(selection);
  println("Successfully Loaded: " + selection.getName() + ", Ready to feedforward.");
}

void select_testing_dataset(){
  selectFolder("Select Testing Dataset Folder", "testing_dataset_selected", new File(sketchPath() + "/data"));
}

void testing_dataset_selected(File selection){
  
  if(selection == null)
    return;
    
  dataset_name = selection.getName();
  
  //Load testing data 
  try{
    testing_data = new ArrayList<Sample>();
    for(File f: selection.listFiles()){
      for(File s: f.listFiles()){
        testing_data.add(new Sample(s, f.getName()));
      }
    }
    println("Successfully Loaded: " + selection.getName() + ", Ready to begin testing");
  }
  catch(Exception e) { println("Testing data failed to load, most likley improper formatting, " + e); }    
}

void select_output_folder(){
  selectFolder("Select Output Folder", "output_folder_selected", new File(sketchPath() + "/data"));
}

void output_folder_selected(File selection){
  if(selection == null)
    return;
  output_path = selection.getPath();
}
