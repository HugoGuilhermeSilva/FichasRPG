import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fichas/common/attribute_fields.dart';
import 'package:fichas/state_management/attributes_provider.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AttributesProvider(),
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text("Ficha"),
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 8,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.deepPurple,
                  ),
                  borderRadius: BorderRadius.circular(16)
                ),
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
                              base: provider.baseControllers[name]!,
                              bonus: provider.bonusControllers[name]!,
                              total: provider.getTotalFor(name),
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
      ),
    );
  }
}