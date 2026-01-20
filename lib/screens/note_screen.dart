import 'package:fichas/common/drawer.dart';
import 'package:fichas/state_management/record_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PassivesScreen extends StatefulWidget{
  const PassivesScreen({super.key});
  @override
  State<PassivesScreen> createState() => _PassivesScreenState();
}

class _PassivesScreenState extends State<PassivesScreen> {
  final TextEditingController passivesController = TextEditingController();
  RecordProvider? _recordProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final recordProvider = Provider.of<RecordProvider>(context);
    if (recordProvider != _recordProvider) {
      _recordProvider = recordProvider;
      passivesController.removeListener(_saveNotes);
      passivesController.text = recordProvider.activeRecord?.passivesNotes ?? '';
      passivesController.addListener(_saveNotes);
    }
  }
  void _saveNotes() {
    _recordProvider?.updateActiveRecordData(passivesNotes: passivesController.text);
  }
  @override
  void dispose() {
    passivesController.removeListener(_saveNotes);
    passivesController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Anotações"),
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
                borderSide: BorderSide(color: Colors.deepPurple, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purpleAccent, width: 3)),
          ),
        ),
      ),
    );
  }
}