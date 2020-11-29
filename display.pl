% End game board
end([
              [orange,empty],                           %even
            [empty,empty,green],                       %odd
          [green,purple,empty,empty],                   %even
        [empty,purple,empty,empty,empty],               %odd
      [orange,green,orange,empty,empty,empty],           %even
        [orange,empty,purple,empty,empty],               %odd
      [empty,orange,empty,empty,green,empty],           %even
    [empty,orange,empty,empty,green,empty,empty],       %odd
      [empty,orange,purple,empty,empty,empty],           %even
    [empty,orange,orange,orange,empty,empty,empty],       %odd
      [empty,orange,empty,empty,orange,empty],           %even
    [empty,orange,orange,empty,empty,empty,empty],
      [empty,orange,purple,empty,empty,empty],
    [empty,purple,orange,purple,purple,empty,empty],
      [orange,orange,orange,purple,orange,empty],
    [empty,orange,orange,empty,purple,empty,empty],
      [empty,orange,empty,purple,purple,empty],
        [orange,purple,empty,orange,empty],
      [orange,empty,orange,empty,purple,empty],
        [empty,empty,empty,empty,purple],
          [empty,green,empty,green],
            [empty,empty,empty],
              [empty,empty]
]).

% Mid game board
mid([
              [orange,empty],                           %even
            [empty,empty,green],                       %odd
          [green,purple,empty,empty],                   %even
        [empty,purple,empty,empty,empty],               %odd
      [empty,green,orange,empty,empty,empty],           %even
        [empty,empty,purple,empty,empty],               %odd
      [empty,empty,empty,empty,green,empty],           %even
    [empty,empty,empty,empty,green,empty,empty],       %odd
      [empty,empty,purple,empty,empty,empty],           %even
    [empty,empty,orange,orange,empty,empty,empty],       %odd
      [empty,empty,empty,empty,orange,empty],           %even
    [empty,empty,orange,empty,empty,empty,empty],
      [empty,empty,purple,empty,empty,empty],
    [empty,purple,empty,empty,purple,empty,empty],
      [orange,green,purple,empty,orange,empty],
    [empty,empty,orange,empty,green,empty,empty],
      [empty,empty,empty,purple,empty,empty],
        [empty,purple,empty,orange,empty],
      [empty,empty,orange,empty,empty,empty],
        [empty,empty,empty,empty,green],
          [empty,green,empty,green],
            [empty,empty,empty],
              [empty,empty]
]).


% Initial board
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

% Associates each color to a letter to be printed on the hexagon.
cell_val(orange, 'O').
cell_val(green, 'G').
cell_val(purple, 'P').
cell_val(empty, ' ').

% Checks if the row is even
even_row(0).
even_row(2).
even_row(4).
even_row(6).
even_row(8).
even_row(10).
even_row(12).
even_row(14).
even_row(16).
even_row(18).
even_row(20).
even_row(22).

% Necessary line starters because the lines of the hexagon do not start the same way
start_value(0,'    ___/ ').
start_value(1,'org ___/ ').
start_value(2,'    ___/ ').
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


% Necessary line starters because the lines of the hexagon do not end the same way
end_value(0,'___2                     ').
end_value(1,'___3   prp           ').
end_value(2,'___4             ').
end_value(3,'___5         ').
end_value(4,'         ').
end_value(5,'___/6        ').
end_value(6,'___      ').
end_value(7,'7    ').
end_value(8,'___/     ').
end_value(9,'8    ').
end_value(10,'___/     ').
end_value(11,'9 grn').
end_value(12,'___/     ').
end_value(13,'10   ').
end_value(14,'___/     ').
end_value(15,'11   ').
end_value(16,'___/     ').
end_value(17,'___/         ').
end_value(18,'12       ').
end_value(19,'___/         ').
end_value(20,'___/             ').
end_value(21,'___/ org             ').
end_value(22,'___/                     ').

% Max length an odd row can have.
max_length_odd(7).  

% Max length an even row can have.  
max_length_even(6).

% Writes N spaces.
writeNspaces(0).
writeNspaces(X):-
    write(' '),
    NX is X-1,
    writeNspaces(NX).

% Displays each tile of the board with it's respective color
display_start_value(0,Nrow):-
    start_value(Nrow,X),
    write(X).

display_start_value(_,_):-
    write('___/ ').

display_piece([],_,_).
display_piece(H,Nrow,NPiece) :-
    [V | T] = H,
    display_start_value(NPiece,Nrow),
    cell_val(V,Piece),
    write(Piece),
    write(' \\'),
    display_piece(T,Nrow,1).

% Closes the top of the hexagon
close_hex_top:-
    writeNspaces(31), write('Diagonal'),writeNspaces(29),write('Line'),nl,
    writeNspaces(28),
    write('___0'),
    writeNspaces(4),
    write('___1'), nl.

