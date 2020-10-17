initial([
    [nodef, nodef, nodef, space, empty, empty, empty, empty, empty, nodef, nodef, nodef],
    [nodef, nodef, empty, empty, empty, empty, empty, empty, empty, empty, nodef, nodef],
    [nodef, space, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],
    [nodef, empty, empty, empty, empty, orange, empty, empty, empty, empty, empty, nodef],
    [space, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [space, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [space, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [nodef, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],
    [nodef, space, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],
    [nodef, nodef, empty, empty, empty, empty, empty, empty, empty, empty, nodef, nodef],
    [nodef, nodef, nodef, space, empty, empty, empty, empty, empty, nodef, nodef, nodef]
]).

cell_val(orange, 'O').
cell_val(empty, ' ').
cell_val(nodef, '      ').
cell_val(space, '   ').


display_top([]).
display_top(H) :-
    [V | T] = H,
    (
        (
            V\=nodef,
            V\=space,
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
            V\=nodef,
            V\=space,
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
            V\=nodef,
            V\=space,
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

play :-
    initial(GameState),
    display_game(GameState,1).
