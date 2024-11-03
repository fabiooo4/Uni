use indicatif::ProgressBar;

pub fn quick_sort<T: PartialOrd + Copy>(list: &mut [T], pb: &ProgressBar) {
    pb.inc(0);
    if list.len() > 1 {
        pb.inc(1);
        let partition_idx = partition(list);
        quick_sort(&mut list[..=partition_idx], pb);
        quick_sort(&mut list[partition_idx + 1..], pb);
    }
}

/// Moves all the elements less than the first to the left and all the elements greater than the
/// first to the right leaving the pivot in the middle and returning the index of the last element
/// in the left slice
pub fn partition<T: PartialOrd + Copy>(list: &mut [T]) -> usize {
    let mut left_idx: isize = match !list.is_empty() {
        true => -1,
        false => return 0,
    };
    let mut right_idx = list.len();
    let pivot = list[0];

    loop {
        // Find the first element from the right that is less than the pivot
        loop {
            right_idx -= 1;

            if list[right_idx] <= pivot {
                break;
            }
        }

        // Find the first element from the left that is greater than the pivot
        loop {
            left_idx += 1;

            if list[left_idx as usize] >= pivot {
                break;
            }
        }

        if (left_idx as usize) < right_idx {
            list.swap(left_idx as usize, right_idx);
        } else {
            return right_idx;
        }
    }
}

#[cfg(test)]
#[test]
fn quick_empty() {
    let mut input: [i32; 0] = [];
    quick_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, []);

    let mut input: Vec<i32> = vec![];
    quick_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, []);
}

#[test]
fn quick_regular() {
    let mut input = [5, 4, 2, 1, 3];
    quick_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<i32> = vec![9, 5, 4, 3, 2, 6, 1, 8, 0, 7];
    quick_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
}

#[test]
fn quick_sorted() {
    let mut input = [1, 2, 3, 4, 5];
    quick_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<i32> = vec![1, 2, 3, 4, 5];
    quick_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);
}

#[test]
fn quick_same_numbers() {
    let mut input = [1, 1, 1, 1, 1];
    quick_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 1, 1, 1, 1]);

    let mut input: Vec<i32> = vec![1, 1, 1, 1, 1];
    quick_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 1, 1, 1, 1]);
}

#[test]
fn quick_size_one() {
    let mut input = [1];
    quick_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1]);

    let mut input: Vec<i32> = vec![1];
    quick_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1]);
}
