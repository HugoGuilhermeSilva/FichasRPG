import 'package:fichas/common/drawer.dart';
import 'package:fichas/data/power_model.dart';
import 'package:fichas/state_management/record_provider.dart';
import 'package:flutter/material.dart';
import 'package:fichas/data/power_list.dart';
import 'package:provider/provider.dart';
import 'package:fichas/models/power_box_widget.dart';

class PowerScreen extends StatefulWidget {
  const PowerScreen({super.key});

  @override
  State<PowerScreen> createState() => _PowerScreenState();
}

class _PowerScreenState extends State<PowerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  @override
  Widget build(BuildContext context) {
    final recordProvider = context.watch<RecordProvider>();
    final powerProvider = recordProvider.powerProvider;
    final characterProvider = recordProvider.characterProvider;
    final List<Power> selectedPowersUI = [];
    final List<Power> generalPowersUI = [];
    final filteredPowers = allPowers.where((power){
      return power.name.toLowerCase().contains(_searchQuery.toLowerCase());
    });
    for (var power in filteredPowers) {
      final playerLevel = powerProvider.selectedPowers[power.name] ?? 0;
      final bonusArchetypeLevel = powerProvider.skillArchetypeBonuses[power.name] ?? 0;
      final bonusPowerLevel = powerProvider.powerInteractionsBonuses[power.name] ?? 0;
      final bonusPowerPassive = powerProvider.passivesPowerBonus[power.name] ?? 0;

      if (playerLevel > 0 || bonusArchetypeLevel > 0 || bonusPowerLevel > 0 || bonusPowerPassive > 0) {
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Pesquisar poder...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.purpleAccent),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.purpleAccent),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  Spacer(),
                  SizedBox(
                    width: 200,
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
                              'Xp Extra:',
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
                                  controller: characterProvider.extraControllers['xpExtra'],
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    hintText: '0',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.white24),
                                    contentPadding: EdgeInsets.symmetric(vertical: 12.5),
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
                  SizedBox(width: 8,),
                  SizedBox(
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
                ],
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