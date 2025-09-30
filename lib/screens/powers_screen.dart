import 'package:flutter/material.dart';
import 'package:fichas/common/power_box_widget.dart';

class PowerScreen extends StatefulWidget{
  const PowerScreen({super.key});
  @override
  State<PowerScreen> createState() => _PowerScreenState();
}
class _PowerScreenState extends State<PowerScreen>{
  List<Powers> allPowers = [
    Powers(name: 'Acelerar', description: 'Só pode ser comprado 1 vez a cada 5 níveis\nCada grau te concede 1 ação bonus adicional no seu turno', cost: 75),
    Powers(name: 'Alcance', description: 'Cada grau aumenta seu alcance em 5 metros', cost: 25),
    Powers(name: 'Área', description: 'Ter esse pode comprado te permite atacar em área divindindo o dano entre os alvos antingidos, cada grau aumenta em 3 metros a área do ataque', cost: 25),
    Powers(name: 'Aumentar Atributo', description: 'Aumenta em 1/3 do nivel +2 em 2 atributos a sua escolha', cost: 40),
    Powers(name: 'Atravessar', description: 'Aumenta seus graus de "Atravessar"', cost: 20),
    Powers(name: 'Atravessar Resistencias', description: 'Voce consegue ignorar graus de defender do alvo iguais aos seus graus de atravessar', cost: 60),
    Powers(name: 'Atravessar Ataque', description: 'Com sua reação voce pode ignorar graus de dano de quem estiver te atacando iguais aos seus graus de atravessar', cost: 60),
    Powers(name: 'Forma da Criatura', description: 'Voce se transforma em uma criatura da ficção recebendo 1/4 do nivel +1 em 2 atributos a sua escolha, tambem recebe seu nivel em graus de dano', cost: 120),
    Powers(name: 'Passiva da Criatura', description: 'Recebe uma passiva adicional baseada na criatura', cost: 120),
    Powers(name: 'Habilidade de Criatura', description: 'Recebe uma habilidade da criatura', cost: 120),
    Powers(name: 'Comunicar', description: 'Voce tem a capacidade de se comunicar de outras formas alem da fala', cost: 10),
    Powers(name: 'Controlar Densidade', description: 'Limite de compra igual ao nível do personagem\nPermite passar o valor de um atributo para outro usando uma acção bonus para cada ponto passado, o limite desse valor é igual aos graus de denisdade', cost: 80),
    Powers(name: 'Tecnocinese', description: 'Permite criar uma ou alterar uma maquina usando recursos ao seu redor ou seu proprio corpo(caso seja possivel), o que a maquina faz deve ser combinado com o mestre', cost: 60),
    Powers(name: 'Mente Cibernética', description: 'Permite que voce invada sistemas com a sua mente substituindo testes de pericia por uma jogada de ataque', cost: 60),
    Powers(name: 'PEM', description: 'Permite que voce use um ataque que atinge uma área igual aos seus graus de área que causa dano dobrado em qualquer coisa tecnologica e as desliga com um teste de vontade cd inteligencia + 1/2 nivel', cost: 60),
    Powers(name: 'Pente de RAM', description: 'Faz com que voce tenha um pente de ran que é igual ao dobro da sua inteligencia, ter RAM te permite usar hacks rapidos, voce regenera 1/8 de RAM por tuno por cada grau deste poder', cost: 20),
    Powers(name: 'Curto Circuito', description: '4 DE RAM\n Usa um ataque para descarregar uma corrente eletrica nos circuitos ou no cerebro do alvo fazendo quem que ele recebe +4 de dano por grau de dano recebido por 1 rodada.', cost: 60),
    Powers(name: 'Desabilitar Arma', description: '6 DE RAM\nVoce usa um ataque para causar uma interferencia eletrica que pode atingir o cerebro ou os sistemas do alvo fazendo que ele solte a arma que esta usando ou tenha desvantagem em ataques no proximo turno', cost: 60),
    Powers(name: 'Esgotamento de Sinápse', description: '10 DE RAM\nO alvo faz um teste de vontade contra seu ataque, caso falhe ele perde 10% da vida maxima e metade da sua vontade total até o final do seu proximo turno', cost: 60),
    Powers(name: 'Reiniciar Optica', description: '6 DE RAM\nVoce cega o alvo fazendo com que tenha vantagem nos ataques contra ele a menos que ele tenha detectar.', cost: 60),
    Powers(name: 'Defeito de Cibernética', description: '10 DE RAM\nVoce faz um ataque contra a força de vontade do alvo, caso acerte voce desabilita todos os poderes de arvores do alvo por 1 turno.', cost: 60),
    Powers(name: 'Aprimoramento Cibernetico', description: '4 DE RAM MAXIMA\nRecebe graus de dano iguais aos seus graus de RAM', cost: 60),
    Powers(name: 'Turbinagem', description: '4 DE RAM\nUsa uma ação bonus para receber 1/4 da sua inteligencia como acerto e 3x ela em vida temporaria por 2 turnos', cost: 60),
    Powers(name: 'Corta Cura', description: 'Faz com que o alvo cure 1/4 a menos para cada grau comprado', cost: 100),
    Powers(name: 'Cura', description: 'Usa uma ação para curar em 1d6 para cada grau de cura', cost: 15),
    Powers(name: 'Dano', description: 'Causa 1d6 de dano para cada grau comprado em um ataque', cost: 15),
    Powers(name: 'Dano por Turno', description: 'Causa 1d4 de dano no alvo toda vez que um turno se passa no combrat por até 1/4 dos graus comprados de dano por turno de vezes', cost: 15),
    Powers(name: 'Defender', description: 'Reduz o dano recebido de um ataque em 2 para cada grau comprado', cost: 15),
    Powers(name: 'Desintegrar', description: 'Permite ao usuário destruir equipamentos dos inimigos mais facilmente, caso o ataque passe da vontade do criador +10 + o tier do item ele é destruido', cost: 100),
    Powers(name: 'Clone', description: 'Permite ao usuário criar um cole de si mesmo, que possui metade da sua ficha', cost: 600),
    Powers(name: 'Substituição', description: 'Permite fazer com que seu clone recebe todos os ataques por voce, caso seu clone seja destruido dessa forma ele não pode mais ser refeito até o final da cena', cost: 400),
    Powers(name: 'Auxiliar', description: 'Pode abrir mão das ações do clone para ter vantagem nas suas até o final do turno', cost: 400),
    Powers(name: 'Desacelerar', description: 'O alvo perde 1 de esquiva / bloqueio por rodada', cost: 100),
    Powers(name: 'Desacordar', description: 'Caso seu ataque seja um critico voce pode fazer com que o alvo role um teste de vontade caso falhe ele dorme por 1 rodada.', cost: 100),
    Powers(name: 'Detectar', description: 'Te permite enxergar por todo seu alcance coisas relacionadas ao seu poder.', cost: 100),
    Powers(name: 'Esconder', description: 'Voce pode com uma reação se esconder por 1 rodada não podendo ser alvo de nd ate ela acabar.(teste de furtuvidade).', cost: 100),
    Powers(name: 'Paralizar', description: 'Caso seu ataque seja um critico pode givar o dano do critico para tentar paralizar o alvo, fazendo que ele faça um teste de vontade caso falhe ele fica paralizado por 1 rodada.', cost: 100),
    Powers(name: 'Escalonamento', description: 'Permite que voce defina uma condição em conjunto com o mestre, toda vez que essa condição é cumprida voce recebe graus em até 2 poderes a sua escolha.\nMenos escalonamento, acerto, bloqueio, esquiva, combate mental, e nenhum atributo a não ser vigor', cost: 80),
    Powers(name: 'Imunidade', description: 'Permite que voce escolha um tipo de dano ppara cada grau desse poder comprado, voce passa a receber metade do dano deles', cost: 80),
    Powers(name: 'Teleporte', description: 'Permite ao usuario se teleportar usando seus graus de alcance ou mover-se como distancia maxima. Tambem permite que o usuario leve pessoas com ele com a mesma regra de mover algo.', cost: 80),
    Powers(name: 'Manipulação Elemental', description: 'Representa seus graus de Manipulação Elementalç', cost: 50),
    Powers(name: 'Golpe elemental', description: 'Permite aplicar seu poder elemental em seu ataque aplicando metade dos seus graus de manipulação elemental no dano. (Manipulação 6 adiciona 3d6 no dano)', cost: 80),
    Powers(name: 'Aprimoramento elemental', description: 'Permite o personagem aprimorar seus ataques mais ainda somando o dobro de seus graus em Dano fixo (Manipulação 5 soma 10 no dano fixo)', cost: 80),
    Powers(name: 'Esfera elemental', description: 'Aumenta o multiplicador de critico em 1', cost: 80),
    Powers(name: 'Prisão elemental', description: 'O personagem pode fazer um ataque contra a esquiva do personagem para restringi-lo com o elemento. Caso acerte o alvo fica preso tendo seu movimento zerado, perde suas reações e ele fica limitada a uma ação por turno. O alvo pode fazer um Clash de ataque contra o personagem para se libertar no começo de seu turno, caso ele ganhe ele se liberta e seu turno segue normalmente, caso ele perca ele permanece preso.', cost: 80),
    Powers(name: 'Fisiologia elemental', description: 'Permite ao personagem transformar seu corpo no elemento para evitar ataques ou se esgueirar por locais pequenos. O personagem pode gastar sua reação para diminuir seu grau de manipulação elemental na rolagem de dano de um inimigo que tenha o acertado.', cost: 80),
    Powers(name: 'Zona elemental', description: 'Permite o personagem moldar o ambiente ao redor para potencializar seu poder elemental. O personagem pode gastar uma ação bônus para criar uma área de 6 metros + seu grau de área caso tenha. Dentro da área ele recebe os seguintes benefícios: Recebe Mover-se e Defender iguais seus graus de manipulação elemental.', cost: 80),
    Powers(name: 'Consumir elemento', description: 'Permite usar uma ação para se curar em 5 por grau de manipulação elemental.', cost: 80),
    Powers(name: 'Moldar grandes quantidades', description: 'O personagem pode controlar grandes quantidade do elemento e manipular o estado da matéria do elemento para criar pontes, mover o elemento ou apagar ele, objetos e abrir caminhos na área com o elemento. O personagem recebe graus de Alcance ou Área de efeito igual ao grau de manipulação elemental.', cost: 80),
    Powers(name: 'Barreira elemental', description: 'Permite gastar uma reação para criar uma barreira com seu elemental para você ou um aliado dando a ele 5 de vida temporária por grau de manipulação durante 1 turno.', cost: 80),
    Powers(name: 'Mestre elemental', description: 'O controle do elemento do personagem é elevado a seu potencial maior concedendo ao personagem uma habilidade elemental única ao elemento controlado.', cost: 80),
    Powers(name: 'Gravidade', description: 'Representa seus graus de gravidade comprados, lembrando que cada poder tambem conta como 1 grau', cost: 40),
    Powers(name: 'Aumento de Força G', description: 'Sempre que seu ataque atinge o alvo ele perde 1/4 do deslocamento.', cost: 80),
    Powers(name: 'Manipulação Gravitacional', description: 'Permite o personagem manipular a gravidade ao seu redor a vontade recebendo metade dos seus graus de gravidade em mover algo.', cost: 80),
    Powers(name: 'Amplificação Gravitacional', description: 'Recebe graus de dano iguais a metade dos seus graus de gravidade.', cost: 80),
    Powers(name: 'Agravamento', description: 'Recebe dano fixo igual a sua manipulação gravitacional total.', cost: 80),
    Powers(name: 'MUGEN', description: 'O personagem pode usar sua reação para criar uma barreira invisível entre ele e seu oponente bloqueando completamente o dano de 1 ataque.', cost: 80),
    Powers(name: 'Ancora Gravitacional', description: 'Recebe metade da sua manipulação gravitacional em mover-se.', cost: 80),
    Powers(name: 'Gravidade Pessoal', description: 'Recebe defender igual a metade dos seus graus de gravidade.', cost: 80),
    Powers(name: 'Mover-se', description: 'Cada grau aumenta seu deslocamento em 5 metros', cost: 25),
    Powers(name: 'Mover-Algo', description: 'Permite que voce carregue coisas com seu poder, voce pode carregar 1 coisa de tamanho até médio por grau de mover algo, a distancia que voce pode mover é igual ao seu alcance, sua área ou seu deslocamento', cost: 25),
    Powers(name: 'Voar', description: 'Recebe deslocamento de voo igual ao seu normal', cost: 20),
    Powers(name: 'Pular', description: 'Permite que voce pule até 2x o seu deslocamento usando 1 ação de movimento', cost: 20),
    Powers(name: 'Percepção Acelerada', description: 'Recebe 1/5 do seu mover-se em prontidão e procurar.', cost: 80),
    Powers(name: 'Reflexos Melhorados', description: 'Recebe +1 de Atravessar e iniciativa a cada 3 de mover-se.', cost: 80),
    Powers(name: 'Força de Aceleração', description: 'Recebe 1/8 da agilidade em reações e ações bônus.', cost: 80),
    Powers(name: 'Pensamento Rapido', description: 'Recebe 1/4 do mover-se em testes de inteligencia.', cost: 80),
    Powers(name: 'Imparavel', description: 'Quando alvo de um efeito que diminui seu deslocamento recebe 1 ação de movimento adicional e o efeito é cortado pela metade.', cost: 80),
    Powers(name: 'Metamorfose', description: 'Permite o personagem assumir formas que podem auxiliar ele durante a luta.\n\nForma Ágil: Voce recebe 1/2+2 nível em agilidade.\nForma Feroz: Voce recebe 1/2+2 nível em força.\nForma Resistente: Voce recebe seu nível em bloqueio / esquiva.\nForma Sorrateira: Voce recebe a habilidade de usar o ataque furtivo do ladino alem de 1/3+2 nível de acerto.\nForma Veloz: Voce recebe mover-se igual ao seu nível e 1/3+2 nível em acerto.', cost: 50),
    Powers(name: 'Anular', description: 'Permite que voce anule 1/4 dos graus de um poder de um inimigo sempre que atinge ele', cost: 100),
    Powers(name: 'Regeneração', description: 'Permite que voce se cure em 1 para cada grau de regeneração toda vez que um turno se passa no combate', cost: 15),
    Powers(name: 'Tranferir', description: 'Com uma ação bonus voce pode transferir 1 grau de um poder para outro, voce pode fazer isso até o seu grau de transferir de vezes', cost: 25),
    Powers(name: 'Som', description: 'Representa quantos graus de som voce tem comprado', cost: 40),
    Powers(name: 'Aceleração Sonora', description: 'Recebe mover-se igual ao seu grau de som.', cost: 80),
    Powers(name: 'Intensificação Sonora', description: 'Recebe graus de dano iguais aos seus graus de som.', cost: 80),
    Powers(name: 'Reverberação', description: 'Para cada alvo atingido no ataque o dano aumenta em 1/4.', cost: 80),
    Powers(name: 'Anulação Sonora', description: 'Os alvos atingidos pelos seus ataques perdem 1 de percepção por rodada conforme perdem a audição.', cost: 80),
    Powers(name: 'Silenciar', description: 'O alvo faz um teste de prontidão. Caso falhe ele fica silenciado, caso ele tente falar ele recebe 1 ataque seu com dano maximizado.', cost: 80),
    Powers(name: 'Anulação Sonora', description: 'Recebe 1/4 dos seus graus de som em furtividade.', cost: 80),
    Powers(name: 'Ecolocalização', description: 'Recebe 1/6 dos graus de som em procurar, rastrear e prontidão.', cost: 80),
    Powers(name: 'Terremoto', description: 'Caso seu ataque seja um crítico pode converter esse crítico para um terremoto causando o dano dele em uma área igual seu grau de som.', cost: 80),
    Powers(name: 'Tempo', description: "Representa quantos graus de tempo voce tem comprados", cost: 40),
    Powers(name: 'Existência Fora do Fluxo', description: 'O personagem é imune a mudanças na linha do tempo e sabe quando elas acontecem.', cost: 100),
    Powers(name: 'Rebobinar', description: 'Pode gastar todo seu turno para voltar a como estava no inicio do combate. (1 vez por combate)', cost: 100),
    Powers(name: 'Quebra no tempo', description: 'Permite ao usuário causar dano adicional em todos os ataques igual ao seu grau de tempo.', cost: 100),
    Powers(name: 'Prever', description: 'O player pode tentar adivinhar algo na sessão. Se de fato acontecer, recebe 1 ponto heroico.', cost: 100),
    Powers(name: 'Isolamento Temporal', description: 'Com uma ação voce se para no tempo, não podendo agir mas também não podendo ser alvejado até que ele acabe. Dura até 6 turnos.', cost: 100),
    Powers(name: 'Congelamento Temporal', description: 'Pode gastar todo seu turno para parar o inimigo no tempo por até 1 minuto.', cost: 100),
    Powers(name: 'Postura Defensiva', description: 'Permite usar uma ação e receber +2 de bloqueio e esquiva até o final da cena', cost: 40),
    Powers(name: 'Resistir', description: 'Permite ao personagem que continue de pe depois de sua vida cair a baixo de 0 enquanto estiver consciente e em combate, o personagem pode resistir a até 1/4 da vida negativa por grau comprado', cost: 150),
    Powers(name: 'Sentidos Melhorados', description: 'O personagem aumenta em 1/3 do nivel seu bonus em todas as pericias pelo resto da ceno ou entrar em combate', cost: 80),
    Powers(name: 'Telecinese', description: 'Representa seus graus comprados de Telecinese', cost: 40),
    Powers(name: 'Proteção', description: 'Recebe defender igual a metade dos graus de telecinese.', cost: 80),
    Powers(name: 'Agressão', description: 'Recebe dano igual a metade dos graus de telecinese.', cost: 80),
    Powers(name: 'Mente Afiada', description: 'Permite somar a inteligência ou vontade como dano fixo nos ataques.', cost: 80),
    Powers(name: 'Detecção Aprimorada', description: 'Voce não pode ser surpreendido.', cost: 80),
    Powers(name: 'Chamado de Arma', description: 'Pode convocar sua arma de qualquer lugar.', cost: 80),
    Powers(name: 'Telepatico', description: 'Permite conversar com qualquer pessoa por pensamento, também permite fazer um clash contra o alvo, se passar pode ler suas memorias pelo restante do turno.', cost: 80),
    Powers(name: 'Vampirismo', description: 'Permite se curar em 1/4 do dano causado por grau de vampirismo', cost: 100),
  ];
  @override
  Widget build(BuildContext context){
    final selected = allPowers.where((a) => a.selected).toList();
    final general = allPowers.where((a) => !a.selected).toList();
    return Scaffold(
      appBar: AppBar(title: Text('Poderes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),backgroundColor: Colors.deepPurple[900],),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Xp Disponivel = 0', style: TextStyle(color: Colors.white, fontSize: 22,),textAlign: TextAlign.end,),
            Text('Selecionados', style: TextStyle( color: Colors.white, fontSize: 22),),
            Wrap(
                spacing: 4,
                runSpacing: 4,
                children: selected.map((a) =>
                    PowerCards(
                      name: a.name,
                      cost: a.cost,
                      description: a.description,
                      selected: a.selected,
                      onChanged: (val){
                        setState(() => a.selected = val ?? false);
                      },
                    )
                ).toList()
            ),
            Divider(color: Colors.white,),
            Text('Todos', style: TextStyle(color: Colors.white, fontSize: 22),),
            Wrap(
                spacing: 4,
                runSpacing: 4,
                children: general.map((a) =>
                    PowerCards(
                      name: a.name,
                      description: a.description,
                      selected: a.selected,
                      cost: a.cost,
                      onChanged: (val){
                        setState(() => a.selected = val ?? false);
                      },
                    )
                ).toList()
            ),
          ],
        ),
      ),
    );
  }
}

