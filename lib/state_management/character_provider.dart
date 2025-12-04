import 'package:fichas/state_management/attributes_provider.dart';
import 'package:fichas/state_management/power_provider.dart';
import 'package:flutter/material.dart';
import 'package:fichas/data/archetype_data.dart';
import 'package:fichas/models/record_model.dart';

class CharacterProvider with ChangeNotifier {
  final PowerProvider powerProvider;
  late final AttributesProvider attributesProvider;
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
  String? activeArchetype;
  final List<String> _selectedAdvantagesNames = [];
  List<String> _selectedSkillNames = [];
  List<String> get selectedSkillNames => _selectedSkillNames;
  int get level => int.tryParse(levelController.text) ?? 1;
  List<String> get selectedAdvantagesNames => _selectedAdvantagesNames;
  CharacterProvider({required this.powerProvider, this.onDataChanged}) {
    levelController.addListener(_handleDataChangeAndSave);
    powerProvider.addListener(recalculateAllStats);
  }
  void setAttributesProvider(AttributesProvider aProvider) {
    attributesProvider = aProvider;
    attributesProvider.addListener(() {
      if (_isRecalculatingFromAttributes) return;
      _isRecalculatingFromAttributes = true;
      recalculateAllStats();
      _isRecalculatingFromAttributes = false;
    });
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
  void recalculateAllStats() {
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
      skillPointPerLevel = archetypeData.skillPointsPerLevel * level;
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
        maxAttacks = 1 + (bonusIntAttacks / 5).round();
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
      if(skillName == 'Velocista'){
        modifierDisplacementLevel = 15;
      }
    }
    if (activeArchetype != null) {
      final archetypeData = allArchetypes.firstWhere((arch) => arch.name == activeArchetype);
      finalLife = (archetypeData.baseHp + lifeBase) * level;
      baseXp = (archetypeData.baseXp + bonusXp1 + bonusXp2) * level;
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
    powerProvider.removeListener(recalculateAllStats);
    levelController.dispose();
    xpController.dispose();
    manaController.dispose();
    super.dispose();
  }
}