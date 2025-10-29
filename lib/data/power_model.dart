class Power{
  final String name;
  final String description;
  final int cost;
  final bool stackable;
  const Power({
    required this.name,
    required this.description,
    required this.cost,
    this.stackable = true
  });
  factory Power.fromMap(Map<String, dynamic> map){
    return Power(
      name: map['name'] ?? 'Nome não encontrado',
      description: map['description'] ?? 'descrição nao encontrada',
      cost: map['cost'] ?? 0,
      stackable: map['stackable'] ?? true
    );
  }
}