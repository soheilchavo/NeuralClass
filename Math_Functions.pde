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

float activation_function(float x){
  if(activation == "Sigmoid")
    return sigmoid(x);
  if(activation == "Inverse Tan")
    return inv_tan(x);
  if(activation == "Relu")
    return relu(x);
   return 0;
}

float activation_function_prime(float x){
  if(activation == "Sigmoid")
    return sigmoid_prime(x);
  if(activation == "Inverse Tan")
    return inv_tan_prime(x);
  if(activation == "Relu")
    return relu_prime(x);
   return 0;
}


//Cost functions
float quadratic_cost(float y, float y_h){
  return pow((y-y_h), 2);
}

float cross_entropy_cost(float y, float y_h){
  return (y_h * log(y) + (1 - y_h)*log(1-y));
}

float loss_function(float y, float y_h){
  if(activation == "Quadratic Cost")
    return quadratic_cost(y, y_h);
  if(activation == "Logistic Cost")
    return cross_entropy_cost(y, y_h);
   return 0;
}

float loss_function_avg(float y[], float y_h[]){
  float sum = 0;
  for(int i = 0; i < y.length; i++){
    sum += loss_function(y[i], y_h[i]);
  }
  return sum/y.length;
}
