import 'package:fichas/state_management/attributes_provider.dart';
import 'package:fichas/state_management/character_provider.dart';
import 'package:fichas/state_management/power_provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:fichas/models/record_model.dart';
import 'package:fichas/services/record_storage_service.dart';
import 'package:fichas/state_management/advantages_provider.dart';

class RecordProvider with ChangeNotifier {
  final RecordStorageService _storageService = RecordStorageService();
  List<Record> _records = [];
  Record? _activeRecord;
  late final AdvantagesProvider advantagesProvider;
  late final PowerProvider powerProvider;
  late final CharacterProvider characterProvider;
  late final AttributesProvider attributesProvider;

  List<Record> get records => _records;
  Record? get activeRecord => _activeRecord;

  RecordProvider(){
    advantagesProvider = AdvantagesProvider(
      onDataChanged : (newData) {
        updateActiveRecordData(advantagesData: newData);
      },
    );
    powerProvider = PowerProvider(
      onDataChanged: (newData) {
        updateActiveRecordData(powersData: newData);
      },
    );
    characterProvider = CharacterProvider(
      powerProvider: powerProvider,
      onDataChanged: ({
        int? characterLevel,
        String? archetypeName,
        List<String>? selectedSkills,
      }) {
        updateActiveRecordData(
          characterLevel: characterLevel,
          archetypeName: archetypeName,
          selectedSkills: selectedSkills,
        );
      },
    );
    attributesProvider = AttributesProvider(
      characterProvider: characterProvider,
      onDataChanged: (newData) {
        updateActiveRecordData(attributesData: newData);
      }
    );
    characterProvider.setAttributesProvider(attributesProvider);
    powerProvider.setCharacterProvider(characterProvider);
    loadAllRecords();
  }
  Future<void> loadAllRecords() async {
    _records = await _storageService.loadAllRecords();
    final lastActiveId = await _storageService.loadLastActiveRecordId();
    if(_records.isNotEmpty){
      _activeRecord = _records.firstWhere((record) => record.id == lastActiveId, orElse: () => _records.first,
      );
    } else{
      createNewRecord(name: '1 Ficha');
    }
    _updateChildProviders();
    notifyListeners();
  }
  Future<void> _saveAllRecords() async {
    await _storageService.saveAllRecords(_records);
  }
  void createNewRecord({required String name}){
    final newRecord = Record(
      id: const Uuid().v4(),
      nameRecord: name,
    );
    _records.add(newRecord);
    _activeRecord = newRecord;
    _updateChildProviders();
    _saveAllRecords();
    notifyListeners();
  }
  void deleteRecord(String recordId) {
    _records.removeWhere((record) => record.id == recordId);
    if (_activeRecord?.id == recordId) {
      _activeRecord = _records.isNotEmpty ? _records.first : null;
      if (_activeRecord == null) {
        createNewRecord(name: '1 Ficha');
        return;
      }
    }
    _updateChildProviders();
    _saveAllRecords();
    notifyListeners();
  }
  void _updateChildProviders(){
    advantagesProvider.updateFromRecord(_activeRecord);
    powerProvider.updateFromRecord(_activeRecord);
    characterProvider.updateFromRecord(_activeRecord);
    attributesProvider.updateFromRecord(_activeRecord);
  }
  void selectedRecord(String recordId) {
    try{
      _activeRecord = _records.firstWhere((record) => record.id == recordId);
      _updateChildProviders();
      _storageService.saveLastActiveRecordId(recordId);
      notifyListeners();
    }catch (e) {
      print('Erro: Ficha com ID $recordId não encontrado.');
    }
  }
  void updateActiveRecordData({
    int? characterLevel,
    String? archetypeName,
    List<String>? selectedSkills,
    Map<String, dynamic>? attributesData,
    Map<String, dynamic>? powersData,
    List<String>? advantagesData,
    String? passivesNotes,
}){
    if (_activeRecord == null) return;
    if (characterLevel != null ) _activeRecord!.characterLevel = characterLevel;
    if (archetypeName != null) _activeRecord!.archetypeName = archetypeName;
    if (selectedSkills != null) _activeRecord!.selectedSkills = selectedSkills;
    if (attributesData != null) _activeRecord!.attributesData = attributesData;
    if (powersData != null) _activeRecord!.powersData = powersData;
    if (advantagesData != null) _activeRecord!.advantagesData = advantagesData;
    if (passivesNotes != null) _activeRecord!.passivesNotes = passivesNotes;
    _saveAllRecords();
    notifyListeners();
  }
}