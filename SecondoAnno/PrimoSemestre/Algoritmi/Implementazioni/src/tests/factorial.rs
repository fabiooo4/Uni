#[cfg(test)]
use crate::algorithms::factorial::factorial;
use num_bigint::BigInt;

#[test]
fn base_case() {
    assert_eq!(factorial(0), BigInt::from(1));
}

#[test]
fn negative() {
    assert_eq!(factorial(-3), BigInt::from(-6));
}

#[test]
fn negative_base_case() {
    assert_eq!(factorial(-0), BigInt::from(1));
}

#[test]
fn big_input() {
    assert_eq!(factorial(14), BigInt::from(87178291200_i64));
}
