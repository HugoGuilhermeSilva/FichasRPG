import 'package:fichas/common/drawer.dart';
import 'package:fichas/models/card_list_widget.dart';
import 'package:fichas/models/expertise_fields.dart';
import 'package:fichas/state_management/record_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fichas/models/attribute_fields.dart';
import 'package:fichas/data/attribute_and_expertise_data.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recordProvider = context.watch<RecordProvider>();
    final attributesProvider = recordProvider.attributesProvider;
    final characterProvider = recordProvider.characterProvider;
    final powerProvider = recordProvider.powerProvider;
    final advantagesProvider = recordProvider.advantagesProvider;

    return Scaffold(
      drawer: const MyDrawer(),
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: DropdownButton<String>(
          value: recordProvider.activeRecord?.id,
          hint: Text(
            recordProvider.activeRecord?.nameRecord ?? 'Crie uma ficha',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          isExpanded: true,
          underline: Container(),
          dropdownColor: Colors.deepPurple[800],
          style: const TextStyle(color: Colors.white, fontSize: 18),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          items: recordProvider.records.map((record) {
            return DropdownMenuItem<String>(
              value: record.id,
              child: Text(record.nameRecord),
            );
          }).toList(),
          onChanged: (recordId) {
            if (recordId != null) {
              recordProvider.selectedRecord(recordId);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Criar Nova Ficha',
            onPressed: () {
              _showCreateRecordDialog(context, recordProvider);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            tooltip: 'Deletar Ficha Ativa',
            onPressed: () {
              if (recordProvider.activeRecord != null) {
                _showDeleteRecordDialog(context, recordProvider);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.deepPurple,
                        ),
                        borderRadius: BorderRadius.circular(16)),
                    width: 410,
                    height: 600,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: attributeNames.map((name) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: AttributeFields(
                              name: name,
                              base: attributesProvider.baseControllers[name] ?? TextEditingController(),
                              bonus: attributesProvider.bonusControllers[name] ?? TextEditingController(),
                              total: attributesProvider.getAttributeTotalFor(name),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.deepPurple,
                        ),
                        borderRadius: BorderRadius.circular(16)),
                    width: 410,
                    height: 1400,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: expertiseNames.map((name) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ExpertiseFields(
                              name: name,
                              bonus: attributesProvider.expertiseBonusControllers[name] ?? TextEditingController(),
                              total: attributesProvider.getExpertiseTotalFor(name),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.deepPurple,
                        ),
                        borderRadius: BorderRadius.circular(16)),
                    width: 410,
                    height: 850,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: characterProvider.levelController,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: 'Nivel Atual',
                                    labelStyle: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple,
                                            width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.purpleAccent,
                                            width: 3)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  controller: attributesProvider.remainingAttributesController,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: 'Pontos de Atributo',
                                    labelStyle: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple,
                                            width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.purpleAccent,
                                            width: 3)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  controller: attributesProvider.remainingExpertisePointsController,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: 'Pontos de Pericia',
                                    labelStyle: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple,
                                            width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.purpleAccent,
                                            width: 3)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  key: ValueKey(attributesProvider.currentLife),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Vida Atual',
                                    hintText: attributesProvider.currentLife.toString(),
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelStyle: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.greenAccent,
                                            width: 2)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.greenAccent,
                                            width: 3)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8,),
                          Row(
                            children: [
                              Expanded(child: TextField(readOnly: true,
                                  controller: attributesProvider.initiativeController,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(
                                      labelText: 'Iniciativa',
                                      labelStyle: TextStyle(
                                          color: Colors.yellow,
                                          fontWeight: FontWeight.bold),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.yellow,
                                              width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.yellow,
                                              width: 3))))),
                              const SizedBox(width: 2,),
                              Expanded(child: TextField(
                                controller: attributesProvider.lostLifeController,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(
                                  labelText: 'Dano Recebido',
                                  labelStyle: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.redAccent,
                                        width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 3
                                      )
                                    )
                                )
                              )),
                            ],
                          ),
                          const SizedBox(height: 8,),
                          Row(
                            children: [
                              Expanded(child: TextField(
                                readOnly: true,
                                  controller: characterProvider.manaController,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(
                                      labelText: 'Mana total',
                                      labelStyle: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                              width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                              width: 3))))),
                              const SizedBox(width: 2,),
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  key: ValueKey(powerProvider.totalDisplacement),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Deslocamento | Alcance',
                                    hintText: '${powerProvider.totalDisplacement}m     |     ${powerProvider.rangeTotal}m',
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelStyle: const TextStyle(
                                      color: Colors.yellowAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.yellowAccent,
                                            width: 2)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.yellowAccent,
                                            width: 3)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  key: ValueKey(powerProvider.turnDamage),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Dano por turno',
                                    hintText: '${powerProvider.turnDamage}D${powerProvider.turnDamageDegree}',
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelStyle: const TextStyle(
                                      color: Colors.deepPurpleAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurpleAccent,
                                            width: 2)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurpleAccent,
                                            width: 3)),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2,),
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  key: ValueKey(powerProvider.defendLevel),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Defender',
                                    hintText: '${powerProvider.defendLevel} RD${powerProvider.rdLevel}',
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelStyle: const TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.brown,
                                            width: 2)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.brown,
                                            width: 3)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  key: ValueKey(powerProvider.totalDagame),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Dano',
                                    hintText: '${powerProvider.totalDagame.toString()}D${powerProvider.stepDamage.toString()}',
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelStyle: const TextStyle(
                                      color: Colors.purpleAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.purpleAccent,
                                            width: 2)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.purpleAccent,
                                            width: 3)),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2,),
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  key: ValueKey(powerProvider.baseDamage),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Dano Fixo',
                                    hintText: powerProvider.baseDamage.toString(),
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelStyle: const TextStyle(
                                      color: Colors.purpleAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.purpleAccent,
                                            width: 2)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.purpleAccent,
                                            width: 3)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  key: ValueKey(powerProvider.criticalMerge),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Critico',
                                    hintText: '${powerProvider.criticalMerge} X${powerProvider.criticalMultiplier}',
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelStyle: const TextStyle(
                                      color: Color(0xFFff6600),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFff6600),
                                            width: 2)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFff6600),
                                            width: 3)),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2,),
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  key: ValueKey(powerProvider.totalStrikes),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Ataques por turno',
                                    hintText: '${powerProvider.totalStrikes}',
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelStyle: const TextStyle(
                                      color: Colors.pink,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.pink,
                                            width: 2)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.pink,
                                            width: 3)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  key: ValueKey(powerProvider.totalHeal),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Graus de cura',
                                    hintText: '${powerProvider.totalHeal.toString()}D${powerProvider.stepHeal.toString()}',
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelStyle: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.greenAccent,
                                            width: 2)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.greenAccent,
                                            width: 3)),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2,),
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  key: ValueKey(powerProvider.baseHeal),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Cura fixa | Regeneração',
                                    hintText: '${powerProvider.baseHeal.toString()}        |        ${powerProvider.regenTotal}',
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelStyle: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.greenAccent,
                                            width: 2)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.greenAccent,
                                            width: 3)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              SizedBox(
                                width: 192,
                                height: 80,
                                child: CardListWidget(nameCard: 'Vantagens Selecionadas', isTile: true,),
                              ),
                              Spacer(),
                              SizedBox(
                                width: 192,
                                height: 80,
                                child: CardListWidget(nameCard: 'Poderes Comprados', isTile: true,),
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              SizedBox(
                                width: 192,
                                height: 280,
                                child: ListView(
                                  children: advantagesProvider.allSelectedAdvantages.map((nameAdvantage){
                                    final advantageDescription = advantagesProvider.getAdvantageDescription(nameAdvantage);
                                    return CardListWidget(
                                      nameCard: nameAdvantage,
                                      isNormal: true,
                                      description: advantageDescription,
                                    );
                                  }).toList(),
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                width: 192,
                                height: 280,
                                child: ListView(
                                  children: powerProvider.allActivePowerNames.where((powerName) {
                                    return powerProvider.getPowerLevel(powerName) > 0;
                                  }).map((powerName) {
                                    final powerLevel = powerProvider.getPowerLevel(powerName);
                                    return CardListWidget(
                                      nameCard: '$powerName\n(Graus: $powerLevel)',
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.deepPurple,
                        ),
                        borderRadius: BorderRadius.circular(16)),
                    width: 410,
                    height: 600,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: combatValue.map((name) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ExpertiseFields(
                              name: name,
                              bonus: attributesProvider.combatBonusControllers[name] ?? TextEditingController(),
                              total: attributesProvider.getCombatTotalFor(name),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showCreateRecordDialog(BuildContext context, RecordProvider provider) {
    final TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: const Text('Criar Nova Ficha'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Nome da Ficha'),
            onSubmitted: (value) {
              if (nameController.text.isNotEmpty) {
                provider.createNewRecord(name: nameController.text);
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Criar'),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  provider.createNewRecord(name: nameController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
  void _showDeleteRecordDialog(BuildContext context, RecordProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: const Text('Deletar Ficha?'),
          content: Text(
              'Quer deletar a ficha: "${provider.activeRecord!.nameRecord}"? Esta ação não pode ser desfeita.\nPow cara, me deleta n. '),
          actions: [
            TextButton(
              child: const Text('Cancelar <3'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Deletar T-T'),
              onPressed: () {
                provider.deleteRecord(provider.activeRecord!.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}