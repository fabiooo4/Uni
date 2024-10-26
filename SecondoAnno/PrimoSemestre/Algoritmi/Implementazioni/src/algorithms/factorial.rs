pub fn factorial(num: i64) -> i64 {
    match num {
        0 => 1,
        _ => num * factorial(num - 1)
    }
}

pub fn run_factorial(num: i64) {
    todo!()
}
