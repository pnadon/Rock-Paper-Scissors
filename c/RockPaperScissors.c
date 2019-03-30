//
// RockPaperScissors.c
//
//  Created by Philippe Nadon on 2018-09-24.
//  AUCSC 370, R.Heise
//  Copyright © 2018 Philippe Nadon. All rights reserved.
//  A simulation of the game Rock Paper Scissors,
//  which has a user play against the computer for 10 turns.
//

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "RockPaperScissors.h"


/*
 * Inputs an int and prints it as a character
 *
 * int num: The int to print
 */
void printChar( int num){
    printf("%c", (char)(num + '0'));
} // printChar


/*
 * Prints the string name which represents the input
 *
 * int input: The int which represents rock, paper, or scissors
 */
void printCharToString( int input){
    
    enum words{ ROCK, PAPER, SCISSORS};
    if( input == ROCK){
        printf( "ROCK");
    }
    else if( input == PAPER){
        printf( "PAPER");
    }
    else if( input == SCISSORS){
        printf( "SCISSORS");
    }
    else printf( "ERROR: Unknown character");
} // printCharToString


/*
 * Checks the values inputted by the person and cpu,
 * and adds a point to the respect player.
 * If there is no winner, another point is added to ties.
 * Since the choices are interpreted as ints,
 * they are numerically compared to determine the winner.
 *
 * int plrInput / cpuInput: The ints representing the choices
 * of the player and computer
 *
 * int wins[3]: Keeps track of the score
 */
void printWinner( int plrInput, int cpuInput, int wins[3]){
    if( ((plrInput + 1) % 3) == cpuInput){
        printf("COMPUTER\n");
        wins[0]++;
    }
    else if( plrInput == ((cpuInput + 1) % 3)){
        printf("YOU\n");
        wins[1]++;
    }
    else if( plrInput == cpuInput){
        printf("TIE\n");
        wins[2]++;
    }
} // printWinner


/*
 * This method prompts the user for an input,
 * and returns it if it is valid, loops otherwise.
 *
 * char VALID_CHARS[]:  contains valid input characters
 *
 * returns the int representing the player's choice
 */
int getChoice( char VALID_CHARS[]){
    
    char plrInput[100];
    // unnecesaryChar catches the second character that the input reads
    char unnecesaryChar;
    
    while( 1){
        printf( "\nPlease enter your choice: \"Rock\", \"Paper\", or \"Scissors\"   ");
        scanf("%s", plrInput);
        scanf("%c", &unnecesaryChar);
        
        
        for( int i = 0; i < 6; i++){
            if (plrInput[0] == VALID_CHARS[i]){
                return (i % 3);
            }
        } // for
        
        printf( "\nNot sure of your selection. Try again.");
    } // while
} // getChoice


/*
 * Prints the champion on the 10 rounds
 *
 * int wins[3]: Represents the scores
 */
void printChampion( int wins[3]){
    
    printf("\nChampion: ");
    
    if( wins[0] > wins[1]){
        printf("COMPUTER");
    }
    else if( wins[1] > wins[0]){
        printf("YOU");
    }
    else printf("NO ONE");
}// printChampion


/*
 * Loops through 10 rounds of rock paper scissors,
 * while keeping track of the wins and ties.
 * Upon completing 10 rounds,
 * it prints the number of wins and ties.
 */
int main(int argc, const char * argv[]) {
    
    char VALID_CHARS[6] = {'r','p','s','R','P','S'};
    
    int numRounds = 0;
    int wins[3] = {0,0,0};
    
    int plrChoice = 0;
    int cpuChoice = 0;
    
    printf( "Welcome to ROCK PAPER SCISSORS game\n");
    printf( "-----------------------------------\n");
    
    while( numRounds<10) {
        
        plrChoice = getChoice( VALID_CHARS);
        
        time_t t;
        srand((unsigned) time(&t));
        cpuChoice = rand() % 3;
        
        printf( "\nYou entered ");
        printCharToString( plrChoice);
        printf( "   Computer chose ");
        printCharToString( cpuChoice);
        printf( "   Winner is ");
        printWinner( plrChoice, cpuChoice, wins);
        
        numRounds++;
    } // while
    
    printf("Game Over! You won ");
    printChar(wins[1]);
    printf(" rounds, computer won ");
    printChar(wins[0]);
    printf(" rounds, tied ");
    printChar(wins[2]);
    printf(" rounds");
    
    printChampion( wins);
} // main
