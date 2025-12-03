import 'dart:convert';

class Record {
  final String id;
  String nameRecord;
  int characterLevel;
  String? archetypeName;
  List<String>? selectedSkills;
  Map<String, dynamic>? attributesData;
  Map<String, dynamic>? powersData;
  List<String>? advantagesData;
  String passivesNotes;

  Record({
    required this.id,
    required this.nameRecord,
    this.characterLevel = 1,
    this.archetypeName,
    List<String>? selectedSkills,
    Map<String, dynamic>? attributesData,
    Map<String, dynamic>? powersData,
    List<String>? advantagesData,
    this.passivesNotes = '',
  })  : this.selectedSkills = selectedSkills ?? [],
        this.attributesData = attributesData ?? {},
        this.powersData = powersData ?? {},
        this.advantagesData = advantagesData ?? [];
  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'nameRecord': nameRecord,
      'characterLevel': characterLevel,
      'archetypeName': archetypeName,
      'selectedSkills': selectedSkills,
      'attributesData': attributesData,
      'powersData': powersData,
      'advantagesData': advantagesData,
      'passivesNotes': passivesNotes,
    };
  }
  factory Record.fromMap(Map<String, dynamic> map){
    return Record(
      id: map['id'] ?? '',
      nameRecord: map['nameRecord'] ?? 'Ficha sem Nome',
      characterLevel: map['characterLevel'] ?? 1,
      archetypeName: map['archetypeName'],
      selectedSkills: List<String>.from(map['selectedSkills'] ?? []),
      attributesData: Map<String, dynamic>.from(map['attributesData'] ?? {}),
      powersData: Map<String, dynamic>.from(map['powersData'] ?? {}),
      advantagesData: List<String>.from(map['advantagesData'] ?? []),
      passivesNotes: map['passivesNotes'] ?? 0,
    );
  }
  String toJson() => json.encode(toMap());
  factory Record.fromJson(String source) => Record.fromMap(json.decode(source));
}