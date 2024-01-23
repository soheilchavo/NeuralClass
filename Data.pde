class Sample{
  
  File image;
  String type;
  
  Sample(File s, String c){
    this.image = s;
    this.type = c;
  }  
  
}

void select_training_dataset(){
  selectFolder("Select Training Dataset Folder", "training_dataset_selected");
}

void training_dataset_selected(File selection){
  
  training_data = new ArrayList<Sample>();
  
  output_size = selection.listFiles().length;
  
  for(File f: selection.listFiles()){
    for(File s: f.listFiles()){
      training_data.add(new Sample(s, f.getName()));
    }
  }
  
}

void select_testing_dataset(){
  selectFolder("Select Testing Dataset Folder", "testing_dataset_selected");
}

void testing_dataset_selected(File selection){
  
  testing_data = new ArrayList<Sample>();
  
  output_size = selection.listFiles().length;
  
  for(File f: selection.listFiles()){
    for(File s: f.listFiles()){
      testing_data.add(new Sample(s, f.getName()));
    }
  }
}
