/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

synchronized public void win_draw1(PApplet appc, GWinData data) { //_CODE_:Parameters_Window:437002:
  appc.background(230);
} //_CODE_:Parameters_Window:437002:

public void EpochFieldChagned(GTextField source, GEvent event) { //_CODE_:EpochField:826180:
  epochs = int(clamp(int(EpochField.getText()), 1, 8));
} //_CODE_:EpochField:826180:

public void ActivationListChanged(GDropList source, GEvent event) { //_CODE_:ActivationList:754752:
  activation = index_in_arr(activation_list, ActivationList.getSelectedText());
} //_CODE_:ActivationList:754752:

public void LossFunctionListChanged(GDropList source, GEvent event) { //_CODE_:LossFunctionList:713425:
  loss = index_in_arr(loss_list, LossFunctionList.getSelectedText());
} //_CODE_:LossFunctionList:713425:

public void BatchSizeChanged(GTextField source, GEvent event) { //_CODE_:BatchSizeField:735693:
  batch_size = int(clamp(int(BatchSizeField.getText()), 1, 12));
} //_CODE_:BatchSizeField:735693:

public void RandomizeChanged(GCheckbox source, GEvent event) { //_CODE_:RandomizeBox:490513:
  randomize_weight_and_bias = RandomizeBox.isSelected();
} //_CODE_:RandomizeBox:490513:

public void AlphaChanged(GTextField source, GEvent event) { //_CODE_:AlphaBox:380148:
  alpha = clamp(float(AlphaBox.getText()), 0.01, 2);
} //_CODE_:AlphaBox:380148:

public void TrainButtonClicked(GButton source, GEvent event) { //_CODE_:TrainButton:677718:

  if(training){
    TrainButton.setText("Train Network");
    SelectSample.setLocalColorScheme(5);
    training = false;
  }
  else{
    TrainButton.setText("Stop Training");
    SelectSample.setLocalColorScheme(0);
    thread("train"); //Starts training model on a new CPU thread
  }
} //_CODE_:TrainButton:677718:

public void LoadButtonClicked(GButton source, GEvent event) { //_CODE_:LoadButton:544203:
  load_network();
} //_CODE_:LoadButton:544203:

public void SaveButtonClicked(GButton source, GEvent event) { //_CODE_:SaveButton:606723:
  save_network();
} //_CODE_:SaveButton:606723:

public void GenerateButtonClicked(GButton source, GEvent event) { //_CODE_:GenerateButton:224937:
  generate_network();
} //_CODE_:GenerateButton:224937:

public void LayersBoxChanged(GTextField source, GEvent event) { //_CODE_:LayersBox:264288:
  hidden_layers = int(clamp(int(LayersBox.getText()),1,10000));
} //_CODE_:LayersBox:264288:

public void NeuronsBoxChanged(GTextField source, GEvent event) { //_CODE_:NeuronsBox:235518:
  neurons_per_layer = int(clamp(int(NeuronsBox.getText()),1,10000));
} //_CODE_:NeuronsBox:235518:

public void TraningDatasetButtonClicked(GButton source, GEvent event) { //_CODE_:TrainingDatasetButton:551031:
  select_training_dataset();
  update_gui_values();
} //_CODE_:TrainingDatasetButton:551031:

public void BWCheckboxClicked(GCheckbox source, GEvent event) { //_CODE_:BWCheckbox:955981:
  black_and_white = BWCheckbox.isSelected();
} //_CODE_:BWCheckbox:955981:

synchronized public void win_draw2(PApplet appc, GWinData data) { //_CODE_:Network_Output:364765:
  appc.background(230);
} //_CODE_:Network_Output:364765:

public void SampleButtonClicked(GButton source, GEvent event) { //_CODE_:SelectSample:765611:
  output_mode = "Sample";
  SelectSample.setLocalColorScheme(5);
  SetButton.setLocalColorScheme(0);
} //_CODE_:SelectSample:765611:

public void SetButtonClicked(GButton source, GEvent event) { //_CODE_:SetButton:310582:
  output_mode = "Set";
  SetButton.setLocalColorScheme(5);
  SelectSample.setLocalColorScheme(0);
} //_CODE_:SetButton:310582:

public void DataSelectClicked(GButton source, GEvent event) { //_CODE_:DataSelectButton:869626:
  
  if(output_mode == "Set"){
    select_testing_dataset();
  }
  else{
    select_sample_data();
    update_gui_values();
  }
} //_CODE_:DataSelectButton:869626:

public void FeedForwardButtonClicked(GButton source, GEvent event) { //_CODE_:FeedForwardButton:837957:
  
  if(output_mode == "Sample"){
    if(curr_sample == null)
      println("Sample Not Loaded.");
    else
      feed_forward_sample();
  }
  else{
    if(testing_data == null)
      println("Data Not Loaded.");
    else
      feed_forward_set();
  }
} //_CODE_:FeedForwardButton:837957:

