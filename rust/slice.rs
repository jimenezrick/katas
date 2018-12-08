fn main() {
    let v = vec![1, 2, 3];
    let s: &[i32] = &v[0..3];

    let a: [i32; 3] = [1, 2, 3];

    println!("s = {:?}", s);
    println!("a = {:?}", a);
}
