use cpu_time::ProcessTime;
use indicatif::{ProgressBar, ProgressIterator, ProgressStyle};
use rand::{distributions::Uniform, Rng};

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

#[cfg(test)]
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
