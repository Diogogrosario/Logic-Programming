# Alliances-5

## Grupo Alliances_5 Turma 3
Diogo Guimarães do Rosário - 201806582  
Henrique Melo Ribeiro - 201806529

## Alliances
O objetivo final do jogo é ganhar 2 cores, isto é, unir totalmente 2 cores de um lado ao outro do tabuleiro usando essa cor e a cor aliada. 
A cor aliada é definida no início do jogo e varia entre os jogadores.
Para ganhar a cor laranja, um dos jogadores terá que fazer um caminho ininterrupto usando apenas peças laranja ou peças laranja e a sua cor aliada. 
Adicionalmente, o jogador poderá bloquear o caminho ao adversário, ganhando essa cor, visto que será impossível de criar um caminho usando essa cor e a aliada.
Existem 42 peças de cada cor (laranja, verde e roxo) que são partilhadas entre os 2 jogadores.
As peças podem ser colocadas em qualquer casa vazia.

## Representação interna do jogo
É usada uma lista de listas para guardar o estado do jogo. <br /><br />
### Estado Inicial
![Initial Board Representation](./images/initialBoard.png) <br />
O jogador atual e o número de peças restantes de cada cor são representados no fundo do board, bem como as alianças para as cores de cada jogador.
As casas vazias são representados pelo valor empty, enquanto que as peças são representadas por 1 dos 3 seguintes valores - orange, green, purple. 
Outros átomos são usados apenas para facilitar a representação do board tendo em conta os espaços livres.
```prolog
cell_val(orangeBoardSpace,'org').
cell_val(orangeBoardNodef,'   org').
cell_val(greenBoardSpace,'grn').
cell_val(greenBoardNodef,'   grn').
cell_val(purpleBoardNodef,'prp  ').
cell_val(orange, 'O').
cell_val(green, 'G').
cell_val(purple, 'P').
cell_val(empty, ' ').
cell_val(nodef, '      ').
cell_val(space, '   ').
```
Para a visualização do jogo foram criados os seguintes predicados
```prolog
display_game([],Player).
display_game(GameState,Player) :-
    [H | T] = GameState,
    display_line(H),
    display_game(T,Player).
    
display_line(H) :-
    display_top(H), nl,
    display_mid(H), nl,
    display_bottom(H), nl.
```
Por razões de simplificação de código, o valor da cor do tabuleiro é repetida 3x, uma para cada um dos predicados chamados pelo display_line, de modo a reduzir o número de verificações aquando dos prints.
Estes 3 predicados são responsáveis por ler o valor de cada célula da lista H (que corresponde a uma linha) e imprimir o seu valor, 
por exemplo, para o hexágono o display_top imprime uma sequência de ____ enquanto que o display_mid imprime / O \\, 
no caso da peça colocado nessa célula ser laranja. Já o display_bottom imprime \\___/ de modo a fechar o hexágono.

### Estado Intermédio
![Mid Board Representation](./images/midBoard.png) <br />

### Estado final
![Final Board Representation](./images/endBoard.png) <br />
Neste caso, o jogador 2 ganhou, visto que bloqueou a cor roxa do jogador 1 (é inacessível ao jogador 1 pois a aliança da cor roxa é laranja e terá sempre uma linha verde a bloquear) e uniu com sucesso a cor verde usando verdes e as suas alianças (neste caso, laranja).
