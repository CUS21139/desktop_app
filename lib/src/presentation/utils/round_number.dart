import 'dart:math';

double roundNumber(double val){ 
   num mod = pow(10.0, 2); 
   return ((val * mod).round().toDouble() / mod); 
}