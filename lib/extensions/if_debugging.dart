import 'package:flutter/foundation.dart';

extension IfDebugging on String{
String? get ifDebugging{
  if(kDebugMode){
    return this;
  }
  return null;
}
}