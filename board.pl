:- dynamic player/1.
:- dynamic initial/1.

initial([
    [nodef, nodef, nodef, nodef, nodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef, nodef, nodef, nodef, nodef]   ,
    [nodef, nodef, nodef, nodef, space, empty, empty, empty, empty, empty, nodef, nodef, nodef, nodef],
    [nodef, nodef, orangeBoardNodef, empty, empty, empty, empty, empty, empty, empty, empty, greeneBoardSpace, nodef, nodef],
    [nodef, nodef, orangeBoardSpace, empty, empty, empty, empty, empty, empty, empty, empty, empty, greeneBoardSpace, nodef],
    [nodef, orangeBoardNodef, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, greeneBoardSpace, nodef],
    [nodef, orangeBoardSpace, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, greeneBoardSpace],
    [orangeBoardNodef, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, greeneBoardSpace],
    [nodef, space, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],
    [greenBoardNodef, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, orangeBoardSpace],
    [nodef, greeneBoardSpace, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, orangeBoardSpace],
    [nodef, greenBoardNodef, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, orangeBoardSpace, nodef],
    [nodef, nodef, greeneBoardSpace, empty, empty, empty, empty, empty, empty, empty, empty, empty, orangeBoardSpace, nodef],
    [nodef, nodef, greenBoardNodef, empty, empty, empty, empty, empty, empty, empty, empty, orangeBoardSpace, nodef, nodef],
    [nodef, nodef, nodef, nodef, space, empty, empty, empty, empty, empty, nodef, nodef, nodef, nodef],
    [nodef, nodef, nodef, nodef, nodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef, nodef, nodef, nodef, nodef]
]).

player(0).

cell_val(orangeBoardSpace,'org').
cell_val(orangeBoardNodef,'   org').
cell_val(greeneBoardSpace,'grn').
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
    

display_game([],Player).
display_game(GameState,Player) :-
    [H | T] = GameState,
    display_line(H),
    display_game(T,Player).

display_player(Player):-
    P is Player+1,
    write('Current Player: ') , write(P), nl.

update_player(Player):-
    P is mod(Player+1,2),
    retract(player(_)),
    assert(player(P)).

display_pieces :-
    write('Current Orange Pieces Left: 42'), nl,
    write('Current Purple Pieces Left: 42'), nl,
    write('Current Green Pieces Left: 42'), nl.

play :-
    player(Player),
    initial(GameState),
    display_game(GameState,Player),
    display_player(Player),
    display_pieces,
    update_player(Player).
