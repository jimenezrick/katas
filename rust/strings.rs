use std::str::FromStr;

static U: u32 = 123;

fn main() {
    let s: &'static str = "Hello";

    let s2: String = s.to_string();
    let s3: String = String::from_str(s).unwrap();

    let n: i32 = i32::from_str("123").unwrap();

    println!("{}", s.len());
    println!("n = {}", n);
}
