import 'package:fichas/state_management/character_provider.dart';
import 'package:fichas/data/attribute_and_expertise_data.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:fichas/models/record_model.dart';

class PassiveEntry {
  String id;
  String? selectedPower;
  String? selectedAdvantage;
  String? selectedAttributeOrSkill;
  String type;
  TextEditingController controller;

  PassiveEntry({
    required this.id,
    this.selectedPower,
    this.selectedAdvantage,
    this.selectedAttributeOrSkill,
    this.type = 'attr_skill',
    required this.controller,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'selectedPower': selectedPower,
      'selectedAdvantage': selectedAdvantage,
      'selectedAttributeOrSkill': selectedAttributeOrSkill,
      'type': type,
      'value': controller.text,
    };
  }
  factory PassiveEntry.fromMap(Map<String, dynamic> map, VoidCallback onUpdate) {
    return PassiveEntry(
      id: map['id'],
      selectedPower: map['selectedPower'],
      selectedAdvantage: map['selectedAdvantage'],
      selectedAttributeOrSkill: map['selectedAttributeOrSkill'],
      type: map['type'] ?? 'attr_skill',
      controller: TextEditingController(text: map['value'] ?? '0')..addListener(onUpdate),
    );
  }
}

class PassiveCardModel {
  String id;
  TextEditingController titleController;
  TextEditingController descController;
  List<PassiveEntry> bonusEntries;

  PassiveCardModel({
    required this.id,
    required this.titleController,
    required this.descController,
    required this.bonusEntries,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': titleController.text,
      'desc': descController.text,
      'bonusEntries': bonusEntries.map((e) => e.toMap()).toList(),
    };
  }
  factory PassiveCardModel.fromMap(Map<String, dynamic> map, VoidCallback onUpdate) {
    return PassiveCardModel(
      id: map['id'],
      titleController: TextEditingController(text: map['title'])..addListener(onUpdate),
      descController: TextEditingController(text: map['desc'])..addListener(onUpdate),
      bonusEntries: (map['bonusEntries'] as List)
          .map((e) => PassiveEntry.fromMap(e, onUpdate))
          .toList(),
    );
  }
}

class PassivesProvider with ChangeNotifier {
  final CharacterProvider characterProvider;
  List<PassiveCardModel> cards = [];
  final Function(List<Map<String, dynamic>>)? onDataChanged;
  PassivesProvider({required this.characterProvider, this.onDataChanged});
  void _notifyAndSave() {
    applyAllPassiveBonuses();
    if (onDataChanged != null) {
      onDataChanged!(cards.map((c) => c.toMap()).toList());
    }
  }
  void updateFromRecord(Record? record) {
    if (record == null) return;

    if (record.passivesData != null && record.passivesData!.isNotEmpty) {
      cards = record.passivesData!
          .map((c) => PassiveCardModel.fromMap(c, _notifyAndSave))
          .toList();
    } else {
      cards = [];
    }
    applyAllPassiveBonuses();
  }

  void addNewCard() {
    cards.add(PassiveCardModel(
      id: const Uuid().v4(),
      titleController: TextEditingController(),
      descController: TextEditingController(),
      bonusEntries: [],
    ));
    _notifyAndSave();
  }
  void removeCard(String cardId) {
    cards.removeWhere((c) => c.id == cardId);
    applyAllPassiveBonuses();
    _notifyAndSave();
  }
  void addNewPassiveLine(String cardId) {
    try{
      final card = cards.firstWhere((c) => c.id == cardId);
      final newId = const Uuid().v4();
      final newController = TextEditingController(text: '0');

      newController.addListener(() {
        applyAllPassiveBonuses();
      });

      card.bonusEntries.add(PassiveEntry(id: newId, controller: newController));
      _notifyAndSave();
    } catch (e){
      print("Erro: Card não encontrado no Provider!");
    }
  }

  void removePassiveLine(String cardId, String entryId) {
    final card = cards.firstWhere((c) => c.id == cardId);
    card.bonusEntries.removeWhere((e) => e.id == entryId);
    applyAllPassiveBonuses();
    _notifyAndSave();
  }
  void selectPower(String cardId, String entryId, String powerName) {
    final card = cards.firstWhere((c) => c.id == cardId);
    final entry = card.bonusEntries.firstWhere((e) => e.id == entryId);
    entry.type = 'power';
    entry.selectedPower = powerName;
    entry.selectedAdvantage = null;
    entry.selectedAttributeOrSkill = null;
    applyAllPassiveBonuses();
    _notifyAndSave();
  }

  void selectAdvantage(String cardId, String entryId, String advantageName) {
    final card = cards.firstWhere((c) => c.id == cardId);
    final entry = card.bonusEntries.firstWhere((e) => e.id == entryId);
    entry.type = 'advantage';
    entry.selectedAdvantage = advantageName;
    entry.selectedPower = null;
    entry.selectedAttributeOrSkill = null;
    applyAllPassiveBonuses();
    _notifyAndSave();
  }

  void selectAttributeOrSkill(String cardId, String entryId, String name) {
    final card = cards.firstWhere((c) => c.id == cardId);
    final entry = card.bonusEntries.firstWhere((e) => e.id == entryId);
    entry.type = 'attr_skill';
    entry.selectedAttributeOrSkill = name;
    entry.selectedPower = null;
    entry.selectedAdvantage = null;
    applyAllPassiveBonuses();
    _notifyAndSave();
  }
  void applyAllPassiveBonuses() {
    characterProvider.powerProvider.clearPassivesBonus();
    characterProvider.advantagesProvider.clearPassivesBonusAdvantages();
    characterProvider.attributesProvider.clearAllPassiveBonuses();
    for (var card in cards) {
      for (var entry in card.bonusEntries) {
        int value = int.tryParse(entry.controller.text) ?? 0;

        if (entry.type == 'power' && entry.selectedPower != null) {
          characterProvider.powerProvider.addPowerByPassives(
              entry.selectedPower!, value);
        }
        else if (entry.type == 'advantage' && entry.selectedAdvantage != null) {
          characterProvider.advantagesProvider.addPassivesBonusAdvantages(
              entry.selectedAdvantage!);
        }
        else if (entry.type == 'attr_skill' &&
            entry.selectedAttributeOrSkill != null) {
          String target = entry.selectedAttributeOrSkill!;
          if (attributeNames.contains(target)) {
            characterProvider.attributesProvider.addPassiveAttributeBonus(
                target, value);
          }
          else if (combatValue.contains(target)) {
            characterProvider.attributesProvider.addPassiveCombatBonus(
                target, value);
          } else {
            characterProvider.attributesProvider.addPassiveExpertiseBonus(
                target, value);
          }
        }
      }
    }
    characterProvider.recalculateAllStats();
  }
}