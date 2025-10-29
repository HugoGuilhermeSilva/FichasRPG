import 'package:fichas/data/power_model.dart';
import 'package:fichas/state_management/power_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PowerCard extends StatelessWidget {
  final Power power;

  const PowerCard({
    super.key,
    required this.power,
  });

  @override
  Widget build(BuildContext context) {
    final powerProvider = context.watch<PowerProvider>();
    final isSelected = powerProvider.isPowerSelected(power.name);
    final powerLevel = powerProvider.getPowerLevel(power.name);

    return Card(
      shape:  RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected ? Colors.purpleAccent : Colors.deepPurple,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8)
      ),
      color: Colors.black,
      elevation: 4,
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (bool? value) {
                    powerProvider.togglePowerSelection(
                        power.name, value ?? false);
                  },
                  activeColor: Colors.deepPurple,
                ),
                Expanded(
                  child: Text(
                    power.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'Custo: ${power.cost} XP',
                  style: const TextStyle(color: Colors.amber, fontSize: 14),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 4),
              child: Text(
                power.description,
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ),
            if (isSelected && power.stackable)
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 16.0),
                child: Row(
                  children: [
                    const Text('Graus:',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                          Icons.remove_circle, color: Colors.redAccent),
                      onPressed: () =>
                          powerProvider.decrementPowerLevel(power.name),
                    ),
                    Text(
                      '$powerLevel',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(
                          Icons.add_circle, color: Colors.greenAccent),
                      onPressed: () =>
                          powerProvider.incrementPowerLevel(power.name),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}