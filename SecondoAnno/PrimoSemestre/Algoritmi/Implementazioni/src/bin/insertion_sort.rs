fn main() {
    let mut a = [6, 1, 3, 6, 7, 8, 32, 2, 1, 6, 767, 3, 2];
    insertion_sort(&mut a);
    println!("{:?}", a);
}

fn insertion_sort<T: PartialOrd>(list: &mut [T]) {
    for i in 1..list.len() {
        let mut j = i;
        while j > 0 && list[j - 1] > list[j] {
            list.swap(j, j - 1);
            j -= 1;
        }
    }
}
