pub mod sorts;
pub mod factorial;

use std::fmt::Display;


pub enum Algorithms {
    InsertionSort,
    Factorial,
}

impl Display for Algorithms {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Algorithms::InsertionSort => write!(f, "Insertion Sort O(n²)"),
            Algorithms::Factorial => write!(f, "Factorial O(n)"),
        }
    }
}
