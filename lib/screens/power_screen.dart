import 'package:fichas/common/drawer.dart';
import 'package:fichas/data/power_model.dart';
import 'package:fichas/state_management/record_provider.dart';
import 'package:flutter/material.dart';
import 'package:fichas/data/power_list.dart';
import 'package:provider/provider.dart';
import 'package:fichas/models/power_box_widget.dart';

class PowerScreen extends StatelessWidget {
  const PowerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recordProvider = context.watch<RecordProvider>();
    final powerProvider = recordProvider.powerProvider;
    final characterProvider = recordProvider.characterProvider;
    final List<Power> selectedPowersUI = [];
    final List<Power> generalPowersUI = [];
    for (var power in allPowers) {
      final playerLevel = powerProvider.selectedPowers[power.name] ?? 0;
      final bonusLevel = powerProvider.bonusPowers[power.name] ?? 0;

      if (playerLevel > 0 || bonusLevel > 0) {
        selectedPowersUI.add(power);
      } else {
        generalPowersUI.add(power);
      }
    }
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text(
          'Poderes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple[900],
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 300,
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.purpleAccent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                  color: Colors.black,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'XP Disponível = ${characterProvider.xpController.text}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            const Text(
              'Selecionados',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (selectedPowersUI.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Nenhum poder selecionado.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
             Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 4,
                children: selectedPowersUI.map((power) => PowerCard(power: power, powerProvider: powerProvider,)).toList(),
              ),
            const Divider(color: Colors.white, height: 40),
            const Text(
              'Todos os Poderes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 4,
              runSpacing: 4,
              children: generalPowersUI.map((power) => PowerCard(power: power, powerProvider: powerProvider,)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}