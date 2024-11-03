mod factorial;
mod sorts;

use factorial::run_factorial;
use sorts::{
    counting_sort::run_counting_sort, heap_sort::heap_sort, insertion_sort::insertion_sort,
    merge_sort::merge_sort, quick_sort::quick_sort, run_sort,
};
use std::fmt::Display;

pub enum Algorithms {
    InsertionSort,
    QuickSort,
    MergeSort,
    HeapSort,
    CountingSort,
    Factorial,
}

impl Display for Algorithms {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Algorithms::InsertionSort => write!(f, "Insertion Sort O(n²)"),
            Algorithms::QuickSort => write!(f, "Quick Sort O(n²)"),
            Algorithms::MergeSort => write!(f, "Merge Sort O(n log n)"),
            Algorithms::HeapSort => write!(f, "Heap Sort O(n log n)"),
            Algorithms::CountingSort => write!(f, "Counting Sort O(n)"),
            Algorithms::Factorial => write!(f, "Factorial O(n)"),
        }
    }
}

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
