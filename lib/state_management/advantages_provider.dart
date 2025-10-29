import 'package:fichas/services/sotrage_Service.dart';
import 'package:flutter/material.dart';
import 'package:fichas/data/advantages_data.dart';

class AdvantagesProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<String> _selectedAdvantageNames = [];
  AdvantagesProvider() {
    _loadAdvantages();
  }
  int get selectedCount => _selectedAdvantageNames.length;
  bool isSelected(String advantageName) {
    return _selectedAdvantageNames.contains(advantageName);
  }
  void toggleAdvantage(String advantageName) {
    if (isSelected(advantageName)) {
      _selectedAdvantageNames.remove(advantageName);
    } else {
      _selectedAdvantageNames.add(advantageName);
    }
    _saveAdvantages();
    notifyListeners();
  }
  Future<void> _loadAdvantages() async {
    final loadedNames = await _storageService.loadStringList(
        'selected_advantages');
    if (loadedNames != null) {
      _selectedAdvantageNames = loadedNames;
      notifyListeners();
    }
  }
  Future<void> _saveAdvantages() async {
    await _storageService.saveStringList(
        'selected_advantages', _selectedAdvantageNames);
  }
}