import 'package:fichas/data/advantages_data.dart';
import 'package:fichas/models/record_model.dart';
import 'package:flutter/material.dart';

class AdvantagesProvider with ChangeNotifier {
  List<String> _selectedAdvantages = [];
  List<String> _bonusAdvantages = [];
  List<String> _bonusAdvantagesByPassives = [];
  List<String> get selectedAdvantages => _selectedAdvantages;
  List<String> get allSelectedAdvantages => [..._selectedAdvantages, ..._bonusAdvantages, ..._bonusAdvantagesByPassives];
  final Function(List<String>)? onDataChanged;
  final VoidCallback? onAdvantagesChangedForRecalculation;

  AdvantagesProvider({this.onDataChanged, this.onAdvantagesChangedForRecalculation});
  String getAdvantageDescription(String advantageName) {
    try {
      final advantage = allAdvantages.firstWhere((adv) => adv.name == advantageName,);
      return advantage.description;
    } catch (e) {
      return 'Descrição não encontrada.';
    }
  }
  void clearPassivesBonusAdvantages(){
    _bonusAdvantagesByPassives.clear();
    notifyListeners();
  }
  void addPassivesBonusAdvantages(String advantageName){
    if(!_bonusAdvantagesByPassives.contains(advantageName)){
      _bonusAdvantagesByPassives.add(advantageName);
      notifyListeners();
    }
  }
  void clearBonusAdvantagesSilently() {
    _bonusAdvantages.clear();
    notifyListeners();
  }
  void addBonusAdvantageSilently(String advantageName) {
    if (!_bonusAdvantages.contains(advantageName)) {
      _bonusAdvantages.add(advantageName);
      notifyListeners();
    }
  }
  void addBonusAdvantage(String advantageName) {
    if (!_bonusAdvantages.contains(advantageName)) {
      _bonusAdvantages.add(advantageName);
      _notifyAndSaveChanges();
    }
  }
  void clearBonusAdvantages() {
    if (_bonusAdvantages.isNotEmpty) {
      _bonusAdvantages.clear();
      _notifyAndSaveChanges();
    }
  }
  void updateFromRecord(Record? record) {
    _selectedAdvantages = record?.advantagesData ?? [];
    notifyListeners();
  }
  void _notifyAndSaveChanges() {
    onDataChanged?.call(_selectedAdvantages);
    onAdvantagesChangedForRecalculation?.call();
    notifyListeners();
  }
  void toggleAdvantageSelection(String advantageName, bool isSelected) {
    if (isSelected) {
      if (!_selectedAdvantages.contains(advantageName)) {
        _selectedAdvantages.add(advantageName);
      }
    } else {
      _selectedAdvantages.remove(advantageName);
    }
    _notifyAndSaveChanges();
  }
  bool isAdvantageSelected(String advantageName) {
    return allSelectedAdvantages.contains(advantageName);
  }
}