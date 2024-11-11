use indicatif::ProgressBar;

pub fn bucket_sort<'a, T: PartialOrd + Ord + Copy + Into<u32>>(
    list: &'a mut [T],
    k: u16,
    sort: fn(&mut [T], &ProgressBar),
    pb: &ProgressBar,
) {
    if list.is_empty() {
        return;
    };

    let mut buckets: Vec<Vec<T>> = vec![vec![list[0]; k.into()]];

    // For each element in the list insert it into the appropriate bucket
    (0..list.len()).for_each(|i| buckets[(k as u32 * list[i].into()) as usize].push(list[i]));

    // Sort each bucket with the preferred sorting algorithm
    buckets.iter_mut().for_each(|bucket| sort(bucket, pb));

    // Copy the concatenated buckets into the list to sort it
    list.copy_from_slice(&buckets.concat());
}

#[cfg(test)]
use crate::sorts::insertion_sort::insertion_sort;
#[test]
fn bucket_empty() {
    let mut input: [u16; 0] = [];
    bucket_sort(&mut input, u16::MAX, insertion_sort, &ProgressBar::hidden());
    assert_eq!(input, []);

    let mut input: Vec<u16> = vec![];
    bucket_sort(&mut input, u16::MAX, insertion_sort, &ProgressBar::hidden());
    assert_eq!(input, []);
}

#[test]
fn bucket_regular() {
    let mut input: [u16; 5] = [5, 4, 2, 1, 3];
    bucket_sort(&mut input, u16::MAX, insertion_sort, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<u16> = vec![9, 5, 4, 3, 2, 6, 1, 8, 0, 7];
    bucket_sort(&mut input, u16::MAX, insertion_sort, &ProgressBar::hidden());
    assert_eq!(input, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
}

#[test]
fn bucket_sorted() {
    let mut input: [u16; 5] = [1, 2, 3, 4, 5];
    bucket_sort(&mut input, u16::MAX, insertion_sort, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<u16> = vec![1, 2, 3, 4, 5];
    bucket_sort(&mut input, u16::MAX, insertion_sort, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);
}

#[test]
fn bucket_same_numbers() {
    let mut input: [u16; 5] = [1, 1, 1, 1, 1];
    bucket_sort(&mut input, u16::MAX, insertion_sort, &ProgressBar::hidden());
    assert_eq!(input, [1, 1, 1, 1, 1]);

    let mut input: Vec<u16> = vec![1, 1, 1, 1, 1];
    bucket_sort(&mut input, u16::MAX, insertion_sort, &ProgressBar::hidden());
    assert_eq!(input, [1, 1, 1, 1, 1]);
}

#[test]
fn bucket_size_one() {
    let mut input: [u16; 1] = [1];
    bucket_sort(&mut input, u16::MAX, insertion_sort, &ProgressBar::hidden());
    assert_eq!(input, [1]);

    let mut input: Vec<u16> = vec![1];
    bucket_sort(&mut input, u16::MAX, insertion_sort, &ProgressBar::hidden());
    assert_eq!(input, [1]);
}
