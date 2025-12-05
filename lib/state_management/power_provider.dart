import 'package:fichas/data/power_model.dart';
import 'package:fichas/state_management/character_provider.dart';
import 'package:flutter/material.dart';
import 'package:fichas/data/power_list.dart';
import 'package:fichas/models/record_model.dart';

class PowerProvider with ChangeNotifier{
  CharacterProvider? characterProvider;
  Map<String, int> _selectedPowers = {};
  Map<String, int> get selectedPowers => _selectedPowers;
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
  void updateFromRecord(Record? record){
    _selectedPowers = Map<String, int>.from(record?.powersData ?? {});
    _updateCalculatedValues();
  }
  void _notifyAndSaveChanges(){
    onDataChanged?.call(_selectedPowers);
    _updateCalculatedValues();
  }
  bool isPowerSelected(String powerName){
    return _selectedPowers.containsKey(powerName);
  }
  int getPowerLevel(String powerName){
    return _selectedPowers[powerName] ?? 0;
  }
  void togglePowerSelection(String powerName, bool isSelected) {
    if (isSelected) {
      if (!_selectedPowers.containsKey(powerName)) {
        _selectedPowers[powerName] = 1;
      }
    } else {
      _selectedPowers.remove(powerName);
    }
    _notifyAndSaveChanges();
  }
  void incrementPowerLevel(String powerName){
    if(_selectedPowers.containsKey(powerName)){
      _selectedPowers[powerName] = _selectedPowers[powerName]! + 1;
      _notifyAndSaveChanges();
    }
  }
  void decrementPowerLevel(String powerName){
    if(_selectedPowers.containsKey(powerName)){
      int currentLevel = _selectedPowers[powerName]!;
      if(currentLevel > 1 ){
        _selectedPowers[powerName] = currentLevel - 1;
      } else{
        _selectedPowers.remove(powerName);
      }
      _notifyAndSaveChanges();
    }
  }
  void setPowerLevel(String powerName, int level) {
    if (level > 0) {
      _selectedPowers[powerName] = level;
    } else {
      _selectedPowers.remove(powerName);
    }
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
    final int stepDamage = 6;
    return stepDamage;
  }
  int get totalDisplacement {
    const int baseDisplacement = 10;
    final moveLevel = getPowerLevel('Mover-se');
    final int modifierDisplacementLevel = characterProvider?.modifierDisplacementLevel ?? 5;
    final totalDisplacement = baseDisplacement + (modifierDisplacementLevel * moveLevel);
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
    final rdLevel = rd;
    return rdLevel;
  }
  int get totalDagame{
    final damage = getPowerLevel('Dano');
    final elementalDamage = getPowerLevel('Manipulação Elemental');
    final ramDagame = getPowerLevel('Pente de RAM');
    final gravDagame = getPowerLevel('Gravidade');
    final soundDamage = getPowerLevel('Som');
    final psiDamage = getPowerLevel('Telecinese');
    final totalDamage = (damage + (elementalDamage / 2) + (ramDagame) + (gravDagame / 2) + (soundDamage) + (psiDamage / 2)).round();
    return totalDamage;
  }
  int get baseDamage{
    final elementalDamage = getPowerLevel('Manipulação Elemental');
    final gravDamage = getPowerLevel('Gravidade');
    final archetypeSMI = characterProvider?.flatDamageByMov ?? 0;
    final totalBaseDamage = (elementalDamage * 2) + (gravDamage * 2) + archetypeSMI;
    return totalBaseDamage;
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