import 'package:fichas/common/drawer.dart';
import 'package:fichas/services/sotrage_Service.dart';
import 'package:flutter/material.dart';

class PassivesScreen extends StatefulWidget{
  const PassivesScreen({super.key});
  @override
  State<PassivesScreen> createState() => _PassivesScreenState();
}

class _PassivesScreenState extends State<PassivesScreen>{
  final TextEditingController passivesController = TextEditingController();
  final StorageService _storageService = StorageService();
  @override
  void initState(){
    passivesController.addListener((){});
    passivesController.addListener(_saveNotes);
    super.initState();
    _loadNotes();
  }
  Future<void> _loadNotes() async {
    final loadedNotes = await _storageService.loadString('passives_notes');
    if (loadedNotes != null) {
      passivesController.text = loadedNotes;
    }
  }
  Future<void> _saveNotes() async {
    await _storageService.saveString('passives_notes', passivesController.text);
  }
  @override
  void dispose(){
    passivesController.dispose();
    passivesController.removeListener(_saveNotes);
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