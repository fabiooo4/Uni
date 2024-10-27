use cpu_time::ProcessTime;
use indicatif::{ProgressBar, ProgressStyle};
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

pub fn run_sort(input_size: usize, sort_function: fn(&mut [i64], &ProgressBar)) {
    // Generate an array with the input size
    let mut rng = rand::thread_rng();
    let range = Uniform::new(i64::MIN, i64::MAX);

    // Benchmark input generation
    let cpu_now = ProcessTime::now();
    let mut input: Vec<i64> = (0..input_size).map(|_| rng.sample(range)).collect();
    let cpu_time = cpu_now.elapsed();

    println!("Input generation time: {:.2?}", cpu_time);

    // Create progress bar
    let pb = ProgressBar::new(input.len() as u64);
    pb.set_style(
        ProgressStyle::with_template(
            "[{elapsed_precise}] [{wide_bar:.green/red}] {percent_precise}%  Remaining: {eta}",
        )
        .unwrap()
        .progress_chars("---"),
    );

    // Execute and benchmark
    let cpu_now = ProcessTime::now();
    sort_function(&mut input, &pb);
    let cpu_time = cpu_now.elapsed();

    pb.set_position(input.len() as u64);

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
// Insertion sort
#[test]
fn insertion_empty() {
    let mut input: [i32; 0] = [];
    insertion_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, []);

    let mut input: Vec<i32> = vec![];
    insertion_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, []);
}

#[test]
fn insertion_regular() {
    let mut input = [5, 4, 2, 1, 3];
    insertion_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<i32> = vec![5, 4, 2, 1, 3];
    insertion_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1, 2, 3, 4, 5]);
}

#[test]
fn insertion_sorted() {
    let mut input = [1, 2, 3, 4, 5];
    insertion_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<i32> = vec![1, 2, 3, 4, 5];
    insertion_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1, 2, 3, 4, 5]);
}

#[test]
fn insertion_same_numbers() {
    let mut input = [1, 1, 1, 1, 1];
    insertion_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1, 1, 1, 1, 1]);

    let mut input: Vec<i32> = vec![1, 1, 1, 1, 1];
    insertion_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1, 1, 1, 1, 1]);
}

#[test]
fn insertion_size_one() {
    let mut input = [1];
    insertion_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1]);

    let mut input: Vec<i32> = vec![1];
    insertion_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1]);
}

// Merge sort
#[test]
fn merge_empty() {
    let mut input: [i32; 0] = [];
    merge_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, []);

    let mut input: Vec<i32> = vec![];
    merge_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, []);
}

#[test]
fn merge_regular() {
    let mut input = [5, 4, 2, 1, 3];
    merge_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<i32> = vec![5, 4, 2, 1, 3];
    merge_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1, 2, 3, 4, 5]);
}

#[test]
fn merge_sorted() {
    let mut input = [1, 2, 3, 4, 5];
    merge_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1, 2, 3, 4, 5]);

    let mut input: Vec<i32> = vec![1, 2, 3, 4, 5];
    merge_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1, 2, 3, 4, 5]);
}

#[test]
fn merge_same_numbers() {
    let mut input = [1, 1, 1, 1, 1];
    merge_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1, 1, 1, 1, 1]);

    let mut input: Vec<i32> = vec![1, 1, 1, 1, 1];
    merge_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1, 1, 1, 1, 1]);
}

#[test]
fn merge_size_one() {
    let mut input = [1];
    merge_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1]);

    let mut input: Vec<i32> = vec![1];
    merge_sort(&mut input, &ProgressBar::new(0));
    assert_eq!(input, [1]);
}
