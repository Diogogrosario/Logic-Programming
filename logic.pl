:- include('display.pl').
:- include('input.pl').
:- include('bot.pl').

:- use_module(library(random)).
:- use_module(library(aggregate)).
:- use_module(library(system)).

player(0).


allied(0,orange,green).
allied(1,orange,purple).

allied(0,green,purple).
allied(1,green,orange).

allied(0,purple,orange).
allied(1,purple,green).

at_border(orange, 18, 12).
at_border(orange, 19, 12).
at_border(orange, 20, 12).
at_border(orange, 21, 12).
at_border(orange, 22, 12).

at_border(purple, 0, 1).
at_border(purple, 1, 2).
at_border(purple, 2, 3).
at_border(purple, 3, 4).
at_border(purple, 4, 5).

at_border(green, 7, 7).
at_border(green, 9, 8).
at_border(green, 11, 9).
at_border(green, 13, 10).
at_border(green, 15, 11).


update_player(Player, NewPlayer):-
    NewPlayer is mod(Player+1,2).


getValue(Board,RowNumber,Diagonal,Color):-
    nth0(RowNumber,Board,Row),
    diagonal_index(RowNumber,DiagonalStart),
    DiagonalDiff is Diagonal-DiagonalStart,
    nth0(DiagonalDiff,Row,Color).


% gotten from https://stackoverflow.com/questions/8519203/prolog-replace-an-element-in-a-list-at-a-specified-index/8544713
replace_val([_|T], 0, X, [X|T]).
replace_val([H|T], I, X, [H|R]):- 
  I > 0, 
  I1 is I-1, 
  replace_val(T, I1, X, R).

getRow([Row|T],0,[NewRow|T],Move):-
    [InitialRow|V] = Move,
    [Diagonal|R] = V,
    diagonal_index(InitialRow,X),
    Replace is Diagonal-X,
    [Color|_] = R,
    replace_val(Row,Replace,Color,NewRow).

getRow([H|T],RowNumber,[H|NewBoard],Move):-
    RowNumber > 0,
    NewRowNumber is RowNumber-1,
    getRow(T,NewRowNumber,NewBoard,Move).

move(GameState, Move, NewGameState):-
    [Board | T ] = GameState,
    [RowNumber|_] = Move,
    getRow(Board,RowNumber,NewBoard,Move),
    NewGameState = [NewBoard|T].

count_occurrences(List, X, Count) :- aggregate_all(count, member(X, List), Count).

% If a player has alreay captured two colors he is the winner.
game_over(GameState, Winner):-
    [ _ , ColorsWon | _ ] = GameState, 
    count_occurrences(ColorsWon,0,CountOfZero),
    count_occurrences(ColorsWon,1,CountOfOne),
    (CountOfZero < 2 ; Winner is 0),
    (CountOfOne < 2 ; Winner is 1).

% Checks if the line is valid 
valid_line(Line):-
    number(Line),
    between(0,22,Line).
  
% Checks if the diagonal is valid 
valid_diagonal(Diagonal, D1, D2):-
    number(Diagonal),
    between(D1,D2,Diagonal).
    
% Returns the neighbours of a piece.
getNeighbours(Row,Diagonal,Neighbours):-
    validMove(Row,Diagonal),
    LastRow is Row-1,
    LastLastRow is Row-2,
    NextRow is Row+1,
    NextNextRow is Row+2,
    LastDiagonal is Diagonal-1,
    NextDiagonal is Diagonal+1,
    Neighbours = [[LastRow,Diagonal],[NextRow,NextDiagonal],[LastLastRow,LastDiagonal],[NextNextRow,NextDiagonal],[LastRow,LastDiagonal],[NextRow,Diagonal]].
    

checkOrange(0,_,_,0,_).
checkOrange(1,_,_,1,_).
checkOrange(_,Player,Board,NewOrangeWon,Orange1Length):-
    getOrangePathLength(Player,Board,Orange1Length),
    getNewWon(Player,Orange1Length,NewOrangeWon).

