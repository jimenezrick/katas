use std::mem;
use std::rc::Rc;

#[derive(Debug, Clone)]
struct Container {
    my_ptr: Box<u8>,
}

impl Container {
    fn plus_one(&mut self) {
        *self.my_ptr += 1;
    }
}

impl Drop for Container {
    fn drop(&mut self) {
        println!("drop Container{:?}", self);
    }
}

#[derive(Debug, Clone)]
struct SharedContainer {
    my_ptr: Rc<u8>,
}

impl SharedContainer {
    fn plus_one(&mut self) {
        //*self.my_ptr += 1;
    }
}

impl Drop for SharedContainer {
    fn drop(&mut self) {
        println!("drop SharedContainerContainer{:?}", self);
    }
}

fn main() {
    let mut c = Container {
        my_ptr: Box::new(100_u8),
    };
    c.my_ptr = Box::new(0);
    let c2 = c.clone();
    c.my_ptr = Box::new(1);

    println!("c = {:?}", c);
    c.plus_one();
    println!("c = {:?}", c);
    println!("c2 = {:?}", c2);

    let r = SharedContainer {
        my_ptr: Rc::new(200_u8),
    };
    let r2 = r.clone();
}
