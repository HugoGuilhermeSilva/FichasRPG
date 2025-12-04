import 'package:fichas/state_management/power_provider.dart';
import 'package:flutter/material.dart';
import 'package:fichas/data/archetype_data.dart';
import 'package:fichas/models/record_model.dart';

class CharacterProvider with ChangeNotifier {
  final PowerProvider powerProvider;
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
  int lifeBase = 0;
  int skillPointPerLevel = 0;
  int modifierDisplacementLevel = 5;
  int advantagesAvailable = 0;
  String? activeArchetype;
  List<String> _selectedSkillNames = [];
  List<String> get selectedSkillNames => _selectedSkillNames;
  int get level => int.tryParse(levelController.text) ?? 1;
  CharacterProvider({required this.powerProvider, this.onDataChanged}) {
    levelController.addListener(_handleDataChangeAndSave);
    powerProvider.addListener(recalculateAllStats);
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
    baseAttributePoints = 2;
    baseMana = 0;

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
      lifeBase = archetypeData.baseHp * level;
      skillPointPerLevel = archetypeData.skillPointsPerLevel * level;
      baseXp = archetypeData.baseXp * level;
      baseAttributePoints = archetypeData.attributePoints * level + 2;
      baseMana = archetypeData.mana * level;
    }
    advantagesAvailable = (level / 2).round();
    modifierDisplacementLevel = 5;
    for (String skillName in _selectedSkillNames) {
      if (skillName == 'Prodígio') {
        baseXp = 125 * level;
      }
      if(skillName == 'Estudante'){
        int extraAdvantages = 1 + (level / 5).round();
        advantagesAvailable = (level / 2).round() + extraAdvantages;
      }
      if(skillName == 'Velocista'){
        modifierDisplacementLevel = 15;
      }
    }
    manaController.text = baseMana.toString();
    int currentXp = baseXp - powerProvider.totalPowersCost;
    xpController.text = currentXp.toString();
    notifyListeners();
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