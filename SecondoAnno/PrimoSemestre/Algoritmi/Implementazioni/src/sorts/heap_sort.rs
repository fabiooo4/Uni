use indicatif::ProgressBar;

/// Fixes the direct children of a node to follow the max-heap property
/// # Example
/// ```
/// let list = [16,4,10,14,7]
/// ```
/// ```
///       16
///       /\
///      4 10
///     /\
///    14 7
/// ```
/// ```
/// heapify(list,0)
/// ```
/// Does nothing, because the children of 16 are all less than their parent.
/// If the function is called on a node with children that do not follow the max-heap property
/// heap will be fixed:
/// ```
/// heapify(list,1)
/// assert_eq!(list, [16,14,10,4,7]);
/// ```
/// The output will be:
/// ```
///       16
///       /\
///     14 10
///     /\
///    4 7
/// ```
pub fn heapify<T: PartialOrd>(list: &mut [T], node_idx: usize) {
    let left_leaf = (node_idx + 1) * 2 - 1;
    let right_leaf = (node_idx + 1) * 2;
    let mut largest = node_idx;

    if left_leaf < list.len() && list[left_leaf] > list[node_idx] {
        largest = left_leaf;
    }

    if right_leaf < list.len() && list[right_leaf] > list[largest] {
        largest = right_leaf;
    }

    if largest != node_idx {
        list.swap(node_idx, largest);
        heapify(list, largest);
    }
}

/// Generates a max heap from a list
pub fn build_heap<T: PartialOrd>(list: &mut [T]) {
    (0..list.len() / 2).rev().for_each(|i| heapify(list, i));
}

pub fn heap_sort<T: PartialOrd>(list: &mut [T], pb: &ProgressBar) {
    pb.inc(0);
    build_heap(list);
    (1..list.len()).rev().for_each(|i| {
        pb.inc(1);
        list.swap(0, i);
        heapify(&mut list[0..i], 0);
    });
}

#[cfg(test)]
#[test]
fn heapify_test() {
    let mut input = [16, 4, 10, 14, 7, 9, 3, 2, 8, 1];
    heapify(&mut input, 1);
    assert_eq!(input, [16, 14, 10, 8, 7, 9, 3, 2, 4, 1]);

    let mut input = [16, 4, 10, 14, 7];
    heapify(&mut input, 1);
    assert_eq!(input, [16, 14, 10, 4, 7]);
}

#[test]
fn build_heap_test() {
    let mut input = [1, 2, 3, 4, 5];
    build_heap(&mut input);
    assert_eq!(input, [5, 4, 3, 1, 2]);
}

#[test]
fn heap_empty() {
    let mut input: [i32; 0] = [];
    heap_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, []);

    let mut input: Vec<i32> = vec![];
    heap_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, []);
}

#[test]
fn heap_regular() {
    let mut input = [5, 4, 2, 1, 3];
    heap_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<i32> = vec![9, 5, 4, 3, 2, 6, 1, 8, 0, 7];
    heap_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
}

#[test]
fn heap_sorted() {
    let mut input = [1, 2, 3, 4, 5];
    heap_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<i32> = vec![1, 2, 3, 4, 5];
    heap_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);
}

#[test]
fn heap_same_numbers() {
    let mut input = [1, 1, 1, 1, 1];
    heap_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 1, 1, 1, 1]);

    let mut input: Vec<i32> = vec![1, 1, 1, 1, 1];
    heap_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 1, 1, 1, 1]);
}

#[test]
fn heap_size_one() {
    let mut input = [1];
    heap_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1]);

    let mut input: Vec<i32> = vec![1];
    heap_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1]);
}
