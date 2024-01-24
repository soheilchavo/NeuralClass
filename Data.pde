class Sample{
  
  File image;
  String type;
  
  Sample(File s, String c){
    this.image = s;
    this.type = c;
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
    
    for(File f: selection.listFiles()){
      for(File s: f.listFiles()){
        training_data.add(new Sample(s, f.getName()));
      }
    }
    
    
    curr_sample = training_data.get(0);
    PImage sample_image = loadImage(curr_sample.image.getCanonicalPath());
    input_size = sample_image.width*sample_image.height;
    
    neurons_per_layer = int(input_size*2/3);
    
    generate_network();
  }
  catch(Exception e) { println("Training data failed to load, most likley improper formatting, " + e); }    
  
  println("Successfully Loaded: " + selection.getName() + ", Ready to begin training");
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
