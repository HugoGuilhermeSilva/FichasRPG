import 'package:flutter/material.dart';
import 'package:fichas/data/attribute_and_expertise_data.dart';
import 'package:fichas/state_management/character_provider.dart';

class AttributesProvider with ChangeNotifier {
  CharacterProvider? _characterProvider;
  final Map<String, TextEditingController> baseControllers = {};
  final Map<String, TextEditingController> bonusControllers = {};
  final Map<String, TextEditingController> expertiseBonusControllers = {};
  final Map<String, TextEditingController> combatBonusControllers = {};
  final TextEditingController initiativeController = TextEditingController();
  final TextEditingController remainingAttributesController = TextEditingController();
  final TextEditingController remainingExpertisePointsController = TextEditingController();
  final TextEditingController totalLifeController = TextEditingController();
  final TextEditingController lostLifeController = TextEditingController();
  int _accumulatedDamage = 0;
  int _lastInputValue = 0;

  final Map<String, int> _attributesTotals = {};
  final Map<String, int> _expertiseTotals = {};
  final Map<String, int> _combatTotals = {};
  AttributesProvider() {
    for (final name in attributeNames) {
      baseControllers[name] = TextEditingController();
      bonusControllers[name] = TextEditingController();
      _attributesTotals[name] = 0;
      baseControllers[name]!.addListener(() =>
          _updateTotalsFor(attributeName: name));
      bonusControllers[name]!.addListener(() =>
          _updateTotalsFor(attributeName: name));
    }
    for (final name in expertiseNames) {
      expertiseBonusControllers[name] = TextEditingController();
      _expertiseTotals[name] = 0;
      expertiseBonusControllers[name]!.addListener(() =>
          _updateTotalsFor(expertiseName: name));
    }
    for (final name in combatValue) {
      combatBonusControllers[name] = TextEditingController();
      _combatTotals[name] = 0;
      combatBonusControllers[name]!.addListener(() =>
          _updateTotalsFor(combatName: name));
    }
    for (final name in attributeNames) {
      _updateTotalsFor(attributeName: name);
    }
    lostLifeController.addListener(_updateDamage);
    _recalculateAndNotify();
  }

  void update(CharacterProvider characterProvider) {
    if (_characterProvider != characterProvider) {
      _characterProvider = characterProvider;
      _characterProvider!.addListener(_recalculateAndNotify);
      _recalculateAndNotify();
    }
  }
  void _recalculateAndNotify() {
    remainingAttributesController.text = remainingAttributePoints.toString();
    remainingExpertisePointsController.text = remainingExpertisePoints.toString();
    totalLifeController.text = totalLife.toString();
    initiativeController.text = totalInitiative.toString();
    notifyListeners();
  }
  void _updateDamage(){
   final currentInput = int.tryParse(lostLifeController.text) ?? 0;
   final delta = currentInput - _lastInputValue;
   if (delta != 0) {
     _accumulatedDamage += delta;
     _lastInputValue = currentInput;
     notifyListeners();
   }
  }
  int get currentLife {
    final total = totalLife;
    final remaining = total - _accumulatedDamage;
    return remaining.clamp(0, total);
  }
  int get spentAttributePoints {
    int totalSpent = 0;
    for (var controller in baseControllers.values) {
      totalSpent += int.tryParse(controller.text) ?? 0;
    }
    return totalSpent;
  }

