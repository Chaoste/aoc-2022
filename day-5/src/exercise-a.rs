extern crate regex;
use regex::Regex;
use std::fs::File;
use std::io::{self, prelude::*, BufReader};

fn main() -> io::Result<()> {
  let file = File::open("input.txt")?;
  let reader = BufReader::new(file);
  let mut crates: Vec<Vec<char>> = Vec::new();
  let mut crates_input: Vec<String> = Vec::new();
  for _i in 0..9 {
    crates.push(Vec::new());
  }

  let mut i = 0;
  let re = Regex::new(r"move (\d+) from (\d+) to (\d+)").unwrap();
  for line in reader.lines() {
    let line = line.unwrap();
    if i < 9 {
      crates_input.push(line);
    } else if i == 9 {
      for stack_idx in 0..9 {
        let char_idx = stack_idx * 4 + 1;
        for crate_level in (0..8).rev() {
          let crate_content = crates_input[crate_level].chars().nth(char_idx).unwrap();
          if crate_content != ' ' {
            crates[stack_idx].push(crate_content);
          }
        }
      }
    } else if i > 9 {
      let caps = re.captures(&line).unwrap();
      let amount = caps.get(1).unwrap().as_str().parse::<i32>().unwrap();
      let from = caps.get(2).unwrap().as_str().parse::<i32>().unwrap() as usize;
      let to = caps.get(3).unwrap().as_str().parse::<i32>().unwrap() as usize;
      let mut from_crate: Vec<char> = crates.get(from-1).expect("exists").to_vec();
      let mut to_crate: Vec<char> = crates.get(to-1).expect("exists").to_vec();
      for _ in 0..=amount-1 {
        let moved_crate = &from_crate.pop().unwrap();
        to_crate.push(*moved_crate);
      }
      let _ = std::mem::replace(&mut crates[from-1], from_crate);
      let _ = std::mem::replace(&mut crates[to-1], to_crate);
    }
    i += 1;
  }

  println!();
  print!("Final elements: ");
  for mut final_crate in crates {
    print!("{}", final_crate.pop().unwrap());
  }
  println!();

  Ok(())
}