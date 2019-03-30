use std::io::stdin;

pub fn get_choice() -> u8 {

  const VALID_CHARS: [char; 6] = ['r', 'p', 's', 'R', 'P', 'S'];

  loop {
    println!("Please enter your choice: \"Rock\", \"Paper\", or \"Scissors\"   ");

    let mut s = String::new();
    stdin().read_line(&mut s).expect("error in input");
    
    let plr_input: char = s.chars().nth(0).unwrap();

    println!("{}",plr_input);
    for i in 0..6 {
        if plr_input == VALID_CHARS[i] {
          return (i as u8) % 3;
        }
    }
    //println!("{}",input);
    println!("not sure of your selection. Try again.");
  }
}

pub fn round_winner(plr_choice: u8, cpu_choice: u8) -> usize {
  if (plr_choice + 1) % 3 == cpu_choice {
    return 0
  }

  if (cpu_choice + 1) % 3 == plr_choice {
    return 1
  }

  2
}

pub fn get_champ(wins: [i64; 3]) -> usize {
  let plr_wins = wins[0];
  let cpu_wins = wins[1];

  if plr_wins > cpu_wins {
    return 0
  }

  if cpu_wins > plr_wins {
    return 1
  }

  2
}
