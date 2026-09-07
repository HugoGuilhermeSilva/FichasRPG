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
  Map<String, int> get passivesPowerBonus => _passiveBonuses;
  final Function(Map<String, int>)? onDataChanged;
  bool _isRecalculatingFromCharacter = false;
  final VoidCallback? onPowersChangedForRecalculation;

  PowerProvider({this.onDataChanged,required this.characterProvider, required this.advantagesProvider,this.onPowersChangedForRecalculation,});
  void ensurePowerExists(String powerName) {
    if (!_selectedPowers.containsKey(powerName)) {
      _selectedPowers[powerName] = 0;
    }
  }
  void addPowerByPassives(String powerName, int levelsToAdd){
    _passiveBonuses[powerName] = (_passiveBonuses[powerName] ?? 0) + levelsToAdd;
    _notifyAndSaveChanges();
  }
  void clearPassivesBonus(){
    if(_passiveBonuses.isNotEmpty){
      _passiveBonuses.clear();
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
        if ((_skillAndArchetypeBonuses[powerName] ?? 0) == 0 || (_passiveBonuses[powerName] ?? 0) == 0) {
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
      if ((_skillAndArchetypeBonuses[powerName] ?? 0) > 0 || (_passiveBonuses[powerName] ?? 0) > 0) {
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
      if ((_skillAndArchetypeBonuses[powerName] ?? 0) == 0 || (_passiveBonuses[powerName] ?? 0) == 0) {
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
    powerSet.addAll(_passiveBonuses.keys);
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
    final baseHealExtra = characterProvider.baseHealExtra;
    final baseHeal = baseHealFromArchetype + medicExpertBonus + baseHealExtra;
    return baseHeal;
  }
  int get stepHeal{
    final int bonusStepHealFromArchetype = characterProvider.stepHeal;
    final stepHealExtra = characterProvider.stepHealExtra;
    final stepHeal = bonusStepHealFromArchetype + 6 + (stepHealExtra * 2);
    return stepHeal;
  }
  int get stepDamage{
    final has1Gun = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Estilo de 1 arma');
    final oneGunBonus = has1Gun ? 2 : 0;
    final bonusByFirePower = characterProvider.bonusByFirePower;
    final bonusByDestroyer = characterProvider.destroyerBonus;
    final stepDamageExtra = characterProvider.stepDamageExtra * 2;
    final rawStepDamage = 6 + bonusByFirePower * 2 + bonusByDestroyer * 2 + oneGunBonus + stepDamageExtra;
    return rawStepDamage > 30 ? 30 : rawStepDamage;
  }
  int get _stepDamageOverflow {
    final has1Gun = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Estilo de 1 arma');
    final oneGunBonus = has1Gun ? 2 : 0;
    final bonusByFirePower = characterProvider.bonusByFirePower;
    final bonusByDestroyer = characterProvider.destroyerBonus;
    final stepDamageExtra = characterProvider.stepDamageExtra * 2;
    final rawStepDamage = 6 + bonusByFirePower * 2 + bonusByDestroyer * 2 + oneGunBonus + stepDamageExtra;
    return rawStepDamage > 30 ? (rawStepDamage - 30) : 0;
  }
  int get totalDisplacement {
    const baseDisplacement = 10;
    final modifierDisplacementLevel = characterProvider.modifierDisplacementLevel;
    final boltMultiplier = characterProvider.boltMultiplier;
    final moveLevel = getPowerLevel('Mover-se');
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
    final defendLevel = (defend * bonus1C);
    return defendLevel;
  }
  int get rdLevel{
    final rd = 2;
    final rdByPosture = characterProvider.postureRdBonus;
    final rdByImmutable = characterProvider.immutableBonus;
    final rdExtra = characterProvider.rdExtra * 2;
    final rdLevel = rd + rdByPosture + rdByImmutable + rdExtra;
    return rdLevel;
  }
  int get totalDagame{
    final damage = getPowerLevel('Dano');
    final bool hasBestiary = allActivePowerNames.contains('(Bestiário)Forma da Criatura');
    final bestiaryBonus = hasBestiary ? characterProvider.level : 0;
    final totalDamage = damage + bestiaryBonus;
    return totalDamage;
  }
  int get baseDamage{
    final elementalDamage = getPowerLevel('Manipulação Elemental');
    final gravDamage = getPowerLevel('Gravidade');
    final bool hasFlyingKick = advantagesProvider.allSelectedAdvantages.contains('Voadora');
    final bonusByFlyingKick = hasFlyingKick ? getPowerLevel('Mover-se') : 0;
    final bool hasAggravating = advantagesProvider.allSelectedAdvantages.contains('Ataque Agravante');
    final bonusByAggravating = hasAggravating ? characterProvider.level : 0;
    final bool hasMind = allActivePowerNames.contains('(Telecinese)Mente Afiada');
    final int intBonus = int.tryParse(characterProvider.attributesProvider.getAttributeTotalFor('Inteligencia')) ?? 0;
    final int vontBonus = int.tryParse(characterProvider.attributesProvider.getAttributeTotalFor('Vontade')) ?? 0;
    final int mindBonus = hasMind ? ((intBonus + vontBonus) / 2).round() : 0;
    final archetypeSMI = characterProvider.flatDamageByMov;
    final archetypeBH = characterProvider.breakReadBonus;
    final archetypeWar = characterProvider.warBonus;
    final archetypeSniper = characterProvider.sniperBonus;
    final bonusByExtra = characterProvider.baseDamageExtra;
    final overflowFromStep = _stepDamageOverflow;
    final totalBaseDamage = (elementalDamage * 2) + (gravDamage * 2) + archetypeSMI + archetypeBH + archetypeWar + archetypeSniper + bonusByAggravating + bonusByFlyingKick + mindBonus + bonusByExtra + overflowFromStep;
    return totalBaseDamage;
  }
  int get criticalMerge{
    final baseCriticalMerge = 20;
    final bool hasPlusCritical = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Critico Aprimorado');
    final bonusByPlusCritical = hasPlusCritical ? 1 : 0;
    final has1Gun = characterProvider.advantagesProvider.allSelectedAdvantages.contains('Estilo de 1 arma');
    final oneGunBonus = has1Gun ? 1 : 0;
    final archetypeWP = characterProvider.criticalReductionWeakPoint;
    final mergeExtra = characterProvider.marginCritExtra;
    final finalCriticalMerge = baseCriticalMerge - archetypeWP - bonusByPlusCritical - oneGunBonus - mergeExtra;
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
    final hasElementalSphere = allActivePowerNames.contains('(Manipulação Elemental)Esfera elemental');
    final elementalSphereBonus = hasElementalSphere ? 1 : 0;
    final multCritExtra = characterProvider.multCritExtra;
    final finalCriticalMultiplier = baseCriticalMultiplier + criticalMultiplierByPowerfulStrike + zevyrBonus + bonusByPlusCritical + oneGunBonus + elementalSphereBonus + multCritExtra;
    return finalCriticalMultiplier;
  }
  int get totalStrikes{
    final bool hasAmbidextery = advantagesProvider.allSelectedAdvantages.contains('Ambidestria');
    final strikesBase = hasAmbidextery ? 3 : 1;
    final bonusStrikesByAcc = getPowerLevel('Acelerar');
    final baseStrikesBySlice = characterProvider.sliceBonus;
    final knowledgeBonus = characterProvider.maxAttacks;
    int bonusStrikesBySlice;
    if (baseStrikesBySlice == 0) {
      bonusStrikesBySlice = 0;
    } else {
      bonusStrikesBySlice = ((strikesBase + bonusStrikesByAcc) / baseStrikesBySlice).round();
    }
    final totalStrikes = strikesBase + bonusStrikesByAcc + bonusStrikesBySlice + knowledgeBonus;
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
    final Set<String> rulePowers = {};
    rulePowers.addAll(_selectedPowers.keys);
    rulePowers.addAll(_skillAndArchetypeBonuses.keys);
    for (String powerName in rulePowers) {
      if (
      powerName == '(Manipulação Elemental)Aprimoramento elemental' ||
          powerName == '(Manipulação Elemental)Esfera elemental' ||
          powerName == '(Manipulação Elemental)Prisão elemental' ||
          powerName == '(Manipulação Elemental)Fisiologia elemental' ||
          powerName == '(Manipulação Elemental)Consumir elemento' ||
          powerName == '(Manipulação Elemental)Barreira elemental' ||
          powerName == '(Manipulação Elemental)Mestre elemental' ||
          powerName == '(Manipulação Elemental)Anatomia elemental' ||
          powerName == '(Manipulação Elemental)Moldar grandes quantidades' ||
          powerName == '(Manipulação Elemental)Golpe elemental'
      ) {
        if ((_selectedPowers[powerName] ?? 0) > 0 || (_skillAndArchetypeBonuses[powerName] ?? 0) > 0) {
          ensurePowerExists('Manipulação Elemental');
          _addPowerInteractionBonus('Manipulação Elemental', 1);
        }
      }
      if(
      powerName == '(Tecnocinese)Mente Cibernética'||
          powerName == '(Tecnocinese)PEM'||
          powerName == '(Tecnocinese)Tecnocinese'||
          powerName == '(Tecnocinese)Curto Circuito'||
          powerName == '(Tecnocinese)Desabilitar Arma'||
          powerName == '(Tecnocinese)Esgotamento de Sinápse'||
          powerName == '(Tecnocinese)Reiniciar Optica'||
          powerName == '(Tecnocinese)Defeito de Cibernética'||
          powerName == '(Tecnocinese)Aprimoramento Cibernetico'||
          powerName == '(Tecnocinese)Turbinagem'
      ){
        if ((_selectedPowers[powerName] ?? 0) > 0 || (_skillAndArchetypeBonuses[powerName] ?? 0) > 0) {
          ensurePowerExists('(Tecnocinese)Pente de RAM');
          _addPowerInteractionBonus('(Tecnocinese)Pente de RAM', 1);
        }
      }
      if(
        powerName == '(Atravessar)Atravessar Resistencias' ||
        powerName == '(Atravessar)Atravessar Ataque'
      ){
        if ((_selectedPowers[powerName] ?? 0) > 0 || (_skillAndArchetypeBonuses[powerName] ?? 0) > 0) {
          ensurePowerExists('Atravessar');
          _addPowerInteractionBonus('Atravessar', 1);
        }
      }
      if(
        powerName == '(Gravidade)Aumento de Força G'||
        powerName == '(Gravidade)Manipulação Gravitacional'||
        powerName == '(Gravidade)Amplificação Gravitacional'||
        powerName == '(Gravidade)Agravamento'||
        powerName == '(Gravidade)MUGEN'||
        powerName == '(Gravidade)Ancora Gravitacional'||
        powerName == '(Gravidade)Gravidade Pessoal'
      ){
        if ((_selectedPowers[powerName] ?? 0) > 0 || (_skillAndArchetypeBonuses[powerName] ?? 0) > 0) {
          ensurePowerExists('Gravidade');
          _addPowerInteractionBonus('Gravidade', 1);
        }
      }
      if(
        powerName == '(Som)Aceleração Sonora'||
        powerName == '(Som)Intensificação Sonora'||
        powerName == '(Som)Reverberação'||
        powerName == '(Som)Anulação Sonora'||
        powerName == '(Som)Silenciar'||
        powerName == '(Som)Silencioso'||
        powerName == '(Som)Ecolocalização'||
        powerName == '(Som)Terremoto'
      ){
        if ((_selectedPowers[powerName] ?? 0) > 0 || (_skillAndArchetypeBonuses[powerName] ?? 0) > 0) {
          ensurePowerExists('Som');
          _addPowerInteractionBonus('Som', 1);
        }
      }
      if(
        powerName == '(Tempo)Existência Fora do Fluxo'||
        powerName == '(Tempo)Rebobinar'||
        powerName == '(Tempo)Quebra no tempo'||
        powerName == '(Tempo)Prever'||
        powerName == '(Tempo)Isolamento Temporal'||
        powerName == '(Tempo)Congelamento Temporal'
      ){
        if ((_selectedPowers[powerName] ?? 0) > 0 || (_skillAndArchetypeBonuses[powerName] ?? 0) > 0) {
          ensurePowerExists('Tempo');
          _addPowerInteractionBonus('Tempo', 1);
        }
      }
      if(
        powerName == '(Telecinese)Proteção'||
        powerName == '(Telecinese)Agressão'||
        powerName == '(Telecinese)Mente Afiada'||
        powerName == '(Telecinese)Detecção Aprimorada'||
        powerName == '(Telecinese)Chamado de Arma'||
        powerName == '(Telecinese)Telepatico'
      ){
        if ((_selectedPowers[powerName] ?? 0) > 0 || (_skillAndArchetypeBonuses[powerName] ?? 0) > 0) {
          ensurePowerExists('Telecinese');
          _addPowerInteractionBonus('Telecinese', 1);
        }
      }
    }
    if(isPowerSelected('(Telecinese)Proteção')){
      int teleBonus = (getPowerLevel('Telecinese') / 2).floor();
      if(teleBonus > 0){
        _addPowerInteractionBonus('Defender', teleBonus);
      }
    }
    if(isPowerSelected('(Telecinese)Agressão')){
      int teleBonus = (getPowerLevel('Telecinese') / 2).floor();
      if(teleBonus > 0){
        _addPowerInteractionBonus('Dano', teleBonus);
      }
    }
    if(isPowerSelected('(Som)Aceleração Sonora')){
      int soundBonus = getPowerLevel('Som');
      if(soundBonus > 0){
        _addPowerInteractionBonus('Mover-se', soundBonus);
      }
    }
    if(isPowerSelected('(Som)Intensificação Sonora')){
      int soundBonus = getPowerLevel('Som');
      if(soundBonus > 0){
        _addPowerInteractionBonus('Dano', soundBonus);
      }
    }
    if(isPowerSelected('(Velocidade)Reflexos Melhorados')){
      int moveBonus = (getPowerLevel('Mover-se') / 3).floor();
      if(moveBonus > 0){
        _addPowerInteractionBonus('Atravessar', moveBonus);
      }
    }
    if(isPowerSelected('(Gravidade)Gravidade Pessoal')){
      int gravBonus = (getPowerLevel('Gravidade') / 2).floor();
      if(gravBonus > 0){
        _addPowerInteractionBonus('Defender', gravBonus);
      }
    }
    if(isPowerSelected('(Gravidade)Ancora Gravitacional')){
      int gravBonus = (getPowerLevel('Gravidade') / 2).floor();
      if(gravBonus > 0){
        _addPowerInteractionBonus('Mover-se', gravBonus);
      }
    }
    if(isPowerSelected('(Gravidade)Manipulação Gravitacional')){
      int gravBonus = (getPowerLevel('Gravidade') / 2).floor();
      if(gravBonus > 0){
        _addPowerInteractionBonus('Mover-Algo', gravBonus);
      }
    }
    if(isPowerSelected('(Gravidade)Amplificação Gravitacional')){
      int gravBonus = getPowerLevel('Gravidade');
      if(gravBonus > 0){
        _addPowerInteractionBonus("Dano", gravBonus);
      }
    }
    if(isPowerSelected('(Tecnocinese)Aprimoramento Cibernetico')){
      int ramBonus = getPowerLevel('Pente de RAM');
      if(ramBonus > 0){
        _addPowerInteractionBonus('Dano', ramBonus);
      }
    }
    if (isPowerSelected('(Manipulação Elemental)Anatomia elemental')) {
      int elementalBonus = (getPowerLevel('Manipulação Elemental') / 4).floor();
      if (elementalBonus > 0) {
        _addPowerInteractionBonus('Mover-se', elementalBonus);
        _addPowerInteractionBonus('Defender', elementalBonus);
      }
    }
    if (isPowerSelected('(Manipulação Elemental)Moldar grandes quantidades')) {
      int elementalBonus = getPowerLevel('Manipulação Elemental');
      if (elementalBonus > 0) {
        _addPowerInteractionBonus('Alcance', elementalBonus);
      }
    }
    if (isPowerSelected('(Manipulação Elemental)Golpe elemental')) {
      int elementalBonus = getPowerLevel('Manipulação Elemental');
      if (elementalBonus > 0) {
        _addPowerInteractionBonus('Dano', (elementalBonus / 2).floor());
      }
    }
  }
  void _updateCalculatedValues() {
    if (_isRecalculatingFromCharacter) return;
    _isRecalculatingFromCharacter = true;
    _clearPowerInteractionBonuses();
    _applyBonusRules();
    notifyListeners();
    onPowersChangedForRecalculation?.call();
    _isRecalculatingFromCharacter = false;
  }
}