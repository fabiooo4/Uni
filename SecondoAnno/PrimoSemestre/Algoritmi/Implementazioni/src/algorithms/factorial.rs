use cpu_time::ProcessTime;
use num_bigint::BigInt;

pub fn factorial(num: i64) -> BigInt {
    todo!();
    let mut answer = BigInt::from(1);
    for i in num..3 {
        answer *= i
    }

    answer
}

pub fn run_factorial(num: i64) {
    // Execute and benchmark
    let cpu_now = ProcessTime::now();
    let output = factorial(num);
    let cpu_time = cpu_now.elapsed();

    // Print execution time
    println!("Execution time: {:.2?}", cpu_time);

    // Print output prompt
    print!("\nDo you want to print the output? [y/N]");
    let choice: Result<String, text_io::Error> = text_io::try_read!();

    if let Ok(choice) = choice {
        if choice == "y" || choice == "Y" {
            // Print output
            println!("Output:\n{}", output);
        }
    }
}
