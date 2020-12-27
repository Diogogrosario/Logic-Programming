mode_menu(1):-
    write('Insert the left side of the product with the following template [X,Y] (this represents XY):'),
    repeat,
        nl,
        catch(read(L1),_,true), is_list(L1), !,

    write('Insert the right side of the product with the following template [X,Y] (this represents XY):'),
    repeat,
        nl,
        catch(read(L2),_,true), is_list(L2), !,

    write('Insert the solution for the product with the following template [X,Y] (this represents XY):'),
    repeat,
        nl,
        catch(read(Sol),_,true), is_list(Sol), !, write(L1), nl , write(L2), nl,
    crypto_user(L1, L2, Sol).
    

main_menu(Mode):-
    write('Welcome to crypto products!'),
     repeat,
        nl, write('   ----------------------------------------------------------------------------------------------'), nl, nl,
        write('1) Build a puzzle.'), nl,
        catch(read(AuxMode),_,true), number(AuxMode),
        between(1,1,AuxMode), !,
    Mode = AuxMode.