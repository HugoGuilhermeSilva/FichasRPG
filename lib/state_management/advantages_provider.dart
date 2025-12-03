import 'package:fichas/models/record_model.dart';
import 'package:flutter/material.dart';

class AdvantagesProvider with ChangeNotifier {
  List<String> _selectedAdvantages = [];
  List<String> get selectedAdvantages => _selectedAdvantages;
  final Function(List<String>)? onDataChanged;

  AdvantagesProvider({this.onDataChanged});
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