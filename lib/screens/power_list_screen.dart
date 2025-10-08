import 'package:flutter/material.dart';
import 'package:fichas/common/power_box_widget.dart';
import 'package:fichas/screens/power_list.dart';

class PowerScreen extends StatefulWidget {
  const PowerScreen({super.key});

  @override
  State<PowerScreen> createState() => _PowerScreenState();
}

class _PowerScreenState extends State<PowerScreen> {
  // Conversão dos dados em objetos Powers usando map()
  List<Powers> get allPowers => powersData.map((data) => Powers(
    name: data['name'] as String,
    description: data['description'] as String,
    cost: data['cost'] as int,
  )).toList();

  @override
  Widget build(BuildContext context) {
    final selected = allPowers.where((a) => a.selected).toList();
    final general = allPowers.where((a) => !a.selected).toList();

    return Scaffold(
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
        child: Column(
          children: [
            const Text(
              'Xp Disponivel = 0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
              textAlign: TextAlign.end,
            ),
            const Text(
              'Selecionados',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: selected.map((a) => PowerCards(
                name: a.name,
                cost: a.cost,
                description: a.description,
                selected: a.selected,
                onChanged: (val) {
                  setState(() => a.selected = val ?? false);
                },
              )).toList(),
            ),
            const Divider(color: Colors.white),
            const Text(
              'Todos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: general.map((a) => PowerCards(
                name: a.name,
                description: a.description,
                selected: a.selected,
                cost: a.cost,
                onChanged: (val) {
                  setState(() => a.selected = val ?? false);
                },
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}