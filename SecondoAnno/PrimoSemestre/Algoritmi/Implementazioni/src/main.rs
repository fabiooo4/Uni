mod sort;
use sort::run_insertion_sort;

use std::fmt::Display;

enum Algorithms {
    InsertionSort,
}

impl Display for Algorithms {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Algorithms::InsertionSort => write!(f, "Insertion Sort"),
        }
    }
}

fn main() {
    let entries = [Algorithms::InsertionSort];

    println!("Select an algorithm to run:");
    entries
        .iter()
        .enumerate()
        .for_each(|(i, e)| println!("{}. {e}", i + 1));

    let selected: Result<usize, text_io::Error> = text_io::try_read!();

    match selected {
        Ok(idx) => {
            match entries.get(idx.wrapping_sub(1)) {
                Some(algorithm) => {
                    match algorithm {
                        // Execute the algorithm
                        Algorithms::InsertionSort => {
                            // Choose the size of the input
                            print!("\nSet the input size: ");
                            let n: Result<u64, text_io::Error> = text_io::try_read!();
                            println!();

                            match n {
                                Ok(n) => {
                                    run_insertion_sort(n);
                                }
                                Err(e) => println!("Invalid input: {e}"),
                            }
                        }
                    }
                }
                None => println!("There is no algorithm with that number"),
            }
        }
        Err(e) => println!("Invalid input: {e}"),
    }
}
