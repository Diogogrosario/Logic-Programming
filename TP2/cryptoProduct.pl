:- use_module(library(lists)).
:- use_module(library(between)).
:- use_module(library(clpfd)).

:- include('solver.pl').
:- include('menus.pl').
:- include('puzzels.pl').

crypto_product :- 
    prompt(_,''),
    main_menu(Mode),
    mode_menu(Mode).
