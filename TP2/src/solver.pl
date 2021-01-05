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

% reset_timer :- statistics(walltime,_).	
% print_time :-
% 	statistics(walltime,[_,T]),
% 	TS is ((T//10)*10)/1000,
% 	nl, write('Time: '), write(T), write('ms'), nl, nl.

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
    
    % reset_timer,
    labeling([ ff, enum ],NoDups),
    % print_time,
    % fd_statistics,

    print_results(MultLeft,MultRight,Sol).

