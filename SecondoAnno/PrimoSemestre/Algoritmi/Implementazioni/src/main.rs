mod algorithms;

use algorithms::{
    factorial::run_factorial,
    sorts::{heap_sort, insertion_sort, merge_sort, quick_sort, run_counting_sort, run_sort},
    Algorithms,
};

fn main() {
    let entries = [
        Algorithms::InsertionSort,
        Algorithms::QuickSort,
        Algorithms::MergeSort,
        Algorithms::HeapSort,
        Algorithms::CountingSort,
        Algorithms::Factorial,
    ];

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
                                    run_sort(n, insertion_sort);
                                }
                                Err(e) => println!("Invalid input: {e}"),
                            }
                        }

                        Algorithms::QuickSort => {
                            // Choose the size of the input
                            print!("\nSet the input size: ");
                            let n: Result<usize, text_io::Error> = text_io::try_read!();
                            println!();

                            match n {
                                Ok(n) => {
                                    run_sort(n, quick_sort);
                                }
                                Err(e) => println!("Invalid input: {e}"),
                            }
                        }

                        Algorithms::MergeSort => {
                            // Choose the size of the input
                            print!("\nSet the input size: ");
                            let n: Result<usize, text_io::Error> = text_io::try_read!();
                            println!();

                            match n {
                                Ok(n) => {
                                    run_sort(n, merge_sort);
                                }
                                Err(e) => println!("Invalid input: {e}"),
                            }
                        }

                        Algorithms::HeapSort => {
                            // Choose the size of the input
                            print!("\nSet the input size: ");
                            let n: Result<usize, text_io::Error> = text_io::try_read!();
                            println!();

                            match n {
                                Ok(n) => {
                                    run_sort(n, heap_sort);
                                }
                                Err(e) => println!("Invalid input: {e}"),
                            }
                        }

                        Algorithms::CountingSort => {
                            // Choose the size of the input
                            print!("\nSet the input size: ");
                            let n: Result<usize, text_io::Error> = text_io::try_read!();
                            println!();

                            match n {
                                Ok(n) => {
                                    run_counting_sort(n);
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
