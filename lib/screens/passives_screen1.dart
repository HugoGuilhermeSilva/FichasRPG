import 'package:fichas/common/drawer.dart';
import 'package:fichas/models/passive_card_widget.dart'; // Importe seu widget de Card
import 'package:fichas/state_management/passives_provider.dart';
import 'package:fichas/state_management/record_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PassivesScreen1 extends StatelessWidget {
  const PassivesScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessamos o provider central para chamar as funções de criação
    final recordProvider = context.read<RecordProvider>();
    final passivesProvider = recordProvider.passivesProvider;

    return Scaffold(
      backgroundColor: Colors.grey[900], // Fundo cinza escuro conforme pedido
      drawer: const MyDrawer(), // Drawer vazio solicitado
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent, // AppBar PurpleAccent
        title: const Text(
          'Passivas, Armas e Minions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Botão Adicionar Passiva
          TextButton.icon(
            onPressed: () {
              print("Tentando adicionar card...");
              passivesProvider.addNewCard();
              print("Cards agora: ${passivesProvider.cards.length}");
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Adicionar Passiva",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          // Botão Adicionar Minion (Mecânica futura)
          TextButton.icon(
            onPressed: () {
              // Mecânica de minion faremos depois
              debugPrint("Adicionar Minion pressionado");
            },
            icon: const Icon(Icons.person_add, color: Colors.white),
            label: const Text(
              "Adicionar Minion",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
        body: Consumer<RecordProvider>(
            builder: (context, record, child) {
              return ChangeNotifierProvider.value(
                value: record.passivesProvider,
                child: Consumer<PassivesProvider>(
                  builder: (context, passiveProv, child) {
                    final cards = passiveProv.cards;
                    if (cards.isEmpty) {
                      return const Center(child: Text("Nenhuma passiva adicionada..."));
                    }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return PassiveCardWidget(cardModel: cards[index]);
            },
          );
        },
      ),
    );
  }));
}
}