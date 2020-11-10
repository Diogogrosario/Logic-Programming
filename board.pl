
% oldBoard([
%     [nodef, nodef, nodef, nodef, nodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef,    purpleBoardNodef, nodef, nodef, nodef, nodef],
%     [nodef, nodef, nodef, nodef, space,                 empty, empty, empty, empty, empty,                         nodef, nodef, nodef, nodef],
%     [nodef, nodef, orangeBoardNodef,         empty, empty, empty, empty, empty, empty, empty, empty,               greenBoardSpace, nodef, nodef],
%     [nodef, nodef, orangeBoardSpace,      empty, empty, empty, empty, empty, empty, empty, empty, empty,           greenBoardSpace, nodef],
%     [nodef, orangeBoardNodef,          empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,       greenBoardSpace, nodef],
%     [nodef, orangeBoardSpace,      empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,    greenBoardSpace],
%     [orangeBoardNodef,         empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, greenBoardSpace],
%     [nodef, space,               empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,      nodef],
%     [greenBoardNodef,          empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, orangeBoardSpace],
%     [nodef, greenBoardSpace,      empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,     orangeBoardSpace],
%     [nodef, greenBoardNodef,           empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,       orangeBoardSpace, nodef],
%     [nodef, nodef, greenBoardSpace,       empty, empty, empty, empty, empty, empty, empty, empty, empty,           orangeBoardSpace, nodef],
%     [nodef, nodef, greenBoardNodef,          empty, empty, empty, empty, empty, empty, empty, empty,               orangeBoardSpace, nodef, nodef],
%     [nodef, nodef, nodef, nodef, space,                 empty, empty, empty, empty, empty,                         nodef, nodef, nodef, nodef],
%     [nodef, nodef, nodef, nodef, nodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef, purpleBoardNodef,    purpleBoardNodef, nodef, nodef, nodef, nodef]
% ]).

:- dynamic player/1.

player(0).

update_player(Player):-
    P is mod(Player+1,2),
    retract(player(_)),
    assert(player(P)).

:- dynamic initial/1.

initial([
              [empty,empty],                           %even
            [empty,empty,empty],                       %odd
          [empty,empty,empty,empty],                   %even
        [empty,empty,empty,empty,empty],               %odd
      [empty,empty,empty,empty,empty,empty],           %even
        [empty,empty,empty,empty,empty],               %odd
      [empty,empty,empty,empty,empty,empty],           %even
    [empty,empty,empty,empty,empty,empty,empty],       %odd
      [empty,empty,empty,empty,empty,empty],           %even
    [empty,empty,empty,empty,empty,empty,empty],       %odd
      [empty,empty,empty,empty,empty,empty],           %even
    [empty,empty,empty,empty,empty,empty,empty],
      [empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty],
      [empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty],
      [empty,empty,empty,empty,empty,empty],
        [empty,empty,empty,empty,empty],
      [empty,empty,empty,empty,empty,empty],
        [empty,empty,empty,empty,empty],
          [empty,empty,empty,empty],
            [empty,empty,empty],
              [empty,empty]
]).


    %         ___     ___
    %     ___/   \___/   \___
    % ___/   \___/   \___/   \___
    %    \___/   \___/   \___/
    %        \___/   \___/   \___/


cell_val(orange, 'O').
cell_val(green, 'G').
cell_val(purple, 'P').
cell_val(empty, ' ').

even_row(0).
even_row(2).
even_row(4).
even_row(6).
even_row(8).
even_row(10).
even_row(2).
even_row(14).
even_row(16).
even_row(18).
even_row(20).
even_row(22).

odd_row(1).
odd_row(3).
odd_row(5).
odd_row(7).
odd_row(9).
odd_row(11).
odd_row(13).
odd_row(15).
odd_row(17).
odd_row(19).
odd_row(21).
odd_row(23).

max_length_odd(7).    
max_length_even(6).

writeNspaces(0).
writeNspaces(X):-
    write(' '),
    NX is X-1,
    writeNspaces(NX).

display_top([]).
display_top(H) :-
    display_top(T).

display_piece([],NRow).
display_piece(H,Nrow) :-
    [V | T] = H,
    write('___/ '),
    cell_val(V,Piece),
    write(Piece),
    write(' \\'),
    display_piece(T,Nrow).


display_bottom([]).
display_bottom(H) :-
    display_bottom(T).

close_hex_top:-
    writeNspaces(24),
    write('___'),
    writeNspaces(5),
    write('___'), nl.

display_line(H,NRow) :-
    %display_top(H), nl,

    length(H,L),
    (
      (
        even_row(NRow),
        max_length_even(X),
        N is (X - L) * 4,
        writeNspaces(4+N)
      );
      (
        max_length_odd(X),
        N is (X - L) * 4,
        writeNspaces(N)
      )
    ),
    display_piece(H,NRow), 
    write('___'),
    write('       '), write(NRow), nl.
    %display_bottom(H), nl.
    

display_board([],Player,NewRow).
display_board(GameState,Player,NRow) :-
    [H | T] = GameState,
    display_line(H,NRow),
    NewRow is NRow+1,
    display_board(T,Player,NewRow).

display_player(Player):-
    P is Player+1,
    write('Current Player: ') , write(P), nl.

display_remaining_pieces :-
    write('Current Orange Pieces Left: 42'), nl,
    write('Current Purple Pieces Left: 42'), nl,
    write('Current Green Pieces Left: 42'), nl.

display_alliances:-
    write('Player 1 alliances: To connect Orange: Orange-Green, to connect Green: Green-Purple, to connect Purple: Purple-Orange'), nl,
    write('Player 2 alliances: To connect Orange: Orange-Purple, to connect Green: Green-Orange, to connect Purple: Purple-Green'), nl.

display_game(GameState,Player):-
    close_hex_top,
    display_board(GameState,Player,0),
    display_player(Player),
    display_remaining_pieces,
    display_alliances,
    update_player(Player).

play :-
    player(Player),
    initial(GameState),
    display_game(GameState,Player).
    
