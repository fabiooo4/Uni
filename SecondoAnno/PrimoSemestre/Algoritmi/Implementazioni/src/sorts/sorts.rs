use cpu_time::ProcessTime;
use indicatif::{ProgressBar, ProgressIterator, ProgressStyle};
use rand::{distributions::Uniform, prelude::*};





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
