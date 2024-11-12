# Algorithms implementation
This is a program i wrote to implement all the algorithms discussed in the "Data structures and Algorithms"
course. I decided to write it in Rust to improve my Rust programming skills, even though at my university we
use C and Java. If you want to check out the code it's not that hard to understand, i tried to make it as
simple as possible, but you can just run the program and see the results without looking at the code.

## How to run the program
1. Clone the repository to your local machine via the following commands:
```bash
git clone -n --depth=1 --filter=tree:0 \
  https://github.com/fabiooo4/Uni algorithms
cd algorithms
git sparse-checkout set --no-cone SecondoAnno/PrimoSemestre/Algoritmi/Implementazioni
git checkout
mv SecondoAnno/PrimoSemestre/Algoritmi/Implementazioni/* .
rm -rf SecondoAnno
```

2. Run the program with the following command (make sure you have Rust installed):
```bash
cargo run --release
```

3. You can now see the results of the algorithms implemented in the program.

## Algorithms implemented
- [x] Insertion sort
- [x] Merge sort
- [x] Heap sort
- [x] Quick sort
- [x] Counting sort
- [x] Factorial
- [x] Bucket sort
- [x] Radix sort
- [ ] Randomized search
