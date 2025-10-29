import 'package:flutter/material.dart';
import 'package:fichas/data/archetype_data.dart';
class CharacterProvider with ChangeNotifier{
  final TextEditingController levelController = TextEditingController(text: '1');
  int get level => int.tryParse(levelController.text) ?? 1;
  final List<String> _selectedSkillNames = [];
  List<String> get selectedSkillNames => _selectedSkillNames;
  int baseAttributePoints = 0;
  int baseXp = 0;
  int lifeBase = 0;
  int skillPointPerLevel = 0;
  String? activeArchetype;

  CharacterProvider(){
    levelController.addListener(_recalculateAllStats);
    _recalculateAllStats();
  }
  void toggleSkill(String skillName){
    if(_selectedSkillNames.contains(skillName)){
      _selectedSkillNames.remove(skillName);
  } else {
    _selectedSkillNames.add(skillName);
  }
    _recalculateAllStats();
  }
  bool isSkillSelected(String skillName){
    return _selectedSkillNames.contains(skillName);
  }
  void _recalculateAllStats(){
    activeArchetype = null;
    if (_selectedSkillNames.isNotEmpty){
      final lastSelectedSkill = _selectedSkillNames.last;
     for(var archetype in allArchetypes){
       if(archetype.skills.any((skill) => skill.name == lastSelectedSkill)){
         activeArchetype = archetype.name;
         break;
       }
     }
    }
    if(activeArchetype != null){
      final archetypeData = allArchetypes.firstWhere((arch) => arch.name == activeArchetype);
      lifeBase = archetypeData.baseHp * level;
      skillPointPerLevel = archetypeData.skillPointsPerLevel * level;
      baseXp = archetypeData.baseXp * level;
      baseAttributePoints = archetypeData.attributePoints * level + 2;
    } else{
      lifeBase = 0;
      skillPointPerLevel = 0;
      baseXp = 0;
      baseAttributePoints = 2;
    }
    for(String skillName in _selectedSkillNames){
     if(skillName == 'Prodígio'){
      baseXp = 25 * level;
     }
     if(skillName == 'Muralha'){
       lifeBase = lifeBase * 10;
     }
    }
    notifyListeners();
  }
  @override
  void dispose() {
    levelController.dispose();
    super.dispose();
  }
}