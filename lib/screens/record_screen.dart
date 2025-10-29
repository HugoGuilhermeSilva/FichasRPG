import 'package:fichas/common/expertise_fields.dart';
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
        child: Wrap(
          children: [
            Column(
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
        ]
        ),
      ),
    );
  }
}