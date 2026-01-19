import 'package:fichas/state_management/character_provider.dart';
import 'package:fichas/data/attribute_and_expertise_data.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
}

class PassiveCardModel {
  String id;
  TextEditingController titleController;
  TextEditingController descController;
  List<PassiveEntry> bonusEntries; // Cada card tem sua própria lista de bônus

  PassiveCardModel({
    required this.id,
    required this.titleController,
    required this.descController,
    required this.bonusEntries,
  });
}

class PassivesProvider with ChangeNotifier {
  final CharacterProvider characterProvider;

  // MUDANÇA: Agora gerenciamos uma lista de Cards
  List<PassiveCardModel> cards = [];

  PassivesProvider({required this.characterProvider});

  // --- FUNÇÕES DE CARD ---

  void addNewCard() {
    cards.add(PassiveCardModel(
      id: const Uuid().v4(),
      titleController: TextEditingController(),
      descController: TextEditingController(),
      bonusEntries: [], // Começa sem nenhum bônus
    ));
    notifyListeners();
  }

  void removeCard(String cardId) {
    cards.removeWhere((c) => c.id == cardId);
    applyAllPassiveBonuses();
    notifyListeners();
  }

  // --- FUNÇÕES DE BÔNUS (DENTRO DO CARD) ---

  void addNewPassiveLine(String cardId) {
    try{
      final card = cards.firstWhere((c) => c.id == cardId);
      final newId = const Uuid().v4();
      final newController = TextEditingController(text: '0');

      newController.addListener(() {
        applyAllPassiveBonuses();
      });

      card.bonusEntries.add(PassiveEntry(id: newId, controller: newController));
      notifyListeners();
    } catch (e){
      print("Erro: Card não encontrado no Provider!");
    }
  }

  void removePassiveLine(String cardId, String entryId) {
    final card = cards.firstWhere((c) => c.id == cardId);
    card.bonusEntries.removeWhere((e) => e.id == entryId);
    applyAllPassiveBonuses();
    notifyListeners();
  }

  // Funções de Seleção atualizadas para encontrar o card e a linha correta
  void selectPower(String cardId, String entryId, String powerName) {
    final card = cards.firstWhere((c) => c.id == cardId);
    final entry = card.bonusEntries.firstWhere((e) => e.id == entryId);
    entry.type = 'power';
    entry.selectedPower = powerName;
    entry.selectedAdvantage = null;
    entry.selectedAttributeOrSkill = null;
    applyAllPassiveBonuses();
    notifyListeners();
  }

  void selectAdvantage(String cardId, String entryId, String advantageName) {
    final card = cards.firstWhere((c) => c.id == cardId);
    final entry = card.bonusEntries.firstWhere((e) => e.id == entryId);
    entry.type = 'advantage';
    entry.selectedAdvantage = advantageName;
    entry.selectedPower = null;
    entry.selectedAttributeOrSkill = null;
    applyAllPassiveBonuses();
    notifyListeners();
  }

  void selectAttributeOrSkill(String cardId, String entryId, String name) {
    final card = cards.firstWhere((c) => c.id == cardId);
    final entry = card.bonusEntries.firstWhere((e) => e.id == entryId);
    entry.type = 'attr_skill';
    entry.selectedAttributeOrSkill = name;
    entry.selectedPower = null;
    entry.selectedAdvantage = null;
    applyAllPassiveBonuses();
    notifyListeners();
  }

  // --- CÁLCULO FINAL ---

  void applyAllPassiveBonuses() {
    characterProvider.powerProvider.clearPassivesBonus();
    characterProvider.advantagesProvider.clearPassivesBonusAdvantages();
    characterProvider.attributesProvider.clearAllPassiveBonuses();

    // Percorre todos os cards e todos os bônus de cada card
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