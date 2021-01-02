setValDomain([],_,IntValue, IntValue).

setValDomain([X|Rest], L, IntValue, Acc):-
    X in L..9,
    NextAcc #= Acc*10 + X,
    setValDomain(Rest, 0, IntValue, NextAcc).

printList([]).
printList([X|R]):-
    write(X),
    printList(R).

print_results(MultLeft,MultRight,Sol):-
    printList(MultLeft),
    write(' x '),
    printList(MultRight),
    write(' = '),
    printList(Sol).

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

convertNumberToList(Colors,0,List,List).
convertNumberToList(Colors,Number,List,Acc):-
    Number #> 0,
    NewNumber #= Number div 10,
    Digit #= Number mod 10,
    NewAcc = [Digit|Acc],
    convertNumberToList(Colors,NewNumber,List,NewAcc).

mySelValores(Var, _Rest, BB, BB1) :-
    fd_set(Var, Set), fdset_to_list(Set, List),
    random_member(Value, List),
    (   
        first_bound(BB, BB1), Var #= Value
        ;   
        later_bound(BB, BB1), Var #\= Value
    ).

% seleciona uma variável de forma aleatória
selRandom(ListOfVars, Var, Rest):-
    random_select(Var, ListOfVars, Rest). % da library(random)

% make_distinct(X,Y,F,1):-
%     X #= Y,
%     nvalue(2,F).

make_distinct(X,Y,F,1):-
    X #\= Y,
    K #= 3 #\/ K #= 2,
    nvalue(K,F).

% make_distinct(X,X,F,2):-
%     K #= 5 #\/ K #= 4 #\/ K #= 3,
%     nvalue(K,F).

make_distinct(X,Y,F,2):-
    X #\= Y,
    K #= 6 #\/ K #= 5 #\/ K #= 4 #\/ K #= 3,
    nvalue(K,F).

getCharsList([],_,[]).
getCharsList([HN|TN],Colors,[Elem|ET]):-
    nth0(HN,Colors,Elem),
    getCharsList(TN,Colors,ET).

generatePuzzle(Difficulty, L1, L2, Sol):-
    AuxDiff is Difficulty - 1,
    MaxNumberLength is integer(exp(10,Difficulty)),
    MinNumberLength is integer(exp(10, AuxDiff)),
    X in MinNumberLength..MaxNumberLength,
    Y in MinNumberLength..MaxNumberLength,
    X #> Y,
    Result #= X * Y,

    convertNumberToList(RandomColors,X,L1,[]),
    convertNumberToList(RandomColors,Y,L2,[]),
    convertNumberToList(RandomColors,Result,Sol,[]),
    append(L1,L2, L),
    append(L, Sol, F),

    make_distinct(X,Y,F,Difficulty),

    length(F,Leng),
    getDiffLength(Difficulty,ExpectLeng),
    Leng#=ExpectLeng,

    labeling([value(mySelValores), variable(selRandom)],[X,Y]), 

    colors(Aux),
    random_permutation(Aux,Colors),
    getCharsList(L1,Colors, LChar1),
    getCharsList(L2,Colors, LChar2),
    getCharsList(Sol,Colors, SolChar),
    print_results(LChar1,LChar2,SolChar).
    

