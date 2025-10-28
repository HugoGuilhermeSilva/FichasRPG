import 'package:flutter/material.dart';
import 'package:fichas/data/attribute_and_expertise_data.dart';
import 'package:fichas/state_management/character_provider.dart';

class AttributesProvider with ChangeNotifier{
  CharacterProvider? _characterProvider;
  final Map<String, TextEditingController> baseControllers = {};
  final Map<String, TextEditingController> bonusControllers = {};
  final Map<String, TextEditingController> attributeTotalControllers = {};
  final Map<String, int> _attributesTotals = {};
  final Map<String, TextEditingController> expertiseBonusControllers = {};
  final Map<String, TextEditingController> expertiseTotalControllers = {};
  final Map<String, int> _expertiseTotals = {};
  final Map<String, TextEditingController> combatBonusControllers = {};
  final Map<String, TextEditingController> combatTotalControllers = {};
  final Map<String, int> _combatTotals = {};
  final TextEditingController remainingAttributesController = TextEditingController();
  final TextEditingController remainingExpertisePointsController = TextEditingController();

  AttributesProvider(){
    for(final name in attributeNames){
      baseControllers[name] = TextEditingController();
      bonusControllers[name] = TextEditingController();
      attributeTotalControllers[name] = TextEditingController();
      _attributesTotals[name] = 0;
      baseControllers[name]!.addListener(() => _updateTotalsFor(attributeName: name));
      bonusControllers[name]!.addListener(() => _updateTotalsFor(attributeName: name));
    }
    for(final name in expertiseNames){
      expertiseBonusControllers[name] = TextEditingController();
      expertiseTotalControllers[name] = TextEditingController();
      _expertiseTotals[name] = 0;
      expertiseBonusControllers[name]!.addListener(() => _updateTotalsFor(expertiseName: name));
    }
    for(final name in combatValue){
      combatBonusControllers[name] = TextEditingController();
      combatTotalControllers[name] = TextEditingController();
      _combatTotals[name] = 0;
      combatBonusControllers[name]!.addListener(() => _updateTotalsFor(combatName: name));
    }
    for(final name in attributeNames){
      _updateTotalsFor(attributeName: name);
    }
  }
  void update(CharacterProvider characterProvider){
    _characterProvider = characterProvider;
  }
  int get spentAttributePoints {
    int totalSpent = 0;
    for (var controller in baseControllers.values) {
      totalSpent += int.tryParse(controller.text) ?? 0;
    }
    return totalSpent;
  }
  int get spentExpertisePoints {
    int totalSpentS = 0;
    for (var controller in expertiseBonusControllers.values) {
      totalSpentS += int.tryParse(controller.text) ?? 0;
    }
    return totalSpentS;
  }
  int get remainingAttributePoints{
    final totalAvailable = _characterProvider?.baseAttributePoints ?? 0;
    final remaining = totalAvailable - spentAttributePoints;
    remainingAttributesController.text = remaining.toString();
    return remaining;
  }
  int get remainingExpertisePoints{
    final totalAvailable = (_characterProvider?.skillPointPerLevel ?? 0) * (_characterProvider?.level ?? 1);
    final remaining = totalAvailable - spentExpertisePoints;
    remainingExpertisePointsController.text = remaining.toString();
    return remaining;
  }
  String getAttributeTotalFor(String attributeName) => (_attributesTotals[attributeName] ?? 0).toString();
  String getExpertiseTotalFor(String expertiseName) => (_expertiseTotals[expertiseName] ?? 0).toString();
  String getCombatTotalFor(String combatName) => (_combatTotals[combatName] ?? 0).toString();

  void _updateTotalsFor({String? attributeName, String? expertiseName, String? combatName}){
    bool somethingChanged = false;

    if(attributeName != null){
      final baseValue = int.tryParse(baseControllers[attributeName]?.text ?? '') ?? 0;
      final bonusValue = int.tryParse(bonusControllers[attributeName]?.text ?? '') ?? 0;
      final newTotal = baseValue + bonusValue;

      if(_attributesTotals[attributeName] != newTotal){
        _attributesTotals[attributeName] = newTotal;
        attributeTotalControllers[attributeName]?.text = newTotal.toString();
        somethingChanged = true;

        for(var entry in expertiseAttributeMap.entries){
          if(entry.value == attributeName){
            _updateExpertiseTotal(entry.key);
          }
        }
        for (var entry in combatAttributeMap.entries){
          if(entry.value == attributeName){
            _updateCombatTotal(entry.key);
          }
        }
      }
    }
    if (expertiseName != null) {
      if (_updateExpertiseTotal(expertiseName)) {
        somethingChanged = true;
      }
    }
    if (combatName != null) {
      if(_updateCombatTotal(combatName)){
        somethingChanged= true;
      }
    }
    if (somethingChanged) {
      notifyListeners();
    }
    notifyListeners();
  }
  bool _updateExpertiseTotal(String expertiseName){
    final dependentAttribute = expertiseAttributeMap[expertiseName];
    if(dependentAttribute == null) return false;

    final attributeValue = (_attributesTotals[dependentAttribute] ?? 0);
    final baseExpertiseValue = (attributeValue / 2).round();

    final bonusValue = int.tryParse(expertiseBonusControllers[expertiseName]?.text ?? '') ?? 0;
    final newTotal = baseExpertiseValue + bonusValue;
    if(_expertiseTotals[expertiseName] != newTotal){
      _expertiseTotals[expertiseName] = newTotal;
      expertiseTotalControllers[expertiseName]?.text = newTotal.toString();
      return true;
    }
    return false;
  }
  bool _updateCombatTotal(String combatName){
    final dependentAttribute = combatAttributeMap[combatName];
    if(dependentAttribute == null) return false;

    final specificValue = combatBaseValueMap[combatName] ?? 0;
    final attributeValue = (_attributesTotals[dependentAttribute] ?? 0);
    final bonusValue = int.tryParse(combatBonusControllers[combatName]?.text ?? '') ?? 0;
    final newTotal = specificValue + attributeValue + bonusValue;
    if(_combatTotals[combatName] != newTotal){
      _combatTotals[combatName] = newTotal;
      combatTotalControllers[combatName]?.text = newTotal.toString();
      return true;
    }
    return false;
  }
  @override
  void dispose() {
    remainingAttributesController.dispose();
    remainingExpertisePointsController.dispose();
    for (var c in baseControllers.values) {c.dispose();}
    for (var c in bonusControllers.values) {c.dispose();}
    for (var c in expertiseBonusControllers.values) {c.dispose();}
    for (var c in combatBonusControllers.values) {c.dispose();}
    for (var c in attributeTotalControllers.values) { c.dispose(); }
    for (var c in expertiseTotalControllers.values) { c.dispose(); }
    for (var c in combatTotalControllers.values) { c.dispose(); }
    super.dispose();
  }
}