use indicatif::ProgressBar;

pub fn insertion_sort<T: PartialOrd>(list: &mut [T], pb: &ProgressBar) {
    for i in 1..list.len() {
        let mut j = i;
        pb.set_position(i as u64);
        while j > 0 && list[j - 1] > list[j] {
            list.swap(j, j - 1);
            j -= 1;
        }
    }
}

#[cfg(test)]
#[test]
fn insertion_empty() {
    let mut input: [i32; 0] = [];
    insertion_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, []);

    let mut input: Vec<i32> = vec![];
    insertion_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, []);
}

#[test]
fn insertion_regular() {
    let mut input = [5, 4, 2, 1, 3];
    insertion_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<i32> = vec![9, 5, 4, 3, 2, 6, 1, 8, 0, 7];
    insertion_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
}

#[test]
fn insertion_sorted() {
    let mut input = [1, 2, 3, 4, 5];
    insertion_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<i32> = vec![1, 2, 3, 4, 5];
    insertion_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);
}

#[test]
fn insertion_same_numbers() {
    let mut input = [1, 1, 1, 1, 1];
    insertion_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 1, 1, 1, 1]);

    let mut input: Vec<i32> = vec![1, 1, 1, 1, 1];
    insertion_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 1, 1, 1, 1]);
}

#[test]
fn insertion_size_one() {
    let mut input = [1];
    insertion_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1]);

    let mut input: Vec<i32> = vec![1];
    insertion_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1]);
}
