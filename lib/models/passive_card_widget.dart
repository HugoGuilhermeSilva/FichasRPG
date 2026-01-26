import 'package:fichas/data/advantages_data.dart';
import 'package:fichas/data/attribute_and_expertise_data.dart';
import 'package:fichas/data/power_list.dart';
import 'package:fichas/state_management/character_provider.dart';
import 'package:fichas/state_management/passives_provider.dart';
import 'package:fichas/state_management/record_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PassiveCardWidget extends StatelessWidget {
  final CharacterProvider characterProvider;
  final PassiveCardModel cardModel;

  const PassiveCardWidget({
    super.key,
    required this.cardModel,
    required this.characterProvider
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<RecordProvider>().passivesProvider;
    return SizedBox(
      width: 500,
      height: 400,
      child: Card(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.deepPurpleAccent, width: 2.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: TextField(
                        controller: cardModel.titleController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Nome da Passiva',
                          labelStyle: TextStyle(
                              color: Colors.deepPurple, fontWeight: FontWeight.bold),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                              color: Colors.deepPurple, width: 2)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                              color: Colors.purpleAccent, width: 3)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.redAccent),
                    onPressed: () => provider.removeCard(cardModel.id),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: cardModel.descController,
                  textAlign: TextAlign.start,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.bold),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                        color: Colors.deepPurple, width: 2)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                        color: Colors.purpleAccent, width: 3)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Bônus da Passiva",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      provider.addNewPassiveLine(cardModel.id);
                    },
                    icon: const Icon(
                        Icons.add_circle, color: Colors.deepPurpleAccent,
                        size: 30),
                  ),
                ],
              ),
              const Divider(color: Colors.deepPurpleAccent),
              Expanded(
                flex: 3,
                child: Consumer<RecordProvider>(
                  builder: (context, record, child) {
                    final currentCard = record.passivesProvider.cards.firstWhere((c) => c.id == cardModel.id);
                    return ListView.builder(
                      itemCount: currentCard.bonusEntries.length,
                      itemBuilder: (context, index) {
                        return PassiveBonusRowWidget(
                            characterProvider: characterProvider,
                            cardId: cardModel.id,
                            entry: currentCard.bonusEntries[index]
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PassiveBonusRowWidget extends StatelessWidget {
  final CharacterProvider characterProvider;
  final String cardId;
  final PassiveEntry entry;

  const PassiveBonusRowWidget(
      {super.key, required this.cardId, required this.entry, required this.characterProvider});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<RecordProvider>().passivesProvider;

    final allPowerNames = allPowers.map((p) => p.name).toList();
    final allAdvantageNames = allAdvantages.map((a) => a.name).toList();
    final List<String> allAttrSkillCombat = [
      ...attributeNames,
      ...combatValue,
      ...expertiseNames
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.black,
                  value: entry.selectedAttributeOrSkill,
                  hint: const Text("Atributos/Pericias/Combate",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                    ),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  items: allAttrSkillCombat.map((name) =>
                      DropdownMenuItem(value: name, child: Text(name))).toList(),
                  onChanged: (val) =>
                      provider.selectAttributeOrSkill(cardId, entry.id, val!),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.black,
                  value: entry.selectedPower,
                  hint: const Text("Poderes",
                      style: TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center,),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  items: allPowerNames
                      .map((name) =>
                      DropdownMenuItem(value: name,
                          child: Text(name, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (val) => provider.selectPower(cardId, entry.id, val!),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.black,
                  value: entry.selectedAdvantage,
                  hint: const Text("Vantagens",
                      style: TextStyle(color: Colors.white, fontSize: 10),textAlign: TextAlign.center,),
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                  items: allAdvantageNames
                      .map((name) =>
                      DropdownMenuItem(value: name,
                          child: Text(name, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (val) =>
                      provider.selectAdvantage(cardId, entry.id, val!),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: Tooltip(
              message: 'Tabela de Nível:\n'
                  'Nível Atual = ${characterProvider.level.toString()}\n'
                  "1/2 do nível = ${characterProvider.metLevel.toString()}\n"
                  "1/3 do nível = ${characterProvider.tercLevel.toString()}\n"
                  "1/4 do nível = ${characterProvider.quartLevel.toString()}\n"
                  "1/5 do nível = ${characterProvider.quintLevel.toString()}\n",
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              child: TextField(
                controller: entry.controller,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white,
                    fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                    labelText: 'Bonus',
                    labelStyle: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 3
                        )
                    )
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
                Icons.remove_circle, color: Colors.redAccent, size: 20),
            onPressed: () => provider.removePassiveLine(cardId, entry.id),
          )
        ],
      ),
    );
  }
}