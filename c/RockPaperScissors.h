//
//  RockPaperScissors.h
//
//  Created by Philippe Nadon on 2018-09-27.
//  AUCSC 370, R.Heise
//  Copyright © 2018 Philippe Nadon. All rights reserved.
//
// Header file for RockPaperScissors.c
// Simulates 10 rounds of Rock/Paper/Scissors against the computer

#ifndef rpsMethods_h
#define rpsMethods_h

/*
 * Inputs an int and prints it as a character
 */
void printChar( int num);

/*
 * Prints the string name which represents the input
 */
void printCharToString( int input);

/*
 * Prints the winner and the ending score
 */
void printWinner( int plrInput, int cpuInput, int wins[3]);

/*
 * Gets a choice form the user, returns int representation
 */
int getChoice( char VALID_CHARS[]);

/*
 * Prints the champion of the 10 rounds
 */
void printChampion( int wins[3]);

#endif /* rpsMethods_h */
