#![feature(nll)]
#![allow(unused_variables)]

fn main() {
    let mut x = 22;

    let p = &mut x;

    println!("{}", x);
}
