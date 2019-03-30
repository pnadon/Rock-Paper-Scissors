/*
rps.pl
AUCSC370
Nov 15, 2018

Philippe Nadon

An implementation of Rock Paper Scissors using Prolog
*/

/*
 LIST OF VALID METHODS
 dynamic, assert, asserta, assertz, retract, retractall
 Any arithmetic operators
 Any comparison operators
 is
 random
 write, nl, get0
 and operator (,), not operator (\+)
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Facts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The score is kept as a dynamic fact.
:- dynamic(score/3).
score(0,0,0).

% List of weaknesses, example rock is weak to paper.
weakness(rock, paper, 'ROCK', 'PAPER').
weakness(paper, scissors, 'PAPER', 'SCISSORS').
weakness(scissors, rock, 'SCISSORS', 'ROCK').

% The CPU's random choice corresponds to rock, paper, or scissors.
cpuChoiceIndex(rock, 0).
cpuChoiceIndex(paper, 1).
cpuChoiceIndex(scissors, 2).

% Valid ASCII inputs from the player.
% Correspond to rock, paper, or scissors
validChoice( 82, rock).
validChoice( 114, rock).
validChoice( 80, paper).
validChoice( 112, paper).
validChoice( 83, scissors).
validChoice( 115, scissors).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% One way of completing a round is via a tie
% Both inputs are identical.
% The score for TIE is incremented.
roundWinner(P, P, 'TIE', PMSG, PMSG) :-
  weakness( P, _, PMSG, _),
  score( PScore, CScore, TScore),
  NewScore is TScore + 1,
  retract( score( _,_,_)),
  assert( score( PScore, CScore, NewScore)).
   
% One way of completing a round is by the Player beating the Computer
% The Computer's input's weakness is the Player's input.
% The score for TPLAYER is incremented. 
roundWinner(P, C, 'PLAYER', PMSG, CMSG) :- 
  weakness( C, P, CMSG, PMSG),
  score( PScore, CScore, TScore),
  NewScore is PScore + 1,
  retract( score( _,_,_)),
  assert( score( NewScore, CScore, TScore)).

% One way of completing a round is by the Computer beating the Player
% The Player's input's weakness is the Computers input.
% The score for COMPUTER is incremented.
roundWinner(P, C, 'COMPUTER', PMSG, CMSG) :- 
  weakness(P, C, PMSG, CMSG),
  score( PScore, CScore, TScore),
  NewScore is CScore + 1,
  retract( score( _,_,_)),
  assert( score( PScore, NewScore, TScore)).



% The Player's inputted choice and the Computer random choice are compared.
% It is assumed that the input is correct.
% The approapriate messages are printed, and the score incremented.
playerChoice( P) :-
  random(0,3, CI),
  cpuChoiceIndex( C, CI),
  roundWinner(P, C, WINNERMSG, PMSG, CMSG),
  write( 'You entered '),
  write( PMSG),
  write( '   Computer chose '),
  write( CMSG),
  write( '   Winner is '),
  write( WINNERMSG),
	nl.



% The Player's choice was valid, so the game continues.
checkChoice( Input) :-
  validChoice( X, P),
  Input == X,
  playerChoice( P).

% The Player's choice was invalid, so the round repeats.
checkChoice( Input) :-
  validChoice( X, _),
  Input \= X,
  write( 'Not sure of your selection. Try again.'),
  playRound.



% Receives the Player's input, eliminates unnecesary trailing characters.
getChoice(Code) :-
  get0(Code),
  wasteChar.
  
% True if the next character is a return key.
wasteChar :-
  get0(Code),
	isEnter( Code).
	
% Otherwise the rule repeats.
wasteChar :-
	wasteChar.
	
% The next character was the Windows Return key, the game continues.
isEnter( Code) :-
	Code == 13.

% The next character was the UNIX Return key, the game continues.
isEnter( Code) :-
	Code == 10.
	


% The user is prompted for an input, and that input is evaluated.
playRound :-
	nl,
  write( 'Please enter your choice: \"Rock\", \"Paper\", or \"Scissors\"   '),
  getChoice(Code),
  checkChoice( Code).



% Repeats "playRound" as long as roundLoop hasn't been run 10 times already.
roundLoop(N) :- 
  N<10,
  playRound, 
  M is N+1, 
  roundLoop(M).

% roundLoop was run 10 times, so the game ends
roundLoop(N) :-
  N == 10,
  endGame.



% The Player had a higher score than the Computer, the Player wins.
isChampion :-
  score( PScore, CScore, _),
  PScore > CScore,
  write( 'YOU').

% The Computer had a higher score than the Player, the Computer wins.
isChampion :-
  score( PScore, CScore, _),
  CScore > PScore,
  write( 'COMPUTER').

% Both the Computer and Player had identical scores, no one won.
isChampion :-
  score( PScore, CScore, _),
  PScore == CScore,
  write( 'NO ONE').



% The game ends by displaying the score, and then deciding who won.
endGame :-
  score( PScore, CScore, TScore),
  nl,
	nl,
  write( 'Game Over! You won '),
  write( PScore),
  write( ' rounds, computer won '),
  write( CScore),
  write( ' rounds, tied '),
  write( TScore),
  write( ' rounds'),
  nl,
  write( 'Champion: '),
  isChampion.
  


% The game begins with an introduction, and begins the first round.
game :-
  write( 'Welcome to ROCK PAPER SCISSORS game'),
  nl,
  write( '-----------------------------------'),
  nl,
  roundLoop(0).

