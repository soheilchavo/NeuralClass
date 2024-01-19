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
  epochs = int(EpochField.getText());
} //_CODE_:EpochField:826180:

public void ActivationListChanged(GDropList source, GEvent event) { //_CODE_:ActivationList:754752:
  activation = ActivationList.getSelectedText();
} //_CODE_:ActivationList:754752:

public void LossFunctionListChanged(GDropList source, GEvent event) { //_CODE_:LossFunctionList:713425:
  loss = LossFunctionList.getSelectedText();
} //_CODE_:LossFunctionList:713425:

public void BatchSizeChanged(GTextField source, GEvent event) { //_CODE_:BatchSizeField:735693:
  batch_size = BatchSizeField.getValueI();
} //_CODE_:BatchSizeField:735693:

public void RandomizeChanged(GCheckbox source, GEvent event) { //_CODE_:RandomizeBox:490513:
  randomize_weight_and_biases = RandomizeBox.isSelected();
} //_CODE_:RandomizeBox:490513:

public void AlphaChanged(GTextField source, GEvent event) { //_CODE_:AlphaBox:380148:
  alpha = AlphaBox.getValueF();
} //_CODE_:AlphaBox:380148:

public void TrainButtonClicked(GButton source, GEvent event) { //_CODE_:TrainButton:677718:
  print("Train Model");
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
  hidden_layers = int(LayersBox.getText());
} //_CODE_:LayersBox:264288:

public void NeuronsBoxChanged(GTextField source, GEvent event) { //_CODE_:NeuronsBox:235518:
  neurons_per_layer = int(NeuronsBox.getText());
} //_CODE_:NeuronsBox:235518:

