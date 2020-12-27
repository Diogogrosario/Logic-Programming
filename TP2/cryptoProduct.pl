:- use_module(library(lists)).
:- use_module(library(between)).
:- use_module(library(clpfd)).

:- include('solver.pl').
:- include('menus.pl').

crypto_product :- 
    main_menu(Mode),
    mode_menu(Mode).
