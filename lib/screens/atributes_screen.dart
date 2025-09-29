
import 'package:fichas/models/atributes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttributeScreen extends StatelessWidget{
  const AttributeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculator = context.read<AttributeCalculator>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(labelText: "Base do Atributo"),
            keyboardType: TextInputType.number,
            onChanged: null,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Nível"),
            keyboardType: TextInputType.number,
            onChanged: null,
          ),
          const SizedBox(height: 20),
          Consumer<AttributeCalculator>(
            builder: (context, calc, _) {
              return Text(
                "Total do Atributo: ${calc.attribute}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            },
          ),
        ],
      ),
    );
  }
}