import 'package:fichas/data/power_model.dart';
import 'package:flutter/material.dart';
import 'package:fichas/data/power_list.dart';

class PowerProvider with ChangeNotifier{
  final Map<String, int> _selectedPowers = {};
  Map<String, int> get selectedPowers => _selectedPowers;
  final TextEditingController displacementController = TextEditingController();
  final TextEditingController totalDamageController = TextEditingController();
  final TextEditingController baseDamageController = TextEditingController();

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
  int get totalDagame{
    final damage = getPowerLevel('Dano');
    final elementalDamage = getPowerLevel('Manipulação Elemental');
    final ramDagame = getPowerLevel('Pente de RAM');
    final gravDagame = getPowerLevel('Gravidade');
    final soundDamage = getPowerLevel('Som');
    final psiDamage = getPowerLevel('Telecinese');
    final totalDamage = (damage + (elementalDamage / 2) + (ramDagame) + (gravDagame / 2) + (soundDamage) + (psiDamage / 2)).round();
    return totalDamage;
  }
  int get baseDamage{
    final elementalDamage = getPowerLevel('Manipulação Elemental');
    final gravDamage = getPowerLevel('Gravidade');
    final totalBaseDamage = (elementalDamage * 2) + (gravDamage * 2);
    return totalBaseDamage;
  }
  int get totalPowersCost {
    int totalCost = 0;
    _selectedPowers.forEach((powerName, powerLevel) {
      final powerData = allPowers.firstWhere(
            (p) => p.name == powerName,
        orElse: () => Power(name: 'not_found', description: '', cost: 0),
      );
        totalCost += (powerData.cost * powerLevel);
    });
    return totalCost;
  }

  void _updateCalculatedValues() {
    displacementController.text = totalDisplacement.toString();
    totalDamageController.text = totalDagame.toString();
    baseDamageController.text = baseDamage.toString();
    notifyListeners();
  }
  void notifyExternalChange() {
    _updateCalculatedValues();
  }
  @override
  void dispose() {
    displacementController.dispose();
    totalDamageController.dispose();
    baseDamageController.dispose();
    super.dispose();
  }
}