fn main() {
    let v = vec![1, 2, 3];

    borrow_ownership(&v);

    let _v2 = v.clone();
    let _v3 = v.clone();

    let t1 = Token();
    let t2 = &t1;

    a(&t1);
    c(t1);
    a(&t2);
}

fn take_ownership(v: Vec<i32>) -> usize {
    v.len()
}

fn borrow_ownership(v: &Vec<i32>) -> usize {
    v.len()
}

struct Token();

fn a(t: &Token) {}
fn b(t: &mut Token) {}
fn c(t: Token) {}
