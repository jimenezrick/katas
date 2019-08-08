fn main() {
    let mut xs: [u32; 3] = [1, 2, 3];

    {
        let s = &mut xs[..];
        s[1] = 123;
        drop(s);
    }

    for x in &mut xs {
        *x += 1;
    }

    println!("{:?}", xs);
    modify_ref_array(&mut xs);
    println!("{:?}", xs);
}

fn modify_ref_array(xs: &mut [u32]) {
    xs[0] = 666;
}
