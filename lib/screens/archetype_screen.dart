import 'package:fichas/common/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fichas/models/archetype_widget.dart';
import 'package:fichas/data/archetype_data.dart';
import 'package:fichas/state_management/character_provider.dart';

class ArchetypeScreen extends StatelessWidget{
  const ArchetypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final characterProvider = context.watch<CharacterProvider>();
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Arquetipos',
          style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold
          ),),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.deepPurple),
              borderRadius: BorderRadius.circular(2),
              color: Colors.grey[900]
          ),
          height: 1300,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: allArchetypes.map((archetype){
                return Column(
                  children: [
                    ArchetypeHeader(
                      title: archetype.name,
                      level: '1',
                      archetypeDescription:
                      'Pontos de Perícia: ${archetype.skillPointsPerLevel} por nível\n'
                          'Vida Base: ${archetype.baseHp}\n'
                          '${archetype.description}',
                    ),
                    ..._buildSkillsWithLevelHeaders(archetype.skills, characterProvider),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
  List<Widget> _buildSkillsWithLevelHeaders(List<Skill> skills, CharacterProvider provider) {
    final List<Widget> widgets = [];
    int? currentLevel;
    final List<Skill> sortableSkills = skills.toList();
    sortableSkills.sort((a, b) => a.levelRequirement.compareTo(b.levelRequirement));

    for (final skill in sortableSkills) {
      if (skill.levelRequirement != currentLevel && skill.levelRequirement > 1) {
        widgets.add(ArchetypeHeader(level: skill.levelRequirement.toString()));
        currentLevel = skill.levelRequirement;
      }
      widgets.add(ArchetypeCard(
        name: skill.name,
        description: skill.description,
        selected: provider.isSkillSelected(skill.name),
        onChanged: (_) {
          provider.toggleSkill(skill.name);
        },
      ));
    }
    return widgets;
  }
}