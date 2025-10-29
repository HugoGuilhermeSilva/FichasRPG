import 'package:fichas/common/expertise_fields.dart';
import 'package:fichas/state_management/character_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fichas/common/attribute_fields.dart';
import 'package:fichas/state_management/attributes_provider.dart';
import 'package:fichas/data/attribute_and_expertise_data.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Column(
            children: [
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
                child: Padding(padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextField(
                      controller: context.read<CharacterProvider>().levelController,
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
                    Consumer<AttributesProvider>(
                      builder: (context, provider, consumerChild){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [

                          ],
                        );
                      }
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