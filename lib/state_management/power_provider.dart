import 'package:flutter/material.dart';

class PowerProvider with ChangeNotifier{
  final Map<String, int> _selectedPowers = {};
  Map<String, int> get selectedPowers => _selectedPowers;
  final TextEditingController displacementController = TextEditingController();

  bool isPowerSelected(String powerName){
    return _selectedPowers.containsKey(powerName);
  }
  int getPowerLevel(String powerName){
    return _selectedPowers[powerName] ?? 0;
  }
  void togglePowerSelection(String powerName, bool isSelected) {
    if (isSelected) {
      if (!_selectedPowers.containsKey(powerName)) {
        _selectedPowers[powerName] = 1;
      }
    } else {
      _selectedPowers.remove(powerName);
    }
    _updateCalculatedValues();
  }
  void incrementPowerLevel(String powerName){
    if(_selectedPowers.containsKey(powerName)){
      _selectedPowers[powerName] = _selectedPowers[powerName]! + 1;
      _updateCalculatedValues();
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
      _updateCalculatedValues();
    }
  }
  void setPowerLevel(String powerName, int level) {
    if (level > 0) {
      _selectedPowers[powerName] = level;
    } else {
      _selectedPowers.remove(powerName);
    }
  }
  int get totalDisplacement {
    const int baseDisplacement = 10;
    final moveLevel = getPowerLevel('Mover-se');
    return baseDisplacement + (5 * moveLevel);
  }
  void _updateCalculatedValues() {
    displacementController.text = totalDisplacement.toString();
    notifyListeners();
  }
  void notifyExternalChange() {
    notifyListeners();
  }
}