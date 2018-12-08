struct Foo {
    x: i32,
}

impl Drop for Foo {
    fn drop(&mut self) {
        println!("drop Foo{{{}}}", self.x)
    }
}

fn main() {
    let v = vec![1, 2, 3];

    for e in &v {
        println!("{}", e);
        println!("{}", v.len());
    }

    println!(
        "\\x -> x+1: {:?}",
        v.iter().map(|x| x + 1).collect::<Vec<i32>>()
    );
    println!("sum: {}", v.iter().sum::<i32>());

    for i in 1..3 {
        let foo = Foo { x: i };
        println!("i: {}", i);
    }
}
