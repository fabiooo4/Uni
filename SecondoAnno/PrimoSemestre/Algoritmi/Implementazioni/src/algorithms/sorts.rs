use cpu_time::ProcessTime;
use indicatif::{ProgressBar, ProgressStyle};
use rand::{distributions::Uniform, prelude::*};

pub fn insertion_sort<T: PartialOrd>(list: &mut [T]) {
    // Progress bar
    let pb = ProgressBar::new(list.len() as u64);
    pb.set_style(
        ProgressStyle::with_template(
            "[{elapsed_precise}] [{wide_bar:.green/red}] {percent_precise}%  Remaining: {eta}",
        )
        .unwrap()
        .progress_chars("---"),
    );

    for i in 1..list.len() {
        let mut j = i;
        pb.set_position(i as u64);
        while j > 0 && list[j - 1] > list[j] {
            list.swap(j, j - 1);
            j -= 1;
        }
    }
}

pub fn run_insertion_sort(input_size: usize) {
    // Generate an array with the input size
    let mut rng = rand::thread_rng();
    let range = Uniform::new(i64::MIN, i64::MAX);

    // Benchmark input generation
    let cpu_now = ProcessTime::now();
    let mut input: Vec<i64> = (0..input_size).map(|_| rng.sample(range)).collect();
    let cpu_time = cpu_now.elapsed();

    println!("Input generation time: {:.2?}", cpu_time);

    // Execute and benchmark
    let cpu_now = ProcessTime::now();
    insertion_sort(&mut input);
    let cpu_time = cpu_now.elapsed();

    // Print execution time
    println!("Execution time: {:.2?}", cpu_time);

    // Print output prompt
    print!("\nDo you want to print the output? [y/N]");
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
fn insertion_empty() {
    let mut input: [i32;0] = [];
    insertion_sort(&mut input);
    assert_eq!(input, []);

    let mut input: Vec<i32>= vec![];
    insertion_sort(&mut input);
    assert_eq!(input, []);
}

#[test]
fn insertion_regular() {
    let mut input = [5,4,2,1,3];
    insertion_sort(&mut input);
    assert_eq!(input, [1,2,3,4,5]);

    let mut input: Vec<i32>= vec![5,4,2,1,3];
    insertion_sort(&mut input);
    assert_eq!(input, [1,2,3,4,5]);
}

#[test]
fn insertion_sorted() {
    let mut input = [1,2,3,4,5];
    insertion_sort(&mut input);
    assert_eq!(input, [1,2,3,4,5]);

    let mut input: Vec<i32>= vec![1,2,3,4,5];
    insertion_sort(&mut input);
    assert_eq!(input, [1,2,3,4,5]);
}

#[test]
fn insertion_same_numbers() {
    let mut input = [1,1,1,1,1];
    insertion_sort(&mut input);
    assert_eq!(input, [1,1,1,1,1]);

    let mut input: Vec<i32>= vec![1,1,1,1,1];
    insertion_sort(&mut input);
    assert_eq!(input, [1,1,1,1,1]);
}

#[test]
fn insertion_size_one() {
    let mut input = [1];
    insertion_sort(&mut input);
    assert_eq!(input, [1]);

    let mut input: Vec<i32>= vec![1];
    insertion_sort(&mut input);
    assert_eq!(input, [1]);
}
