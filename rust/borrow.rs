fn main() {
    let v = vec![1, 2, 3];

    borrow_ownership(&v);

    let _v2 = v.clone();
    let _v3 = v.clone();
}

fn take_ownership(v: Vec<i32>) -> usize {
    v.len()
}

fn borrow_ownership(v: &Vec<i32>) -> usize {
    v.len()
}
