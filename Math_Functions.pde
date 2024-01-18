//Activation functions and their derrivatives
float sigmoid(float x){
  return 1/(1+exp(-x));
}

float sigmoid_prime(float x){
  return sigmoid(1-sigmoid(x));
}

float inv_tan(float x){
  return 1/tan(x);
}

float inv_tan_prime(float x){
  return -1/pow(sin(x), 2);
}

float relu(float x){
  return max(0, x);
}

float relu_prime(float x){
  if(x > 0){
    return 1;
  }
  return 0;
}

//Cost functions
float quadratic_cost(float y, float y_h){
  return pow((y-y_h), 2);
}

float quadratic_cost_avg(float[] y, float[] y_h){
  float sum = 0;
  for(int i = 0; i < y.length; i++){
    sum += quadratic_cost(y[i], y_h[i]);
  }
  return sum/y.length;
}

float cross_entropy_cost(float y, float y_h){
  return (y_h * log(y) + (1 - y_h)*log(1-y));
}

float cross_entropy_cost_avg(float y[], float y_h[]){
  float sum = 0;
  for(int i = 0; i < y.length; i++){
    sum += cross_entropy_cost(y[i], y_h[i]);
  }
  return sum/y.length;
}
