import 'package:fichas/common/drawer.dart';
import 'package:fichas/models/expertise_fields.dart';
import 'package:fichas/state_management/character_provider.dart';
import 'package:fichas/state_management/power_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fichas/models/attribute_fields.dart';
import 'package:fichas/state_management/attributes_provider.dart';
import 'package:fichas/data/attribute_and_expertise_data.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Ficha"),
        backgroundColor: Colors.deepPurple,
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
                    child: Consumer<AttributesProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          children: attributeNames.map((name) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: AttributeFields(
                                name: name,
                                base: provider.baseControllers[name] ??
                                    TextEditingController(),
                                bonus: provider.bonusControllers[name] ??
                                    TextEditingController(),
                                total: provider.getAttributeTotalFor(name),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
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
                  height: 1400,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Consumer<AttributesProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          children: expertiseNames.map((name) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ExpertiseFields(
                                name: name,
                                bonus: provider.expertiseBonusControllers[name] ??
                                    TextEditingController(),
                                total: provider.getExpertiseTotalFor(name),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ],
              ),
            ),
          SizedBox(width: 8,),
          Column(
            children: [
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
                height: 800,
                child: Padding(padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: context.read<CharacterProvider>().levelController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Nivel Atual',
                              labelStyle: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 2
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purpleAccent,
                                  width: 3
                                )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2,),
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: context.read<AttributesProvider>().remainingAttributesController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Pontos de Atributo',
                              labelStyle: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 2
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purpleAccent,
                                  width: 3
                                )
                              ),
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
                            controller: context.read<AttributesProvider>().remainingExpertisePointsController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Pontos de Pericia',
                              labelStyle: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 2
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purpleAccent,
                                  width: 3
                                )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2,),
                        Expanded(
                          child: Consumer<AttributesProvider>(
                            builder: (context, provider, _) {
                              return TextField(
                                readOnly: true,
                                controller: TextEditingController(
                                  text: provider.currentLife.toString(),
                                ),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Vida Atual',
                                  labelStyle: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.deepPurple,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.purpleAccent,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              );
                            },
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
                            controller: context.read<AttributesProvider>().initiativeController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Iniciativa',
                              labelStyle: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple,
                                      width: 2
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.purpleAccent,
                                      width: 3
                                  )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2,),
                        Expanded(
                          child: TextField(
                            controller: context.read<AttributesProvider>().lostLifeController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Dano Recebido',
                              labelStyle: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple,
                                      width: 2
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.purpleAccent,
                                      width: 3
                                  )
                              ),
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
                            controller: context.read<CharacterProvider>().manaController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Mana total',
                              labelStyle: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 2
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purpleAccent,
                                  width: 3
                                )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2,),
                        Expanded(
                          child: TextField(
                            controller: context.read<PowerProvider>().displacementController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Deslocamento',
                              labelStyle: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple,
                                      width: 2
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.purpleAccent,
                                      width: 3
                                  )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Consumer<AttributesProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          children: combatValue.map((name) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ExpertiseFields(
                                name: name,
                                bonus: provider.combatBonusControllers[name] ??
                                    TextEditingController(),
                                total: provider.getCombatTotalFor(name),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                )
                ),
              )
            ],
          )
        ]
        ),
      ),
    );
  }
}