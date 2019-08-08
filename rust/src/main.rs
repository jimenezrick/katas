use std::sync::mpsc;
use std::sync::{Arc, Barrier};
use std::thread;

use crossbeam_channel;

fn main() {
    let barrier = Arc::new(Barrier::new(3));
    let (snd, rcv) = mpsc::channel::<i32>();

    {
        let b = barrier.clone();
        thread::spawn(move || {
            b.wait();
            snd.send(4);
            println!("{}", "a");
        });
    }
    {
        let b = barrier.clone();
        thread::spawn(move || {
            b.wait();
            rcv.recv().unwrap();
            println!("{}", "b");
        });
    }

    barrier.wait();
    println!("{}", "c");
}
