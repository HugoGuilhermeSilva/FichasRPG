import 'package:fichas/state_management/power_provider.dart';
import 'package:flutter/material.dart';
import 'package:fichas/data/archetype_data.dart';
class CharacterProvider with ChangeNotifier{
  final TextEditingController xpController = TextEditingController();
  final TextEditingController manaController = TextEditingController();
  final TextEditingController levelController = TextEditingController(text: '1');
  int get level => int.tryParse(levelController.text) ?? 1;
  final List<String> _selectedSkillNames = [];
  List<String> get selectedSkillNames => _selectedSkillNames;
  PowerProvider? _powerProvider;
  int baseMana = 0;
  int finalLife = 0;
  int baseAttributePoints = 0;
  int baseXp = 0;
  int lifeBase = 0;
  int skillPointPerLevel = 0;
  String? activeArchetype;

  CharacterProvider(){
    levelController.addListener(recalculateAllStats);
    recalculateAllStats();
  }
  void setPowerProvider(PowerProvider powerProvider) {
    _powerProvider = powerProvider;
  }
  void toggleSkill(String skillName){
    if(_selectedSkillNames.contains(skillName)){
      _selectedSkillNames.remove(skillName);
  } else {
    _selectedSkillNames.add(skillName);
  }
    recalculateAllStats();
  }
  bool isSkillSelected(String skillName){
    return _selectedSkillNames.contains(skillName);
  }
  void recalculateAllStats(){
    activeArchetype = null;
    if (_selectedSkillNames.isNotEmpty){
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
    for (String skillName in _selectedSkillNames) {
      if (skillName == 'Prodígio') {
        baseXp = (baseXp + 25) * level;
      }
      if (skillName == 'Muralha') {
        lifeBase = lifeBase * 10;
      }
    }
    manaController.text = baseMana.toString();
    if (activeArchetype != null) {
      final archetypeData = allArchetypes.firstWhere((arch) => arch.name == activeArchetype);
      lifeBase = archetypeData.baseHp * level;
      skillPointPerLevel = archetypeData.skillPointsPerLevel * level;
      baseXp = archetypeData.baseXp * level;
      baseAttributePoints = archetypeData.attributePoints * level + 2;
      baseMana = archetypeData.mana * level;
    } else {
      lifeBase = 0;
      skillPointPerLevel = 0;
      baseXp = 0;
      baseAttributePoints = 2;
      baseMana = 0;
    }
    int currentXp = baseXp;
    final powersCost = _powerProvider?.totalPowersCost ?? 0;
    currentXp -= powersCost;
    xpController.text = currentXp.toString();
    notifyListeners();
  }

  @override
  void dispose() {
    levelController.dispose();
    super.dispose();
  }
}