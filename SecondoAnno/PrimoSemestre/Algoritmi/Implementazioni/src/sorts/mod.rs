pub mod insertion_sort;
pub mod merge_sort;
pub mod heap_sort;
pub mod quick_sort;
pub mod counting_sort;
pub mod bucket_sort;
pub mod radix_sort;

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
