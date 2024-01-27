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
  if(activation == index_in_arr(activation_list, "Sigmoid"))
    return sigmoid(x);
  if(activation == index_in_arr(activation_list, "Inverse Tan"))
    return inv_tan(x);
  if(activation == index_in_arr(activation_list, "Relu"))
    return relu(x);
  return 0;
}

float activation_function_prime(float x){
  if(activation == index_in_arr(activation_list, "Sigmoid"))
    return sigmoid_prime(x);
  if(activation == index_in_arr(activation_list, "Inverse Tan"))
    return inv_tan_prime(x);
  if(activation == index_in_arr(activation_list, "Relu"))
    return relu_prime(x);
   return 0;
}


//Cost functions

float quadratic_cost(float y, float y_h){
  return pow((y-y_h), 2);
}

float quadratic_cost_prime(float y, float y_h){
  return 2*(y-y_h);
}

float linear_cost(float y, float y_h){
  return abs(y-y_h);
}

float linear_cost_prime(float y, float y_h){
  if(y_h > y)
    return 1;
  return -1;
}

float loss_function_single(float y, float y_h){
  if(loss == index_in_arr(loss_list, "Quadratic"))
    return quadratic_cost(y, y_h);
  if(loss == index_in_arr(loss_list, "Linear"))
    return linear_cost(y, y_h);
   return 0;
}

float loss_function_prime_single(float y, float y_h){
  if(activation == index_in_arr(loss_list, "Quadratic"))
    return quadratic_cost_prime(y, y_h);
  if(activation == index_in_arr(loss_list, "Linear"))
    return linear_cost_prime(y, y_h);
   return 0;
}

float loss_function(float y[], float y_h[]){
  float sum = 0;
  for(int i = 0; i < y.length; i++){
    sum += loss_function_single(y[i], y_h[i]);
  }
  return sum;
}

float loss_function_prime(float y[], float y_h[]){
  float sum = 0;
  for(int i = 0; i < y.length; i++){
    sum += loss_function_prime_single(y[i], y_h[i]);
  }
  return sum;
}

float multiply_arraylist_items(ArrayList<Float> arr){
  float product = 1;
  for(Float f: arr){
    product *= f;
  }
  return product;
}
