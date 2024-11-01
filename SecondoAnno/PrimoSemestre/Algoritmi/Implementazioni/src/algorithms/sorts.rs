use cpu_time::ProcessTime;
use indicatif::{ProgressBar, ProgressIterator, ProgressStyle};
use rand::{distributions::Uniform, prelude::*};

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

pub fn counting_sort<T: PartialOrd + Copy + Into<u32>>(list: &mut [T], k: u16, pb: &ProgressBar) {
    if list.is_empty() || list.len() == 1 {
        return;
    }
    pb.inc(0);

    let k = k as usize;
    let mut tmp: Vec<usize> = vec![0; k];
    let mut result: Vec<T> = vec![list[0]; list.len()];

    (0..list.len()).for_each(|i| tmp[list[i].into() as usize] += 1);

    (1..k).for_each(|i| tmp[i] += tmp[i - 1]);

    (0..list.len()).rev().for_each(|i| {
        pb.inc(1);
        tmp[list[i].into() as usize] = tmp[list[i].into() as usize].saturating_sub(1);
        result[tmp[list[i].into() as usize]] = list[i];
    });

    list.copy_from_slice(&result);
}

pub fn run_counting_sort(input_size: usize) {
    // Generate an array with the input size
    let mut rng = rand::thread_rng();
    let range = Uniform::new(0, u16::MAX);

    // Benchmark input generation
    let cpu_now = ProcessTime::now();
    let mut input: Vec<u16> = (0..input_size)
        .progress()
        .with_message("Generating input...")
        .with_style(
            ProgressStyle::with_template(
                "{msg}\n[{elapsed_precise}] [{wide_bar:.green/red}] {pos}/{len}",
            )
            .unwrap()
            .progress_chars("---"),
        )
        .map(|_| rng.sample(range))
        .collect();
    let cpu_time = cpu_now.elapsed();

    println!("Input generation time: {:.2?}", cpu_time);

    // Create progress bar
    let pb = ProgressBar::new(input.len() as u64).with_message("Sorting...");
    pb.set_style(
        ProgressStyle::with_template(
            "{msg}\n[{elapsed_precise}] [{wide_bar:.green/red}] {percent_precise}%  Remaining: {eta}",
        )
        .unwrap()
        .progress_chars("---"),
    );

    // Execute and benchmark
    let cpu_now = ProcessTime::now();
    counting_sort(&mut input, u16::MAX, &pb);
    let cpu_time = cpu_now.elapsed();

    pb.set_position(input.len() as u64);
    pb.finish_and_clear();

    // Print execution time
    println!("Execution time: {:.2?}", cpu_time);

    // Print output prompt
    print!("\nDo you want to print the output? [y/n]");
    let choice: Result<String, text_io::Error> = text_io::try_read!();

    if let Ok(choice) = choice {
        if choice == "y" || choice == "Y" {
            // Print output
            println!("Output:\n{:#?}", input);
        }
    }
}

pub fn run_sort(input_size: usize, sort_function: fn(&mut [i64], &ProgressBar)) {
    // Generate an array with the input size
    let mut rng = rand::thread_rng();
    let range = Uniform::new(i64::MIN, i64::MAX);

    // Benchmark input generation
    let cpu_now = ProcessTime::now();
    let mut input: Vec<i64> = (0..input_size)
        .progress()
        .with_message("Generating input...")
        .with_style(
            ProgressStyle::with_template(
                "{msg}\n[{elapsed_precise}] [{wide_bar:.green/red}] {pos}/{len}",
            )
            .unwrap()
            .progress_chars("---"),
        )
        .map(|_| rng.sample(range))
        .collect();
    let cpu_time = cpu_now.elapsed();

    println!("Input generation time: {:.2?}", cpu_time);

    // Create progress bar
    let pb = ProgressBar::new(input.len() as u64).with_message("Sorting...");
    pb.set_style(
        ProgressStyle::with_template(
            "{msg}\n[{elapsed_precise}] [{wide_bar:.green/red}] {percent_precise}%  Remaining: {eta}",
        )
        .unwrap()
        .progress_chars("---"),
    );

    // Execute and benchmark
    let cpu_now = ProcessTime::now();
    sort_function(&mut input, &pb);
    let cpu_time = cpu_now.elapsed();

    pb.set_position(input.len() as u64);
    pb.finish_and_clear();

    // Print execution time
    println!("Execution time: {:.2?}", cpu_time);

    // Print output prompt
    print!("\nDo you want to print the output? [y/n]");
    let choice: Result<String, text_io::Error> = text_io::try_read!();

    if let Ok(choice) = choice {
        if choice == "y" || choice == "Y" {
            // Print output
            println!("Output:\n{:#?}", input);
        }
    }
}

#[cfg(test)]
// Insertion sort
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

// Merge sort
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

// Heap
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

// Heap sort
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

// Partition
#[test]
fn partition_regular() {
    let mut input = [3, 4, 5, 1, 2];
    let partition_idx = partition(&mut input);
    assert_eq!(partition_idx, 1);
    assert_eq!(input, [2, 1, 5, 4, 3]);
}

#[test]
fn partition_empty() {
    let mut input: [i32; 0] = [];
    let partition_idx = partition(&mut input);
    assert_eq!(partition_idx, 0);
}

// Quick sort
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

// Counting sort
#[test]
fn counting_empty() {
    let mut input: [u32; 0] = [];
    counting_sort(&mut input, u16::MAX, &ProgressBar::hidden());
    assert_eq!(input, []);

    let mut input: Vec<u16> = vec![];
    counting_sort(&mut input, u16::MAX, &ProgressBar::hidden());
    assert_eq!(input, []);
}

#[test]
fn counting_regular() {
    let mut input: [u16; 5] = [5, 4, 2, 1, 3];
    counting_sort(&mut input, u16::MAX, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<u16> = vec![9, 5, 4, 3, 2, 6, 1, 8, 0, 7];
    counting_sort(&mut input, u16::MAX, &ProgressBar::hidden());
    assert_eq!(input, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
}

#[test]
fn counting_sorted() {
    let mut input: [u16; 5] = [1, 2, 3, 4, 5];
    counting_sort(&mut input, u16::MAX, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<u16> = vec![1, 2, 3, 4, 5];
    counting_sort(&mut input, u16::MAX, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);
}

#[test]
fn counting_same_numbers() {
    let mut input: [u16; 5] = [1, 1, 1, 1, 1];
    counting_sort(&mut input, u16::MAX, &ProgressBar::hidden());
    assert_eq!(input, [1, 1, 1, 1, 1]);

    let mut input: Vec<u16> = vec![1, 1, 1, 1, 1];
    counting_sort(&mut input, u16::MAX, &ProgressBar::hidden());
    assert_eq!(input, [1, 1, 1, 1, 1]);
}

#[test]
fn counting_size_one() {
    let mut input: [u16; 1] = [1];
    counting_sort(&mut input, u16::MAX, &ProgressBar::hidden());
    assert_eq!(input, [1]);

    let mut input: Vec<u16> = vec![1];
    counting_sort(&mut input, u16::MAX, &ProgressBar::hidden());
    assert_eq!(input, [1]);
}
