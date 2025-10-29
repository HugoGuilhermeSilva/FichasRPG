const List<String> attributeNames = [
  'Força',
  'Destreza',
  'Agilidade',
  'Vigor',
  'Percepção',
  'Inteligencia',
  'Vontade',
  'Carisma'
];
const List<String> expertiseNames = [
  'Acrobacia',
  'Atletismo',
  'Blefe',
  'Biologia',
  'Ciencia',
  'Conhecimento',
  'Concentração',
  'Cultura',
  'Disfarce',
  'Furtividade',
  'Intimidação',
  'Intuição',
  'Investigação',
  'Performace',
  'Persuasão',
  'Pretidigitação',
  'Prontidão',
  'Procurar',
  'Rastrear'
];
const Map<String, String> expertiseAttributeMap = {
  'Acrobacia' : 'Agilidade',
  'Atletismo': 'Força',
  'Blefe':'Carisma',
  'Biologia':'Percepção',
  'Ciencia':'Inteligencia',
  'Conhecimento':'Inteligencia',
  'Concentração':'Vontade',
  'Cultura':'Inteligencia',
  'Disfarce':'Carisma',
  'Furtividade':'Agilidade',
  'Intimidação':'Carisma',
  'Intuição':'Inteligencia',
  'Investigação':'Inteligencia',
  'Performace':'Carisma',
  'Persuasão':'Carisma',
  'Pretidigitação': 'Destreza',
  'Prontidão':'Percepção',
  'Procurar':'Percepção',
  'Rastrear':'Percepção'
};
const List<String> combatValue = [
  'Combate Corporal',
  'Combate a Distancia',
  'Combate Mental',
  'Esquiva',
  'Bloqueio',
  'Força de Vontade'
];
const Map<String, String> combatAttributeMap = {
  'Combate Corporal' : 'Força',
  'Combate a Distancia' : 'Agilidade',
  'Combate Mental' : 'Inteligencia',
  'Esquiva' : 'Agilidade',
  'Bloqueio' : 'Percepção',
  'Força de Vontade' : 'Vontade'
};
const Map<String, int> combatBaseValueMap = {
  'Bloqueio' : 10,
  'Força de Vontade' : 10
};