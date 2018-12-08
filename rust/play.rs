static x: i32 = 5;

struct Foo;

fn main() {
    let foo2 = Foo;

    foo2.bar();
    foo2.bar();

    foo(&x);
}

impl Foo {}

impl Foo {
    fn bar(self) {}
}

fn foo(_n: &'static i32) {
    _n;
}
