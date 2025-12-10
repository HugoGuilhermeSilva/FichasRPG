import 'package:fichas/data/power_model.dart';
import 'package:fichas/state_management/advantages_provider.dart';
import 'package:fichas/state_management/character_provider.dart';
import 'package:flutter/material.dart';
import 'package:fichas/data/power_list.dart';
import 'package:fichas/models/record_model.dart';

class PowerProvider with ChangeNotifier{
  final CharacterProvider characterProvider;
  final AdvantagesProvider advantagesProvider;
  Map<String, int> _selectedPowers = {};
  Map<String, int> get selectedPowers => _selectedPowers;
  Map<String, int> _bonusPowers = {};
  Map<String, int> get bonusPowers => _bonusPowers;
  final TextEditingController baseDamageController = TextEditingController();
  final Function(Map<String, int>)? onDataChanged;
  bool _isRecalculatingFromCharacter = false;
  final VoidCallback? onPowersChangedForRecalculation;

  PowerProvider({this.onDataChanged,required this.characterProvider, required this.advantagesProvider,this.onPowersChangedForRecalculation,}) {
    _updateCalculatedValues();
  }
  void ensurePowerExists(String powerName) {
    if (!_selectedPowers.containsKey(powerName)) {
      _selectedPowers[powerName] = 0;
    }
  }
  void addBonusPowerLevels(String powerName, int levelsToAdd) {
    _bonusPowers[powerName] = (_bonusPowers[powerName] ?? 0) + levelsToAdd;
  }
  void clearBonusPowers() {
    if (_bonusPowers.isNotEmpty) {
      _bonusPowers.clear();
    }
  }
  void updateFromRecord(Record? record){
    _selectedPowers = Map<String, int>.from(record?.powersData ?? {});
    _updateCalculatedValues();
  }
  void _notifyAndSaveChanges(){
    onDataChanged?.call(_selectedPowers);
    onPowersChangedForRecalculation?.call();
    _updateCalculatedValues();
  }
  bool isPowerSelected(String powerName){
    return (_selectedPowers[powerName] ?? 0) > 0;
  }
  int getPowerLevel(String powerName){
    final playerLevel = _selectedPowers[powerName] ?? 0;
    final bonusLevel = _bonusPowers[powerName] ?? 0;
    return playerLevel + bonusLevel;
  }
  void decrementPowerLevel(String powerName){
    if(_selectedPowers.containsKey(powerName)){
      int currentLevel = _selectedPowers[powerName]!;

      if(currentLevel > 1){
        _selectedPowers[powerName] = currentLevel - 1;
      } else {
        if ((_bonusPowers[powerName] ?? 0) == 0) {
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
      if ((_bonusPowers[powerName] ?? 0) > 0) {
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
      if ((_bonusPowers[powerName] ?? 0) == 0) {
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
    powerSet.addAll(_bonusPowers.keys);
    return powerSet.toList();
  }
  int get totalHeal{
    final int heal = getPowerLevel('Cura');
    final int totalHeal = heal;
    return totalHeal;
  }
  int get baseHeal{
    final int baseHealFromArchetype = characterProvider.healBonus;
    final baseHeal = baseHealFromArchetype;
    return baseHeal;
  }
  int get stepHeal{
    final int bonusStepHealFromArchetype = characterProvider.stepHeal;
    final stepHeal = bonusStepHealFromArchetype + 6;
    return stepHeal;
  }
  int get stepDamage{
    final bonusByFirePower = characterProvider.bonusByFirePower;
    final bonusByDestroyer = characterProvider.destroyerBonus;
    final stepDamage = 6 + bonusByFirePower * 2 + bonusByDestroyer * 2;
    return stepDamage;
  }
  int get totalDisplacement {
    const baseDisplacement = 10;
    final moveLevel = getPowerLevel('Mover-se');
    final modifierDisplacementLevel = characterProvider.modifierDisplacementLevel;
    final boltMultiplier = characterProvider.boltMultiplier;
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
    final bonus1C = characterProvider.defendBonus;
    final defendLevel = defend * bonus1C;
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
    final totalDamage = (damage + (elementalDamage / 2) + (ramDagame) + (gravDagame / 2) + (soundDamage) + (psiDamage / 2) ).round();
    return totalDamage;
  }
  int get baseDamage{
    final elementalDamage = getPowerLevel('Manipulação Elemental');
    final gravDamage = getPowerLevel('Gravidade');
    final archetypeSMI = characterProvider.flatDamageByMov;
    final archetypeBH = characterProvider.breakReadBonus;
    final archetypeWar = characterProvider.warBonus;
    final archetypeSniper = characterProvider.sniperBonus;
    final totalBaseDamage = (elementalDamage * 2) + (gravDamage * 2) + archetypeSMI + archetypeBH + archetypeWar + archetypeSniper;
    return totalBaseDamage;
  }
  int get criticalMerge{
    final baseCriticalMerge = 20;
    final archetypeWP = characterProvider.criticalReductionWeakPoint;
    final finalCriticalMerge = baseCriticalMerge - archetypeWP;
    return finalCriticalMerge;
  }
  int get criticalMultiplier{
    final baseCriticalMultiplier = 2;
    final criticalMultiplierByPowerfulStrike = characterProvider.criticalMultiplierPowerfulStrike;
    final zevyrBonus = characterProvider.zevyrBonus;
    final finalCriticalMultiplier = baseCriticalMultiplier + criticalMultiplierByPowerfulStrike + zevyrBonus;
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
    final rangeBase = getPowerLevel('Alcance');
    final areaBase = getPowerLevel('Área');
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
  void _updateCalculatedValues() {
    baseDamageController.text = baseDamage.toString();
    if (!_isRecalculatingFromCharacter) {
      notifyListeners();
    }
  }
  @override
  void dispose() {
    baseDamageController.dispose();
    super.dispose();
  }
}