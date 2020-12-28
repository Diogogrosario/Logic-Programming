mode_menu(1):-
    repeat,
        nl, write('   ----------------------------------------------------------------------------------------------'), nl, nl,
        write('1) R x GR = BG'), nl,
        write('2) B x BG = RRR'), nl,
        write('3) G x GB = BRG'), nl,
        write('4) R x BR = BGB'), nl,
        write('5) B x RG = RRG'), nl,
        write('6) GR x RG = RBR'), nl,
        write('7) R x GB = BGG'), nl,
        write('8) BR x RG = GBG'), nl,
        write('9) GB x GR = RBB'), nl,
        write('10) RB x BB = GRG'), nl,
        write('11) BG x BR = GBR'), nl,
        write('12) G x GR = RGG'), nl,
        write('13) R x RB = GBG'), nl,
        write('14) B x BR = GRR'), nl,
        write('15) G x GB = BBR'), nl,
        catch(read(Puzzle),_,true), number(Puzzle),
        between(1,15,Puzzle), !,

    puzzle(Puzzle,L1,L2,Sol),
    crypto_user(L1, L2, Sol).
    


main_menu(Mode):-
    write('Welcome to crypto products!'),
     repeat,
        nl, write('   ----------------------------------------------------------------------------------------------'), nl, nl,
        write('1) Solve a puzzle.'), nl,
        catch(read(AuxMode),_,true), number(AuxMode),
        between(1,1,AuxMode), !,
    Mode = AuxMode.