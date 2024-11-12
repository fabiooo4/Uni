use cpu_time::ProcessTime;
use indicatif::{ProgressBar, ProgressIterator, ProgressStyle};
use rand::{distributions::Uniform, Rng};

pub trait RadixSortable: Sized + Ord + Copy {
    fn num_digits() -> usize;
    fn get_digit(self, digit_idx: usize) -> usize;
}

impl RadixSortable for u64 {
    fn num_digits() -> usize {
        64 // 32-bit integer
    }

    fn get_digit(self, digit_idx: usize) -> usize {
        (self >> digit_idx) as usize & 1
    }
}

impl RadixSortable for u32 {
    fn num_digits() -> usize {
        32 // 32-bit integer
    }

    fn get_digit(self, digit_idx: usize) -> usize {
        (self >> digit_idx) as usize & 1
    }
}

impl RadixSortable for u16 {
    fn num_digits() -> usize {
        16 // 16-bit integer
    }

    fn get_digit(self, digit_idx: usize) -> usize {
        (self >> digit_idx) as usize & 1
    }
}

pub fn radix_sort<T: RadixSortable>(list: &mut [T], pb: &ProgressBar) {
    let max_digits = T::num_digits();
    pb.set_length((list.len() * max_digits) as u64);
    pb.inc(0);

    // Use counting sort for each "digit" (bit in this case)
    for digit_index in 0..max_digits {
        counting_sort_by_digit(list, digit_index, pb);
    }
}

fn counting_sort_by_digit<T: RadixSortable>(list: &mut [T], digit_idx: usize, pb: &ProgressBar) {
    let mut zero_bucket = Vec::new();
    let mut one_bucket = Vec::new();

    for &num in list.iter() {
        pb.inc(1);
        if num.get_digit(digit_idx) == 0 {
            zero_bucket.push(num);
        } else {
            one_bucket.push(num);
        }
    }

    list[0..zero_bucket.len()].copy_from_slice(&zero_bucket);
    list[zero_bucket.len()..].copy_from_slice(&one_bucket);
}

pub fn run_radix_sort(input_size: usize) {
    // Generate an array with the input size
    let mut rng = rand::thread_rng();
    let range = Uniform::new(0, u64::MAX);

    // Benchmark input generation
    let cpu_now = ProcessTime::now();
    let mut input: Vec<u64> = (0..input_size)
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
    radix_sort(&mut input, &pb);
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
fn radix_empty() {
    let mut input: [u32; 0] = [];
    radix_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, []);

    let mut input: Vec<u16> = vec![];
    radix_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, []);
}

#[test]
fn radix_regular() {
    let mut input: [u16; 5] = [5, 4, 2, 1, 3];
    radix_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<u16> = vec![9, 5, 4, 3, 2, 6, 1, 8, 0, 7];
    radix_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
}

#[test]
fn radix_sorted() {
    let mut input: [u16; 5] = [1, 2, 3, 4, 5];
    radix_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<u16> = vec![1, 2, 3, 4, 5];
    radix_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 2, 3, 4, 5]);
}

#[test]
fn radix_same_numbers() {
    let mut input: [u16; 5] = [1, 1, 1, 1, 1];
    radix_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 1, 1, 1, 1]);

    let mut input: Vec<u16> = vec![1, 1, 1, 1, 1];
    radix_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1, 1, 1, 1, 1]);
}

#[test]
fn radix_size_one() {
    let mut input: [u16; 1] = [1];
    radix_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1]);

    let mut input: Vec<u16> = vec![1];
    radix_sort(&mut input, &ProgressBar::hidden());
    assert_eq!(input, [1]);
}

#[test]
fn counting_digit() {
    let mut input: [u16; 2] = [2, 1];
    assert_eq!(input[0].get_digit(1), 1);

    counting_sort_by_digit(&mut input, 1, &ProgressBar::hidden());
    assert_eq!(input, [1, 2]);
}
