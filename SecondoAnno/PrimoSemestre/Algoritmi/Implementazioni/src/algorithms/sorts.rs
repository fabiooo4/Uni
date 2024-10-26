use cpu_time::ProcessTime;
use rand::{distributions::Uniform, prelude::*};

pub fn insertion_sort<T: PartialOrd>(list: &mut [T]) {
    for i in 1..list.len() {
        let mut j = i;
        while j > 0 && list[j - 1] > list[j] {
            list.swap(j, j - 1);
            j -= 1;
        }
    }
}

pub fn run_insertion_sort(input_size: u64) {
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
    println!("Algorithm execution time: {:.2?}", cpu_time);
}
