// D:/coisas do hugo/fichas/lib/state_management/character_provider.dart

import 'package:fichas/state_management/power_provider.dart';
import 'package:flutter/material.dart';
import 'package:fichas/data/archetype_data.dart';
import 'package:fichas/models/record_model.dart';

class CharacterProvider with ChangeNotifier {
  final PowerProvider powerProvider;

  // A função de callback para o RecordProvider continua necessária
  final Function({
  int? characterLevel,
  String? archetypeName,
  List<String>? selectedSkills,
  })? onDataChanged;

  // Seus TextControllers
  final TextEditingController xpController = TextEditingController();
  final TextEditingController manaController = TextEditingController();
  final TextEditingController levelController = TextEditingController();

  // Suas variáveis de cálculo são RESTAURADAS
  int baseMana = 0;
  int finalLife = 0; // Você mencionou, então adicionei. Se não for usada aqui, pode remover.
  int baseAttributePoints = 0;
  int baseXp = 0;
  int lifeBase = 0;
  int skillPointPerLevel = 0;
  String? activeArchetype;

  List<String> _selectedSkillNames = [];

  List<String> get selectedSkillNames => _selectedSkillNames;

  int get level => int.tryParse(levelController.text) ?? 1;

  // Construtor
  CharacterProvider({required this.powerProvider, this.onDataChanged}) {
    // Adiciona os listeners para reagir a mudanças
    levelController.addListener(_handleDataChangeAndSave);
    powerProvider.addListener(
        recalculateAllStats); // Apenas recalcula, não salva
  }

  // Carrega os dados do Record para o provider, como antes
  void updateFromRecord(Record? record) {
    // Remove listeners para evitar recálculos durante o carregamento
    levelController.removeListener(_handleDataChangeAndSave);

    if (record != null) {
      levelController.text = record.characterLevel.toString();
      _selectedSkillNames = record.selectedSkills ?? [];
      // O arquétipo agora é lido do Record se existir
      activeArchetype = record.archetypeName;
    } else {
      levelController.text = '1';
      _selectedSkillNames = [];
      activeArchetype = null;
    }

    // Recalcula tudo com os novos dados
    recalculateAllStats();

    // Readiciona o listener
    levelController.addListener(_handleDataChangeAndSave);
  }

  // Esta função agora lida com MUDANÇAS e SALVAMENTO
  void _handleDataChangeAndSave() {
    // Primeiro, recalcula tudo para que `activeArchetype` seja atualizado
    recalculateAllStats();

    // Depois, notifica o RecordProvider para salvar os dados no disco
    onDataChanged?.call(
      characterLevel: level,
      archetypeName: activeArchetype, // Salva o arquétipo que foi calculado
      selectedSkills: _selectedSkillNames,
    );
  }

  // toggleSkill permanece simples: muda o dado e chama a função que salva
  void toggleSkill(String skillName) {
    if (_selectedSkillNames.contains(skillName)) {
      _selectedSkillNames.remove(skillName);
    } else {
      _selectedSkillNames.add(skillName);
    }
    // Chama a função centralizada que recalcula e salva
    _handleDataChangeAndSave();
  }

  bool isSkillSelected(String skillName) {
    return _selectedSkillNames.contains(skillName);
  }

  // SUA FUNÇÃO DE CÁLCULO É 100% RESTAURADA E PRESERVADA
  void recalculateAllStats() {
    activeArchetype = null; // Reseta para recalcular
    lifeBase = 0;
    skillPointPerLevel = 0;
    baseXp = 0;
    baseAttributePoints = 2;
    baseMana = 0;

    // Sua lógica original para encontrar o arquétipo
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

    // Sua lógica original para preencher as variáveis a partir do arquétipo
    if (activeArchetype != null) {
      final archetypeData = allArchetypes.firstWhere((arch) =>
      arch.name == activeArchetype);
      lifeBase = archetypeData.baseHp * level;
      skillPointPerLevel = archetypeData.skillPointsPerLevel * level;
      baseXp = archetypeData.baseXp * level;
      baseAttributePoints = archetypeData.attributePoints * level + 2;
      baseMana = archetypeData.mana * level;
    }

    // Sua lógica original para aplicar os efeitos das skills
    for (String skillName in _selectedSkillNames) {
      if (skillName == 'Prodígio') {
        baseXp = 125 * level;
      }
      if (skillName == 'Muralha') {
        lifeBase = (lifeBase + 30) * 10;
      }
    }

    // Sua lógica original para atualizar os controllers
    manaController.text = baseMana.toString();
    int currentXp = baseXp - powerProvider.totalPowersCost;
    xpController.text = currentXp.toString();

    // Notifica a UI e outros providers (como o AttributesProvider) que os valores foram recalculados
    notifyListeners();
  }

  @override
  void dispose() {
    // Remove todos os listeners adicionados
    levelController.removeListener(_handleDataChangeAndSave);
    powerProvider.removeListener(recalculateAllStats);

    levelController.dispose();
    xpController.dispose();
    manaController.dispose();
    super.dispose();
  }
}