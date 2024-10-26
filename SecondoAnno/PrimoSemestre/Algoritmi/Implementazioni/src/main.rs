mod algorithms;
mod tests;

use algorithms::{factorial::run_factorial, sorts::run_insertion_sort, Algorithms};

fn main() {
    let entries = [Algorithms::InsertionSort, Algorithms::Factorial];

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
                            let n: Result<usize, text_io::Error> = text_io::try_read!();
                            println!();

                            match n {
                                Ok(n) => {
                                    run_insertion_sort(n);
                                }
                                Err(e) => println!("Invalid input: {e}"),
                            }
                        }

                        Algorithms::Factorial => {
                            // Choose the factorial to calculate
                            print!("\nChoose the factorial to calculate: ");
                            let n: Result<i64, text_io::Error> = text_io::try_read!();
                            println!();

                            match n {
                                Ok(n) => {
                                    run_factorial(n);
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
