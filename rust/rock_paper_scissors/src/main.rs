/*
main.rs
Created by Philippe Nadon
Last modified March 30, 2019

Simulates a rock paper scissors game in rust.
*/

mod lib;
use rand::Rng;

fn main() {
    const RPS_STR: [&str; 3] = ["ROCK", "PAPER", "SCISSORS"];
    const SCORE_STR: [&str; 3] = ["YOU", "COMPUTER", "TIE"];
    const CHAMP_STR: [&str; 3] = ["YOU", "COMPUTER", "NO ONE"];

    let mut num_rounds = 0;
    let mut wins: [i64; 3] = [0, 0, 0];

    println!("Welcome to ROCK PAPER SCISSORS game");
    println!("-----------------------------------");

    while num_rounds < 10 {
        let plr_choice: u8 = lib::get_choice();
        let cpu_choice: u8 = rand::thread_rng().gen_range(0, 3);

        let winner: usize = lib::round_winner(plr_choice, cpu_choice);

        wins[winner] = wins[winner] + 1;

        println!(
            "You entered {}    Computer chose {}    Winner is {}",
            RPS_STR[plr_choice as usize],
            RPS_STR[cpu_choice as usize],
            SCORE_STR[winner]
        );

        num_rounds += 1;
    }
    println!(
        "Game Over! You won {} rounds, computer won {} rounds, tied {} rounds",
        wins[0], wins[1], wins[2]
    );

    let champ: usize = lib::get_champ(wins);
    println!("Champion: {}", CHAMP_STR[champ]);
}
