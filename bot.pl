% Calculates the value of the board
value(GameState, Player, Value):-
    [Board, ColorsWon | _] = GameState,
    captured_color_value(Player, ColorsWon, ColorValue),
    getPathValue(Player,ColorsWon,Board,PathValue),
    NewP is mod(Player+1,2),
    getPathValue(NewP,ColorsWon,Board,Player2PathValue),
    Value is ColorValue + PathValue - Player2PathValue.

% Calculates the value of the captured colors (+400 for player colors, 0 for neutral and -400 for opponent's color)
captured_color_value(Player, ColorsWon,ColorValue):-
    count_occurrences(ColorsWon,Player,CountOfPlayer),
    NewP is mod(Player+1,2),
    count_occurrences(ColorsWon,NewP,CountOfOpponent),
    AuxValue is 0 + CountOfPlayer * 400,
    ColorValue is AuxValue - (CountOfOpponent * 400).

% Used to create the list of valid moves. When iterating the board it checks if the tile is empty. 
% If it is, one possible move is added for every color of piece if there are still any remaining.
iterateRow([],_,_,_,NewListOfMoves,NewListOfMoves).
iterateRow(Row,CurrentRow,CurrentDiagonal,NPieces,ListOfMoves,FinalListOfMoves):-
    [Value | T ] = Row,
    [Orange, Purple, Green] = NPieces,
    (
        (
            Value \== empty,
            AuxOrange = [],
            AuxPurple = [],
            AuxGreen = []
        );
        (
            addOrangeMove(CurrentRow,CurrentDiagonal,Orange,AuxOrange),
            addPurpleMove(CurrentRow,CurrentDiagonal,Purple,AuxPurple),
            addGreenMove(CurrentRow,CurrentDiagonal,Green,AuxGreen)
        )
    ),
    append([AuxPurple],[AuxOrange],AuxList),
    append(AuxList,[AuxGreen],NewAuxList),
    append(ListOfMoves,NewAuxList,NewListOfMoves),
    NewDiagonal is CurrentDiagonal +1,
    iterateRow(T,CurrentRow,NewDiagonal,NPieces,NewListOfMoves,FinalListOfMoves).

% Auxiliar function for the iterate Row that verifies if there are any Orange pieces remaining and if there is it return a possible orange move
addOrangeMove(CurrentRow,CurrentDiagonal,Orange,AuxOrange):-
    (
        Orange > 0,
        AuxOrange = [CurrentRow,CurrentDiagonal,orange]
    );
    (
    AuxOrange = []
    ).

% Auxiliar function for the iterate Row that verifies if there are any Purple pieces remaining and if there is it return a possible purple move
addGreenMove(CurrentRow,CurrentDiagonal,Green,AuxGreen):-
    (
        Green > 0,
        AuxGreen = [CurrentRow,CurrentDiagonal,green]
    );
    (
    AuxGreen = []
    ). 
% Auxiliar function for the iterate Row that verifies if there are any Green pieces remaining and if there is it return a possible green move
addPurpleMove(CurrentRow,CurrentDiagonal,Purple,AuxPurple):-
    (
        Purple > 0,
        AuxPurple = [CurrentRow,CurrentDiagonal,purple]
    );
    (
    AuxPurple = []
    ). 


% Used as a auxiliar funtion of the valid_moves function. Used to iterate the board to find every separate row that is used in the function
% iterateRow to build the list of possible moves.

iterateBoard([],_,_,FinalListOfMoves,FinalListOfMoves).
iterateBoard(Board,NPieces,CurrentRow,ListOfMoves,FinalListOfMoves):-    
    [Row | T ] = Board,
    diagonal_index(CurrentRow,Diagonal),
    iterateRow(Row,CurrentRow,Diagonal,NPieces,ListOfMoves,RowListOfMoves),
    NewRow is CurrentRow+1,
    iterateBoard(T,NPieces,NewRow,RowListOfMoves,FinalListOfMoves).

% Used to obtain the list of possible moves.
valid_moves(GameState, _Player ,FinalListOfMoves):-
    [Board, _ , NPieces] = GameState,
    iterateBoard(Board,NPieces,0,_ , AuxFinalListOfMoves),
    remove_dups(AuxFinalListOfMoves, NoDuplicateListOfMoves),
    delete(NoDuplicateListOfMoves,[], FinalListOfMoves).

% Function used to get the value of the player's path between the sides of the hexagon with the same colors.
% It's used as a part of the funtion to evaluate the best possible move the bot can do since its called when testing all valid moves.
% The function gets the number of pieces necessary to finish building the path by using an algorithm similar to a breadth-first search algorithm
% with a max depth of 9. The value is obtained by putting 9 minus the pieces necessary to finish the path to the power of three.
getPathValue(Player,ColorsWon,Board,PathValue):-
    [Orange,Purple,Green] = ColorsWon,
    (
        (Orange \== -1, Length is 9) ; 
        getOrangePathLength(Player,Board,Length)
    ),
    (
        (Purple \==  -1, Length1 is 9);
        getPurplePathLength(Player,Board,Length1)
    ),
    (
        (Green \==  -1, Length2 is 9); 
        getGreenPathLength(Player,Board,Length2)
    ),
    AuxValue is (9-Length)*(9-Length)*(9-Length),
    AuxValue1 is (9-Length1)*(9-Length1)*(9-Length1),
    AuxValue2 is (9-Length2)*(9-Length2)*(9-Length2),
    PathValue is AuxValue + AuxValue1 + AuxValue2.

% Function used to set up the search for the pieces necessary to make a path between the orange boarders
getOrangePathLength(Player,Board,Length):-
    ToVisit = [[0,0],[1,0],[2,0],[3,0],[4,0]],
    allied(Player,orange,Allied),
    getPathLength(Board,ToVisit,[],Allied,orange,0,Length).

% Function used to set up the search for the pieces necessary to make a path between the purple boarders
getPurplePathLength(Player,Board,Length):-
    ToVisit = [[18,7],[19,8],[20,9],[21,10],[22,11]],
    allied(Player,purple,Allied),
    getPathLength(Board,ToVisit,[],Allied,purple,0,Length).

% Function used to set up the search for the pieces necessary to make a path between the green boarders
getGreenPathLength(Player,Board,Length):-
    ToVisit = [[7,1],[9,2],[11,3],[13,4],[15,5]],
    allied(Player,green,Allied),
    getPathLength(Board,ToVisit,[],Allied,green,0,Length).
    

buildLevel(_,Level1,Level1,[],Visited,Visited,_,_,_).
buildLevel(Board,Level1,ReturnLevel,ToVisit,Visited,NewVisited,Allied,CheckingColor,Depth):-
    [H|T] = ToVisit,
    [Row,Diagonal | _] = H,
    (
        (
            \+member(H,Visited),
            valid_line(Row),
            diagonal_index(Row,D1),
            diagonal_index_end(Row,D2),
            valid_diagonal(Diagonal,D1,D2),
            getValue(Board,Row,Diagonal,Color),
            (
                (
                    (Color == Allied; Color == CheckingColor),
                    getNeighbours(Row,Diagonal,Neighbours),
                    append(Neighbours,T,Aux),
                    append([H],Visited,Aux2),
                    remove_dups(Aux,NoDupes),
                    buildLevel(Board,Level1,ReturnLevel,NoDupes,Aux2,NewVisited,Allied,CheckingColor,Depth)
                );
                (
                    (Color == empty),
                    Depth > 0 ,
                    append([H],Visited,Aux2),
                    remove_dups(T,NoDupes),
                    buildLevel(Board,[H|Level1],ReturnLevel,NoDupes,Aux2,NewVisited,Allied,CheckingColor,Depth)
                ); true
            )
        ); 
        (
            append([H],Visited,Aux2),
            remove_dups(T,NoDupes),
            buildLevel(Board,Level1,ReturnLevel,NoDupes,Aux2,NewVisited,Allied,CheckingColor,Depth)
        )
    ).

% Functions used when calculating the path length. 
% Gets the neighbors of the pieces inside the list ReturnLevel for the next iteration of the function
getNextPossibleVisited([], ToVisitNext,ToVisitNext).
getNextPossibleVisited(ReturnLevel, Aux,ToVisitNext):-
    [H|T] = ReturnLevel,
    [Row,Diagonal | _ ] = H,
    getNeighbours(Row,Diagonal,Neighbours),
    append(Neighbours,Aux,NewToVisit),
    getNextPossibleVisited(T,NewToVisit, ToVisitNext).
    
fillFinishLevel(_,[],_,NewLevel,NewLevel,_,_).
fillFinishLevel(Board,ToVisitNext,Visited,Aux,NewLevel,CheckingColor,Allied):-
    [H | T] = ToVisitNext,
    [Row,Diagonal | _] = H,
    (
        (
            \+member(H,Visited),
            valid_line(Row),
            diagonal_index(Row,D1),
            diagonal_index_end(Row,D2),
            valid_diagonal(Diagonal,D1,D2),
            getValue(Board,Row,Diagonal,Color),
            (Color == CheckingColor; Color == Allied), 
            getNeighbours(Row,Diagonal,Neighbours),
            fillFinishLevel(Board,[Neighbours | ToVisitNext], [H | Visited], [H | Aux], NewLevel,CheckingColor,Allied)

        );
        (
            fillFinishLevel(Board,T,Visited,Aux,NewLevel,CheckingColor,Allied)
        )
    ).

% Verifies if the current level is at the orange boarder. If it is, the function stops and return the number of pieces needed to finish the path 
stopCondition(orange,NewLevel):-
(
    (member([18,12],NewLevel));
    (member([19,12],NewLevel));
    (member([20,12],NewLevel));
    (member([21,12],NewLevel));
    (member([22,12],NewLevel))
).

% Verifies if the current level is at the purple boarder. If it is, the function stops and return the number of pieces needed to finish the path 
stopCondition(purple,NewLevel):-
(
    (member([0,1],NewLevel));
    (member([1,2],NewLevel));
    (member([2,3],NewLevel));
    (member([3,4],NewLevel));
    (member([4,5],NewLevel))
).

% Verifies if the current level is at the green boarder. If it is, the function stops and return the number of pieces needed to finish the path 
stopCondition(green,NewLevel):-
(
    (member([7,7],NewLevel));
    (member([9,8],NewLevel));
    (member([11,9],NewLevel));
    (member([13,10],NewLevel));
    (member([15,11],NewLevel))
).

% Used to remove a list from a list
remove_list([], _, []).
remove_list([X|Tail], L2, Result):- member(X, L2), !, remove_list(Tail, L2, Result). 
remove_list([X|Tail], L2, [X|Result]):- remove_list(Tail, L2, Result).

getPathLength(_,[],_,_,_,_,-1).
getPathLength(Board,ToVisit,LastVisited,Allied,CheckingColor,CurrentDepth,Depth):-
    buildLevel(Board,[],ReturnLevel,ToVisit,LastVisited,Visited,Allied,CheckingColor,CurrentDepth),
    getNextPossibleVisited(ReturnLevel, [],ToVisitNext),
    fillFinishLevel(Board,ToVisitNext,Visited,[],NewLevel,CheckingColor,Allied),
    NewDepth is CurrentDepth+1,
    append(ReturnLevel,NewLevel,FinishedLevel),
    append(Visited,NewLevel,NewVisited),
    getNextPossibleVisited(NewLevel,[],NewToVisitNext),
    append(NewToVisitNext,ToVisitNext,Aux),
    remove_list(Aux,NewVisited,NextListOfTiles),
    (
        (
            \+stopCondition(CheckingColor,FinishedLevel),
            (
                (
                    CurrentDepth > 0,
                    getPathLength(Board,NextListOfTiles,NewVisited,Allied,CheckingColor,NewDepth,Depth)
                );
                (
                    CurrentDepth =:= 0,
                    getPathLength(Board,ToVisit,[],Allied,CheckingColor,1,Depth)
                )
            )
        );
        (
            !,Depth is CurrentDepth
        )
    ).

% Used to get a random move for the bot in the random dificulty.
choose_move(GameState,Player,1,Move):- 
    valid_moves(GameState,Player, ListOfMoves),
    length(ListOfMoves,Length),
    random(0,Length,RandomMove),
    nth0(RandomMove,ListOfMoves,Move), sleep(1),
    [Row,Diagonal,Color] = Move,
    write('Putting piece of color '), write(Color), write(' at row '), write(Row), write(' and diagonal '), write(Diagonal), nl.

% Used to get a move for the bot in the greedy dificulty.
choose_move(GameState,Player,2,Move):- 
    valid_moves(GameState,Player, ListOfMoves),
    simMoves(GameState,ListOfMoves,Player,_BestMove,-10000, NewMove),
    length(NewMove,Length),
    random(0,Length,RandomMove),
    nth0(RandomMove,NewMove,Move),
    [Row,Diagonal,Color] = Move,
    write('Putting piece of color '), write(Color), write(' at row '), write(Row), write(' and diagonal '), write(Diagonal), nl.

% Used to create a game state with simulated moves obtained from the function vali_moves.
% The new game state is then evaluated and the best game state is used to make a move for the bot.
simMoves(_,[],_, BestMove,_, BestMove).
simMoves(GameState,ListOfMoves,Player, BestMove,BestMoveValue, FinalBestMove):-
    [_, ColorsWon, NPieces] = GameState,
    [Move | T] = ListOfMoves,
    updateNPieces(Move,NPieces,_),
    move(GameState, Move, NewGameState),    
    [NewBoard | _] = NewGameState,
    updateColorsWon([NewBoard, ColorsWon], NewColorsWon, Player),
    value([NewBoard,NewColorsWon], Player, Value),
    (
        (
            Value > BestMoveValue,
            simMoves(GameState,T,Player,[Move],Value,FinalBestMove)
        ); 
        (
            Value =:= BestMoveValue,
            simMoves(GameState,T,Player,[Move | BestMove],BestMoveValue,FinalBestMove)
        ); 
        simMoves(GameState,T,Player,BestMove,BestMoveValue,FinalBestMove)
    ).
    