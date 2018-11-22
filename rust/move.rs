#[derive(Debug, Copy, Clone)]
struct Foo {
    caca: i32,
    pedo: i64,
}

fn main() {
    let a = Foo { caca: 1, pedo: 2 };
    let b = a;
    let _c = a;

    let x = 123;
    let _y = x;
    let _z = x;

    println!("{:?}", b);
    println!("{:?}", a);
}
