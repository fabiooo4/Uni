#[cfg(test)]
use num_bigint::BigInt;

use crate::algorithms::factorial::factorial;

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
    assert_eq!(factorial(10), BigInt::from(3628800));
}
