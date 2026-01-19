import 'package:fichas/common/drawer.dart';
import 'package:fichas/models/passive_card_widget.dart';
import 'package:fichas/models/minion_card_widget.dart';
import 'package:fichas/state_management/passives_provider.dart';
import 'package:fichas/state_management/minions_provider.dart';
import 'package:fichas/state_management/record_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PassivesScreen1 extends StatelessWidget {
  const PassivesScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final recordProvider = context.read<RecordProvider>();
    final passivesProvider = recordProvider.passivesProvider;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: const Text(
          'Passivas, Armas e Minions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              passivesProvider.addNewCard();
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
                "Adicionar Passiva", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
          TextButton.icon(
            onPressed: () => recordProvider.minionsProvider.addNewMinion(),
            icon: const Icon(Icons.person_add, color: Colors.white),
            label: const Text(
                "Adicionar Minion", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("PASSIVAS", style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
            ),
            SizedBox(
              height: 410,
              child: Consumer<RecordProvider>(
                builder: (context, record, child) {
                  return ChangeNotifierProvider.value(
                    value: record.passivesProvider,
                    child: Consumer<PassivesProvider>(
                      builder: (context, passiveProv, child) {
                        final cards = passiveProv.cards;
                        if (cards.isEmpty) {
                          return const Center(child: Text(
                              "Nenhuma passiva adicionada...",
                              style: TextStyle(color: Colors.white54)));
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: cards.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: PassiveCardWidget(cardModel: cards[index]),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.purpleAccent, height: 40, thickness: 2),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("MINIONS", style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
            ),
            SizedBox(
              height: 400,
              child: Consumer<RecordProvider>(
                builder: (context, record, child) {
                  return ChangeNotifierProvider.value(
                    value: record.minionsProvider,
                    child: Consumer<MinionsProvider>(
                      builder: (context, minionProv, child) {
                        final minions = minionProv.minions;
                        if (minions.isEmpty) {
                          return const Center(child: Text(
                              "Nenhum minion adicionado...",
                              style: TextStyle(color: Colors.white54)));
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: minions.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: Center(child: MinionCardWidget(
                                  minion: minions[index])),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}