//Clamps a value between two numbers
float clamp(float val, float min, float max) {
  if (val < min) 
    return min;
  if (val > max) 
    return max;
  return val;
}

//Zoom in and out with scrollwheel
void mouseWheel(MouseEvent event)
{
  zoom = clamp(zoom - event.getCount()*zoom_sensitivity, 0.1, 4);
}

//Drag screen around
void mouseDragged(MouseEvent event) {
  x_offset += (-pmouseX+mouseX)*mouse_sensitivity*(1/zoom);
  y_offset += (-pmouseY+mouseY)*mouse_sensitivity*(1/zoom);
}

void keyPressed() {
  
  //Move around with wasd
  if (key == 'w')
    y_offset += shift_sensitivity*(1/zoom);
    
  if (key == 'a')
    x_offset += shift_sensitivity*(1/zoom);
    
  if (key == 's')
    y_offset -= shift_sensitivity*(1/zoom);

  if (key == 'd')
    x_offset -= shift_sensitivity*(1/zoom);

  //Zoom in and out with either =/- or o/i
  if (key == '=' || key == 'o')
    zoom += zoom_sensitivity;
  
  if (key == '-' || key == 'i')
    zoom -= zoom_sensitivity;
    
  //////////////////////////////////////////////////
  //TAKE OUT
  if (key == 'f')
    feed_forward(network, new float[] {0, 1, 45, 4});
    //backprop(network, new float[] {1, 0, 0, 0});
  
}  