checkPurple(0,_,_,0,_).
checkPurple(1,_,_,1,_).
checkPurple(_,Player,Board,NewPurpleWon,Purple1Length):-
    getPurplePathLength(Player,Board,Purple1Length),
    getNewWon(Player,Purple1Length,NewPurpleWon).

checkGreen(0,_,_,0,_).
checkGreen(1,_,_,1,_).
checkGreen(_,Player,Board,NewGreenWon,Green1Length):-
    getGreenPathLength(Player,Board,Green1Length),
    getNewWon(Player,Green1Length,NewGreenWon).

getNewWon(Player,-1,NewPlayer):-
    NewPlayer is mod(Player+1,2).
getNewWon(Player,0,Player).
getNewWon(_,_,-1).

validMove(Row,Diagonal):-
    valid_line(Row),
    diagonal_index(Row,D1),
    diagonal_index_end(Row,D2),
    valid_diagonal(Diagonal,D1,D2).

updateColorsWon(GameState,NewColorsWon, Player, Length1, Length2):-
    [Board, ColorsWon | _ ] = GameState,
    [OrangeWon, PurpleWon, GreenWon | _ ] = ColorsWon,
    NewP is mod(Player+1,2),

    checkOrange(OrangeWon,Player,Board,NewOrangeWon,Orange1Length),
    checkPurple(PurpleWon,Player,Board,NewPurpleWon,Purple1Length),
    checkGreen(GreenWon,Player,Board,NewGreenWon,Green1Length),
    Length1 = [Orange1Length,Purple1Length,Green1Length],

    checkOrange(NewOrangeWon,NewP,Board,FinalOrangeWon,Orange2Length),
    checkPurple(NewPurpleWon,NewP,Board,FinalPurpleWon,Purple2Length),
    checkGreen(NewGreenWon,NewP,Board,FinalGreenWon,Green2Length),
    Length2 = [Orange2Length,Purple2Length,Green2Length],

    NewColorsWon = [FinalOrangeWon,FinalPurpleWon,FinalGreenWon].

updateNPieces(Move,NPieces,NewNPieces):-
    [_,_,Color|_] = Move,
    [OrangePieces, PurplePieces, GreenPieces | _] = NPieces,
    (
        (
            (Color == orange),
            O is OrangePieces-1,
            NewNPieces = [O,PurplePieces,GreenPieces]
        );
        (
            (Color == purple),
            P is PurplePieces-1,
            NewNPieces = [OrangePieces,P,GreenPieces]
        );
        (
            (Color == green),
            G is GreenPieces-1,
            NewNPieces = [OrangePieces,PurplePieces,G]
        )
    ).


game_loop(GameState,Player,Winner,1,_,_):-  %PvP  (1)
    [Board | T] = GameState,
    [ColorsWon , NPieces | _] = T,
    display_game(GameState,Player),
    get_move(Move,Board, NPieces),
    updateNPieces(Move,NPieces,NewNPieces),
    move(GameState, Move, NewGameState),
    [NewBoard | _] = NewGameState,
    updateColorsWon([NewBoard, ColorsWon],NewColorsWon, Player, _, _),
    !,
    game_over([NewBoard,NewColorsWon,NewNPieces],Winner),
    update_player(Player, NewPlayer),
    (
       (
            number(Winner)  % in case there is a winner already the game loop is finished
        );
        (
            game_loop([NewBoard,NewColorsWon,NewNPieces],NewPlayer,Winner,1,_,_)
        )
    ).


      
game_loop(GameState,Player,Winner,2,Level,_):- %PvAI  (2)
    [Board | T] = GameState,
    [ColorsWon , NPieces | _] = T,
    display_game(GameState,Player),
    (
        (
            Player =:= 0,
            get_move(Move,Board, NPieces)
        );
        (
            choose_move(GameState,Player,Level,Move)
        )
    ),
    updateNPieces(Move,NPieces,NewNPieces),
    move(GameState, Move, NewGameState),    
    [NewBoard | _] = NewGameState,
    updateColorsWon([NewBoard, ColorsWon], NewColorsWon, Player, _, _),
    !,
    game_over([NewBoard,NewColorsWon,NewNPieces],Winner),
    update_player(Player, NewPlayer),
    (
       (
            number(Winner)  % in case there is a winner already the game loop is finished
        );
        (
            game_loop([NewBoard,NewColorsWon,NewNPieces],NewPlayer,Winner,2,Level,_)
        )
    ).

