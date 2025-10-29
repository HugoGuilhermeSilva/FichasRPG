import 'package:fichas/screens/archetype_screen.dart';
import 'package:fichas/screens/power_list_screen.dart';
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
              leading: const Icon(Icons.home, color: Colors.white,),
              title: const Text('Ficha', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RecordScreen())
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white,),
              title: const Text('Arquetipos', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ArchetypeScreen())
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white,),
              title: const Text('Poderes', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PowerScreen())
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}