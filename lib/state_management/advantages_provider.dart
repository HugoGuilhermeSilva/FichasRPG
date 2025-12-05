import 'package:fichas/data/advantages_data.dart';
import 'package:fichas/models/record_model.dart';
import 'package:flutter/material.dart';

class AdvantagesProvider with ChangeNotifier {
  List<String> _selectedAdvantages = [];
  List<String> get selectedAdvantages => _selectedAdvantages;
  final Function(List<String>)? onDataChanged;

  AdvantagesProvider({this.onDataChanged});
  String getAdvantageDescription(String advantageName) {
    try {
      final advantage = allAdvantages.firstWhere((adv) => adv.name == advantageName,);
      return advantage.description;
    } catch (e) {
      return 'Descrição não encontrada.';
    }
  }
  void updateFromRecord(Record? record) {
    _selectedAdvantages = record?.advantagesData ?? [];
    notifyListeners();
  }
  void _notifyAndSaveChanges() {
    onDataChanged?.call(_selectedAdvantages);
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
    return _selectedAdvantages.contains(advantageName);
  }
}