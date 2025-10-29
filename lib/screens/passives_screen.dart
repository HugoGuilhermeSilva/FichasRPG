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
      drawer: const MyDrawer(),
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Passivas, Armas e Anotações"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: passivesController,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration(
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
    );
  }
}