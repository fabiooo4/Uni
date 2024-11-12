mod factorial;
mod sorts;
// mod stack;

use factorial::run_factorial;
use sorts::{
    bucket_sort::run_bucket_sort, counting_sort::run_counting_sort, insertion_sort::insertion_sort, radix_sort::{radix_sort, run_radix_sort}, run_sort
};
use std::fmt::Display;

pub enum Algorithms {
    InsertionSort,
    QuickSort,
    BucketSort,
    MergeSort,
    HeapSort,
    CountingSort,
    RadixSort,
    Factorial,
}

impl Display for Algorithms {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Algorithms::InsertionSort => write!(f, "Insertion Sort O(n²)"),
            Algorithms::QuickSort => write!(f, "Quick Sort O(n²)"),
            Algorithms::BucketSort => write!(f, "Bucket sort O(n²)"),
            Algorithms::MergeSort => write!(f, "Merge Sort O(n log n)"),
            Algorithms::HeapSort => write!(f, "Heap Sort O(n log n)"),
            Algorithms::CountingSort => write!(f, "Counting Sort O(n)"),
            Algorithms::RadixSort=> write!(f, "Radix Sort O(n)"),
            Algorithms::Factorial => write!(f, "Factorial O(n)"),
        }
    }
}

impl Algorithms {
    fn get_run(&self, n: usize) {
        match self {
            Algorithms::InsertionSort => run_sort(n, insertion_sort),
            Algorithms::QuickSort => run_sort(n, insertion_sort),
            Algorithms::BucketSort => run_bucket_sort(n),
            Algorithms::MergeSort => run_sort(n, insertion_sort),
            Algorithms::HeapSort => run_sort(n, insertion_sort),
            Algorithms::CountingSort => run_counting_sort(n),
            Algorithms::RadixSort => run_radix_sort(n),
            Algorithms::Factorial => run_factorial(n as i64),
        }
    }
}

fn main() {
    let entries = [
        Algorithms::InsertionSort,
        Algorithms::QuickSort,
        Algorithms::BucketSort,
        Algorithms::MergeSort,
        Algorithms::HeapSort,
        Algorithms::CountingSort,
        Algorithms::RadixSort,
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
                    // Choose the size of the input
                    print!("\nSet the input size: ");
                    let n: Result<usize, text_io::Error> = text_io::try_read!();
                    println!();

                    match n {
                        Ok(n) => {
                            algorithm.get_run(n);
                        }
                        Err(e) => println!("Invalid input: {e}"),
                    }
                }
                None => println!("There is no algorithm with that number"),
            }
        }
        Err(e) => println!("Invalid input: {e}"),
    }
}

