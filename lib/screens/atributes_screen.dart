
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
            onChanged: calculator.setBaseAttribute,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Nível"),
            keyboardType: TextInputType.number,
            onChanged: calculator.setLevel,
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => calculator.addModifier(4),
            child: const Text("Adicionar arma (+4)"),
          ),
          ElevatedButton(
            onPressed: () => calculator.removeModifier(4),
            child: const Text("Remover arma (+4)"),
          ),
        ],
      ),
    );
  }
}