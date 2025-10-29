import 'package:flutter/material.dart';
import 'package:fichas/data/attribute_and_expertise_data.dart';
import 'package:fichas/state_management/character_provider.dart';

class AttributesProvider with ChangeNotifier {
  CharacterProvider? _characterProvider;

  // --- CONTROLLERS EDITÁVEIS (Mantidos) ---
  final Map<String, TextEditingController> baseControllers = {};
  final Map<String, TextEditingController> bonusControllers = {};
  final Map<String, TextEditingController> expertiseBonusControllers = {};
  final Map<String, TextEditingController> combatBonusControllers = {};

  // --- CONTROLLERS PARA VALORES CALCULADOS (Mantidos) ---
  final TextEditingController remainingAttributesController = TextEditingController();
  final TextEditingController remainingExpertisePointsController = TextEditingController();

  // --- MAPAS INTERNOS PARA OS TOTAIS (Mantidos) ---
  final Map<String, int> _attributesTotals = {};
  final Map<String, int> _expertiseTotals = {};
  final Map<String, int> _combatTotals = {};

  // --- CONTROLLERS DE TOTAL (REMOVIDOS) ---
  // final Map<String, TextEditingController> attributeTotalControllers = {};
  // final Map<String, TextEditingController> expertiseTotalControllers = {};
  // final Map<String, TextEditingController> combatTotalControllers = {};


  AttributesProvider() {
    // Inicializa os controllers e adiciona os listeners
    for (final name in attributeNames) {
      baseControllers[name] = TextEditingController();
      bonusControllers[name] = TextEditingController();
      _attributesTotals[name] = 0;
      baseControllers[name]!.addListener(() =>
          _updateTotalsFor(attributeName: name));
      bonusControllers[name]!.addListener(() =>
          _updateTotalsFor(attributeName: name));
    }
    for (final name in expertiseNames) {
      expertiseBonusControllers[name] = TextEditingController();
      _expertiseTotals[name] = 0;
      expertiseBonusControllers[name]!.addListener(() =>
          _updateTotalsFor(expertiseName: name));
    }
    for (final name in combatValue) {
      combatBonusControllers[name] = TextEditingController();
      _combatTotals[name] = 0;
      combatBonusControllers[name]!.addListener(() =>
          _updateTotalsFor(combatName: name));
    }
    // Faz um cálculo inicial para garantir que os valores não comecem zerados
    for (final name in attributeNames) {
      _updateTotalsFor(attributeName: name);
    }
  }

  // Função para linkar com o CharacterProvider
  void update(CharacterProvider characterProvider) {
    // Evita notificações desnecessárias se o provider não mudou
    if (_characterProvider != characterProvider) {
      _characterProvider = characterProvider;
      // Notifica a UI para reconstruir com os dados agora disponíveis
      notifyListeners();
    }
  }

  // --- GETTERS PARA PONTOS GASTOS ---
  int get spentAttributePoints {
    int totalSpent = 0;
    for (var controller in baseControllers.values) {
      totalSpent += int.tryParse(controller.text) ?? 0;
    }
    return totalSpent;
  }

  int get spentExpertisePoints {
    int totalSpent = 0;
    for (var controller in expertiseBonusControllers.values) {
      totalSpent += int.tryParse(controller.text) ?? 0;
    }
    return totalSpent;
  }

  // --- GETTERS PARA PONTOS RESTANTES ---
  int get remainingAttributePoints {
    final totalAvailable = _characterProvider?.baseAttributePoints ?? 0;
    final remaining = totalAvailable - spentAttributePoints;
    // Atualiza o controller do campo de exibição
    remainingAttributesController.text = remaining.toString();
    return remaining;
  }

  int get remainingExpertisePoints {
    final level = _characterProvider?.level ?? 1;
    final pointsPerLevel = _characterProvider?.skillPointPerLevel ?? 0;
    final totalAvailable = pointsPerLevel * level;
    final remaining = totalAvailable - spentExpertisePoints;
    // Atualiza o controller do campo de exibição
    remainingExpertisePointsController.text = remaining.toString();
    return remaining;
  }

