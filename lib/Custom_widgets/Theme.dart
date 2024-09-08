import 'package:flutter/material.dart';
class Theme extends ChangeNotifier{
  var _themeState = ThemeMode.light;
ThemeMode get themeState => _themeState;
void setTheme (){
  final isLight = _themeState == ThemeMode.light;
  if (isLight) {
_themeState = ThemeMode.light;    
  }else{
   _themeState = ThemeMode.dark;

  }
}
}