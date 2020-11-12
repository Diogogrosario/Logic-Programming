:- use_module(library(lists)).

valid_line(Line):-
    number(Line),
    Line >= 0,
    Line =< 22.
  
valid_diagonal(Diagonal, D1, D2):-
    number(Diagonal),
    Diagonal >= D1,
    Diagonal =< D2.

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

get_diagonal(Diagonal, Line):-
    diagonal_index(Line, D1),
    diagonal_index_end(Line, D2),
    repeat,
        write('Insert move diagonal ('), write(D1), write('-'), write(D2), write(') :'),
        read(Diagonal),
        valid_diagonal(Diagonal,D1,D2),!.
  
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

is_empty(Line,Diagonal,GameState):-
    nth0(Line,GameState,Row),
    diagonal_index(Line,X),
    Diagonal_index_in_row is Diagonal - X,
    nth0(Diagonal_index_in_row,Row,Elem),
    (
      (
        Elem == empty
      );
      (
        write('Invalid move, tile is not empty.'), nl,
        fail
      )
    ).

get_move([Line,Diagonal,Color],GameState):-
    repeat,
        get_line(Line), 
        get_diagonal(Diagonal, Line),
        is_empty(Line,Diagonal,GameState),!, 
    get_color(Color).