game_loop(GameState,Player,Winner,3,Level,_):- %AIvP  (3)
    [Board | T] = GameState,
    [ColorsWon , NPieces | _] = T,
    display_game(GameState,Player),
    (
        (
            Player =:= 1,
            get_move(Move,Board, NPieces)
        );
        (
            choose_move(GameState,Player,Level,Move)
        )
    ),
    updateNPieces(Move,NPieces,NewNPieces),
    move(GameState, Move, NewGameState),    
    [NewBoard | _] = NewGameState,
    updateColorsWon([NewBoard, ColorsWon], NewColorsWon, Player, _, _),
    !,
    game_over([NewBoard,NewColorsWon,NewNPieces],Winner),
    update_player(Player, NewPlayer),
    (
       (
            number(Winner)  % in case there is a winner already the game loop is finished
        );
        (
            game_loop([NewBoard,NewColorsWon,NewNPieces],NewPlayer,Winner,3,Level,_)
        )
    ).

game_loop(GameState,Player,Winner,4,Level1,Level2):- %AIvAI  (4)
    [_ | T] = GameState,
    [ColorsWon , NPieces | _] = T,
    display_game(GameState,Player),
    (
        (
            Player =:= 1,
            choose_move(GameState,Player,Level2,Move)
        );
        (
            choose_move(GameState,Player,Level1,Move)
        )
    ),
    updateNPieces(Move,NPieces,NewNPieces),
    move(GameState, Move, NewGameState),    
    [NewBoard | _] = NewGameState,
    updateColorsWon([NewBoard, ColorsWon], NewColorsWon, Player, _, _),
    !,
    game_over([NewBoard,NewColorsWon,NewNPieces],Winner),
    update_player(Player, NewPlayer),
    (
       (
            number(Winner)  % in case there is a winner already the game loop is finished
        );
        (
            game_loop([NewBoard,NewColorsWon,NewNPieces],NewPlayer,Winner,4,Level1,Level2)
        )
    ).


get_bot_dificulty(1,_, _):- !.
get_bot_dificulty(4, Difficulty1, Difficulty2):- 
    !,
    repeat,
        write('         Difficulty for BOT 1:'), nl,
        write('         1) Easy'), nl,
        write('         2) Medium'), nl,
        catch(read(AuxDifficulty1),_,true),
        number(AuxDifficulty1),
        between(1,2,AuxDifficulty1), !,
    repeat,
        write('         Difficulty for BOT 2:'), nl,
        write('         1) Easy'), nl,
        write('         2) Medium'), nl,
        catch(read(AuxDifficulty2),_,true),
        number(AuxDifficulty2),
        between(1,2,AuxDifficulty2), !,
    Difficulty1 = AuxDifficulty1,
    Difficulty2 = AuxDifficulty2.

get_bot_dificulty(_, Difficulty1, _):- 
    !,
    repeat,
        write('         Difficulty for the BOT:'), nl,
        write('         1) Easy'), nl,
        write('         2) Medium'), nl,
        catch(read(AuxDifficulty1),_,true),
        number(AuxDifficulty1),
        between(1,2,AuxDifficulty1), !,
    Difficulty1 = AuxDifficulty1.

play :-
    prompt(_,''),
    display_name,
    display_mode(Mode),
    get_bot_dificulty(Mode, Difficulty1, Difficulty2),
    player(Player),
    initial(Board),
    game_loop([Board,[-1,-1,-1],[42,42,42]], Player, Winner, Mode, Difficulty1, Difficulty2),
    display_winner(Winner).

