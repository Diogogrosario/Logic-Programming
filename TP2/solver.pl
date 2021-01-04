% used to limit the values each variable on a list can have (limits them to be between 1 and 9 if the number is the first one or 0 and 9 if not)
% turns the whole list into one number (for example the list [X,Y,Z] is redifined as the number XYZ)
setValDomain([],_,IntValue, IntValue).
setValDomain([X|Rest], L, IntValue, Acc):-
    X in L..9,
    NextAcc #= Acc*10 + X,
    setValDomain(Rest, 0, IntValue, NextAcc).

% prints a list
printList([]).
printList([X|R]):-
    write(X),
    printList(R).

% formated way to print the results of either the solver or the random generator
print_results(MultLeft,MultRight,Sol):-
    printList(MultLeft),
    write(' x '),
    printList(MultRight),
    write(' = '),
    printList(Sol).

% solver for the crypto puzzle
crypto_user(MultLeft, MultRight, Sol):-
    setValDomain(MultLeft,1, LeftVal, 0),
    setValDomain(MultRight,1, RightVal, 0),
    setValDomain(Sol,1, SolVal, 0),
    
    append(MultLeft,MultRight, L),
    append(L, Sol, F),
    remove_dups(F,NoDups),
    all_distinct(NoDups),
    SolVal #= LeftVal * RightVal,
    labeling([],NoDups),
    print_results(MultLeft,MultRight,Sol).

% converts a number to a list with it's digits (for example 123 becomes [1,2,3])
convertNumberToList(0,List,List).
convertNumberToList(Number,List,Acc):-
    Number #> 0,
    NewNumber #= Number div 10,
    Digit #= Number mod 10,
    NewAcc = [Digit|Acc],
    convertNumberToList(NewNumber,List,NewAcc).

% used to randomize the labeling result
mySelValores(Var, _Rest, BB, BB1) :-
    fd_set(Var, Set), fdset_to_list(Set, List),
    random_member(Value, List),
    (   
        first_bound(BB, BB1), Var #= Value
        ;   
        later_bound(BB, BB1), Var #\= Value
    ).

% selects a random variable
selRandom(ListOfVars, Var, Rest):-
    random_select(Var, ListOfVars, Rest).

% makes sure some numbers are repeated on the puzzle (for example turns G x R = BP in valid since no color is repeated)
% the number of repeated variables depends on the difficulty of the puzzle
make_distinct(X,Y,F,1):-
    X #\= Y,
    K #= 3 #\/ K #= 2,
    nvalue(K,F).

make_distinct(X,Y,F,2):-
    X #\= Y,
    K #= 6 #\/ K #= 5 #\/ K #= 4 #\/ K #= 3,
    nvalue(K,F).

% codifies a number into a list of colors (for example 121 becomes ['G','R','G']) using a list with a randized order of colors
% so that in different puzzles the same number is represented by a diferent color
getCharsList([],_,[]).
getCharsList([HN|TN],Colors,[Elem|ET]):-
    nth0(HN,Colors,Elem),
    getCharsList(TN,Colors,ET).

generatePuzzle(Difficulty):-
    AuxDiff is Difficulty - 1,
    MaxNumberLength is integer(exp(10,Difficulty)),
    MinNumberLength is integer(exp(10, AuxDiff)),
    X in MinNumberLength..MaxNumberLength,
    Y in MinNumberLength..MaxNumberLength,
    X #> Y,
    Result #= X * Y,

    convertNumberToList(X,L1,[]),
    convertNumberToList(Y,L2,[]),
    convertNumberToList(Result,Sol,[]),
    append(L1,L2, L),
    append(L, Sol, F),

    make_distinct(X,Y,F,Difficulty),

    length(F,Leng),
    getDiffLength(Difficulty,ExpectLeng),
    Leng#=ExpectLeng,

    labeling([value(mySelValores), variable(selRandom)],[X,Y]), 

    colors(Aux), % gets a list with 10 colors
    random_permutation(Aux,Colors), % randimizes the list of colors so that in different puzzles the same number is represented by a diferent color
    getCharsList(L1,Colors, LChar1),
    getCharsList(L2,Colors, LChar2),
    getCharsList(Sol,Colors, SolChar),
    print_results(LChar1,LChar2,SolChar). % displays the random puzzle
    


generatePuzzle(3):- % used to obtain the number of digits each number will have in a custom puzzle
    repeat,
        write('Number of digits for one number (between 4 and 9)'), nl,
        catch(read(DigitX),_,true), number(DigitX),
        between(4,9,DigitX), !,
    repeat,
        write('Number of digits for the other number (between 4 and 9)'), nl,
        catch(read(DigitY),_,true), number(DigitY),
        between(4,9,DigitY), !,
    generateCustomPuzzle(DigitX, DigitY).


generateCustomPuzzle(DigitX, DigitY):-
    % use to limit the number of digits for X (for example, if the user wants 4 digist the domain becomes 1000 to 9999)
    AuxX is DigitX - 1,
    LowerX is integer(exp(10,AuxX)),
    UpperX is integer(exp(10,DigitX)) - 1, 

    % use to limit the number of digits for Y (for example, if the user wants 4 digist the domain becomes 1000 to 9999)
    AuxY is DigitY - 1,
    LowerY is integer(exp(10,AuxY)),
    UpperY is integer(exp(10,DigitY)) - 1,

    X in LowerX..UpperX,
    Y in LowerY..UpperY,
    Result #= X * Y,

    convertNumberToList(X,L1,[]),
    convertNumberToList(Y,L2,[]),
    convertNumberToList(Result,Sol,[]), 

    labeling([value(mySelValores), variable(selRandom)],[X,Y]),

    colors(Aux),
    random_permutation(Aux,Colors),
    getCharsList(L1,Colors, LChar1),
    getCharsList(L2,Colors, LChar2),
    getCharsList(Sol,Colors, SolChar),
    print_results(LChar1,LChar2,SolChar).