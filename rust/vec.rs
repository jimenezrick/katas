fn main() {
    let mut v = vec![1,2,3];
    let r = &mut v;

    r.push(666);
}
