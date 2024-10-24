mod sort;
use sort::insertion_sort;
use text_io::read;

use std::{fmt::Display, time::Instant};

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

    let mut a = [6, 1, 3, 6, 7, 8, 32, 2, 1, 6, 767, 3, 2];

    match selected {
        Ok(idx) => {
            match entries.get(idx) {
                Some(algorithm) => {
                    // Start measuring the execution time
                    let now = Instant::now();
                    match algorithm {
                        // Execute the algorithm
                        Algorithms::InsertionSort => insertion_sort(&mut a),
                    }
                    let elapsed = now.elapsed();

                    // Print output and elapsed time
                    println!("{:?}", a);
                    println!("Elapsed: {:.2?}", elapsed);
                }
                None => println!("Invalid input"),
            }
        }
        Err(_) => println!("Invalid input"),
    }
}
