class Skill {
  final String name;
  final String description;
  final int levelRequirement;
  const Skill({
    required this.name,
    required this.description,
    required this.levelRequirement
});
}
class Archetype {
  final String name;
  final int mana;
  final int attributePoints;
  final int baseXp;
  final String description;
  final int baseHp;
  final int skillPointsPerLevel;
  final List<Skill> skills;
  const Archetype({
    required this.mana,
    required this.name,
    this.attributePoints = 6,
    this.baseXp = 100,
    required this.description,
    required this.baseHp,
    required this.skillPointsPerLevel,
    required this.skills
});
}
const List<Archetype> allArchetypes = [
  Archetype(
    name: 'Atirador',
    mana: 5,
    baseHp: 12,
    skillPointsPerLevel: 5,
    description: 'Atiradores recebem 10m de alcance ao invés de 5 por grau comprado e podem converter seus graus de acelerar para ataques.',
    skills: [
      Skill(levelRequirement: 1, name: 'Demolidor', description: 'Quando ataca em área causa o dano total a todos os alvos.'),
      Skill(levelRequirement: 1, name: 'Atirador de Elite', description: 'Recebe a vantagem Atirador e +5m de alcance por grau.'),
      Skill(levelRequirement: 1, name: 'Disparador', description: 'Recebe a vantagem Na Mira, e quando ela é utilizada seu passo de dano aumenta em 1.'),
      Skill(levelRequirement: 8, name: 'Tiro na Cabeça', description: 'Quando usar a vantagem Na Mira sua margem de critico diminui em 1 e seu multiplicador aumenta em 1 no ataque.'),
      Skill(levelRequirement: 8, name: 'Fura Couraça', description: 'Quando acerta um inimigo ele perde metade do total de seu defender.'),
      Skill(levelRequirement: 8, name: 'Dois Estilos', description: 'Pode atacar corpo a corpo com seu bônus de ataque a distancia.'),
      Skill(levelRequirement: 16, name: 'Sniper', description: 'Recebe +5m de alcance por grau, tambem recebe dano fixo igual seu grau de alcance.'),
      Skill(levelRequirement: 16, name: 'Sempre Mais', description: 'Sua área de efeito passa a ser 5m por grau, tambem recebe seu nivel em graus de área.',),
      Skill(levelRequirement: 16, name: 'Descarregar', description: 'Pode givar ataques para multiplicar o dano de um ataque pelo numero de ataques givados.(deve ser declarado antes do ataque).'),
      Skill(levelRequirement: 24, name: 'Estilhaço', description: 'Quando derrotar um alvo o dano excedente passa para o proximo.(Teste de percepção p metade).'),
      Skill(levelRequirement: 24, name: 'Chacina', description: 'Para cada inimigo acertado pelo seu ataque alem de 1 o dano é multiplicado por 0.5( se fosse dar 100 de dano nos 2 vai dar 150 nos 2)'),
      Skill(levelRequirement: 24, name: 'Preciso', description: 'Recebe 1 grau de dano para cada 1 de acerto que superou a ca do inimigo.'),
      Skill(levelRequirement: 32, name: 'Camper', description: 'O personagem pode givar graus de alcance para receber 1/8 do que perdeu de acerto por grau givado.'),
      Skill(levelRequirement: 32, name: 'Explosion', description: 'Pode escolher fazer com que 1 alvo dentro do ataque em área receba o triplo do dano no turno, fazendo com que todos os outros recebam metade. ( Minimo de 3 pessoas atingidas pelo ataque)'),
      Skill(levelRequirement: 32, name: 'Esguio', description: 'Recebe seu nivel mais 1/8 do seu alcance em bloqueio/esquiva.'),
    ],
  ),
  Archetype(
    name: 'Lutador',
    mana: 5,
    baseHp: 30,
    skillPointsPerLevel: 5,
    description: 'Lutadores podem converter seu acelear em ataques.',
    skills: [
      Skill(levelRequirement: 1, name: 'Atacante', description: 'Recebe Aperfeiçoamento e graus de dano iguais a seu nivel.'),
      Skill(levelRequirement: 1, name: 'Tank', description: 'Recebe Ler Movimentos e bloqueio igual seu nivel.'),
      Skill(levelRequirement: 1, name: 'Hibrido', description: 'Recebe Ataques Rapidos e Ambidestria.'),
      Skill(levelRequirement: 8, name: 'Mestre das Armas', description: 'Aumenta seu limite de armas simultâneas em 1'),
      Skill(levelRequirement: 8, name: 'Postura Defensiva', description: 'Recebe seu nivel em defender e o rd aumenta em 2.'),
      Skill(levelRequirement: 8, name: 'Mestre do Combate', description: 'Recebe 2 de acelerar.'),
      Skill(levelRequirement: 16, name: 'Amassar Seu Crânio', description: 'Recebe dano fixo igual ao dobro do seu grau de dano total.'),
      Skill(levelRequirement: 16, name: 'Parede de Carne', description: 'Recebe +5 de vida para cada grau de defender e +2 para cada grau de regeneração'),
      Skill(levelRequirement: 16, name: 'Blindado', description: 'Pode usar seu acelerar para aumentar o rd do defender em 1 por cada acelerar gasto até o inicio do seu próximo turno. e seu rd aumenta em 1/4 do nivel.'),
      Skill(levelRequirement: 24, name: 'Berzerker', description: 'Recebe a vantagem Fúria, enquanto em fúria pode receber metade do dano do seu ataque para que ele tenha acerto automatico, o dano entra depois da cura de vampirismo.'),
      Skill(levelRequirement: 24, name: 'Poder de fogo', description: 'Seu passo de dano aumenta em 5.'),
      Skill(levelRequirement: 24, name: 'Imutavel', description: 'Recebe +2 de acelerar e caso seu acelerar não seja usado para nada ofensivo você recebe imunidade a todos os danos e o seu rd aumenta em 1/4 dos acelerar que voce tem comprados (arredondado para cima)'),
      Skill(levelRequirement: 32, name: 'Guerreiro', description: 'Recebe dano fixo igual a 10x seu acerto total.'),
      Skill(levelRequirement: 32, name: 'Muralha', description: 'Sua vida maxima é multiplicada por 10.'),
      Skill(levelRequirement: 32, name: 'Destruidor', description: 'Seu dano passa a ignorar defender e imunidades e seu passo é aumentado em 2.'),
    ]
  ),
  Archetype(
    name: 'Ladino',
    mana: 7,
    baseHp: 15,
    skillPointsPerLevel: 7,
    description: 'Ladinos podem converter seu acelerar para ataques ou ações de movimento adicionais',
    skills: [
      Skill(levelRequirement: 1, name: 'Assassino', description: 'O personagem passa a poder atacar alvos desprevinidos, caso ataque alguem que não esteja o vendo o ataque será um critico.'),
      Skill(levelRequirement: 1, name: 'Velocista', description: 'Recebe +15m de deslocamento por grau de mover-se, tambem diminui o preço de mover-se pela metade.'),
      Skill(levelRequirement: 1, name: 'Agil', description: 'Recebe Agil, e seu maximo de agilidade aumenta em 1/4 do nivel.'),
      Skill(levelRequirement: 8, name: 'Evasão', description: 'Voce se torna imune a ataques e efeitos em área.'),
      Skill(levelRequirement: 8, name: 'Soco de Massa Infinita', description: 'Recebe +1 de dano fixo por grau de mover-se.'),
      Skill(levelRequirement: 8, name: 'Cada vez mais Rapido', description: 'Recebe 2 de acelerar a cada 5 niveis porém não pode comprar acelerar. E seu deslocamento é dobrado fora de Combate.'),
      Skill(levelRequirement: 16, name: 'Movimentador', description: 'Recebe 1/3+2 nivel em ações de movimento.'),
      Skill(levelRequirement: 16, name: 'Sombra', description: 'Caso erre um ataque furtivo voce não é revelado, tambem faz com que todos os seus ataques no turno em que o alvo esteja supreendido sejam furtivos.'),
      Skill(levelRequirement: 16, name: 'Ponto Fraco', description: 'Diminui sua margem de critico em 2.'),
      Skill(levelRequirement: 24, name: 'Sorte', description: 'Recebe pontos iguais a 1/2 da sua agilidade, que podem ser utilizados como na vantagem sorte.(este arquetipo não pode ser escolhido se o personagem tiver a desvantagem azarado.'),
      Skill(levelRequirement: 24, name: 'Golpe Potente', description: 'O multiplicador de critico aumenta em 2.'),
      Skill(levelRequirement: 24, name: 'Bolt', description: 'Seu deslocamento é dobrado e caso você escolha usar sua ação completa para correr, nada pode impedir seu movimento e você também encerra quaisquer condições que estiverem impedindo seu movimento. Tambem permite que voce use sua reação para transformar suas esquivas em bloqueios. (seu bloqueio se torna 5+ bonus de esquiva).'),
      Skill(levelRequirement: 32, name: 'Fatiar', description: 'A cada 4 ataques pode fazer um adicional.'),
      Skill(levelRequirement: 32, name: 'Franchiesco Virgulino', description: 'Recebe Graus de dano iguais aos graus de mover-se'),
      Skill(levelRequirement: 32, name: 'Zevyr', description: 'Passa a poder se esconder com ação livre e enquanto escondido nada pode te revelar, tambem aumenta em 2 o multiplicador do critico.'),
    ],
  ),
  Archetype(
    name: 'Suporte',
    mana: 10,
    baseHp: 15,
    skillPointsPerLevel: 6,
    description: 'Suportes podem converter seu acelerar para uma ação de cura,ataque ou movimento adicional',
    skills: [
      Skill(levelRequirement: 1, name: 'Curandeiros', description: 'Sua cura aumenta em 1 passo, tambem permite somar cura fixa igual ao total de cura.'),
      Skill(levelRequirement: 1, name: 'Protetores', description: 'Recebem a habilidade de dar seu grau de defender para 1 alvo por reação.'),
      Skill(levelRequirement: 1, name: 'Técnico', description: 'O personagem pode somar sua inteligencia em 1/3+2 do nivel de pericias.'),
      Skill(levelRequirement: 8, name: 'Sobrecura', description: 'A cura excedente num alvo vira um escudo que dura pela cena.'),
      Skill(levelRequirement: 8, name: 'Escudeiro', description: 'Quando alguem esta recebendo seu suporte esta pessoa recebe 1/4 do seu bloqueio/esquiva.'),
      Skill(levelRequirement: 8, name: 'Vai filhão', description: 'Pode energizar 1/3+1 do nivel de aliados cedendo a eles metade dos seus graus de algum pode a sua escolha em algum poder a escolha deles.'),
      Skill(levelRequirement: 16, name: 'Orientação', description: 'Voce recebe metade do bonus que voce esteja concedendo aos seus aliados.'),
      Skill(levelRequirement: 16, name: 'Cura Veloz', description: 'O personagem passa a poder curar usando também sua reação, além disso sua cura passa a tirar efeitos, inclusive exaustão.'),
      Skill(levelRequirement: 16, name: 'Confiança', description: 'Personagens sob a proteção do escudeiro recebem imunidade a todos os danos.'),
      Skill(levelRequirement: 24, name: 'Cura Potencializada', description: 'O personagem ignora corta cura.'),
      Skill(levelRequirement: 24, name: 'Tanque', description: 'Duplica seu defender e sua regeneração. E seus aliados sob sua proteção passam a receber tambem sua regeneração.'),
      Skill(levelRequirement: 24, name: 'Pra Cima', description: 'Alvos energizados por voce recebem 1/3+1 do seu nivel em acerto.'),
      Skill(levelRequirement: 32, name: 'Ressurreição', description: 'O personagem se torna capaz de voltar os mortos. Quando cura alguém que morreu em até 1 minuto, ele volta inconsciente e sua cura permite fazer quem estiver inconsciente acordar. Caso tenha se passado mais de 1 minuto, você pode ressuscitar, mas paga 1 grau de vida para cada minuto em que o alvo esteja morto (Minimo: 1) e somente durante a cena que o alvo morreu. Caso o alvo tenha morrido a mais tempo pode ressucitar, porém perde 1/3 de sua vida permanente.'),
      Skill(levelRequirement: 32, name: 'Rexona (Não te Abandona)', description: 'Cada rodada passada com a defesa aumentada pelo escudeiro, aumenta o rd do defender em 1 até o maximo de 1/2 do nivel.'),
      Skill(levelRequirement: 32, name: 'Parceria', description: 'Passa a poder usar ações para quem está energizado. No seu turno pode usar uma ação sua para outra pessoa executar como se fosse ela (Incluindo Padrão, Bônus, Movimento, Reação e Acelerar).'),
    ],
  ),
  Archetype(
    name: 'Perito',
    baseHp: 14,
    mana: 8,
    skillPointsPerLevel: 8,
    description: 'Peritos podem converter seu acelerar em ataques adicionais',
    skills: [
      Skill(levelRequirement: 1, name: 'Focado', description: 'Escolhe o nv1 de outro arquétipo.'),
      Skill(levelRequirement: 1, name: 'Estudante', description: 'Recebe 1 vantagem a mais no nv 1 e uma a mais a cada 5 niveis.'),
      Skill(levelRequirement: 1, name: 'Prodígio', description: 'Recebe +25 de Xp por nivel.'),
      Skill(levelRequirement: 8, name: 'Força do Conhecimento', description: 'Recebe 1 ataque a mais a cada 5 de Inteligencia, Carisma ou Vontade.'),
      Skill(levelRequirement: 8, name: 'Multiclasse 8', description: 'Pode escolher o nv 8 de outro arquetipo.'),
      Skill(levelRequirement: 8, name: 'Busca por Conhecimento', description: 'Pode somar a inteligencia no calculo de vida + o vigor.( formula= vida*(vigor+14+inteligencia)).'),
      Skill(levelRequirement: 16, name: 'Multiclasse 16', description: 'Pode escolher o nv 16 de outro arquetipo.'),
      Skill(levelRequirement: 16, name: 'Gênio', description: 'Pode escolher 1/3 do nivel de pericias e somar metade da sua inteligencia carisma ou vontade nelas.'),
      Skill(levelRequirement: 16, name: 'Atrasado', description: 'Pode escolher uma habilidade de arquetipo de nv anterior.'),
      Skill(levelRequirement: 24, name: 'Proficiente', description: 'Escolha 1/4 do nivel de pericias e suas rolagens nelas sempre serão 10 para cima.'),
      Skill(levelRequirement: 24, name: 'Aprendiz', description: 'O personagem recebe +50 de Xp por nivel.'),
      Skill(levelRequirement: 24, name: 'Mente Brilhante', description: 'Permite somar mais o seu carisma na força de vontade, e sua vida mental é duplicada.'),
      Skill(levelRequirement: 24, name: 'Multiclasse 24', description: 'Pode escolher o nv 24 de outro arquetipo.'),
      Skill(levelRequirement: 32, name: 'Sempre Melhor', description: 'Recebe Vantagem nas pericias relacionadas ao seu atributo principal( o que é aumentado por aumentar atributo).'),
      Skill(levelRequirement: 32, name: 'Multiclasse 32', description: 'Pode pegar a habilidade nv 24 ou 32 de outro arquetipo.'),
      Skill(levelRequirement: 32, name: 'Adaptável', description: 'Recebe graus de um poder a sua escolha iguais ao seu atributo principal.'),
    ],
  ),
];
