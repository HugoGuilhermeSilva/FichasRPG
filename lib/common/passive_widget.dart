import 'package:flutter/material.dart';

class SkillCard extends StatelessWidget {
  final VoidCallback? onRemove;

  const SkillCard({super.key, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome da habilidade
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: 'Nome da Habilidade',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            // Descrição
            TextField(
              maxLines: 12,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8),

            // Escolher atributo e valor
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Atributo',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'vida', child: Text('Vida', style: TextStyle(color: Colors.white),)),
                      DropdownMenuItem(value: 'força', child: Text('Força')),
                      DropdownMenuItem(value: 'defesa', child: Text('Defesa')),
                    ],
                    onChanged: (_) {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Valor',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Botão de remoção
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Remover'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
