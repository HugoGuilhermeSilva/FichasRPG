import 'package:fichas/common/drawer.dart';
import 'package:fichas/data/power_model.dart';
import 'package:fichas/state_management/character_provider.dart';
import 'package:fichas/state_management/power_provider.dart';
import 'package:flutter/material.dart';
import 'package:fichas/data/power_list.dart';
import 'package:provider/provider.dart';
import 'package:fichas/models/power_box_widget.dart';

class PowerScreen extends StatelessWidget {
  const PowerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PowerProvider>(
      builder: (context, powerProvider, child) {
        final List<Power> selected = [];
        final List<Power> general = [];

        for (var power in allPowers) {
          if (powerProvider.isPowerSelected(power.name)) {
            selected.add(power);
          } else {
            general.add(power);
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
                    child: Consumer<CharacterProvider>(
                        builder: (context, provider, consumerChild) {
                          return Card(
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
                                'XP Disponível = ${provider.xpController.text}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }),
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
                if (selected.isEmpty)
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
                  children: selected
                      .map((power) => PowerCard(power: power))
                      .toList(),
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
                  children: general
                      .map((power) => PowerCard(power: power))
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}