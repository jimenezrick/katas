fn main() {
    let mut v = vec![1, 2, 3];

    println!("v = {:?}", v);
    for e in &mut v {
        *e += 1;
    }
    println!("v = {:?}", v);

    let v2: Vec<_> = v.into_iter().filter(|&x| x >= 3).collect();
    println!("v = {:?}", v2);

    for i in (1..10).rev().filter(|x| x % 2 == 0) {
        println!("i = {:?}", i);
    }
}
