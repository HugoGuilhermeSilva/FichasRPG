import 'package:fichas/common/drawer.dart';
import 'package:flutter/material.dart';

class PassivesScreen extends StatefulWidget{
  const PassivesScreen({super.key});
  @override
  State<PassivesScreen> createState() => _PassivesScreenState();
}

class _PassivesScreenState extends State<PassivesScreen>{
  final TextEditingController passivesController = TextEditingController();
  @override
  void initState(){
    passivesController.addListener((){});
    super.initState();
  }
  @override
  void dispose(){
    passivesController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Passivas, Armas e Anotações"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: TextField(
            maxLines: 100,
            controller: passivesController,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.deepPurple,
                      width: 2
                  )
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.purpleAccent,
                      width: 3
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }
}