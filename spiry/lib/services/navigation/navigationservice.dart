import 'package:flutter/material.dart';


class NavigationService{
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop(value) {
    return _navigationKey.currentState.pop(value);
  }
  Future<dynamic> pushNamed(String routeName, {List arguments}){
    return _navigationKey.currentState.pushNamed(routeName, arguments:arguments);
  }
  Future<dynamic> pushReplacementName(String routeName, {List arguments}){
    return _navigationKey.currentState.pushReplacementNamed(routeName,arguments: arguments);
  }
  Future<dynamic> pushReplacementNameUntil(String routeName, {List arguments}){
    return _navigationKey.currentState.pushNamedAndRemoveUntil(routeName, (route) => false,arguments: arguments);
  }
}