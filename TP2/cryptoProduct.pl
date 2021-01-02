:- use_module(library(lists)).
:- use_module(library(between)).
:- use_module(library(clpfd)).
:- use_module(library(random)).

:- include('solver.pl').
:- include('menus.pl').
:- include('puzzles.pl').

crypto_product :- 
    prompt(_,''),
    main_menu(Mode),
    mode_menu(Mode).
