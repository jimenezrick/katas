use std::fmt::Debug;

#[derive(Debug, Copy, Clone)]
struct Foo<T> {
    elem: T,
}

fn main() {
    let f = Foo { elem: true };

    p(f, f);
}

fn p<T: Debug, T2: Debug>(f: Foo<T>, g: T2) {
    println!("{:?}", f);
    println!("{:?}", g);
}
