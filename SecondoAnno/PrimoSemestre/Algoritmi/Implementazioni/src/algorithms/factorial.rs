use cpu_time::ProcessTime;
use indicatif::{ProgressBar, ProgressStyle};
use num_bigint::BigInt;

pub fn factorial(num: i64, pb: ProgressBar) -> BigInt {
    let mut answer = BigInt::from(1);
    (1..=num.unsigned_abs()).rev().for_each(|i| {
        answer *= i;
        pb.set_position(num.unsigned_abs() - i);
    });

    if num >= 0 {
        answer
    } else {
        -answer
    }
}

pub fn run_factorial(num: i64) {
    // Progress bar
    let pb = ProgressBar::new(num.unsigned_abs()).with_message("Calculating...");
    pb.set_style(
        ProgressStyle::with_template(
            "{msg}\n[{elapsed_precise}] [{wide_bar:.green/red}] {percent_precise}%  Remaining: {eta}",
        )
        .unwrap()
        .progress_chars("---"),
    );

    // Execute and benchmark
    let cpu_now = ProcessTime::now();
    let output = factorial(num, pb);
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

#[cfg(test)]
#[test]
fn base_case() {
    assert_eq!(factorial(0, ProgressBar::new(0)), BigInt::from(1));
}

#[test]
fn negative() {
    assert_eq!(factorial(-3,ProgressBar::new(0)), BigInt::from(-6));
}

#[test]
fn negative_base_case() {
    assert_eq!(factorial(-0,ProgressBar::new(0)), BigInt::from(1));
}

#[test]
fn big_input() {
    assert_eq!(factorial(14,ProgressBar::new(0)), BigInt::from(87178291200_i64));
}