% Closes the bottom of the hexagon.
close_hex_bot:-
    writeNspaces(27),
    write('\\___/'),
    writeNspaces(3),
    write('\\___/'), nl.

% Displays N spaces to align the board
write_row_spaces(Nrow,L):-
    even_row(Nrow),!,
    max_length_even(X),
    N is (X - L) * 4,
    writeNspaces(4+N).

write_row_spaces(_,L):-
    max_length_odd(X),
    N is (X - L) * 4,
    writeNspaces(N).

% Displays a row
display_line(H,NRow) :-
    length(H,L),
    write_row_spaces(NRow,L),
    display_piece(H,NRow,0), 
    end_value(NRow,Line),
    write(Line),
    write('   '), write(NRow), nl.
    

% Displays board using recursion to be able to print each row correctly
display_board([],_,_).
display_board(GameState,Player,NRow) :-
    [H | T] = GameState,
    display_line(H,NRow),
    NewRow is NRow+1,
    display_board(T,Player,NewRow).

% Displays current player
display_player(Player):-
    P is Player+1,
    write('Current Player: ') , write(P), nl.

% Displays remaining pieces
display_remaining_pieces(NPieces) :-
    [Orange,Purple,Green|_] = NPieces,
    write('Current Orange Pieces Left: '), write(Orange), nl,
    write('Current Purple Pieces Left: '), write(Purple), nl,
    write('Current Green Pieces Left: '), write(Green), nl.

% Displays color's alliances
display_alliances:-
    write('Player 1 alliances: To connect Orange: Orange-Green, to connect Green: Green-Purple, to connect Purple: Purple-Orange'), nl,
    write('Player 2 alliances: To connect Orange: Orange-Purple, to connect Green: Green-Orange, to connect Purple: Purple-Green'), nl.


% Displays the player that won each color
write_orange_player(-1):-write('Orange :'), nl.
write_orange_player(Orange):-
    PO is Orange+1,
    write('Orange : Player '), write(PO), nl.

write_purple_player(-1):-write('Purple :'), nl.
write_purple_player(Purple):-
    PP is Purple+1,
    write('Purple : Player '), write(PP), nl.

write_green_player(-1):-write('Green :'), nl.
write_green_player(Green):-
    PG is Green+1,
    write('Green : Player '), write(PG), nl.

display_colors([Orange, Purple, Green | _]):-
    write_orange_player(Orange),
    write_purple_player(Purple),
    write_green_player(Green).

% Displays the game state.
display_game([Board , Colors, NPieces | _],Player):-
    nl,
    close_hex_top,
    display_board(Board,Player,0),
    close_hex_bot,
    nl,
    display_player(Player),
    display_remaining_pieces(NPieces),
    display_colors(Colors),
    display_alliances.

% Displays game name.
display_name:-
  write('       $$$$$$\\  $$\\       $$\\       $$$$$$\\  $$$$$$\\  $$\\   $$\\  $$$$$$\\  $$$$$$$$\\  $$$$$$\\ '), nl,
  write('      $$  __$$\\ $$ |      $$ |      \\_$$  _|$$  __$$\\ $$$\\  $$ |$$  __$$\\ $$  _____|$$  __$$\\ '), nl,
  write('      $$ /  $$ |$$ |      $$ |        $$ |  $$ /  $$ |$$$$\\ $$ |$$ /  \\__|$$ |      $$ /  \\__|'), nl,
  write('      $$$$$$$$ |$$ |      $$ |        $$ |  $$$$$$$$ |$$ $$\\$$ |$$ |      $$$$$\\    \\$$$$$$\\  '), nl,
  write('      $$  __$$ |$$ |      $$ |        $$ |  $$  __$$ |$$ \\$$$$ |$$ |      $$  __|    \\____$$\\ '), nl,
  write('      $$ |  $$ |$$ |      $$ |        $$ |  $$ |  $$ |$$ |\\$$$ |$$ |  $$\\ $$ |      $$\\   $$ |'), nl,
  write('      $$ |  $$ |$$$$$$$$\\ $$$$$$$$\\ $$$$$$\\ $$ |  $$ |$$ | \\$$ |\\$$$$$$  |$$$$$$$$\\ \\$$$$$$  |'), nl,
  write('      \\__|  \\__|\\________|\\________|\\______|\\__|  \\__|\\__|  \\__| \\______/ \\________| \\______/ '), nl.

% Display game modes menu.
display_mode(Mode):-
  repeat,
    nl, write('   ----------------------------------------------------------------------------------------------'), nl, nl,
    write('         1) Player VS Player'), nl,
    write('         2) Player VS AI'), nl,
    write('         3) AI VS Player'), nl,
    write('         4) AI VS AI'), nl,
    write('         '),
    catch(read(AuxMode),_,true), number(AuxMode),
    between(1,4,AuxMode), !,
  Mode = AuxMode.

% Display game's winner.
display_winner(Winner):-
  WinningPlayer is Winner+1,
  write('The winner is player '), write(WinningPlayer), write('!').