  int get spentExpertisePoints {
    int totalSpent = 0;
    for (var controller in expertiseBonusControllers.values) {
      totalSpent += int.tryParse(controller.text) ?? 0;
    }
    return totalSpent;
  }
  int get totalInitiative{
    final totalAgility = _attributesTotals['Agilidade'] ?? 0;
    final totalReadness= _expertiseTotals['Prontidão'] ?? 0;
    final totalInitiative = totalAgility + totalReadness;
    return totalInitiative;
  }
  int get remainingAttributePoints {
    final currentLevel = _characterProvider?.level ?? 1;
    final totalAvailable = 2 + (currentLevel * 6);
    final remaining = totalAvailable - spentAttributePoints;
    return remaining;
  }
  int get totalLife {
    final currentLevel = _characterProvider?.level ?? 1;
    final currentForce = _attributesTotals['Vigor'] ?? 0;
    final currentLife = _characterProvider?.lifeBase ?? 0;
    final totalLife = currentLife + (currentForce * currentLevel);
    return totalLife;
  }
  int get remainingExpertisePoints {
    final pointsPerLevel = _characterProvider?.skillPointPerLevel ?? 0;
    final totalAvailable = pointsPerLevel;
    final remaining = totalAvailable - spentExpertisePoints;
    return remaining;
  }
  String getAttributeTotalFor(String attributeName) =>
      (_attributesTotals[attributeName] ?? 0).toString();

  String getExpertiseTotalFor(String expertiseName) =>
      (_expertiseTotals[expertiseName] ?? 0).toString();

  String getCombatTotalFor(String combatName) =>
      (_combatTotals[combatName] ?? 0).toString();

  void _updateTotalsFor(
      {String? attributeName, String? expertiseName, String? combatName}) {
    bool somethingChanged = false;

    if (attributeName != null) {
      final baseValue = int.tryParse(
          baseControllers[attributeName]?.text ?? '') ?? 0;
      final bonusValue = int.tryParse(
          bonusControllers[attributeName]?.text ?? '') ?? 0;
      final newTotal = baseValue + bonusValue;

      if (_attributesTotals[attributeName] != newTotal) {
        _attributesTotals[attributeName] = newTotal;
        somethingChanged = true;
        for (var entry in expertiseAttributeMap.entries) {
          if (entry.value == attributeName) {
            _updateExpertiseTotal(entry.key);
          }
        }
        for (var entry in combatAttributeMap.entries) {
          if (entry.value == attributeName) {
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
      if (_updateCombatTotal(combatName)) {
        somethingChanged = true;
      }
    }
    if (somethingChanged) {
      _recalculateAndNotify();
    }
  }

  bool _updateExpertiseTotal(String expertiseName) {
    final dependentAttribute = expertiseAttributeMap[expertiseName];
    if (dependentAttribute == null) return false;

    final attributeValue = (_attributesTotals[dependentAttribute] ?? 0);
    final baseExpertiseValue = (attributeValue / 2).round();
    final bonusValue = int.tryParse(
        expertiseBonusControllers[expertiseName]?.text ?? '') ?? 0;
    final newTotal = baseExpertiseValue + bonusValue;

    if (_expertiseTotals[expertiseName] != newTotal) {
      _expertiseTotals[expertiseName] = newTotal;
      return true;
    }
    return false;
  }

  bool _updateCombatTotal(String combatName) {
    final dependentAttribute = combatAttributeMap[combatName];
    if (dependentAttribute == null) return false;

    final specificValue = combatBaseValueMap[combatName] ?? 0;
    final attributeValue = (_attributesTotals[dependentAttribute] ?? 0);
    final bonusValue = int.tryParse(
        combatBonusControllers[combatName]?.text ?? '') ?? 0;
    final newTotal = specificValue + attributeValue + bonusValue;

    if (_combatTotals[combatName] != newTotal) {
      _combatTotals[combatName] = newTotal;
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _characterProvider?.removeListener(_recalculateAndNotify);
    lostLifeController.dispose();
    totalLifeController.dispose();
    initiativeController.dispose();
    remainingAttributesController.dispose();
    remainingExpertisePointsController.dispose();
    for (var c in baseControllers.values) {
      c.dispose();
    }
    for (var c in bonusControllers.values) {
      c.dispose();
    }
    for (var c in expertiseBonusControllers.values) {
      c.dispose();
    }
    for (var c in combatBonusControllers.values) {
      c.dispose();
    }
    super.dispose();
  }
}