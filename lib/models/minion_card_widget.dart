import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fichas/state_management/minions_provider.dart';

class MinionCardWidget extends StatelessWidget {
  final MinionModel minion;

  const MinionCardWidget({super.key, required this.minion});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.deepPurple, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: minion.nameController,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            decoration: const InputDecoration(hintText: "Nome do Minion",
                hintStyle: TextStyle(color: Colors.white24)),
          ),
          const SizedBox(height: 15),
          _buildRow("Acerto", minion.hitController),
          _buildRow("Bloqueio / Esquiva", minion.defenseController),
          _buildRow("Vida", minion.maxHealthController, onChanged: (_) => context.read<MinionsProvider>().refresh()),
          _buildRow("Dano Recebido", minion.damageReceivedController, onChanged: (_) => context.read<MinionsProvider>().refresh()),
          const Divider(color: Colors.deepPurple),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Vida Atual", style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "${minion.currentHealth}",
                  style: TextStyle(
                    color: minion.currentHealth <= 0 ? Colors.red : Colors
                        .greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
              onPressed: () =>
                  context.read<MinionsProvider>().removeMinion(minion.id),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow(String label, TextEditingController controller,
      {Function(String)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            width: 60,
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}