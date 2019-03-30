;; rps.ss
;; AUCSC 370
;; OCT 25, 2018
;; Philippe Nadon
;;
;; An implementation oif Rock Paper Scissors
;; using a functional programming language

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; readLine() --> line (as String) ;;
;; Read one line from standard input, not including the newline
;; but eliminating it. This is wrapper for the recursive method
;; that does the work (readLoop). ;;
(define (readLine)
(readLoop (read-char (current-input-port)) '())) ;do wait for one char

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; readLoop(currentCharacter line) --> line (as String) ;;
;; This recursive method reads a character at a time from the
;; current input port (assuming Scheme's "Interaction Window")
;; until it finds the newline (i.e. enter). It builds the characters
;; into a string which is returned at the end. Newline is not part
;; of the string, but is eliminated from the input ;;
(define (readLoop curChar line)
(cond
((char=? #\newline curChar) (list->string line)) (else (readLoop (read-char (current-input-port))
(append line (list curChar))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Compares inputs plrInput and cpuInput to decide who beat who
;; 0 represents ROCK, 1 is PAPER, 2 is SCISSORS
;; uses typical SCISSORS>PAPER>ROCK>SCISSORS...
;; returns the index of wins list to increment
(define (roundWinner plrInput cpuInput)
    (cond
    ((equal? (modulo (+ plrInput 1) 3) cpuInput)
    (display "COMPUTER")    
    0)
    ((equal? plrInput (modulo (+ cpuInput 1) 3))
    (display "YOU")
    1)
    ((equal? plrInput cpuInput)
    (display "TIE")
    2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The player's choice is represented by a number from 0 - 2
;; This method prints the choice in word form
;; Return is not used
(define (printChoice input)
    (cond 
        ((equal? input 0) (display "ROCK"))
        ((equal? input 1) (display "PAPER"))
        ((equal? input 2) (display "SCISSORS"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Recursively checks to see which index of validChars the char is
;; It then takes that answer and applies modulo 3 to it.
;; Thus, r/R = 0, p/P = 1, s/S = 2
;; It then returns this numerical representation of the input
(define (inputToNum char validChars index)
    (cond
        ((equal? char (car validChars)) (modulo index 3))
        (#t (inputToNum char (cdr validChars) (+ index 1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The recursive portion of checkValidInput
;; Checks if char is equal to the first character of validChars
;; If false, removes first character in validChars and increments index
;; Iterates through all members of validChars, if none match char then
;; #f is returned. If a match is found, #t is returned.
(define (checkValidRec char validChars index)
    (cond
        ((equal? 0 (length validChars)) #f)
        ((equal? (car validChars) char) #t)
        (#t (checkValidRec char (cdr validChars) (+ index 1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Wrapper for checkValidRec
;; Checks if there is no input, to avoid errors
;; rawInput: input from (readLine)
;; validChars: list of valid characters
;; Returns #t if rawInput is a valid choice
;; Returns #f otherwise
(define (checkValidInput rawInput validChars)
    (cond
        ((= (length(string->list rawInput)) 0) #f)
        ((checkValidRec (car (string->list rawInput)) validChars 0))
        (#t #f)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Recursively checks the user's input against validChars
;; If invalid, dispalys error message and loops
;; validChars: a list of valid characters for input
;; rawInput: the string read from (readLine)
;; Returns: the number representing the user's input
(define (getChoiceRec validChars rawInput)
    (cond 
        ((checkValidInput rawInput validChars)
        (inputToNum (car (string->list rawInput)) validChars 0))

        (#t (display "\nNot sure of your selection. Try again.") 
        (getChoice))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Prompts user for a choice, and then evaluates that choice
;; Mostly a wrapper for getChoiceRec, plus a prompt
;; Returns the number representing the user's choice
(define (getChoice)
    (display "\nPlease enter your choice: \"Rock\", \"Paper\", or \"Scissors\"   ")
    (getChoiceRec '(#\r #\p #\s #\R #\P #\S) (readLine)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Checks the choices of the player and computer, and prints them
;; After printing, returns the index of the winner in wins
(define (checkChoices plrInput cpuInput)
    (display "\nYou entered ")
    (printChoice plrInput)
    (display "   Computer chose ")
    (printChoice cpuInput)
    (display "   Winner is ")
    (roundWinner plrInput cpuInput))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Increments the value at index in wins by 1
;; This increment represents the outcome of the round
;; index 0 = computer won, 1 = player, 2 = tie
;; Returns the updated wins list
(define (incrementWins wins index)
    (cond
        ((equal? index 0) 
            (cons (+ (car wins) 1) (cdr wins)))
        ((equal? index 1) 
            (cons (car wins) (cons (+ (cadr wins) 1) (cddr wins))))
        ((equal? index 2)
            (list (car wins) (cadr wins) (+ (caddr wins) 1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Recursively play Rock Paper Scissors until 10 rounds have been played
;; Keeps track of who won which rounds, and number of rounds played
;; Return is the list of wins
(define (playGame wins rounds)
    (cond
        ((>= rounds 10) wins)
        ( #t (playGame 
                ( incrementWins wins (checkChoices (getChoice) (random 3)))
                (+ rounds 1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Prints the winner of the game
;; Inputs the player and cpu scores, then compares them
;; Return is unused
(define (printChampion cpuScore plrScore)
    (display "\nChampion: ")
    (cond
        ((> cpuScore plrScore) (display "COMPUTER"))
        ((> plrScore cpuScore) (display "YOU"))
        (#t (display "NO ONE"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Prints results of the game, by displaying wins
;; Wins are calculated by playGame
;; Return is unused
(define (resultsOfGame wins) 
    (display "Game Over! You won ")
    (display (cadr wins))
    (display " rounds, computer won ")
    (display (car wins))
    (display " rounds, tied ")
    (display (caddr wins))
    (printChampion (car wins) (cadr wins)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Wrapper for resultsOfGame, initializes starting conditions
(define (start)
    (resultsOfGame (playGame '(0 0 0) 0)))
