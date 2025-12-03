import 'package:shared_preferences/shared_preferences.dart';
import 'package:fichas/models/record_model.dart';

class RecordStorageService {
  static const String _recordsKey = 'all_records_list';

  Future<void> saveAllRecords(List<Record> records) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> recordsAsJsonString = records.map((record) => record.toJson()).toList();
    await prefs.setStringList(_recordsKey, recordsAsJsonString);
  }
  Future<List<Record>> loadAllRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? recordsAsJsonString = prefs.getStringList(_recordsKey);
    if(recordsAsJsonString == null){
      return [];
    }
    final List<Record> records = recordsAsJsonString.map((json) => Record.fromJson(json)).toList();
    return records;
  }
  Future<void> saveLastActiveRecordId(String recordId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastActiveRecordId', recordId);
  }
  Future<String?> loadLastActiveRecordId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastActiveRecordId');
  }
}