synchronized public void win_draw2(PApplet appc, GWinData data) { //_CODE_:Network_Output:364765:
  appc.background(230);
} //_CODE_:Network_Output:364765:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  Parameters_Window = GWindow.getWindow(this, "Parameters", 150, 150, 260, 350, JAVA2D);
  Parameters_Window.noLoop();
  Parameters_Window.setActionOnClose(G4P.KEEP_OPEN);
  Parameters_Window.addDrawHandler(this, "win_draw1");
  Hyper_Paramters_Label = new GLabel(Parameters_Window, -10, 180, 268, 20);
  Hyper_Paramters_Label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  Hyper_Paramters_Label.setText("Hyper Paramters");
  Hyper_Paramters_Label.setLocalColorScheme(GCScheme.RED_SCHEME);
  Hyper_Paramters_Label.setOpaque(false);
  Epoch_Label = new GLabel(Parameters_Window, 20, 200, 58, 20);
  Epoch_Label.setText("Epochs");
  Epoch_Label.setOpaque(false);
  EpochField = new GTextField(Parameters_Window, 110, 200, 65, 19, G4P.SCROLLBARS_NONE);
  EpochField.setText("5");
  EpochField.setPromptText("(Numbers Only)");
  EpochField.setOpaque(true);
  EpochField.addEventHandler(this, "EpochFieldChagned");
  Activation_label = new GLabel(Parameters_Window, 20, 220, 57, 20);
  Activation_label.setText("Activation");
  Activation_label.setOpaque(false);
  ActivationList = new GDropList(Parameters_Window, 110, 220, 140, 80, 3, 10);
  ActivationList.setItems(loadStrings("list_754752"), 0);
  ActivationList.addEventHandler(this, "ActivationListChanged");
  CostLabel = new GLabel(Parameters_Window, 20, 240, 60, 20);
  CostLabel.setText("Loss");
  CostLabel.setOpaque(false);
  LossFunctionList = new GDropList(Parameters_Window, 110, 240, 140, 66, 2, 10);
  LossFunctionList.setItems(loadStrings("list_713425"), 0);
  LossFunctionList.addEventHandler(this, "LossFunctionListChanged");
  BatchSizeLabel = new GLabel(Parameters_Window, 20, 260, 66, 20);
  BatchSizeLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  BatchSizeLabel.setText("Batch-Size");
  BatchSizeLabel.setOpaque(false);
  BatchSizeField = new GTextField(Parameters_Window, 110, 260, 89, 22, G4P.SCROLLBARS_NONE);
  BatchSizeField.setText("5");
  BatchSizeField.setOpaque(true);
  BatchSizeField.addEventHandler(this, "BatchSizeChanged");
  RandomizeBox = new GCheckbox(Parameters_Window, 70, 120, 117, 20);
  RandomizeBox.setIconPos(GAlign.EAST);
  RandomizeBox.setText("Randomize W/B");
  RandomizeBox.setOpaque(false);
  RandomizeBox.addEventHandler(this, "RandomizeChanged");
  RandomizeBox.setSelected(true);
  AlphaLable = new GLabel(Parameters_Window, 20, 280, 70, 20);
  AlphaLable.setText("Alpha");
  AlphaLable.setOpaque(false);
  AlphaBox = new GTextField(Parameters_Window, 110, 280, 90, 22, G4P.SCROLLBARS_NONE);
  AlphaBox.setText("0.5");
  AlphaBox.setOpaque(true);
  AlphaBox.addEventHandler(this, "AlphaChanged");
  TrainButton = new GButton(Parameters_Window, 60, 310, 121, 30);
  TrainButton.setText("Train Network");
  TrainButton.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  TrainButton.addEventHandler(this, "TrainButtonClicked");
  LoadButton = new GButton(Parameters_Window, 130, 20, 56, 25);
  LoadButton.setText("Load");
  LoadButton.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  LoadButton.addEventHandler(this, "LoadButtonClicked");
  SaveButton = new GButton(Parameters_Window, 60, 20, 56, 22);
  SaveButton.setText("Save");
  SaveButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  SaveButton.addEventHandler(this, "SaveButtonClicked");
  GenerateButton = new GButton(Parameters_Window, 70, 150, 108, 30);
  GenerateButton.setText("Generate Network");
  GenerateButton.addEventHandler(this, "GenerateButtonClicked");
  label1 = new GLabel(Parameters_Window, 0, 0, 259, 20);
  label1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label1.setText("Save or Load Network");
  label1.setOpaque(false);
  LayersLabel = new GLabel(Parameters_Window, 30, 70, 93, 20);
  LayersLabel.setText("Hidden Layers");
  LayersLabel.setOpaque(false);
  NeuronsLabel = new GLabel(Parameters_Window, 30, 100, 93, 20);
  NeuronsLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  NeuronsLabel.setText("Neurons/Layer");
  NeuronsLabel.setOpaque(false);
  LayersBox = new GTextField(Parameters_Window, 130, 70, 90, 22, G4P.SCROLLBARS_NONE);
  LayersBox.setText("4");
  LayersBox.setOpaque(true);
  LayersBox.addEventHandler(this, "LayersBoxChanged");
  NeuronsBox = new GTextField(Parameters_Window, 130, 100, 90, 21, G4P.SCROLLBARS_NONE);
  NeuronsBox.setText("14");
  NeuronsBox.setOpaque(true);
  NeuronsBox.addEventHandler(this, "NeuronsBoxChanged");
  GenerateLabel = new GLabel(Parameters_Window, 0, 50, 260, 20);
  GenerateLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  GenerateLabel.setText("Network Parameters");
  GenerateLabel.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  GenerateLabel.setOpaque(false);
  Network_Output = GWindow.getWindow(this, "NetworkOutput", 950, 250, 300, 230, JAVA2D);
  Network_Output.noLoop();
  Network_Output.setActionOnClose(G4P.KEEP_OPEN);
  Network_Output.addDrawHandler(this, "win_draw2");
  OutputLabel = new GLabel(Network_Output, 6, 6, 80, 20);
  OutputLabel.setText("Output");
  OutputLabel.setOpaque(false);
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
GWindow Network_Output;
GLabel OutputLabel; 
