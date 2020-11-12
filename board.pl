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
      [empty,empty,empty,orange,empty,empty],           %even
    [empty,empty,empty,empty,empty,empty,empty],       %odd
      [empty,empty,empty,empty,empty,empty],           %even
    [empty,empty,empty,empty,empty,empty,empty],       %odd
      [empty,empty,empty,empty,empty,empty],           %even
    [empty,empty,empty,empty,empty,empty,empty],
      [empty,green,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty],
      [empty,empty,empty,empty,empty,empty],
    [empty,empty,purple,empty,empty,empty,empty],
      [empty,empty,empty,empty,empty,empty],
        [empty,empty,empty,empty,empty],
      [empty,empty,empty,empty,empty,empty],
        [empty,empty,empty,empty,empty],
          [empty,empty,empty,empty],
            [empty,empty,empty],
              [orange,orange]
]).


cell_val(orange, 'O').
cell_val(green, 'G').
cell_val(purple, 'P').
cell_val(empty, ' ').

diagonal_index(0,0).
diagonal_index(1,0).
diagonal_index(2,0).
diagonal_index(3,0).
diagonal_index(4,0).
diagonal_index(5,1).
diagonal_index(6,1).
diagonal_index(7,1).
diagonal_index(8,2).
diagonal_index(9,2).
diagonal_index(10,3).
diagonal_index(11,3).
diagonal_index(12,4).
diagonal_index(13,4).
diagonal_index(14,5).
diagonal_index(15,5).
diagonal_index(16,6).
diagonal_index(17,7).
diagonal_index(18,7).
diagonal_index(19,8).
diagonal_index(20,9).
diagonal_index(21,10).
diagonal_index(22,11).

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

start_value(0,'    ___/ ').
start_value(1,'    ___/ ').
start_value(2,'org ___/ ').
start_value(3,'    ___/ ').
start_value(4,'       / ').
start_value(5,'   \\___/ ').
start_value(6,'    ___/ ').
start_value(7,'       / ').
start_value(8,'   \\___/ ').
start_value(9,'       / ').
start_value(10,'   \\___/ ').
start_value(11,'   grn / ').
start_value(12,'   \\___/ ').
start_value(13,'       / ').
start_value(14,'   \\___/ ').
start_value(15,'       / ').
start_value(16,'   \\___/ ').
start_value(17,'   \\___/ ').
start_value(18,'       / ').
start_value(19,'   \\___/ ').
start_value(20,'   \\___/ ').
start_value(21,'prp\\___/ ').
start_value(22,'   \\___/ ').

end_value(0,'___    ').
end_value(1,'___    ').
end_value(2,'___ prp').
end_value(3,'___    ').
end_value(4,'    ').
end_value(5,'___/    ').
end_value(6,'___    ').
end_value(7,'    ').
end_value(8,'___/    ').
end_value(9,'    ').
end_value(10,'___/    ').
end_value(11,' grn').
end_value(12,'___/    ').
end_value(13,'    ').
end_value(14,'___/    ').
end_value(15,'    ').
end_value(16,'___/    ').
end_value(17,'___/    ').
end_value(18,'    ').
end_value(19,'___/    ').
end_value(20,'___/    ').
end_value(21,'___/ org').
end_value(22,'___/    ').


% gotten from https://stackoverflow.com/questions/8519203/prolog-replace-an-element-in-a-list-at-a-specified-index/8544713
replace_val([_|T], 0, X, [X|T]).
replace_val([H|T], I, X, [H|R]):- 
  I > 0, 
  I1 is I-1, 
  replace_val(T, I1, X, R).


max_length_odd(7).    
max_length_even(6).

writeNspaces(0).
writeNspaces(X):-
    write(' '),
    NX is X-1,
    (
      (
        NX<0,
        writeNspaces(0)
      );
      (
        writeNspaces(NX)
      )
    ).

display_top([]).
display_top(H) :-
    display_top(T).

display_piece([],Nrow,NPiece).
display_piece(H,Nrow,NPiece) :-
    [V | T] = H,
    (
      (
        (NPiece == 0),
        start_value(Nrow,X),
        write(X)
      );
      write('___/ ')
    ),
    cell_val(V,Piece),
    write(Piece),
    write(' \\'),
    display_piece(T,Nrow,1).


display_bottom([]).
display_bottom(H) :-
    display_bottom(T).

close_hex_top:-
    S is 28,
    writeNspaces(S),
    write('___'),
    M is 5,
    writeNspaces(M),
    write('___'), nl.

close_hex_bot:-
    writeNspaces(27),
    write('\\___/'),
    writeNspaces(3),
    write('\\___/'), nl.


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
    display_piece(H,NRow,0), 
    end_value(NRow,Line),
    write(Line),
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
    close_hex_bot,
    display_player(Player),
    display_remaining_pieces,
    display_alliances.

valid_line(Line):-
    number(Line),
    Line >= 0,
    Line =< 22.
  
valid_diagonal(Diagonal):-
    number(Diagonal),
    Diagonal >= 0,
    Diagonal =< 12.

valid_color(Color):-
    atom(Color),
    (
      Color == 'O';
      Color == 'G';
      Color == 'P'
    ).

get_line(Line):-
    repeat,
        write('Insert move line (0-22): '),
        read(Line),
        valid_line(Line),!.

get_diagonal(Diagonal):-
    repeat,
        write('Insert move diagonal (0-12): '),
        read(Diagonal),
        valid_diagonal(Diagonal),!.
  
get_color(Color):-
    repeat,
        write('Insert move color (O,P,G): '),
        read(Aux),
        valid_color(Aux),
        (
          (
            Aux == 'O',
            Color = orange
          );
          (
            Aux == 'P',
            Color = purple
          );
          (
            Aux == 'G',
            Color = green
          )
        ),!.

get_move([Line,Diagonal,Color]):-
    get_line(Line), 
    get_diagonal(Diagonal), 
    get_color(Color).

getRow([Row|T],0,Row,[NewRow|T],Move):-
    [InitialRow|V] = Move,
    [Diagonal|R] = V,
    diagonal_index(InitialRow,X),
    Replace is Diagonal-X,
    [Color|H] = R,
    replace_val(Row,Replace,Color,NewRow).

getRow([H|T],RowNumber,Row,[H|NewGameState],Move):-
    NewRowNumber is RowNumber-1,
    getRow(T,NewRowNumber,Row,NewGameState,Move).

move(GameState, Move, NewGameState):-
    [RowNumber|T] = Move,
    diagonal_index(RowNumber,FirstDiagonalIndex),
    getRow(GameState,RowNumber,Row,NewGameState,Move).

game_loop(GameState,Player):-
    display_game(GameState,Player),
    get_move(Move),
    move(GameState, Move, NewGameState),
    update_player(Player),
    game_loop(NewGameState,Player).
      

play :-
    prompt(_,''),
    player(Player),
    initial(GameState),
    game_loop(GameState,Player).
    