  // --- GETTERS PARA OS TOTAIS (Usados pela UI) ---
  String getAttributeTotalFor(String attributeName) =>
      (_attributesTotals[attributeName] ?? 0).toString();

  String getExpertiseTotalFor(String expertiseName) =>
      (_expertiseTotals[expertiseName] ?? 0).toString();

  String getCombatTotalFor(String combatName) =>
      (_combatTotals[combatName] ?? 0).toString();

  // --- LÓGICA DE ATUALIZAÇÃO ---
  void _updateTotalsFor(
      {String? attributeName, String? expertiseName, String? combatName}) {
    bool somethingChanged = false;

    if (attributeName != null) {
      final baseValue = int.tryParse(
          baseControllers[attributeName]?.text ?? '') ?? 0;
      final bonusValue = int.tryParse(
          bonusControllers[attributeName]?.text ?? '') ?? 0;
      final newTotal = baseValue + bonusValue;

      if (_attributesTotals[attributeName] != newTotal) {
        _attributesTotals[attributeName] = newTotal;
        // A linha que atualizava o `attributeTotalControllers` foi REMOVIDA
        somethingChanged = true;

        // Atualiza perícias e valores de combate que dependem deste atributo
        for (var entry in expertiseAttributeMap.entries) {
          if (entry.value == attributeName) {
            _updateExpertiseTotal(entry.key);
          }
        }
        for (var entry in combatAttributeMap.entries) {
          if (entry.value == attributeName) {
            _updateCombatTotal(entry.key);
          }
        }
      }
    }

    if (expertiseName != null) {
      if (_updateExpertiseTotal(expertiseName)) {
        somethingChanged = true;
      }
    }

    if (combatName != null) {
      if (_updateCombatTotal(combatName)) {
        somethingChanged = true;
      }
    }

    // CORREÇÃO CRÍTICA: Notifica a UI apenas UMA VEZ e SOMENTE se algo mudou.
    // Isso evita o loop infinito que causa os erros de layout.
    if (somethingChanged) {
      notifyListeners();
    }
  }

  bool _updateExpertiseTotal(String expertiseName) {
    final dependentAttribute = expertiseAttributeMap[expertiseName];
    if (dependentAttribute == null) return false;

    final attributeValue = (_attributesTotals[dependentAttribute] ?? 0);
    final baseExpertiseValue = (attributeValue / 2).round();
    final bonusValue = int.tryParse(
        expertiseBonusControllers[expertiseName]?.text ?? '') ?? 0;
    final newTotal = baseExpertiseValue + bonusValue;

    if (_expertiseTotals[expertiseName] != newTotal) {
      _expertiseTotals[expertiseName] = newTotal;
      // A linha que atualizava o `expertiseTotalControllers` foi REMOVIDA
      return true;
    }
    return false;
  }

  bool _updateCombatTotal(String combatName) {
    final dependentAttribute = combatAttributeMap[combatName];
    if (dependentAttribute == null) return false;

    final specificValue = combatBaseValueMap[combatName] ?? 0;
    final attributeValue = (_attributesTotals[dependentAttribute] ?? 0);
    final bonusValue = int.tryParse(
        combatBonusControllers[combatName]?.text ?? '') ?? 0;
    final newTotal = specificValue + attributeValue + bonusValue;

    if (_combatTotals[combatName] != newTotal) {
      _combatTotals[combatName] = newTotal;
      // A linha que atualizava o `combatTotalControllers` foi REMOVIDA
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    // Limpa todos os controllers que ainda existem
    remainingAttributesController.dispose();
    remainingExpertisePointsController.dispose();
    for (var c in baseControllers.values) {
      c.dispose();
    }
    for (var c in bonusControllers.values) {
      c.dispose();
    }
    for (var c in expertiseBonusControllers.values) {
      c.dispose();
    }
    for (var c in combatBonusControllers.values) {
      c.dispose();
    }
    // As linhas do dispose dos controllers de total foram REMOVIDAS
    super.dispose();
  }
}