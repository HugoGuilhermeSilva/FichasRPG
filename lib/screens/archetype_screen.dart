import 'package:flutter/material.dart';
import 'package:fichas/common/archetype_widget.dart';

class ArchetypeScreen extends StatefulWidget{
  const ArchetypeScreen({super.key});

  @override
  State<ArchetypeScreen> createState() => _ArchetypeScreenState();
}

class _ArchetypeScreenState extends State<ArchetypeScreen>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Arquetipos',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold
        ),),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            Column(
              children: [
                ArchetypeHeader(
                  title: 'Atirador',
                  level: '1',
                  archetypeDescription: 'Pontos de Perícia: 5\n'
                      'Vida Base: 12\n'
                      'Atiradores recebem 10 metros de alcance ao inves de 5 por grau comprado\n'
                      'Atiradores podem converter seus graus de acelerar para ataques\n'
                      'No nível 1 permite escolher 1 entre as seguintes opções:',
                ),
                ArchetypeCard(
                  name: 'Demolidor',
                  description: 'Quando ataca em área causa o dano total a todos os alvos',
                  selected: false,
                  onChanged: (_) {}
                ),
                ArchetypeCard(
                  name: 'Atirador de Elite',
                  description: 'Recebe a vantagem Atirador e +5 metros de alcance por grau',
                  selected: false,
                  onChanged: (_) {}
                ),
                ArchetypeCard(
                  name: 'Disparador',
                  description: 'Recebe a vantagem Na Mira, e quando ela é utilizada seu passo de dano aumenta em 1',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '5',),
                ArchetypeCard(
                  name: 'Tiro na Cabeça',
                  description: 'Quando usar a vantagem Na Mira sua margem de critico diminui em 1 e seu multiplicador aumenta em 1 no ataque',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Fura Couraça',
                  description: 'Quando acerta um inimigo ele perde metade do total de seu defender.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Dois Estilos',
                  description: 'Pode atacar corpo a corpo com seu bônus de ataque a distancia.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '10',),
                ArchetypeCard(
                  name: 'Sniper',
                  description: 'Recebe +5m de alcance por grau, tambem recebe dano fixo igual seu grau de alcance.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Sempre Mais',
                  description: 'Sua área de efeito passa a ser 5m por grau, tambem recebe seu nivel em graus de área.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Descarregar',
                  description: 'Pode givar ataques para multiplicar o dano de um ataque pelo numero de ataques givados.(deve ser declarado antes do ataque).',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '15',),
                ArchetypeCard(
                  name: 'Estilhaço',
                  description: 'Quando derrotar um alvo o dano excedente passa para o proximo.(Teste de percepção p metade).',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Chacina',
                  description: 'Para cada inimigo acertado no ataque em área voce recebe 1/3 do seu nivel em graus do seu poder principal( Pode ser dano, manipulação, gravidade etc.)',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Preciso',
                  description: 'Recebe 1 grau de dano para cada 1 de acerto que superou a ca do inimigo.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '20',),
                ArchetypeCard(
                  name: 'Camper',
                  description: 'O personagem pode givar graus de alcance para receber metade do que perdeu de acerto por grau givado.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Explosion',
                  description: 'Pode escolher fazer com que 1 alvo dentro do ataque em área receba o triplo do dano no turno, fazendo com que todos os outros recebam metade. ( Minimo de 3 pessoas atingidas pelo ataque)',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Esguio',
                  description: 'Recebe seu nivel mais 1/4 do seu alcance em bloqueio/esquiva.',
                  selected: false,
                  onChanged: (_) {},
                ),
              ],
            ),
            Column(
              children: [
                ArchetypeHeader(
                  title: 'Lutador',
                  level: '1',
                  archetypeDescription: 'Pontos de perícia: 5 por nivel\n'
                      'Vida Base: 30\n'
                      'Lutadores podem converter seu acelear em ataques.',
                ),
                ArchetypeCard(
                  name: 'Atacante',
                  description: 'Recebe Aperfeiçoamento e graus de dano iguais a seu nivel.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Tank',
                  description: 'Recebe Ler Movimentos e bloqueio igual seu nivel.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Hibrido',
                  description: 'Recebe Ataques Rapidos e Ambidestria.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '5',),
                ArchetypeCard(
                  name: 'Mestre das Armas',
                  description: 'Aumenta seu limite de armas simultâneas em 1.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Postura Defensiva',
                  description: 'Recebe seu nivel em defender e o rd aumenta em 2.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Mestre do Combate',
                  description: 'Recebe 2 de acelerar.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '10',),
                ArchetypeCard(
                  name: 'Amassar Seu Crânio',
                  description: 'Recebe dano fixo igual ao dobro do seu grau de dano total.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Parede de Carne',
                  description: 'Recebe +5 de vida para cada grau de defender e +2 para cada grau de regeneração.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Blindado',
                  description: 'Pode usar seu acelerar para aumentar o rd do defender em 1 por cada acelerar gasto até o inicio do seu próximo turno. e seu rd aumenta em 1/4 do nivel.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '15',),
                ArchetypeCard(
                  name: 'Berzerker',
                  description: 'Recebe a vantagem Fúria, enquanto em fúria pode receber metade do dano do seu ataque para que ele tenha acerto automatico, o dano entra depois da cura de vampirismo.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Poder de fogo',
                  description: 'Seu passo de dano aumenta em 5.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Imutavel',
                  description: 'Recebe +2 de acelerar, caso seu acelerar não seja usado para nada ofensivo você recebe imunidade a todos os danos e o seu rd aumenta em 1/4 dos acelerar que voce tem comprados (arredondado para cima).',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '20',),
                ArchetypeCard(
                  name: 'Guerreiro',
                  description: 'Recebe dano fixo igual a 10x seu acerto total.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Muralha',
                  description: 'Sua vida maxima é multiplicada por 10.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Destruidor',
                  description: 'Seu dano passa a ignorar defender e imunidades e seu passo é aumentado em 2.',
                  selected: false,
                  onChanged: (_) {},
                ),
              ],
            ),
            Column(
              children: [
                ArchetypeHeader(
                  title: 'Ladino',
                  level: '1',
                  archetypeDescription: 'Pontos de Perícia: 7 por nível\n'
                      'Vida Base: 15\n'
                      'Ladinos podem converter seu acelerar para ataques ou ações de movimento adicionais',
                ),
                ArchetypeCard(
                  name: 'Assassino',
                  description: 'O personagem passa a poder atacar alvos desprevinidos, caso ataque alguem que não esteja o vendo o ataque será um critico.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Velocista',
                  description: 'Recebe +15m de deslocamento por grau de mover-se, tambem diminui o preço de mover-se pela metade.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Agil',
                  description: 'Recebe Agil, e seu maximo de agilidade aumenta em 1/4 do nivel.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '5',),
                ArchetypeCard(
                  name: 'Evasão',
                  description: 'Voce se torna imune a ataques e efeitos em área.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Soco de Massa Infinita',
                  description: 'Recebe +1 de dano fixo por grau de mover-se.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Cada vez mais Rapido',
                  description: 'Recebe 2 de acelerar a cada 5 niveis porém não pode comprar acelerar. E seu deslocamento é dobrado fora de Combate.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '10',),
                ArchetypeCard(
                  name: 'Movimentador',
                  description: 'Recebe 1/3+2 nivel em ações de movimento.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Sombra',
                  description: 'Caso erre um ataque furtivo voce não é revelado, tambem faz com que todos os seus ataques no turno em que o alvo esteja supreendido sejam furtivos.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Ponto Fraco',
                  description: 'Diminui sua margem de critico em 2.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '15',),
                ArchetypeCard(
                  name: 'Sorte',
                  description: 'Recebe pontos iguais a 1/2 da sua agilidade, que podem ser utilizados como na vantagem sorte.(este arquetipo não pode ser escolhido se o personagem tiver a desvantagem azarado.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Golpe Potente',
                  description: 'O multiplicador de critico aumenta em 2.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Bolt',
                  description: 'Seu deslocamento é dobrado e caso você escolha usar sua ação completa para correr, nada pode impedir seu movimento e você também encerra quaisquer condições que estiverem impedindo seu movimento. Tambem permite que voce use sua reação para transformar suas esquivas em bloqueios. (seu bloqueio se torna 5+ bonus de esquiva).',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '20',),
                ArchetypeCard(
                  name: 'Fatiar',
                  description: 'A cada 4 ataques pode fazer um adicional.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Franchiesco Virgulino',
                  description: 'Pode givar completamente seu movimento no turno para receber graus de dano iguais ao seu mover-se.(no inicio do seu proximo turno voce pode se mover novamente.)',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Zevyr',
                  description: 'Passa a poder se esconder com ação livre e enquanto escondido nada pode te revelar, tambem aumenta em 2 o multiplicador do critico.',
                  selected: false,
                  onChanged: (_) {},
                ),
              ],
            ),
            Column(
              children: [
                ArchetypeHeader(
                  title: 'Suporte',
                  level: '1',
                  archetypeDescription: 'Pontos de Perícia: 6 por nível\n'
                      'Vida Base: 15\n'
                      'Suportes podem converter seu acelerar para uma ação de cura,ataque ou movimento adicional',
                ),
                ArchetypeCard(
                  name: 'Curandeiros',
                  description: 'Sua cura aumenta em 1 passo, tambem permite somar cura fixa igual ao total de cura.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Protetores',
                  description: 'Recebem a habilidade de dar seu grau de defender para 1 alvo por reação.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Técnico',
                  description: 'O personagem pode somar sua inteligencia em 1/3+2 do nivel de pericias.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '5',),
                ArchetypeCard(
                  name: 'Sobrecura',
                  description: 'A cura excedente num alvo vira um escudo que dura pela cena.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Escudeiro',
                  description: 'Quando alguem esta recebendo seu suporte esta pessoa recebe 1/4 do seu bloqueio/esquiva.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Vai filhão',
                  description: 'Pode energizar 1/3+1 do nivel de aliados cedendo a eles metade dos seus graus de algum pode a sua escolha em algum poder a escolha deles.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '10',),
                ArchetypeCard(
                  name: 'Orientação',
                  description: 'Voce recebe metade do bonus que voce esteja concedendo aos seus aliados.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Cura Veloz',
                  description: 'O personagem passa a poder curar usando também sua reação, além disso sua cura passa a tirar efeitos, inclusive exaustão.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Confiança',
                  description: 'Personagens sob a proteção do escudeiro recebem imunidade a todos os danos.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '15',),
                ArchetypeCard(
                  name: 'Cura Potencializada',
                  description: 'O personagem ignora corta cura.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Tanque',
                  description: 'Duplica seu defender e sua regeneração. E seus aliados sob sua proteção passam a receber tambem sua regeneração.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Pra Cima',
                  description: 'Alvos energizados por voce recebem 1/3+1 do seu nivel em acerto.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '20',),
                ArchetypeCard(
                  name: 'Ressurreição',
                  description: 'O personagem se torna capaz de voltar os mortos. Quando cura alguém que morreu em até 1 minuto, ele volta inconsciente e sua cura permite fazer quem estiver inconsciente acordar. Caso tenha se passado mais de 1 minuto, você pode ressuscitar, mas paga 1 grau de vida para cada minuto em que o alvo esteja morto (Minimo: 1) e somente durante a cena que o alvo morreu. Caso o alvo tenha morrido a mais tempo pode ressucitar, porém perde 1/3 de sua vida permanente.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Rexona (Não te Abandona)',
                  description: 'Cada rodada passada com a defesa aumentada pelo escudeiro, aumenta o rd do defender em 1 até o maximo de 1/2 do nivel.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Parceria',
                  description: 'Passa a poder usar ações para quem está energizado. No seu turno pode usar uma ação sua para outra pessoa executar como se fosse ela (Incluindo Padrão, Bônus, Movimento, Reação e Acelerar).',
                  selected: false,
                  onChanged: (_) {},
                ),
              ],
            ),
            Column(
              children: [
                ArchetypeHeader(
                  title: 'Perito',
                  level: '1',
                  archetypeDescription: 'Pontos de Perícia: 8 por nível\n'
                      'Vida Base: 14\n'
                      'Peritos podem converter seu acelerar em ataques adicionais',
                ),
                ArchetypeCard(
                  name: 'Focado',
                  description: 'Escolhe o nv1 de outro arquétipo.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Estudante',
                  description: 'Recebe 1 vantagem a mais no nv 1 e uma a mais a cada 5 niveis.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Prodígio',
                  description: 'Recebe +25 de Xp por nivel.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '5',),
                ArchetypeCard(
                  name: 'Força do Conhecimento',
                  description: 'Recebe 1 ataque a mais a cada 5 de carisma, vontade ou Inteligencia.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Multiclasse',
                  description: 'Pode escolher o nv 5 de outro arquetipo.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Busca por Conhecimento',
                  description: 'Pode somar a inteligencia no calculo de vida + o vigor.( formula= vida*(vigor+14+inteligencia)).',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '10',),
                ArchetypeCard(
                  name: 'Multiclasse',
                  description: 'Pode escolher o nv 10 de outro arquetipo.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Gênio',
                  description: 'Pode escolher 1/3 do nivel de pericias e trocar o tributo principal delas por inteligencia carisma ou vontade.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Atrasado',
                  description: 'Pode escolher uma habilidade de arquetipo de nv anterior.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '15',),
                ArchetypeCard(
                  name: 'Proficiente',
                  description: 'Escolha 1/4 do nivel de pericias e suas rolagens nelas sempre serão 10 para cima.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Aprendiz',
                  description: 'O personagem recebe +50 de Xp por nivel.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Mente Brilhante',
                  description: 'Permite somar mais o seu carisma na força de vontade, e sua vida mental é duplicada.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Multiclasse',
                  description: 'Pode escolher o nv 15 de outro arquetipo.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeHeader(level: '20',),
                ArchetypeCard(
                  name: 'Sempre Melhor',
                  description: 'Recebe Vantagem nas pericias relacionadas ao seu atributo principal( o que é aumentado por aumentar atributo).',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Multiclasse',
                  description: 'Pode pegar a habilidade nv 15 ou 20 de outro arquetipo.',
                  selected: false,
                  onChanged: (_) {},
                ),
                ArchetypeCard(
                  name: 'Adaptável',
                  description: 'Recebe graus de um poder a sua escolha iguais ao seu atributo principal.',
                  selected: false,
                  onChanged: (_) {},
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}