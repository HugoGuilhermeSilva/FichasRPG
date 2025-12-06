import 'package:fichas/data/power_model.dart';
import 'package:fichas/state_management/character_provider.dart';
import 'package:flutter/material.dart';
import 'package:fichas/data/power_list.dart';
import 'package:fichas/models/record_model.dart';

class PowerProvider with ChangeNotifier{
  CharacterProvider? characterProvider;
  Map<String, int> _selectedPowers = {};
  Map<String, int> get selectedPowers => _selectedPowers;
  Map<String, int> _bonusPowers = {};
  Map<String, int> get bonusPowers => _bonusPowers;
  final TextEditingController baseDamageController = TextEditingController();
  final Function(Map<String, int>)? onDataChanged;
  bool _isRecalculatingFromCharacter = false;

  PowerProvider({this.onDataChanged,this.characterProvider}) {
    _updateCalculatedValues();
  }
  void setCharacterProvider(CharacterProvider provider) {
    characterProvider?.removeListener(_onCharacterProviderChanged);
    characterProvider = provider;
    characterProvider?.addListener(_onCharacterProviderChanged);
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
    final int baseHealFromArchetype = characterProvider?.healBonus ?? 0;
    final baseHeal = baseHealFromArchetype;
    return baseHeal;
  }
  int get stepHeal{
    final int bonusStepHealFromArchetype = characterProvider?.stepHeal ?? 0;
    final stepHeal = bonusStepHealFromArchetype + 6;
    return stepHeal;
  }
  int get stepDamage{
    final bonusByFirePower = characterProvider?.bonusByFirePower ?? 0;
    final bonusByDestroyer = characterProvider?.destroyerBonus ?? 0;
    final stepDamage = 6 + bonusByFirePower * 2 + bonusByDestroyer * 2;
    return stepDamage;
  }
  int get totalDisplacement {
    const baseDisplacement = 10;
    final moveLevel = getPowerLevel('Mover-se');
    final modifierDisplacementLevel = characterProvider?.modifierDisplacementLevel ?? 5;
    final boltMultiplier = characterProvider?.boltMultiplier ?? 1;
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
    final bonus1C = characterProvider?.defendBonus ?? 1;
    final defendLevel = defend * bonus1C;
    return defendLevel;
  }
  int get rdLevel{
    final rd = 2;
    final rdByPosture = characterProvider?.postureRdBonus ?? 0;
    final rdByImmutable = characterProvider?.immutableBonus ?? 0;
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
    final archetypeSMI = characterProvider?.flatDamageByMov ?? 0;
    final archetypeBH = characterProvider?.breakReadBonus ?? 0;
    final archetypeWar = characterProvider?.warBonus ?? 0;
    final totalBaseDamage = (elementalDamage * 2) + (gravDamage * 2) + archetypeSMI + archetypeBH + archetypeWar;
    return totalBaseDamage;
  }
  int get criticalMerge{
    final baseCriticalMerge = 20;
    final archetypeWP = characterProvider?.criticalReductionWeakPoint ?? 0;
    final finalCriticalMerge = baseCriticalMerge - archetypeWP;
    return finalCriticalMerge;
  }
  int get criticalMultiplier{
    final baseCriticalMultiplier = 2;
    final criticalMultiplierByPowerfulStrike = characterProvider?.criticalMultiplierPowerfulStrike ?? 0;
    final zevyrBonus = characterProvider?.zevyrBonus ?? 0;
    final finalCriticalMultiplier = baseCriticalMultiplier + criticalMultiplierByPowerfulStrike + zevyrBonus;
    return finalCriticalMultiplier;
  }
  int get totalStrikes{
    final strikesBase = 1;
    final bonusStrikesByAcc = getPowerLevel('Acelerar');
    final baseStrikesBySlice = characterProvider?.sliceBonus ?? 0;
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
    final regenByTank = characterProvider?.regenBonus ?? 1;
    final regenTotal = regenBase * regenByTank;
    return regenTotal;
  }
  int get rangeTotal{
    final rangeBase = getPowerLevel('Alcance');
    final areaBase = getPowerLevel('Área');
    final rangeTotal = rangeBase * 5 + areaBase * 3;
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
  void notifyExternalChange() {
    _updateCalculatedValues();
  }
  void _onCharacterProviderChanged() {
    if (_isRecalculatingFromCharacter) return;
    _isRecalculatingFromCharacter = true;
    _updateCalculatedValues();
    _isRecalculatingFromCharacter = false;
  }
  @override
  void dispose() {
    characterProvider?.removeListener(_onCharacterProviderChanged);
    baseDamageController.dispose();
    super.dispose();
  }
}