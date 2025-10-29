import 'package:fichas/common/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fichas/models/advantages_widget.dart';
import 'package:fichas/data/advantages_data.dart';
import 'package:fichas/state_management/character_provider.dart';
import 'package:provider/provider.dart';

class AdvantagesScreen extends StatefulWidget{
  const AdvantagesScreen({super.key});
  @override
  State<AdvantagesScreen> createState() => _AdvantagesScreenState();
}
class _AdvantagesScreenState extends State<AdvantagesScreen>{
  @override
  Widget build(BuildContext context){
    final selected = allAdvantages.where((a) => a.selected).toList();
    final general = allAdvantages.where((a) => !a.selected).toList();

    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: Text('Vantagens', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),backgroundColor: Colors.deepPurple[900],),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<CharacterProvider>(
              builder: (context, provider, consumerChild){
              return SizedBox(
                width: 350,
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
                          'Quantidade disponivel = ${((provider.level / 2) - (selected.length)).round()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }),
              );
              }
            ),
            Text('Selecionadas', style: TextStyle( color: Colors.white, fontSize: 22),),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: selected.map((a) =>
              AdvantagesCards(
                name: a.name,
                description: a.description,
                selected: a.selected,
                onChanged: (val){
                  setState(() => a.selected = val ?? false);
                },
              )
            ).toList()
            ),
            Divider(color: Colors.white,),
            Text('Todas', style: TextStyle(color: Colors.white, fontSize: 22),),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: general.map((a) =>
                AdvantagesCards(
                  name: a.name,
                  description: a.description,
                  selected: a.selected,
                  onChanged: (val){
                    setState(() => a.selected = val ?? false);
                  } ,
                )
              ).toList()
            ),
          ],
        ),
      ),
    );
  }
}