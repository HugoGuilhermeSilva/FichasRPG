import 'package:fichas/state_management/advantages_provider.dart';
import 'package:fichas/state_management/attributes_provider.dart';
import 'package:fichas/state_management/power_provider.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fichas/data/archetype_data.dart';
import 'package:fichas/models/record_model.dart';

class CharacterProvider with ChangeNotifier {
  final PowerProvider Function() getPowerProvider;
  final AttributesProvider Function() getAttributesProvider;
  final AdvantagesProvider advantagesProvider;
  bool _isRecalculatingFromAttributes = false;
  final Function({
  int? characterLevel,
  String? archetypeName,
  List<String>? selectedSkills,
  })? onDataChanged;
  final TextEditingController xpController = TextEditingController();
  final TextEditingController manaController = TextEditingController();
  final TextEditingController levelController = TextEditingController();

  int baseMana = 0;
  int finalLife = 0;
  int baseAttributePoints = 0;
  int baseXp = 0;
  int bonusXp1 = 0;
  int bonusXp2 = 0;
  int lifeBase = 0;
  int skillPointPerLevel = 0;
  int modifierDisplacementLevel = 5;
  int advantagesAvailable = 0;
  int maxAttacks = 1;
  int bonusWillForce = 0;
  int bonusDodge = 0;
  int bonusBlock = 0;
  int healBonus = 0;
  int stepHeal = 0;
  int defendBonus = 1;
  int regenBonus = 1;
  int flatDamageByMov = 0;
  int criticalReductionWeakPoint = 0;
  int criticalMultiplierPowerfulStrike = 0;
  int boltMultiplier = 1;
  int sliceBonus = 0;
  int zevyrBonus = 0;
  int blockTankBonus = 0;
  int postureRdBonus = 0;
  int breakReadBonus = 0;
  int bonusLifeByWall = 0;
  int bonusByFirePower = 0;
  int immutableBonus = 0;
  int warBonus = 0;
  int wallBonus = 1;
  int destroyerBonus = 0;
  int rangeMultiplier = 5;
  int areaMultiplier = 3;
  int rangeBonusMultiplier = 0;
  int sniperBonus = 0;
  int slenderBonus = 0;
  String? activeArchetype;
  PowerProvider get powerProvider => getPowerProvider();
  AttributesProvider get attributesProvider => getAttributesProvider();
  final List<String> _selectedAdvantagesNames = [];
  List<String> _selectedSkillNames = [];
  List<String> get selectedSkillNames => _selectedSkillNames;
  int get level => int.tryParse(levelController.text) ?? 1;
  List<String> get selectedAdvantagesNames => _selectedAdvantagesNames;
  CharacterProvider({
    required this.getPowerProvider,
    required this.getAttributesProvider,
    required this.advantagesProvider,
    this.onDataChanged}) {
    levelController.addListener(_handleDataChangeAndSave);
    //powerProvider.addListener(recalculateAllStats);
  }
  void updateFromRecord(Record? record) {
    levelController.removeListener(_handleDataChangeAndSave);

    if (record != null) {
      levelController.text = record.characterLevel.toString();
      _selectedSkillNames = record.selectedSkills ?? [];
      activeArchetype = record.archetypeName;
    } else {
      levelController.text = '1';
      _selectedSkillNames = [];
      activeArchetype = null;
    }
    recalculateAllStats();
    levelController.addListener(_handleDataChangeAndSave);
  }
  void _handleDataChangeAndSave() {
    recalculateAllStats();
    onDataChanged?.call(
      characterLevel: level,
      archetypeName: activeArchetype,
      selectedSkills: _selectedSkillNames,
    );
  }
  void toggleSkill(String skillName) {
    if (_selectedSkillNames.contains(skillName)) {
      _selectedSkillNames.remove(skillName);
    } else {
      _selectedSkillNames.add(skillName);
    }
    _handleDataChangeAndSave();
  }
  bool isSkillSelected(String skillName) {
    return _selectedSkillNames.contains(skillName);
  }
  bool isArchetypeSelected(String archetypeName){
    return advantagesProvider.allSelectedAdvantages.contains(archetypeName);
  }
  int get hardAsStoneBonus {
    final bool hasHardAsStone = advantagesProvider.isAdvantageSelected('Duro como pedra');
    if (hasHardAsStone) {
      final int defendPowerLevel = powerProvider.getPowerLevel('Defender');
      return defendPowerLevel;
    } else {
      return 0;
    }
  }
  void recalculateAllStats() {
    advantagesProvider.clearBonusAdvantagesSilently();
    powerProvider.clearBonusPowers();
    activeArchetype = null;
    lifeBase = 0;
    skillPointPerLevel = 0;
    baseXp = 0;
    bonusXp1 = 0;
    bonusXp2 = 0;
    baseAttributePoints = 2;
    baseMana = 0;
    bonusWillForce = 0;
    bonusDodge = 0;
    bonusBlock = 0;
    healBonus = 0;
    stepHeal = 0;
    defendBonus = 1;
    regenBonus = 1;
    flatDamageByMov = 0;
    criticalReductionWeakPoint = 0;
    criticalMultiplierPowerfulStrike = 0;
    boltMultiplier = 1;
    sliceBonus = 0;
    zevyrBonus = 0;
    blockTankBonus = 0;
    postureRdBonus = 0;
    breakReadBonus = 0;
    bonusLifeByWall = 0;
    bonusByFirePower = 0;
    immutableBonus = 0;
    warBonus = 0;
    wallBonus = 1;
    destroyerBonus = 0;
    rangeMultiplier = 5;
    areaMultiplier = 3;
    rangeBonusMultiplier = 0;
    sniperBonus = 0;
    slenderBonus = 0;

    if (_selectedSkillNames.isNotEmpty) {
      for (String skillName in _selectedSkillNames) {
        for (var archetype in allArchetypes) {
          final firstThreeSkills = archetype.skills.take(3);
          if (firstThreeSkills.any((skill) => skill.name == skillName)) {
            activeArchetype = archetype.name;
            break;
          }
        }
        if (activeArchetype != null) {
          break;
        }
      }
    }
    if (activeArchetype != null) {
      final archetypeData = allArchetypes.firstWhere((arch) => arch.name == activeArchetype);
      final bool hasQuickLearner = advantagesProvider.selectedAdvantages.contains('Aprendiz Rápido');
      final int quickLearnerBonus = hasQuickLearner ? 1 : 0;
      skillPointPerLevel = (archetypeData.skillPointsPerLevel + quickLearnerBonus) * level;
      baseAttributePoints = archetypeData.attributePoints * level + 2;
      baseMana = archetypeData.mana * level;
    }
    advantagesAvailable = (level / 2).round();
    modifierDisplacementLevel = 5;
    maxAttacks = 1;
    for (String skillName in _selectedSkillNames) {
      if (skillName == 'Prodígio') {
        bonusXp1 = 25;
      }
      if(skillName == 'Estudante'){
        int extraAdvantages = 1 + (level / 5).round();
        advantagesAvailable = (level / 2).round() + extraAdvantages;
      }
      if(skillName == 'Força do Conhecimento'){
        int bonusIntAttacks = int.tryParse(attributesProvider.getAttributeTotalFor('Inteligencia')) ?? 0;
        int bonusCharAttacks = int.tryParse(attributesProvider.getAttributeTotalFor('Carisma')) ?? 0;
        int bonusWillAttacks = int.tryParse(attributesProvider.getAttributeTotalFor('Vontade')) ?? 0;
        int biggerAttacks = max(bonusWillAttacks, max(bonusIntAttacks,bonusCharAttacks));
        maxAttacks = 1 + (biggerAttacks / 5).round();
      }
      if(skillName == 'Busca por Conhecimento'){
        int intelligenceLifeBonus = int.tryParse(attributesProvider.getAttributeTotalFor('Inteligencia')) ?? 0;
        lifeBase = intelligenceLifeBonus;
      }
      if (skillName == 'Aprendiz'){
        bonusXp2 = 50;
      }
      if (skillName == 'Mente Brilhante'){
        int charismaBonus = int.tryParse(attributesProvider.getAttributeTotalFor('Carisma')) ?? 0;
        bonusWillForce = charismaBonus;
      }
      if(skillName == 'Curandeiros'){
        healBonus = powerProvider.getPowerLevel('Cura');
        stepHeal = 2;
      }
      if(skillName == 'Tanque'){
        int regenBonusC = 2;
        int defendBonusC = 2;
        regenBonus = regenBonusC;
        defendBonus = defendBonusC;
      }
      if(skillName == 'Velocista'){
        modifierDisplacementLevel = 15;
      }
      if(skillName == 'Agil'){
        advantagesProvider.addBonusAdvantageSilently('Agil');
      }
      if(skillName == 'Soco de Massa Infinita'){
        int bonusC = powerProvider.getPowerLevel('Mover-se');
        flatDamageByMov = bonusC;
      }
      if(skillName == 'Cada vez mais Rapido'){
        int accelerateBonus = 2 + (level / 5).round();
        powerProvider.ensurePowerExists('Acelerar');
        powerProvider.addBonusPowerLevels('Acelerar', accelerateBonus);
      }
      if(skillName == 'Ponto Fraco'){
        criticalReductionWeakPoint = 2;
      }
      if(skillName == 'Golpe Potente'){
        criticalMultiplierPowerfulStrike = 2;
      }
      if(skillName == 'Bolt'){
        boltMultiplier = 2;
      }
      if(skillName == 'Fatiar'){
        sliceBonus = 4;
      }
      if(skillName == 'Franchiesco Virgulino'){
        int bonusFrantiescoC = powerProvider.getPowerLevel('Mover-se');
        powerProvider.ensurePowerExists('Dano');
        powerProvider.addBonusPowerLevels('Dano', bonusFrantiescoC);
      }
      if(skillName == 'Zevyr'){
        zevyrBonus = 2;
      }
      if(skillName == 'Atacante'){
        advantagesProvider.addBonusAdvantageSilently('Aperfeiçoamento');
        int bonusDamage = level;
        powerProvider.ensurePowerExists('Dano');
        powerProvider.addBonusPowerLevels('Dano', bonusDamage);
      }
      if(skillName == 'Tank'){
        advantagesProvider.addBonusAdvantageSilently('Ler Movimentos');
        int bonusBlock = level;
        blockTankBonus = bonusBlock;
      }
      if(skillName == 'Hibrido'){
        advantagesProvider.addBonusAdvantageSilently('Agil');
        advantagesProvider.addBonusAdvantageSilently('Ambidestria');
      }
      if(skillName == 'Postura Defensiva'){
        int bonusDefend = level;
        powerProvider.ensurePowerExists('Defender');
        powerProvider.addBonusPowerLevels('Defender', bonusDefend);
        postureRdBonus = 2;
      }
      if(skillName == 'Mestre do Combate'){
        int bonus = 2;
        powerProvider.ensurePowerExists('Acelerar');
        powerProvider.addBonusPowerLevels('Acelerar', bonus);
      }
      if(skillName == 'Amassar Seu Crânio'){
        int damage = powerProvider.getPowerLevel('Dano');
        breakReadBonus = damage * 2;
      }
      if(skillName == 'Parede de Carne'){
        int bonusByDefend = powerProvider.getPowerLevel('Defender');
        int bonusByRegen = powerProvider.getPowerLevel('Regeneração');
        bonusLifeByWall = (bonusByDefend * 5) + (bonusByRegen * 2);
      }
      if(skillName == 'Poder de fogo'){
        bonusByFirePower = 5;
      }
      if(skillName == 'Imutavel'){
        int bonus = 2;
        powerProvider.ensurePowerExists('Acelerar');
        powerProvider.addBonusPowerLevels('Acelerar', bonus);
        int totalAccelerate = powerProvider.getPowerLevel('Acelerar');
        immutableBonus = (totalAccelerate / 4).round();
      }
      if(skillName == 'Guerreiro'){
        int meleeC = int.tryParse(attributesProvider.getCombatTotalFor('Combate Corporal')) ?? 0;
        int rangedC = int.tryParse(attributesProvider.getCombatTotalFor('Combate a Distancia')) ?? 0;
        int mentalC = int.tryParse(attributesProvider.getCombatTotalFor('Combate Mental')) ?? 0;
        int biggerCombat = max(mentalC, max(meleeC, rangedC));
        warBonus = biggerCombat * 10;
      }
      if(skillName == 'Muralha'){
        wallBonus = 10;
      }
      if(skillName == 'Destruidor'){
        destroyerBonus = 2;
      }
      if(skillName == 'Demolidor'){
        rangeMultiplier = 10;
      }
      if(skillName == 'Atirador de Elite'){
        rangeMultiplier = 15;
        advantagesProvider.addBonusAdvantageSilently('Atirador');
      }
      if(skillName == 'Disparador'){
        advantagesProvider.addBonusAdvantageSilently('Na Mira');
      }
      if(skillName == 'Sniper'){
        rangeBonusMultiplier = 5;
        int bonusDamage = powerProvider.getPowerLevel('Alcance');
        sniperBonus = bonusDamage;
      }
      if(skillName == 'Sempre Mais'){
        areaMultiplier = 5;
        powerProvider.ensurePowerExists('Área');
        powerProvider.addBonusPowerLevels('Área', level);
      }
      if(skillName == 'Esguio'){
        int bonusRange = powerProvider.getPowerLevel('Alcance');
        slenderBonus = level + (bonusRange / 8).round();
      }
    }
    if (activeArchetype != null) {
      final archetypeData = allArchetypes.firstWhere((arch) => arch.name == activeArchetype);
      finalLife = ((archetypeData.baseHp + lifeBase) * level + bonusLifeByWall);
      final hasSlender = advantagesProvider.allSelectedAdvantages.contains('Esguio');
      final bool lifeIsLow = attributesProvider.isLifeBelow100;
      int slenderXpBonus = 1;
      if(hasSlender && lifeIsLow){
        slenderXpBonus = 2;
      }
      final bool hasMutant = advantagesProvider.allSelectedAdvantages.contains('Mutação');
      final int mutantBonus = hasMutant ? 40 : 0;
      baseXp = ((archetypeData.baseXp + bonusXp1 + bonusXp2 + mutantBonus) * level) * slenderXpBonus;
    }
    manaController.text = baseMana.toString();
    int currentXp = baseXp - powerProvider.totalPowersCost;
    xpController.text = currentXp.toString();
    if (!_isRecalculatingFromAttributes) {
      notifyListeners();
    }
  }
  @override
  void dispose() {
    levelController.removeListener(_handleDataChangeAndSave);
    levelController.dispose();
    xpController.dispose();
    manaController.dispose();
    super.dispose();
  }
}