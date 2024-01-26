class Sample{
  
  File image_file;
  String type;
  
  Sample(File s){
    this.image_file = s;
  }
  
  Sample(File s, String c){
    this.image_file = s;
    this.type = c;
  }
  
  float[] get_pixel_data(){
    PImage image = loadImage(this.image_file.getPath());
    
    if(black_and_white){
      image.loadPixels();
      float[] output_pixels = new float[image.pixels.length];
      
      for(int i = 0; i < image.pixels.length; i++){
        output_pixels[i] = (red(image.pixels[i]) + green(image.pixels[i]) + blue(image.pixels[i]))/3;
      }
      return output_pixels;
    }
    return new float[] {};
  }
  
}

void select_training_dataset(){
  selectFolder("Select Training Dataset Folder", "training_dataset_selected", new File(sketchPath() + "/data"));
}

void training_dataset_selected(File selection){
  
  println("Loading Dataset: " + selection.getName());
  
  try{
    training_data = new ArrayList<Sample>();
    
    output_size = selection.listFiles().length;
    output_classes = new String[output_size]; 
    
    for(int i = 0; i < selection.listFiles().length; i++){
      File f = selection.listFiles()[i];
      output_classes[i] = f.getName();
      for(File s: f.listFiles()){
        training_data.add(new Sample(s, f.getName()));
      }
    }
    
    curr_sample = training_data.get(0);
    PImage sample_image = loadImage(curr_sample.image_file.getPath());
    input_size = sample_image.width*sample_image.height;
    
    neurons_per_layer = int(input_size*2/3);
    
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
}

void select_testing_dataset(){
  selectFolder("Select Testing Dataset Folder", "testing_dataset_selected", new File(sketchPath() + "/data"));
}

void testing_dataset_selected(File selection){
  try{
    testing_data = new ArrayList<Sample>();
    for(File f: selection.listFiles()){
      for(File s: f.listFiles()){
        testing_data.add(new Sample(s, f.getName()));
      }
    }
  }
  catch(Exception e) { println("Training data failed to load, most likley improper formatting, " + e); }    
}

void select_output_folder(){
  selectFolder("Select Output Folder", "output_folder_selected", new File(sketchPath() + "/data"));
}

void output_folder_selected(File selection){
  output_path = selection.getPath();
}
