import 'package:fichas/common/drawer.dart';
import 'package:fichas/state_management/record_provider.dart';
import 'package:flutter/material.dart';
import 'package:fichas/models/advantages_widget.dart';
import 'package:fichas/data/advantages_data.dart';
import 'package:provider/provider.dart';
class AdvantagesScreen extends StatefulWidget {
  const AdvantagesScreen({super.key});

  @override
  State<AdvantagesScreen> createState() => _AdvantagesScreenState();
}

class _AdvantagesScreenState extends State<AdvantagesScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final recordProvider = Provider.of<RecordProvider>(context);
    final advantagesProvider = recordProvider.advantagesProvider;
    final characterProvider = recordProvider.characterProvider;
    final filteredAdvantages = allAdvantages.where((a) {
      return a.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          a.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
    final List<Advantage> selected = filteredAdvantages.where((a) => advantagesProvider.isAdvantageSelected(a.name)).toList();
    final List<Advantage> general = filteredAdvantages.where((a) => !advantagesProvider.isAdvantageSelected(a.name)).toList();
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Vantagens',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple[900],
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Pesquisar vantagem...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(
                      Icons.search, color: Colors.purpleAccent),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.purpleAccent),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 275,
                  height: 55,
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
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Vantagens Extras:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: TextField(
                                controller: characterProvider
                                    .extraControllers['vantagensExtra'],
                                decoration: const InputDecoration(
                                  isCollapsed: true,
                                  hintText: '0',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.white24),
                                  contentPadding:
                                  EdgeInsets.symmetric(vertical: 12.5),
                                ),
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 300,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.purpleAccent, width: 2),
                        borderRadius: BorderRadius.circular(8)),
                    color: Colors.black,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        'Disponível = ${(((characterProvider
                            .advantagesAvailable + characterProvider
                            .bonusAdvantages) -
                            advantagesProvider.selectedAdvantages.length))}',
                        style:
                        const TextStyle(color: Colors.white, fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (selected.isNotEmpty) ...[
              const Text('Selecionadas',
                  style: TextStyle(color: Colors.white, fontSize: 22)),
              Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: selected
                      .map((advantage) =>
                      AdvantagesCards(
                        name: advantage.name,
                        description: advantage.description,
                        selected: true,
                        onChanged: (val) {
                          advantagesProvider.toggleAdvantageSelection(
                              advantage.name, false);
                        },
                      ))
                      .toList()),
              const Divider(color: Colors.white),
            ],
            const Text('Todas',
                style: TextStyle(color: Colors.white, fontSize: 22)),
            Wrap(
                spacing: 4,
                runSpacing: 4,
                children: general
                    .map((advantage) =>
                    AdvantagesCards(
                      name: advantage.name,
                      description: advantage.description,
                      selected: false,
                      onChanged: (val) {
                        advantagesProvider.toggleAdvantageSelection(
                            advantage.name, true);
                      },
                    ))
                    .toList()),
          ],
        ),
      ),
    );
  }
}