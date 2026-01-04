import 'package:fichas/data/power_model.dart';
import 'package:fichas/state_management/advantages_provider.dart';
import 'package:fichas/state_management/character_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fichas/data/power_list.dart';
import 'package:fichas/models/record_model.dart';

class PowerProvider with ChangeNotifier{
  final CharacterProvider characterProvider;
  final AdvantagesProvider advantagesProvider;
  Map<String, int> _selectedPowers = {};
  Map<String, int> get selectedPowers => _selectedPowers;
  Map<String, int> _skillAndArchetypeBonuses = {};
  Map<String, int> get skillArchetypeBonuses => _skillAndArchetypeBonuses;
  Map<String, int> _powerInteractionBonuses = {};
  Map<String, int> get powerInteractionsBonuses => _powerInteractionBonuses;
  Map<String, int> _passiveBonuses = {};
  final Function(Map<String, int>)? onDataChanged;
  bool _isRecalculatingFromCharacter = false;
  final VoidCallback? onPowersChangedForRecalculation;

  PowerProvider({this.onDataChanged,required this.characterProvider, required this.advantagesProvider,this.onPowersChangedForRecalculation,});
  void ensurePowerExists(String powerName) {
    if (!_selectedPowers.containsKey(powerName)) {
      _selectedPowers[powerName] = 0;
    }
  }
  void addSkillBonus(String powerName, int levelsToAdd) {
    _skillAndArchetypeBonuses[powerName] = (_skillAndArchetypeBonuses[powerName] ?? 0) + levelsToAdd;
    _notifyAndSaveChanges();
  }
  void clearSkillBonuses() {
    if (_skillAndArchetypeBonuses.isNotEmpty) {
      _skillAndArchetypeBonuses.clear();
    }
  }
  void _addPowerInteractionBonus(String powerName, int levelsToAdd) {
    _powerInteractionBonuses[powerName] = (_powerInteractionBonuses[powerName] ?? 0) + levelsToAdd;
  }
  void _clearPowerInteractionBonuses() {
    if (_powerInteractionBonuses.isNotEmpty) {
      _powerInteractionBonuses.clear();
    }
  }
  void updateFromRecord(Record? record){
    _selectedPowers = Map<String, int>.from(record?.powersData ?? {});
    _updateCalculatedValues();
  }
  void _notifyAndSaveChanges(){
    onDataChanged?.call(_selectedPowers);
    _updateCalculatedValues();
  }
  bool isPowerSelected(String powerName){
    return (_selectedPowers[powerName] ?? 0) > 0;
  }
  int getPowerLevel(String powerName) {
    final playerLevel = _selectedPowers[powerName] ?? 0;
    final skillBonus = _skillAndArchetypeBonuses[powerName] ?? 0;
    final powerBonus = _powerInteractionBonuses[powerName] ?? 0;
    final passiveBonus = _passiveBonuses[powerName] ?? 0;
    return playerLevel + skillBonus + powerBonus + passiveBonus;
  }
  void decrementPowerLevel(String powerName){
    if(_selectedPowers.containsKey(powerName)){
      int currentLevel = _selectedPowers[powerName]!;

      if(currentLevel > 1){
        _selectedPowers[powerName] = currentLevel - 1;
      } else {
        if ((_skillAndArchetypeBonuses[powerName] ?? 0) == 0) {
          _selectedPowers.remove(powerName);
        } else {
          _selectedPowers[powerName] = 0;
        }
      }
      _notifyAndSaveChanges();
    }
  }
  void incrementPowerLevel(String powerName){
    if(!_selectedPowers.containsKey(powerName)){
      _selectedPowers[powerName] = 0;
    }
    _selectedPowers[powerName] = _selectedPowers[powerName]! + 1;
    _notifyAndSaveChanges();
  }
  void togglePowerSelection(String powerName, bool isSelected) {
    if (isSelected) {
      _selectedPowers[powerName] = 1;
    } else {
      if ((_skillAndArchetypeBonuses[powerName] ?? 0) > 0) {
        _selectedPowers[powerName] = 0;
      } else {
        _selectedPowers.remove(powerName);
      }
    }
    _notifyAndSaveChanges();
  }
  void setPowerLevel(String powerName, int level) {
    if (level > 0) {
      _selectedPowers[powerName] = level;
    } else {
      if ((_skillAndArchetypeBonuses[powerName] ?? 0) == 0) {
        _selectedPowers.remove(powerName);
      } else {
        _selectedPowers[powerName] = 0;
      }
    }
    _notifyAndSaveChanges();
  }
  List<String> get allActivePowerNames {
    final powerSet = <String>{};
    powerSet.addAll(_selectedPowers.keys);
    powerSet.addAll(_skillAndArchetypeBonuses.keys);
    powerSet.addAll(_powerInteractionBonuses.keys);
    return powerSet.toList();
  }
  int get totalHeal{
    final int heal = getPowerLevel('Cura');
    final int totalHeal = heal;
    return totalHeal;
  }
  int get baseHeal{
    final int baseHealFromArchetype = characterProvider.healBonus;
    final bool hasMedicExpert = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Especialista Médica');
    final medicExpertBonus = hasMedicExpert ? characterProvider.level * 3 : 0;
    final baseHeal = baseHealFromArchetype + medicExpertBonus;
    return baseHeal;
  }
  int get stepHeal{
    final int bonusStepHealFromArchetype = characterProvider.stepHeal;
    final stepHeal = bonusStepHealFromArchetype + 6;
    return stepHeal;
  }
  int get stepDamage{
    final has1Gun = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Estilo de 1 arma');
    final oneGunBonus = has1Gun ? 2 : 0;
    final bonusByFirePower = characterProvider.bonusByFirePower;
    final bonusByDestroyer = characterProvider.destroyerBonus;
    final stepDamage = 6 + bonusByFirePower * 2 + bonusByDestroyer * 2 + oneGunBonus;
    return stepDamage;
  }
  int get totalDisplacement {
    const baseDisplacement = 10;
    final bool hasGrav = allActivePowerNames.contains('Ancora Gravitacional');
    final gravBonus = (getPowerLevel('Gravidade') / 2).round();
    final gravMoveBonus = hasGrav ? gravBonus : 0;
    final modifierDisplacementLevel = characterProvider.modifierDisplacementLevel;
    final boltMultiplier = characterProvider.boltMultiplier;
    final moveLevel = getPowerLevel('Mover-se') + gravMoveBonus;
    final totalDisplacement = (baseDisplacement + (modifierDisplacementLevel * moveLevel)) * boltMultiplier;
    return totalDisplacement;
  }
  int get turnDamage{
    final initialTurnDamage = getPowerLevel('Dano por Turno');
    final turnDamage = initialTurnDamage;
    return turnDamage;
  }
  int get turnDamageDegree{
    final turnDamageDC = 4;
    final turnDamageDegree = turnDamageDC;
    return turnDamageDegree;
  }
  int get defendLevel{
    final defend = getPowerLevel('Defender');
    final bool hasGrav = allActivePowerNames.contains('Gravidade Pessoal');
    final gravBonus = (getPowerLevel('Gravidade') / 2).round();
    final gravDefendBonus = hasGrav ? gravBonus : 0;
    final bonus1C = characterProvider.defendBonus;
    final defendLevel = (defend * bonus1C) + gravDefendBonus;
    return defendLevel;
  }
  int get rdLevel{
    final rd = 2;
    final rdByPosture = characterProvider.postureRdBonus;
    final rdByImmutable = characterProvider.immutableBonus;
    final rdLevel = rd + rdByPosture + rdByImmutable;
    return rdLevel;
  }
  int get totalDagame{
    final damage = getPowerLevel('Dano');
    final elementalDamage = getPowerLevel('Manipulação Elemental');
    final ramDagame = getPowerLevel('Pente de RAM');
    final gravDagame = getPowerLevel('Gravidade');
    final soundDamage = getPowerLevel('Som');
    final psiDamage = getPowerLevel('Telecinese');
    final bool hasBestiary = allActivePowerNames.contains('Forma da Criatura');
    final bestiaryBonus = hasBestiary ? characterProvider.level : 0;
    final totalDamage = (damage + (elementalDamage / 2) + (ramDagame) + (gravDagame / 2) + (soundDamage) + (psiDamage / 2) ).round() + bestiaryBonus;
    return totalDamage;
  }
  int get baseDamage{
    final elementalDamage = getPowerLevel('Manipulação Elemental');
    final gravDamage = getPowerLevel('Gravidade');
    final bool hasFlyingKick = advantagesProvider.allSelectedAdvantages.contains('Voadora');
    final bonusByFlyingKick = hasFlyingKick ? getPowerLevel('Mover-se') : 0;
    final bool hasAggravating = advantagesProvider.allSelectedAdvantages.contains('Ataque Agravante');
    final bonusByAggravating = hasAggravating ? characterProvider.level : 0;
    final archetypeSMI = characterProvider.flatDamageByMov;
    final archetypeBH = characterProvider.breakReadBonus;
    final archetypeWar = characterProvider.warBonus;
    final archetypeSniper = characterProvider.sniperBonus;
    final totalBaseDamage = (elementalDamage * 2) + (gravDamage * 2) + archetypeSMI + archetypeBH + archetypeWar + archetypeSniper + bonusByAggravating + bonusByFlyingKick;
    return totalBaseDamage;
  }
  int get criticalMerge{
    final baseCriticalMerge = 20;
    final bool hasPlusCritical = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Critico Aprimorado');
    final bonusByPlusCritical = hasPlusCritical ? 1 : 0;
    final has1Gun = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Estilo de 1 arma');
    final oneGunBonus = has1Gun ? 1 : 0;
    final archetypeWP = characterProvider.criticalReductionWeakPoint;
    final finalCriticalMerge = baseCriticalMerge - archetypeWP - bonusByPlusCritical - oneGunBonus;
    return finalCriticalMerge;
  }
  int get criticalMultiplier{
    final baseCriticalMultiplier = 2;
    final bool hasPlusCritical = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Critico Aprimorado');
    final bonusByPlusCritical = hasPlusCritical ? 1 : 0;
    final has1Gun = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Estilo de 1 arma');
    final oneGunBonus = has1Gun ? 1 : 0;
    final criticalMultiplierByPowerfulStrike = characterProvider.criticalMultiplierPowerfulStrike;
    final zevyrBonus = characterProvider.zevyrBonus;
    final hasElementalSphere = allActivePowerNames.contains('Esfera elemental');
    final elementalSphereBonus = hasElementalSphere ? 1 : 0;
    final finalCriticalMultiplier = baseCriticalMultiplier + criticalMultiplierByPowerfulStrike + zevyrBonus + bonusByPlusCritical + oneGunBonus + elementalSphereBonus;
    return finalCriticalMultiplier;
  }
  int get totalStrikes{
    final bool hasAmbidextery = advantagesProvider.allSelectedAdvantages.contains('Ambidestria');
    final strikesBase = hasAmbidextery ? 3 : 1;
    final bonusStrikesByAcc = getPowerLevel('Acelerar');
    final baseStrikesBySlice = characterProvider.sliceBonus;
    int bonusStrikesBySlice;
    if (baseStrikesBySlice == 0) {
      bonusStrikesBySlice = 0;
    } else {
      bonusStrikesBySlice = ((strikesBase + bonusStrikesByAcc) / baseStrikesBySlice).round();
    }
    final totalStrikes = strikesBase + bonusStrikesByAcc + bonusStrikesBySlice;
    return totalStrikes;
  }
  int get regenTotal{
    final regenBase = getPowerLevel('Regeneração');
    final regenByTank = characterProvider.regenBonus;
    final regenTotal = regenBase * regenByTank;
    return regenTotal;
  }
  int get rangeTotal{
    int rangeBase = getPowerLevel('Alcance');
    int areaBase = getPowerLevel('Área');
    final elementalBonus = getPowerLevel('Manipulação Elemental');
    if(rangeBase > areaBase){
      rangeBase += elementalBonus;
    }
    else if(areaBase > rangeBase){
      areaBase += elementalBonus;
    } else {
      rangeBase += elementalBonus;
    }
    final archetypeBaseRangeMultiplier = characterProvider.rangeMultiplier;
    final archetypeAreaMultiplier = characterProvider.areaMultiplier;
    final archetypeSniperBonus = characterProvider.rangeBonusMultiplier;
    final rangeTotal = rangeBase * (archetypeBaseRangeMultiplier + archetypeSniperBonus) + areaBase * archetypeAreaMultiplier;
    return rangeTotal;
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
  void _applyBonusRules() {
    final int totalElementalLevel = getPowerLevel('Manipulação Elemental');
    if (totalElementalLevel > 0) {
      final int damageBonus = (totalElementalLevel / 2).round();
      if (damageBonus > 0) {
        _addPowerInteractionBonus('Dano', damageBonus);
      }
    }
  }
  void _updateCalculatedValues() {
    if (_isRecalculatingFromCharacter) return;
    _isRecalculatingFromCharacter = true;
    const int maxIterations = 5;
    for (int i = 0; i < maxIterations; i++) {
      final Map<String, int> oldBonuses = Map.from(_powerInteractionBonuses);
      _clearPowerInteractionBonuses();
      _applyBonusRules();

      bool haveBonusesChanged = oldBonuses.length != _powerInteractionBonuses.length || oldBonuses.keys.any((key) => oldBonuses[key] != _powerInteractionBonuses[key]);

      if (!haveBonusesChanged) {
        break;
      }
    }
    notifyListeners();
    onPowersChangedForRecalculation?.call();
    _isRecalculatingFromCharacter = false;
  }
}