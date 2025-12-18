import 'package:flutter/material.dart';
import 'package:fichas/data/attribute_and_expertise_data.dart';
import 'package:fichas/state_management/character_provider.dart';
import 'package:fichas/models/record_model.dart';

class AttributesProvider with ChangeNotifier {
  final CharacterProvider characterProvider;
  bool _isRecalculatingFromCharacter = false;
  final Function(Map<String, dynamic>)? onDataChanged;
  final Map<String, TextEditingController> baseControllers = {};
  final Map<String, TextEditingController> bonusControllers = {};
  final Map<String, TextEditingController> expertiseBonusControllers = {};
  final Map<String, TextEditingController> combatBonusControllers = {};
  final TextEditingController initiativeController = TextEditingController();
  final TextEditingController remainingAttributesController = TextEditingController();
  final TextEditingController remainingExpertisePointsController = TextEditingController();
  final TextEditingController totalLifeController = TextEditingController();
  final TextEditingController lostLifeController = TextEditingController();
  final Map<String, int> _attributesTotals = {};
  final Map<String, int> _expertiseTotals = {};
  final Map<String, int> _combatTotals = {};

  AttributesProvider({this.onDataChanged, required this.characterProvider}) {
    _initializeControllers();
    characterProvider.addListener(_recalculateAndNotify);
  }
  void updateFromRecord(Record? record) {
    final data = record?.attributesData ?? {};
    for (final name in attributeNames) {
      baseControllers[name]?.text = data['base_$name'] ?? '';
      bonusControllers[name]?.text = data['bonus_$name'] ?? '';
    }
    for (final name in expertiseNames) {
      expertiseBonusControllers[name]?.text = data['exp_bonus_$name'] ?? '';
  }
    for (final name in combatValue) {
      combatBonusControllers[name]?.text = data['combat_bonus_$name'] ?? '';
    }
    lostLifeController.text = (data['lost_life_input'] ?? '').toString();
    _recalculateAndNotify();
  }
  void _notifyAndSaveChanges(){
    final Map<String, dynamic> dataToSave = {};
    for(final name in attributeNames){
      dataToSave['base_$name'] = baseControllers[name]?.text ?? '';
      dataToSave['bonus_$name'] = bonusControllers[name]?.text ?? '';
    }
    for (final name in expertiseNames){
      dataToSave['exp_bonus_$name'] = expertiseBonusControllers[name]?.text ?? '';
    }
    for (final name in combatValue){
      dataToSave['combat_bonus_$name'] = combatBonusControllers[name]?.text ?? '';
    }
    dataToSave['lost_life_input'] = lostLifeController.text;
    onDataChanged?.call(dataToSave);
  }
  void _initializeControllers() {
    void listener() {
      _recalculateAndNotify();
      _notifyAndSaveChanges();
    }
    for (final name in attributeNames) {
      baseControllers[name] = TextEditingController();
      bonusControllers[name] = TextEditingController();
      _attributesTotals[name] = 0;
      baseControllers[name]!.addListener(listener);
      bonusControllers[name]!.addListener(listener);
    }
    for (final name in expertiseNames) {
      expertiseBonusControllers[name] = TextEditingController();
      _expertiseTotals[name] = 0;
      expertiseBonusControllers[name]!.addListener(listener);
    }
    for (final name in combatValue) {
      combatBonusControllers[name] = TextEditingController();
      _combatTotals[name] = 0;
      combatBonusControllers[name]!.addListener(listener);
    }
    lostLifeController.addListener(listener);
  }
  void _recalculateAndNotify(){
    for (final name in attributeNames) {
      _updateTotalsFor(attributeName: name);
    }
    for (final name in expertiseNames){
      _updateTotalsFor(expertiseName: name);
    }
    for (final name in combatValue) {
      _updateTotalsFor(combatName: name);
    }
    remainingAttributesController.text = remainingAttributePoints.toString();
    remainingExpertisePointsController.text = remainingExpertisePoints.toString();
    totalLifeController.text = totalLife.toString();
    initiativeController.text = totalInitiative.toString();
    if (!_isRecalculatingFromCharacter) {
      notifyListeners();
    }
  }
  int get totalLife {
    final currentLevel = characterProvider.level;
    final currentForce = _attributesTotals['Vigor'] ?? 0;
    final currentLife = characterProvider.finalLife;
    final hStoneBonus = characterProvider.hardAsStoneBonus * 10;
    final bool hasRobust = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Robusto');
    final robustBonus = hasRobust ? 2 : 1;
    final wallBonus = characterProvider.wallBonus;
    final int lifeDegreeBonus = characterProvider.powerProvider.getPowerLevel('Graus de Vida') * 10;
    final totalLife = ((currentLife + (currentForce * currentLevel) + hStoneBonus + lifeDegreeBonus) * robustBonus) * wallBonus;
    return totalLife;
  }
  bool get isLifeBelow100{
    return totalLife < 100;
  }
  int get currentLife {
    final total = totalLife;
    final damageTaken = int.tryParse(lostLifeController.text) ?? 0;
    final remaining = total - damageTaken;
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
  int get totalInitiative {
    final totalAgility = _attributesTotals['Agilidade'] ?? 0;
    final totalReadness = _expertiseTotals['Prontidão'] ?? 0;
    final bool hasAgilBonus = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Agil');
    final agilBonus = hasAgilBonus ? ((characterProvider.level) / 2).round() : 0;
    final bool hasFlash = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Flash');
    final flashBonus = hasFlash ? (characterProvider.level / 2).round() : 0;
    final bool hasAttentive = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Prontidão Aprimorada');
    final attentiveBonus = hasAttentive ? 10 : 0;
    final totalInitiative = totalAgility + totalReadness + agilBonus + flashBonus + attentiveBonus;
    return totalInitiative;
  }
  int get remainingAttributePoints {
    final currentLevel = characterProvider.level;
    final totalAvailable = 2 + (currentLevel * 6);
    final remaining = totalAvailable - spentAttributePoints;
    return remaining;
  }
  int get remainingExpertisePoints {
    final pointsPerLevel = characterProvider.skillPointPerLevel;
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
    String? dependentAttribute;
    if(expertiseName == 'Atletismo'){
      final bool hasAgil = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Agil');
      if(hasAgil){
        dependentAttribute = 'Agilidade';
      } else {
        dependentAttribute = expertiseAttributeMap[expertiseName];
      }
    }else {
      dependentAttribute = expertiseAttributeMap[expertiseName];
    }
    if(dependentAttribute == null) return false;
    final attributeValue = (_attributesTotals[dependentAttribute] ?? 0);
    final baseExpertiseValue = (attributeValue / 2).round();
    final bonusValue = int.tryParse(expertiseBonusControllers[expertiseName]?.text ?? '') ?? 0;
    int skillBonus = 0;
    if(expertiseName == 'Furtividade'){
      final bool hasMislead = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Despistar');
      final misleadBonus = hasMislead ? (characterProvider.level / 2).round() : 0;
      skillBonus = misleadBonus;
    }
    if(expertiseName == 'Intuição'){
      final bool basSherlock = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Sherlock Holmes');
      final int bonusByInt = int.tryParse(getAttributeTotalFor('Inteligencia')) ?? 0;
      final int sherlockBonus = basSherlock ? bonusByInt : 0;
      skillBonus = sherlockBonus;
    }
    if(expertiseName == 'Procurar'){
      final bool basSherlock = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Sherlock Holmes');
      final int bonusByInt = int.tryParse(getAttributeTotalFor('Inteligencia')) ?? 0;
      final int sherlockBonus = basSherlock ? bonusByInt : 0;
      final bool hasVeloC = characterProvider.powerProvider.allActivePowerNames.contains('Percepção Acelerada');
      final int moveBonus = (characterProvider.powerProvider.getPowerLevel('Mover-se') / 5).round();
      final int velocBonus = hasVeloC ? moveBonus : 0;
      skillBonus = sherlockBonus + velocBonus;
    }
    if(expertiseName == 'Rastrear'){
      final bool hasBatman = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Investigador Nato');
      final batmanBonus = hasBatman ? (characterProvider.level / 2).round() : 0;
      final bool basSherlock = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Sherlock Holmes');
      final int bonusByInt = int.tryParse(getAttributeTotalFor('Inteligencia')) ?? 0;
      final int sherlockBonus = basSherlock ? bonusByInt : 0;
      skillBonus = batmanBonus + sherlockBonus;
    }
    if(expertiseName == 'Investigação'){
      final bool hasBatman = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Investigador Nato');
      final batmanBonus = hasBatman ? (characterProvider.level / 2).round() : 0;
      skillBonus = batmanBonus;
    }
    if(expertiseName == 'Prontidão'){
      final bool hasParanoid = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Paranoico');
      final int paranoidBonus = hasParanoid ? characterProvider.level : 0;
      final bool hasVeloC = characterProvider.powerProvider.allActivePowerNames.contains('Percepção Acelerada');
      final int moveBonus = (characterProvider.powerProvider.getPowerLevel('Mover-se') / 5).round();
      final int velocBonus = hasVeloC ? moveBonus : 0;
      skillBonus = paranoidBonus + velocBonus;
    }
    final newTotal = baseExpertiseValue + bonusValue + skillBonus;

    if (_expertiseTotals[expertiseName] != newTotal) {
      _expertiseTotals[expertiseName] = newTotal;
      return true;
    }
    return false;
  }
  bool _updateCombatTotal(String combatName) {
    String? dependentAttribute;
    if(combatName == 'Combate Corporal'){
      final bool hasRapidStrikes = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Ataques Rápidos');
      if(hasRapidStrikes){
        dependentAttribute = 'Agilidade';
      } else {
        dependentAttribute = combatAttributeMap[combatName];
      }
    } else {
      dependentAttribute = combatAttributeMap[combatName];
    }
    if (dependentAttribute == null) return false;
    final specificValue = combatBaseValueMap[combatName] ?? 0;
    final attributeValue = (_attributesTotals[dependentAttribute] ?? 0);
    final bonusValue = int.tryParse(combatBonusControllers[combatName]?.text ?? '') ?? 0;
    int skillBonus = 0;
    if (combatName == 'Força de Vontade'){
      final bool hasIronWill = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Vontade de Ferro');
      final int bonusByIronWill = hasIronWill ? characterProvider.level : 0;
      skillBonus = characterProvider.bonusWillForce + bonusByIronWill;
    }
    if (combatName == 'Bloqueio'){
      int slenderBonus = characterProvider.slenderBonus;
      int fighterTankBonus = characterProvider.blockTankBonus;
      skillBonus = fighterTankBonus + slenderBonus;
    }
    if(combatName == 'Esquiva'){
      final bool hasNaturalDoge = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Esquiva Natural');
      final int naturalDogeBonus = hasNaturalDoge ? (((characterProvider.level) / 3).round()) + 2 : 0;
      skillBonus = characterProvider.slenderBonus + naturalDogeBonus;
    }
    if(combatName == 'Combate Corporal'){
      final bool hasImprovement = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Aperfeiçoamento');
      final int improvementBonus = hasImprovement ? ((characterProvider.level) / 3).round() + 2 : 0;
      skillBonus = improvementBonus;
    }
    if(combatName == 'Combate a Distancia'){
      final bool hasShooter = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Atirador');
      final int shooterBonus = hasShooter ? ((characterProvider.level) / 3).round() + 2 : 0;
      skillBonus = shooterBonus;
    }
    if(combatName == 'Combate Mental'){
      final bool hasMind = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Megamente');
      final int mindBonus = hasMind ? ((characterProvider.level) / 3).round() + 2 : 0;
      skillBonus = mindBonus;
    }
    final newTotal = specificValue + attributeValue + bonusValue + skillBonus;
    if (_combatTotals[combatName] != newTotal) {
      _combatTotals[combatName] = newTotal;
      return true;
    }
    return false;
  }
  @override
  void dispose() {
    characterProvider.removeListener(_recalculateAndNotify);
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