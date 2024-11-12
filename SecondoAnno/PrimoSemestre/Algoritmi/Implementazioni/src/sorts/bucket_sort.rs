use crate::Algorithms;

use crate::sorts::{
    heap_sort::heap_sort, insertion_sort::insertion_sort, merge_sort::merge_sort,
    quick_sort::quick_sort,
};
use cpu_time::ProcessTime;
use indicatif::{ProgressBar, ProgressIterator, ProgressStyle};
use rand::{distributions::Uniform, Rng};

pub fn bucket_sort<T: PartialOrd + Ord + Copy + Into<u32>>(
    list: &mut [T],
    k: u16, // Number of buckets
    sort: fn(&mut [T], &ProgressBar),
    pb: &ProgressBar,
) {
    if list.is_empty() {
        return;
    };

    pb.set_length(list.len() as u64 * 2);

    let mut buckets: Vec<Vec<T>> = vec![Vec::new(); k as usize];

    let max = match list.iter().max() {
        Some(n) => *n,  // If the list is not empty get the max value
        None => return, // Return otherwise
    };

    let m: u32 = max.into() + 1;

    // For each element in the list insert it into the appropriate bucket
    (0..list.len()).for_each(|i| {
        pb.inc(1);
        buckets[(k as u32 * list[i].into() / m) as usize].push(list[i])
    });

    // Sort each bucket with the preferred sorting algorithm
    let mut idx = 0;
    for bucket in buckets.iter_mut() {
        if bucket.is_empty() {
            continue;
        }

        sort(bucket, &ProgressBar::hidden());

        // Append the sorted buckets to the list
        list[idx..bucket.len()+idx].copy_from_slice(bucket);
        idx += bucket.len();

        pb.inc(bucket.len() as u64);
    }

    // list.copy_from_slice(&buckets.concat());
}

pub fn run_bucket_sort(input_size: usize) {
    let allowed_algorithms = [
        Algorithms::InsertionSort,
        Algorithms::QuickSort,
        Algorithms::MergeSort,
        Algorithms::HeapSort,
    ];

    let mut sort: Option<fn(&mut [u16], &ProgressBar)>;

    loop {
        print!("\nChoose the algorithm to use to sort each bucket:\n");
        allowed_algorithms
            .iter()
            .enumerate()
            .for_each(|(i, e)| println!("{}. {e}", i + 1));

        let a: Result<usize, text_io::Error> = text_io::try_read!();
        println!();

        sort = match a {
            Ok(a) => match allowed_algorithms.get(a.wrapping_sub(1)) {
                Some(algorithm) => match algorithm {
                    Algorithms::InsertionSort => Some(insertion_sort),
                    Algorithms::QuickSort => Some(quick_sort),
                    Algorithms::MergeSort => Some(merge_sort),
                    Algorithms::HeapSort => Some(heap_sort),
                    _ => None,
                },
                None => {
                    println!("There is no algorithm with that number\n");
                    None
                }
            },
            Err(e) => {
                println!("Invalid input: {e}\n");
                None
            }
        };

        if sort.is_some() {
            break;
        }
    }

    let sort = sort.unwrap();

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
    bucket_sort(&mut input, u16::MAX, sort, &pb);
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
