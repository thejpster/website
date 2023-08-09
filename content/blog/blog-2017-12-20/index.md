+++
title = "Advent of Code"
date = 2017-12-20
+++

Over the past weeks, I've been working through Advent of Code. If you haven't seen it, it's basically a daily programming challenge - one a day for the 25 days running up to Christmas. Each challenge has two parts, and you get points for being in the first 100 people to submit a correct answer (usually a number, or a short string). There's nothing for coming 101st! The challenges open at 00:00 EST (so, 05:00 GMT) so if you want to have a crack at the leaderboard, it's a very early start. The best I've managed so far is about 162nd, but there's a few days left.

Most people tackle the problems in Python, and arguably that's a very good choice. It's a very expressive language, and as the winners produce short, dense code - it needs to be fast to type after all - the lack of static type checking isn't as much of a problem as it might be in a larger application.

I'm doing it in Rust, and it's been very educational.

I thought my Rust was OK going in to this challenge but it turns out I've spent an awful lot of time referring to the [Standard Library documentation](https://doc.rust-lang.org/std/) trying to find various methods on Vec or Iterator. This is getting better, slowly, and I guess only more practice will help here. I have found the Rust Enhanced plugin for Sublime Text to be very helpful - basically I can get a rough outline of the programme in, and then edit until all the red errors have gone away. This means I find the speed of the compiler is less of an issue than in C, as by the time I come to actually build the programme I know it is syntactically good and it's just down to run-time bugs.

To reduce the time it takes to put solutions together, I have a wrapper program which takes inputs files on the command line and calls out to the appropriate 'function' for each day's challenge. These functions take a `&[Vec<String>]` - that is, each input file is a Vec of Strings, and there's an arbitrary number of them in a slice. I also have a wrapper script which fetches that day's input file and adds it to git, and another which executes my main program with the correct arguments for that day. As the code increases in size, I'm starting to wonder if it's better to have some shared library boilerplate and to put each exercise in its own binary file, but it is what it is for now.

A typical input file might be some comma separated integers, as with 2017's Day 10. Parsing these is simple enough:

```rust
pub fn run(contents: &[Vec<String>]) {
    let lengths: Vec<u8> = contents[0][0].split(',').map(|x| x.parse().unwrap()).collect();
    ...
}
```

I started out doing splits with string literals (because Python), but Clippy told me I should use a char as my split pattern instead. Thanks Clippy! Sometimes the input isn't integers, but symbols of some sort (such as N, E, S, W movements on a map, or a maze layout, or some pseudo-assembler language that needs executing). The Python programmers often resort to some fairly grim looking string matching, but I generally prefer to define the appropriate enum and structs to hold the data, and then work in that. More typing, but less scope for silly mistakes that are impossible to see. Here's an example that's reading in an ASCII-art maze with letters that you need to collect as you walk the maze:

```rust
#[derive(Debug, Copy, Clone, Eq, PartialEq)]
enum Piece {
    Cross,
    LeftRight,
    UpDown,
    Space,
    Letter(char),
}
    
pub fn run(contents: &[Vec<String>]) {
    let mut map: Vec<Vec<Piece>> = Vec::new();
    for line in &contents[0] {
        let mut line_vec = Vec::new();
        for square in line.chars() {
            match square {
                '|' => line_vec.push(Piece::UpDown),
                ' ' => line_vec.push(Piece::Space),
                '+' => line_vec.push(Piece::Cross),
                '-' => line_vec.push(Piece::LeftRight),
                'A'...'Z' => line_vec.push(Piece::Letter(square)),
                _ => panic!("Bad char {}", square),
            }
        }
        map.push(line_vec);
    }
    ...
}
```

Because I've got first class Iterators, Maps and Sets, I'm able to 'think' in a Python way, and with a syntax that I found an awful lot easier to work with that modern C++. Need to read some sentences and find those that contain duplicate words? No problem!

```rust
use std::collections::HashSet;

pub fn run(contents: &[Vec<String>]) {
    let mut count = 0;
    for line in &contents[0] {
        let mut dup = false;
        let mut set: HashSet<String> = HashSet::new();
        for word in line.split_whitespace() {
            if !set.insert(word.into()) {
                dup = true;
            }
        }
        if !dup {
            count += 1;
        }
    }
    println!("Count: {}", count);
}
```

While that's all positive, some things that have proved a little frustating include:

* Google searches like "rust hashmap insert" don't always go to the canonical API docs. Sometimes you get Servo docs, or sometimes you get a link to an old version (say, 1.14). The documentation doesn't have a link to the latest canonical version ("These docs are out of date - try here!"), which would be useful.
* I end up using too many unwraps because proper error handling takes more typing.
* I have to get up at 5am.

Frankly, that's not a very long list considering it's a pretty new language with a famously steep learning curve. Onwards, to Christmas and the grand finale!
