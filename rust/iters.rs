#[derive(Default)]
struct Foo {
    a: u8,
    b: u32,
    c: bool,
}

enum Bar {
    X(u32),
    Y(bool, u64),
}

impl Default for Bar {
    fn default() -> Bar {
        Bar::X(123)
    }
}

struct Unit;

fn main() {
    let v1 = vec![1, 2, 3];

    println!("v1.len: {}", v1.len());

    for v in &v1 {
        println!("Got: {}", v);
    }

    println!("sum: {}", v1.len());
}

fn aux() -> i8 {
    let foo = Foo {
        a: 0,
        b: 1,
        c: false,
    };
    let foo_def: Foo = Default::default();
    let bar = Bar::Y(false, 666);
    let unit = Unit;

    8
}
