pub mod sorts;
pub mod factorial;

use std::fmt::Display;


pub enum Algorithms {
    InsertionSort,
    MergeSort,
    Factorial,
}

impl Display for Algorithms {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Algorithms::InsertionSort => write!(f, "Insertion Sort O(n²)"),
            Algorithms::MergeSort => write!(f, "Merge Sort O(n log n)"),
            Algorithms::Factorial => write!(f, "Factorial O(n)"),
        }
    }
}
