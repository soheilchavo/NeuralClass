void generate_network(){
  network = new Network(input_size, output_size, hidden_layers, neurons_per_layer);
}

void save_network(){
  selectOutput("Create Network file", "networkOutputSelected");
}

void networkOutputSelected(File selection){
  //PrintWriter output = createOutput(selection.getAbsolutePath());
  return;
}

void load_network(){
  selectInput("Select Network to load.", "networkSelected");
}

void networkSelected(File selection){
  print(selection + " selected");
}
