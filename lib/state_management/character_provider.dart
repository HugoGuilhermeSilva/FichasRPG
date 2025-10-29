import 'package:fichas/services/sotrage_Service.dart';
import 'package:fichas/state_management/power_provider.dart';
import 'package:flutter/material.dart';
import 'package:fichas/data/archetype_data.dart';

class CharacterProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final TextEditingController xpController = TextEditingController();
  final TextEditingController manaController = TextEditingController();
  final TextEditingController levelController = TextEditingController(
      text: '1');

  int get level => int.tryParse(levelController.text) ?? 1;
  List<String> _selectedSkillNames = [];
  List<String> get selectedSkillNames => _selectedSkillNames;

  PowerProvider? _powerProvider;
  int baseMana = 0;
  int finalLife = 0;
  int baseAttributePoints = 0;
  int baseXp = 0;
  int lifeBase = 0;
  int skillPointPerLevel = 0;
  String? activeArchetype;

  CharacterProvider() {
    _loadCharacterData();
    levelController.addListener(() {
      recalculateAllStats();
      _saveCharacterData();
    });
  }
  Future<void> _loadCharacterData() async {
    final loadedLevel = await _storageService.loadString('character_level');
    if (loadedLevel != null) {
      levelController.text = loadedLevel;
    }
    final loadedSkills = await _storageService.loadStringList('selected_skills');
    if (loadedSkills != null) {
      _selectedSkillNames = loadedSkills;
    }
    recalculateAllStats();
  }
  Future<void> _saveCharacterData() async {
    await _storageService.saveString('character_level', levelController.text);
    await _storageService.saveStringList(
        'selected_skills', _selectedSkillNames);
  }

  void setPowerProvider(PowerProvider powerProvider) {
    _powerProvider = powerProvider;
  }

  void toggleSkill(String skillName) {
    if (_selectedSkillNames.contains(skillName)) {
      _selectedSkillNames.remove(skillName);
    } else {
      _selectedSkillNames.add(skillName);
    }
    recalculateAllStats();
    _saveCharacterData();
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
          if (archetype.skills.first.name == skillName) {
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
      final archetypeData = allArchetypes.firstWhere((arch) =>
      arch.name == activeArchetype);
      lifeBase = archetypeData.baseHp * level;
      skillPointPerLevel = archetypeData.skillPointsPerLevel * level;
      baseXp = archetypeData.baseXp * level;
      baseAttributePoints = archetypeData.attributePoints * level + 2;
      baseMana = archetypeData.mana * level;
    }
    for (String skillName in _selectedSkillNames) {
      if (skillName == 'Prodígio') {
        baseXp = (baseXp + 25) * level;
      }
      if (skillName == 'Muralha') {
        lifeBase = lifeBase * 10;
      }
    }
    manaController.text = baseMana.toString();
    int currentXp = baseXp;
    final powersCost = _powerProvider?.totalPowersCost ?? 0;
    currentXp -= powersCost;
    xpController.text = currentXp.toString();

    notifyListeners();
  }

  @override
  void dispose() {
    levelController.removeListener(recalculateAllStats);
    levelController.dispose();
    xpController.dispose();
    manaController.dispose();
    super.dispose();
  }
}