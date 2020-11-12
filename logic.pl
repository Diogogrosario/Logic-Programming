:- include('display.pl').
:- include('input.pl').

:- dynamic player/1.

player(0).

update_player(Player):-
    P is mod(Player+1,2),
    retract(player(_)),
    assert(player(P)).

% gotten from https://stackoverflow.com/questions/8519203/prolog-replace-an-element-in-a-list-at-a-specified-index/8544713
replace_val([_|T], 0, X, [X|T]).
replace_val([H|T], I, X, [H|R]):- 
  I > 0, 
  I1 is I-1, 
  replace_val(T, I1, X, R).

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
    get_move(Move,GameState),
    move(GameState, Move, NewGameState),
    update_player(Player),
    game_loop(NewGameState,Player).
      

play :-
    prompt(_,''),
    player(Player),
    initial(GameState),
    game_loop(GameState,Player).
    