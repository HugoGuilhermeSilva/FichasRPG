import 'package:flutter/material.dart';

const List<String> attributeNames = [
  'Força',
  'Destreza',
  'Agilidade',
  'Vigor',
  'Percepção',
  'Inteligencia',
  'Vontade',
  'Carisma'
];
class AttributesProvider with ChangeNotifier{
  final Map<String, TextEditingController> baseControllers = {};
  final Map<String, TextEditingController> bonusControllers = {};
  final Map<String, int> _totals = {};

  AttributesProvider(){
    for(final name in attributeNames){
      baseControllers[name] = TextEditingController();
      bonusControllers[name] = TextEditingController();
      baseControllers[name]!.addListener(() => _updateTotal(name));
      bonusControllers[name]!.addListener(() => _updateTotal(name));
    }

  }
  String getTotalFor(String attributeName){
    return (_totals[attributeName] ?? 0).toString();
  }
  void _updateTotal(String attributeName){
    final baseValue = int.tryParse(baseControllers[attributeName]?.text ?? '') ?? 0;
    final bonusValue = int.tryParse(bonusControllers[attributeName]?.text ?? '') ?? 0;
    _totals [attributeName] = baseValue + bonusValue;
    notifyListeners();
  }
  @override
  void dispose() {
    for (final name in attributeNames) {
      baseControllers[name]?.dispose();
      bonusControllers[name]?.dispose();
    }
    super.dispose();
  }
}