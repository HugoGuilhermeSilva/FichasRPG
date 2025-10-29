import 'package:flutter/material.dart';

class PowerProvider with ChangeNotifier{
  final Map<String, int> _selectedPowers = {};
  Map<String, int> get selectedPowers => _selectedPowers;

  bool isPowerSelected(String powerName){
    return _selectedPowers.containsKey(powerName);
  }
  int getPowerLevel(String powerName){
    return _selectedPowers[powerName] ?? 0;
  }
  void togglePowerSelection(String powerName, bool isSelected){
    if(isSelected){
      if(!_selectedPowers.containsKey(powerName)){
        _selectedPowers[powerName] = 1;
      }else{
        _selectedPowers.remove(powerName);
      }
      notifyListeners();
    }
  }
  void incrementPowerLevel(String powerName){
    if(_selectedPowers.containsKey(powerName)){
      _selectedPowers[powerName] = _selectedPowers[powerName]! + 1;
      notifyListeners();
    }
  }
  void decrementPowerLevel(String powerName){
    if(_selectedPowers.containsKey(powerName)){
      int currentLevel = _selectedPowers[powerName]!;
      if(currentLevel > 1 ){
        _selectedPowers[powerName] = currentLevel - 1;
      } else{
        _selectedPowers.remove(powerName);
      }
      notifyListeners();
    }
  }
  void setPowerLevel(String powerName, int level) {
    if (level > 0) {
      _selectedPowers[powerName] = level;
    } else {
      _selectedPowers.remove(powerName);
    }
  }
  void notifyExternalChange() {
    notifyListeners();
  }
}