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
    let mut buckets: Vec<Vec<T>> = vec![Vec::new(); k as usize];

    let max = match list.iter().max() {
        Some(n) => *n,  // If the list is not empty get the max value
        None => return, // Return otherwise
    };

    let m: u32 = max.into() + 1;

    // For each element in the list insert it into the appropriate bucket
    (0..list.len()).for_each(|i| buckets[(k as u32 * list[i].into() / m) as usize].push(list[i]));

    // Sort each bucket with the preferred sorting algorithm
    buckets.iter_mut().for_each(|bucket| sort(bucket, pb));

    // Copy the concatenated buckets into the list to sort it
    list.copy_from_slice(&buckets.concat());
}

pub fn run_bucket_sort(
    input_size: usize,
    sort: fn(&mut [u16], &ProgressBar),
) {
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
