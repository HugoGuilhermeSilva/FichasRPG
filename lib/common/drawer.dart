import 'package:fichas/screens/advantagens_screen.dart';
import 'package:fichas/screens/archetype_screen.dart';
import 'package:fichas/screens/note_screen.dart';
import 'package:fichas/screens/passives_screen1.dart';
import 'package:fichas/screens/power_screen.dart';
import 'package:fichas/screens/record_screen.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget{
  const MyDrawer ({super.key});
  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple
              ),
              child: Text('Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),),
            ),
            ListTile(
              title: const Text('Ficha', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RecordScreen())
                );
              },
            ),
            ListTile(
              title: const Text('Arquetipos', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ArchetypeScreen())
                );
              },
            ),
            ListTile(
              title: const Text('Poderes', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PowerScreen())
                );
              },
            ),
            ListTile(
              title: const Text('Vantagens', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdvantagesScreen())
                );
              },
            ),
            ListTile(
              title: const Text('Passivas, Armas e Minions', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PassivesScreen1())
                );
              },
            ),
            ListTile(
              title: const Text('Anotações', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PassivesScreen())
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}