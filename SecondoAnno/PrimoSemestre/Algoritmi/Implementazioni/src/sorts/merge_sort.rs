use indicatif::ProgressBar;

pub fn merge_sort<T: PartialOrd + Clone>(list: &mut [T], pb: &ProgressBar) {
    if list.len() > 1 {
        pb.inc(1);

        let size = list.len() / 2;

        let (left, right) = list.split_at_mut(size);
        merge_sort(left, pb);
        merge_sort(right, pb);

        let merged = merge(left, right);

        list.clone_from_slice(&merged);
    }
}

fn merge<'a, T: PartialOrd + Clone>(left: &'a mut [T], right: &'a mut [T]) -> Vec<T> {
    let mut i = 0;
    let mut j = 0;
    let mut merged: Vec<T> = Vec::new();

    while i < left.len() && j < right.len() {
        if left[i] < right[j] {
            merged.push(left[i].clone());
            i += 1;
        } else {
            merged.push(right[j].clone());
            j += 1;
        }
    }

    if i < left.len() {
        while i < left.len() {
            merged.push(left[i].clone());
            i += 1;
        }
    }

    if j < right.len() {
        while j < right.len() {
            merged.push(right[j].clone());
            j += 1;
        }
    }

    merged
}

#[cfg(test)]
#[test]
fn merge_empty() {
    let mut input: [i32; 0] = [];
    merge_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, []);

    let mut input: Vec<i32> = vec![];
    merge_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, []);
}

#[test]
fn merge_regular() {
    let mut input = [5, 4, 2, 1, 3];
    merge_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<i32> = vec![9, 5, 4, 3, 2, 6, 1, 8, 0, 7];
    merge_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
}

#[test]
fn merge_sorted() {
    let mut input = [1, 2, 3, 4, 5];
    merge_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<i32> = vec![1, 2, 3, 4, 5];
    merge_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);
}

#[test]
fn merge_same_numbers() {
    let mut input = [1, 1, 1, 1, 1];
    merge_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 1, 1, 1, 1]);

    let mut input: Vec<i32> = vec![1, 1, 1, 1, 1];
    merge_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 1, 1, 1, 1]);
}

#[test]
fn merge_size_one() {
    let mut input = [1];
    merge_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1]);

    let mut input: Vec<i32> = vec![1];
    merge_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1]);
}
