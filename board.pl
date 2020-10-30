:- dynamic player/1.
:- dynamic initial/1.

initial([
    [nodef, nodef, nodef, nodef, nodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef, nodef, nodef, nodef, nodef],
    [nodef, nodef, nodef, nodef, space,                 empty, empty, empty, empty, empty,                         nodef, nodef, nodef, nodef],
    [nodef, nodef, orangeBoardNodef,         empty, empty, empty, empty, empty, empty, empty, empty,               greenBoardSpace, nodef, nodef],
    [nodef, nodef, orangeBoardSpace,      empty, empty, empty, empty, empty, empty, empty, empty, empty,           greenBoardSpace, nodef],
    [nodef, orangeBoardNodef,          empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,       greenBoardSpace, nodef],
    [nodef, orangeBoardSpace,      empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,    greenBoardSpace],
    [orangeBoardNodef,         empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, greenBoardSpace],
    [nodef, space,               empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,      nodef],
    [greenBoardNodef,          empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, orangeBoardSpace],
    [nodef, greenBoardSpace,      empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,     orangeBoardSpace],
    [nodef, greenBoardNodef,           empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,       orangeBoardSpace, nodef],
    [nodef, nodef, greenBoardSpace,       empty, empty, empty, empty, empty, empty, empty, empty, empty,           orangeBoardSpace, nodef],
    [nodef, nodef, greenBoardNodef,          empty, empty, empty, empty, empty, empty, empty, empty,               orangeBoardSpace, nodef, nodef],
    [nodef, nodef, nodef, nodef, space,                 empty, empty, empty, empty, empty,                         nodef, nodef, nodef, nodef],
    [nodef, nodef, nodef, nodef, nodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef, nodef, nodef, nodef, nodef]
]).

player(0).

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


display_top([]).
display_top(H) :-
    [V | T] = H,
    (
        (
            (V=empty;V=orange;V=green;V=purple),
            write(' ____ ')
        );
        (
            cell_val(V,X),
            write(X)
        )
    ),
    display_top(T).

display_mid([]).
display_mid(H) :-
    [V | T] = H,
    (
        (
            (V=empty;V=orange;V=green;V=purple),
            cell_val(V,X),
            put_code(9585),write(' '), write(X), write('  ') , put_code(9586)
        );
        (
            cell_val(V,X),
            write(X)
        )
    ),
    display_mid(T).


display_bottom([]).
display_bottom(H) :-
    [V | T] = H,
    (
        (
            (V=empty;V=orange;V=green;V=purple),
            cell_val(V,X),
            put_code(9586),write('____') , put_code(9585)
        );
        (
            cell_val(V,X),
            write(X)
        )
    ),
    display_bottom(T).

display_line(H) :-
    display_top(H), nl,
    display_mid(H), nl,
    display_bottom(H), nl.
    

display_board([],Player).
display_board(GameState,Player) :-
    [H | T] = GameState,
    display_line(H),
    display_board(T,Player).

display_player(Player):-
    P is Player+1,
    write('Current Player: ') , write(P), nl.

update_player(Player):-
    P is mod(Player+1,2),
    retract(player(_)),
    assert(player(P)).

display_remaining_pieces :-
    write('Current Orange Pieces Left: 42'), nl,
    write('Current Purple Pieces Left: 42'), nl,
    write('Current Green Pieces Left: 42'), nl.

display_alliances:-
    write('Player 1 alliances: To connect Orange: Orange-Green, to connect Green: Green-Purple, to connect Purple: Purple-Orange'), nl,
    write('Player 2 alliances: To connect Orange: Orange-Purple, to connect Green: Green-Orange, to connect Purple: Purple-Green'), nl.

display_game(GameState,Player):-
    display_board(GameState,Player),
    display_player(Player),
    display_remaining_pieces,
    display_alliances,
    update_player(Player).

play :-
    player(Player),
    initial(GameState),
    display_game(GameState,Player).
    
