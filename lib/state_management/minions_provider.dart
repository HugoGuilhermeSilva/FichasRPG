import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:fichas/models/record_model.dart';

class MinionModel {
  String id;
  TextEditingController nameController;
  TextEditingController hitController;
  TextEditingController defenseController;
  TextEditingController maxHealthController;
  TextEditingController damageReceivedController;

  MinionModel({
    required this.id,
    required this.nameController,
    required this.hitController,
    required this.defenseController,
    required this.maxHealthController,
    required this.damageReceivedController,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': nameController.text,
      'hit': hitController.text,
      'defense': defenseController.text,
      'maxHealth': maxHealthController.text,
      'damageReceived': damageReceivedController.text,
    };
  }
  factory MinionModel.fromMap(Map<String, dynamic> map, VoidCallback onUpdate) {
    return MinionModel(
      id: map['id'],
      nameController: TextEditingController(text: map['name'])..addListener(onUpdate),
      hitController: TextEditingController(text: map['hit'])..addListener(onUpdate),
      defenseController: TextEditingController(text: map['defense'])..addListener(onUpdate),
      maxHealthController: TextEditingController(text: map['maxHealth'])..addListener(onUpdate),
      damageReceivedController: TextEditingController(text: map['damageReceived'])..addListener(onUpdate),
    );
  }
  int get currentHealth {
    int max = int.tryParse(maxHealthController.text) ?? 0;
    int damage = int.tryParse(damageReceivedController.text) ?? 0;
    return max - damage;
  }
}

class MinionsProvider with ChangeNotifier {
  List<MinionModel> minions = [];
  final Function(List<Map<String, dynamic>>)? onDataChanged;
  MinionsProvider({this.onDataChanged});
  void _notifyAndSave() {
    notifyListeners();
    if (onDataChanged != null) {
      onDataChanged!(minions.map((m) => m.toMap()).toList());
    }
  }
  void addNewMinion() {
    minions.add(MinionModel(
      id: const Uuid().v4(),
      nameController: TextEditingController(text: "Novo Minion")..addListener(_notifyAndSave),
      hitController: TextEditingController(text: "0")..addListener(_notifyAndSave),
      defenseController: TextEditingController(text: "0")..addListener(_notifyAndSave),
      maxHealthController: TextEditingController(text: "10")..addListener(_notifyAndSave),
      damageReceivedController: TextEditingController(text: "0")..addListener(_notifyAndSave),
    ));
    _notifyAndSave();
  }

  void updateFromRecord(Record? record) {
    if (record == null) return;

    if (record.minionsData != null && record.minionsData!.isNotEmpty) {
      minions = record.minionsData!.map((m) => MinionModel.fromMap(m, _notifyAndSave)).toList();
    } else {
      minions = [];
    }
    notifyListeners();
  }
  void removeMinion(String id) {
    minions.removeWhere((m) => m.id == id);
    _notifyAndSave();
  }
  void refresh() {
    _notifyAndSave();
  }
}