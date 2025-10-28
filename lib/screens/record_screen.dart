import 'package:fichas/state_management/character_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fichas/common/attribute_fields.dart';
import 'package:fichas/common/expertise_fields.dart';
import 'package:fichas/state_management/attributes_provider.dart';
import 'package:fichas/data/attribute_and_expertise_data.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Ficha"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================== COLUNA DA ESQUERDA ==================
            Expanded(
              child: Column(
                // Diz para a coluna ocupar apenas o espaço vertical necessário.
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- Card de Atributos ---
                  Card(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Consumer<AttributesProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            // Tenta encolher para caber o conteúdo.
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Atributos", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              // Usando um 'for' loop em vez de .map
                              for (final name in attributeNames)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0),
                                  child: AttributeFields(
                                    name: name,
                                    base: provider.baseControllers[name]!,
                                    bonus: provider.bonusControllers[name]!,
                                    total: provider
                                        .attributeTotalControllers[name]!,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // --- Card de Perícias ---
                  Card(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Consumer<AttributesProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Perícias", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              for (final name in expertiseNames)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0),
                                  child: ExpertiseFields(
                                    name: name,
                                    bonus: provider
                                        .expertiseBonusControllers[name]!,
                                    total: provider
                                        .expertiseTotalControllers[name]!,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // ================== COLUNA DA DIREITA ==================
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- Card de Status Gerais ---
                  Card(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: context
                                .read<CharacterProvider>()
                                .levelController,
                            decoration: const InputDecoration(
                                labelText: 'Nível Atual'),
                            style: const TextStyle(color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: context
                                .read<AttributesProvider>()
                                .remainingAttributesController,
                            // Mantido como você confirmou
                            readOnly: true,
                            decoration: const InputDecoration(
                                labelText: 'Pontos de Atributo Disponíveis'),
                            style: const TextStyle(
                                color: Colors.green, // Cor para diferenciar
                                fontSize: 20, // Tamanho ligeiramente menor
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: context
                                .read<AttributesProvider>()
                                .remainingExpertisePointsController,
                            readOnly: true,
                            decoration: const InputDecoration(
                                labelText: 'Pontos de Perícia Disponíveis'),
                            style: const TextStyle(color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // --- Card de Valores de Combate ---
                  Card(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Consumer<AttributesProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Valores de Combate", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              for (final name in combatValue)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0),
                                  child: ExpertiseFields(
                                    name: name,
                                    bonus: provider
                                        .combatBonusControllers[name]!,
                                    total: provider
                                        .combatTotalControllers[name]!,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
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