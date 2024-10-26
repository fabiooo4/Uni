#[cfg(test)]
use crate::algorithms::sorts::insertion_sort;

#[test]
fn insertion_empty() {
    let mut input: [i32;0] = [];
    insertion_sort(&mut input);
    assert_eq!(input, []);

    let mut input: Vec<i32>= vec![];
    insertion_sort(&mut input);
    assert_eq!(input, []);
}

#[test]
fn insertion_regular() {
    let mut input = [5,4,2,1,3];
    insertion_sort(&mut input);
    assert_eq!(input, [1,2,3,4,5]);

    let mut input: Vec<i32>= vec![5,4,2,1,3];
    insertion_sort(&mut input);
    assert_eq!(input, [1,2,3,4,5]);
}

#[test]
fn insertion_sorted() {
    let mut input = [1,2,3,4,5];
    insertion_sort(&mut input);
    assert_eq!(input, [1,2,3,4,5]);

    let mut input: Vec<i32>= vec![1,2,3,4,5];
    insertion_sort(&mut input);
    assert_eq!(input, [1,2,3,4,5]);
}

#[test]
fn insertion_same_numbers() {
    let mut input = [1,1,1,1,1];
    insertion_sort(&mut input);
    assert_eq!(input, [1,1,1,1,1]);

    let mut input: Vec<i32>= vec![1,1,1,1,1];
    insertion_sort(&mut input);
    assert_eq!(input, [1,1,1,1,1]);
}

#[test]
fn insertion_size_one() {
    let mut input = [1];
    insertion_sort(&mut input);
    assert_eq!(input, [1]);

    let mut input: Vec<i32>= vec![1];
    insertion_sort(&mut input);
    assert_eq!(input, [1]);
}