public void OutputDirectoryButtonClicked(GButton source, GEvent event) { //_CODE_:OutputDirectoryButton:259796:
  select_output_folder();
} //_CODE_:OutputDirectoryButton:259796:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("NeuralClass");
  Parameters_Window = GWindow.getWindow(this, "Parameters", 244, 150, 260, 530, JAVA2D);
  Parameters_Window.noLoop();
  Parameters_Window.setActionOnClose(G4P.KEEP_OPEN);
  Parameters_Window.addDrawHandler(this, "win_draw1");
  Hyper_Paramters_Label = new GLabel(Parameters_Window, -10, 220, 268, 20);
  Hyper_Paramters_Label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  Hyper_Paramters_Label.setText("Hyper Paramters");
  Hyper_Paramters_Label.setLocalColorScheme(GCScheme.RED_SCHEME);
  Hyper_Paramters_Label.setOpaque(false);
  Epoch_Label = new GLabel(Parameters_Window, 10, 250, 110, 20);
  Epoch_Label.setText("Epochs (1-8)");
  Epoch_Label.setOpaque(true);
  EpochField = new GTextField(Parameters_Window, 130, 250, 120, 19, G4P.SCROLLBARS_NONE);
  EpochField.setText("5");
  EpochField.setPromptText("(Numbers Only)");
  EpochField.setOpaque(true);
  EpochField.addEventHandler(this, "EpochFieldChagned");
  Activation_label = new GLabel(Parameters_Window, 10, 280, 110, 20);
  Activation_label.setText("Activation Function");
  Activation_label.setOpaque(true);
  ActivationList = new GDropList(Parameters_Window, 130, 280, 120, 80, 3, 10);
  ActivationList.setItems(loadStrings("list_754752"), 0);
  ActivationList.addEventHandler(this, "ActivationListChanged");
  CostLabel = new GLabel(Parameters_Window, 10, 310, 110, 20);
  CostLabel.setText("Cost Function");
  CostLabel.setOpaque(true);
  LossFunctionList = new GDropList(Parameters_Window, 130, 310, 120, 66, 2, 10);
  LossFunctionList.setItems(loadStrings("list_713425"), 0);
  LossFunctionList.addEventHandler(this, "LossFunctionListChanged");
  BatchSizeLabel = new GLabel(Parameters_Window, 10, 340, 110, 20);
  BatchSizeLabel.setText("Batch-Size (1-12)");
  BatchSizeLabel.setOpaque(true);
  BatchSizeField = new GTextField(Parameters_Window, 130, 340, 120, 22, G4P.SCROLLBARS_NONE);
  BatchSizeField.setText("5");
  BatchSizeField.setOpaque(true);
  BatchSizeField.addEventHandler(this, "BatchSizeChanged");
  RandomizeBox = new GCheckbox(Parameters_Window, 50, 150, 170, 20);
  RandomizeBox.setIconPos(GAlign.EAST);
  RandomizeBox.setText("Random Weight & Biases");
  RandomizeBox.setOpaque(false);
  RandomizeBox.addEventHandler(this, "RandomizeChanged");
  RandomizeBox.setSelected(true);
  AlphaLable = new GLabel(Parameters_Window, 10, 370, 110, 20);
  AlphaLable.setText("Alpha (0.01-2)");
  AlphaLable.setOpaque(true);
  AlphaBox = new GTextField(Parameters_Window, 130, 370, 120, 22, G4P.SCROLLBARS_NONE);
  AlphaBox.setText("0.5");
  AlphaBox.setOpaque(true);
  AlphaBox.addEventHandler(this, "AlphaChanged");
  TrainButton = new GButton(Parameters_Window, 10, 480, 240, 40);
  TrainButton.setText("Train Network");
  TrainButton.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  TrainButton.addEventHandler(this, "TrainButtonClicked");
  LoadButton = new GButton(Parameters_Window, 130, 30, 120, 25);
  LoadButton.setText("Load");
  LoadButton.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  LoadButton.addEventHandler(this, "LoadButtonClicked");
  SaveButton = new GButton(Parameters_Window, 10, 30, 110, 22);
  SaveButton.setText("Save");
  SaveButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  SaveButton.addEventHandler(this, "SaveButtonClicked");
  GenerateButton = new GButton(Parameters_Window, 20, 180, 220, 30);
  GenerateButton.setText("Generate Network");
  GenerateButton.addEventHandler(this, "GenerateButtonClicked");
  label1 = new GLabel(Parameters_Window, 0, 0, 259, 20);
  label1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label1.setText("Save or Load Network");
  label1.setOpaque(false);
  LayersLabel = new GLabel(Parameters_Window, 10, 90, 110, 20);
  LayersLabel.setText("Hidden Layers");
  LayersLabel.setOpaque(true);
  NeuronsLabel = new GLabel(Parameters_Window, 10, 120, 110, 20);
  NeuronsLabel.setText("Neurons/Layer");
  NeuronsLabel.setOpaque(true);
  LayersBox = new GTextField(Parameters_Window, 130, 90, 120, 22, G4P.SCROLLBARS_NONE);
  LayersBox.setText("4");
  LayersBox.setOpaque(true);
  LayersBox.addEventHandler(this, "LayersBoxChanged");
  NeuronsBox = new GTextField(Parameters_Window, 130, 120, 120, 21, G4P.SCROLLBARS_NONE);
  NeuronsBox.setText("14");
  NeuronsBox.setOpaque(true);
  NeuronsBox.addEventHandler(this, "NeuronsBoxChanged");
  GenerateLabel = new GLabel(Parameters_Window, 0, 60, 260, 20);
  GenerateLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  GenerateLabel.setText("Network Parameters");
  GenerateLabel.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  GenerateLabel.setOpaque(false);
  TrainingDatasetButton = new GButton(Parameters_Window, 30, 440, 200, 30);
  TrainingDatasetButton.setText("Load Training Dataset");
  TrainingDatasetButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  TrainingDatasetButton.addEventHandler(this, "TraningDatasetButtonClicked");
  BWCheckbox = new GCheckbox(Parameters_Window, 30, 410, 200, 20);
  BWCheckbox.setIconPos(GAlign.EAST);
  BWCheckbox.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  BWCheckbox.setText("Dataset is in Black and White");
  BWCheckbox.setOpaque(false);
  BWCheckbox.addEventHandler(this, "BWCheckboxClicked");
  BWCheckbox.setSelected(true);
  Network_Output = GWindow.getWindow(this, "NetworkOutput", 400, 250, 300, 400, JAVA2D);
  Network_Output.noLoop();
  Network_Output.setActionOnClose(G4P.KEEP_OPEN);
  Network_Output.addDrawHandler(this, "win_draw2");
  OutputLabel = new GLabel(Network_Output, 20, 20, 80, 20);
  OutputLabel.setText("Output Mode:");
  OutputLabel.setOpaque(false);
  SelectSample = new GButton(Network_Output, 111, 20, 80, 20);
  SelectSample.setText("Sample");
  SelectSample.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  SelectSample.addEventHandler(this, "SampleButtonClicked");
  SetButton = new GButton(Network_Output, 200, 20, 80, 20);
  SetButton.setText("Set");
  SetButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  SetButton.addEventHandler(this, "SetButtonClicked");
  DataSelectButton = new GButton(Network_Output, 20, 60, 120, 30);
  DataSelectButton.setText("Select Data");
  DataSelectButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  DataSelectButton.addEventHandler(this, "DataSelectClicked");
  FeedForwardButton = new GButton(Network_Output, 60, 180, 180, 40);
  FeedForwardButton.setText("Feed Forward Data");
  FeedForwardButton.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  FeedForwardButton.addEventHandler(this, "FeedForwardButtonClicked");
  NetworkGuessLabel = new GLabel(Network_Output, -10, 220, 310, 20);
  NetworkGuessLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  NetworkGuessLabel.setText("Network Guess:");
  NetworkGuessLabel.setOpaque(false);
  OutputDirectoryButton = new GButton(Network_Output, 150, 60, 130, 30);
  OutputDirectoryButton.setText("Select Output Directory");
  OutputDirectoryButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  OutputDirectoryButton.addEventHandler(this, "OutputDirectoryButtonClicked");
  DataLabel = new GLabel(Network_Output, 0, 100, 300, 70);
  DataLabel.setIcon("6.png", 1, GAlign.SOUTH, GAlign.CENTER, GAlign.MIDDLE);
  DataLabel.setTextAlign(GAlign.CENTER, GAlign.TOP);
  DataLabel.setText("Data Not Loaded");
  DataLabel.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  DataLabel.setOpaque(false);
  NetworkOutputLabel = new GLabel(Network_Output, 60, 240, 180, 160);
  NetworkOutputLabel.setTextAlign(GAlign.CENTER, GAlign.TOP);
  NetworkOutputLabel.setText("No Output");
  NetworkOutputLabel.setOpaque(false);
  Parameters_Window.loop();
  Network_Output.loop();
}

// Variable declarations 
// autogenerated do not edit
GWindow Parameters_Window;
GLabel Hyper_Paramters_Label; 
GLabel Epoch_Label; 
GTextField EpochField; 
GLabel Activation_label; 
GDropList ActivationList; 
GLabel CostLabel; 
GDropList LossFunctionList; 
GLabel BatchSizeLabel; 
GTextField BatchSizeField; 
GCheckbox RandomizeBox; 
GLabel AlphaLable; 
GTextField AlphaBox; 
GButton TrainButton; 
GButton LoadButton; 
GButton SaveButton; 
GButton GenerateButton; 
GLabel label1; 
GLabel LayersLabel; 
GLabel NeuronsLabel; 
GTextField LayersBox; 
GTextField NeuronsBox; 
GLabel GenerateLabel; 
GButton TrainingDatasetButton; 
GCheckbox BWCheckbox; 
GWindow Network_Output;
GLabel OutputLabel; 
GButton SelectSample; 
GButton SetButton; 
GButton DataSelectButton; 
GButton FeedForwardButton; 
GLabel NetworkGuessLabel; 
GButton OutputDirectoryButton; 
GLabel DataLabel; 
GLabel NetworkOutputLabel; 
