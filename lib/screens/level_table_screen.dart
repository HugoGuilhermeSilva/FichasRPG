import 'package:fichas/common/drawer.dart';
import 'package:flutter/material.dart';

class LevelTable extends StatelessWidget{
  const LevelTable({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Tabela de Nível',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple[900],
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text('Nível\n'
              '1-Vantagem, Arquétipo, Passiva, Ponto de Feitiço\n'
              '2-\n'
              '3-Vantagem\n'
              '4-\n'
              '5-Ponto de Feitiço, Vantagem\n'
              '6-\n'
              '7-Vantagem\n'
              '8-Arquétipo\n'
              '9-Vantagem\n'
              '10-Passiva 2, Ponto de Feitiço, Vantagem\n'
              '11-Vantagem\n'
              '12-\n'
              '13-Vantagem\n'
              '14-\n'
              '15-Ponto de Feitiço\n'
              '16-Arquétipo, Vantagem\n'
              '17-\n'
              '18-Vantagem\n'
              '19-\n'
              '20-Passiva 3, Ponto de Feitiço, Vantagem\n'
              '21-\n'
              '22-Vantagem\n'
              '23-\n'
              '24-Arquétipo, Vantagem\n'
              '25-Ponto de Feitiço\n'
              '26-Vantagem\n'
              '27-\n'
              '28-Vantagem\n'
              '29-\n'
              '30-Ponto de Feitiço, Vantagem\n'
              '31-\n'
              '32-Arquétipo, Vantagem\n'
              '33-\n'
              '34-Vantagem\n'
              '35-Ponto de Feitiço\n'
              '36-Vantagem\n'
              '37-\n'
              '38-Vantagem\n'
              '39-\n'
              '40-3 Pontos de Feitiço, Vantagem\n',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}