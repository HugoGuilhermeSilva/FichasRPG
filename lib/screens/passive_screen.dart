import 'package:fichas/common/passive_widget.dart';
import 'package:flutter/material.dart';

class PassiveScreen extends StatelessWidget {
  const PassiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(title: const Text('Passivas', style:  TextStyle(color: Colors.white),), backgroundColor: Colors.deepPurple,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Habilidade'),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.grey[800]),
                  foregroundColor: WidgetStateProperty.all(Colors.white)
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Lista de cards
            Expanded(
              child: ListView.builder(
                itemCount: 3, // temporário
                itemBuilder: (context, index) {
                  return SkillCard(
                    onRemove: () {
                      // aqui virá a lógica futura de remoção
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
