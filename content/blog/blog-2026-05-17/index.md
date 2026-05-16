+++
title = "Finding the Time Part 2 - Rust Async and the Arm Generic Timer"
date = "2026-05-17"
+++

## Intro

In the [last article](@/blog/blog-2026-05-16/index.md), I set out the various versions of the Arm Architecture, and ones I've been focussed on whilst developing the  [`aarch32-rt`] and [`aarch32-cpu`] libraries.

[`aarch32-rt`]: https://crates.io/crates/aarch32-rt
[`aarch32-cpu`]: https://crates.io/crates/aarch32-cpu

Building an example that gets into `fn main()` and perhaps fires a few interrupts is fine and all that, but most people using these big processors are going to want a bit more - some sort of framework that lets them run multiple tasks concurrently (whether using pre-emptive task switching, or co-operative scheduling) and manage a list of upcoming events (like timeouts, or when the LED next needs to blink).

In Rust, many people use [Embassy](https://embassy.dev) or [RTIC](https://rtic.rs) for this. So how hard can be it to run these frameworks on, say, the Armv8-R AArch32 architecture?

Well, before we get to that, let's talk about some common timer peripherals.

## Timers

I'm going to introduce three timer peripherals, so we can see how they are similar and how they are different. The first is found in all Arm Cortex-M based devices, but it's not very good as we'll see. You should note that if you have an STM32 it will have one (or more) timer peripherals from ST, and if you have an nRF52 it will have one (or more) timer peripherals from Nordic Semi. But let's stick to these Arm ones because I know we can emulate them in QEMU for testing, and the final we we're looking at is the one that comes for free in every Armv8-A/Armv8-R system (and some Armv7-A/Armv7-R systems).

### Arm SYSTICK

The [Arm SYSTICK](https://developer.arm.com/documentation/dui0646/c/Cortex-M7-Peripherals/System-timer--SysTick) is a standard feature of every version of the Arm Architecture M-Profile. That is, you will find the same one in a:

* Cortex-M0
* Cortex-M0+
* Cortex-M1
* Cortex-M3
* Cortex-M4
* Cortex-M7
* Cortex-M23
* Cortex-M33
* Cortex-M55
* Cortex-M85

The SYSTICK has a counter which counts down. When it hits zero the counter is automatically reset the value in the *SysTick Reload Value Register*, and the Arm SYSTICK exception is (optionally) fired.

The timer seemingly has one job, and that is to fire an interrupt at very regular intervals - such as 100 times per second, or 1000 times per second. This is exactly what most classic C RTOSes need to drive their scheduler - a timer tick is an opportunity to pre-empt the currently running thread and switch it out for another one that is waiting to run, allowing the threads to appear to execute concurrently even if both are busy doing work.

If you want a timer that can be used as a programmable alarm for some arbitrary moment in the future, this is not going to work very well. The counter is only 24-bits, and it is designed to be driven from your main SoC system clock. So, if you have a 480 MHz system clock, the maximum time you're going be able to have between timer ticks is {{ maths(code="\frac{{2}^{24} - 1}{480 \mathrm{MHz}} = 34.95 \mathrm{ms}") }}. Fine if you want a 100 Hz (10 ms) tick, but if you want to wait longer than that, you'll need to set the SYSTICK counter to the maximum possible, and when it fires, work out how long is left until your event of interest, and set the timer again. If the event is an hour away and you're forced to tick every 35 ms or so until you get there, that's not ideal for battery life.

Luckily, most SoCs also include a somewhat more capable timer.

### Arm CMSDK Timer

To help engineers design products using Cortex-M processors, Arm produce some standard peripherals as part of the [*Cortex-M System Design Kit* (CMSDK)](https://developer.arm.com/documentation/ddi0479/c/). Arm also use these peripherals when building evaluation kits for their processors, and, as it happens QEMU emulates several of these boards - such as the [Arm MPS2-AN385](https://developer.arm.com/documentation/dai0385/d).

The FPGA based SoC on the MPS2-AN385 includes an [Arm CMSDK APB Timer](https://developer.arm.com/documentation/ddi0479/c/apb-components/apb-timer), and because QEMU is very useful for testing Rust firmware without real hardware needing to be plugged into Github CI, I think this is an interesting example to study.

The CMSDK APB Timer has a 32-bit counter and a 32-bit reload value, and not much else. But even so, that's already an improvement on the Arm SYSTICK and much more useful for setting alarms to fire some variable time in the future (as opposed to some fixed periodic tick interval). It also has an `INTSTATUS` register we can use to check if the alarm is currently ringing (i.e. did the counter value hit zero and reload) and an `INTCLEAR` register can use to silence the alarm (that is, to cancel the interrupt).

The APB CMSDK timer is usually run from a peripheral clock that is lower than the main system clock, but even at 480 MHz that 32-bit counter gives us a maximum of {{ maths(code="\frac{{2}^{32} - 1}{480 \mathrm{MHz}} = 8.95 \mathrm{s}") }} between alarms. Not perfect, but better for your battery life than the SYSTICK. And many SoCs will let you lower the timer's clock speed, extending its range.

### Arm Generic Timer

The [Arm Generic Timer](https://developer.arm.com/documentation/ddi0406/c/System-Level-Architecture/The-Generic-Timer) is an optional feature on Armv7-A and Armv7-R processors, and a standard feature in Armv8-A and Armv8-R. The Arm Generic Timer is exposed as System Registers in AArch64 mode and CP15 registers in AArch32 mode, and so is not using MMIO and does not have any memory addresses.

The Arm Generic Timer provides two of:

* a 64-bit free-running counter, which starts at 0 on reset
* a 64-bit count-down timer, which can trigger an interrupt when it hits zero
* a 64-bit compare value, which will trigger an interrupt when the free-running counter exceeds this value

The Arm Generic Timer calls its two timers the Physical Timer and the Virtual Timer and the difference is only apparent when you are running an OS inside a hypervisor. The Physical Timer is counting "wall time" as you would see elapsed on a clock hanging on the wall, whilst the Virtual Timer only counts time when the guest OS is running. You'd probably use the Physical Timer for operations involving external things (a timeout for a byte over a UART) but the Virtual Timer for operations the OS is performing (benchmarking a CRC algorithm, for example). Think about it, you wouldn't want your benchmark results to be messed up because the guest OS got swapped out for 10ms, but equally, being swapped out for 10ms doesn't mean you want to extend your UART timeouts by that amount - the device should have responded whether or not the guest OS was running at that moment. The way a hypervisor accounts for this is to set an offset value in the `CNTVOFF` register. This amount is then subtracted from the free-running Physical Timer counter (the `CNTPCT` register) to generate the free-running Virtual Timer counter (the `CNTVCT` register). If the hypervisor isn't setting that register to account for 'lost' time whenever the guest OS is swapped back in (or if you don't have a hypervisor), then you basically have two identical timers you can use.

Even if we assume a generous 2 GHz clock speed, our 64-bit counter gives us a maximum period of {{ maths(code="\frac{{2}^{64} - 1}{2 \mathrm{GHz}} = 9.22 \times 10^9 \mathrm{s}") }} between alarms. 9.22 Gigaseconds is over 292 years - that's certainly enough that you don't need to worry about wrap-around.

For reasons I don't fully understand, the Arm Generic Timer implementation provided as part of QEMU's emulation of the MPS3-AN536 board (and its Cortex-R52 Armv8-R AArch32 processor) runs at 62.5 GHz, trimming our maximum period down to a mere 9.3 years. Weird, but I guess I can live with that.

There's actually a third timer available called the Hyp Timer, but that's designed to be exclusively used by a hypervisor at EL2 - I guess so it can measure when the timeslice is up and the running guest OS needs to be swapped over. And, if you are on a system that supports Secure Mode, you will also have a fourth, called the Secure Mode Physical Timer. But they're fairly specialist use-cases, so I'm ignoring them.

## Embassy

It turns out that if you want to run Embassy on Armv8-R, a bunch of work had been done already. The [`embassy-executor`] crate already had [`platform-cortex-ar` feature] which brought in a dependency on my `aarch32-cpu` crate (or its earlier incarnation, `cortex-ar-cpu`). It only supports the 'modern' architectures, and refuses to build for earlier architectures like ARMv4T, with their lack of atomic compare-and-swap and other niceties, but that's fine. The important thing is that it uses the `WFE` instruction to sleep the processor when there are no tasks to run, and interrupt handlers use the `SEV` instruction to ensure the processor comes out of sleep, even if it's *just* about to go to sleep[^1].

[`embassy-executor`]: https://docs.embassy.dev/embassy-executor/0.10.0/cortex-m/index.html
[`platform-cortex-ar` feature]: https://github.com/embassy-rs/embassy/blob/796d8e6039ddf92db7bebf40506a8367b057e963/embassy-executor/Cargo.toml#L157

[^1]: With the older `WFI` instruction there was a risk your interrupt would run *after* the main thread had checked some global boolean flags, but *before* it went to sleep, at which point it might sleep forever not knowing an interrupt had fired and there was work to be done. The workaround was to enter a critical-section with interrupts disabled to do the flag check and then the `WFI` (and `WFI` was specified to turn interrupts back on automatically). But using `WFE` and `SEV` is easier - the *Event* set by the *Set Event* (SEV) instruction is like a boolean flag for the processor that `WFE` checks before sleeping in a way that's hazard-free. You can also send an *Event* to other processors in an SMP system to wake them up.

So, it was relatively easy to copy over one of my examples for the MPS3-AN536 Arm Cortex-R52 evaluation board that QEMU can emulate, and start the Embassy thread-mode async executor using their `embassy_executor::main` attribute macro:

```rust
#[embassy_executor::main(entry = "aarch32_rt::entry")]
async fn main(_spawner: embassy_executor::Spawner) -> ! {
    let p = embassy_mps3_an536_examples::Board::new().unwrap();
    loop {
        // uh, now what.
        // 
        // I don't have any interesting `async fn` to call
    }
}
```

Yeah, I'm going to need need something for my tasks to wait for, and I don't have any async peripheral drivers. So let's make a timer with an async API. This is something which, luckily for us, Embassy has a framework for.

The [`embassy-time`] is the user-facing part of time on Embassy. It allows you to write code like this:

```rust
use embassy_time::{Duration, Timer};

async fn sleep_for_a_second() {
    Timer::after(Duration::from_secs(1)).await;
}
```

For this to work, you must provide a *Time Driver*, which implements the traits defined in [`embassy-time-driver`]. So, let's do that for the Arm Generic Timer, using the [`El1VirtualTimer`] driver from the `aarch32-cpu` crate.

As an aside, it's called the `El1VirtualTimer` because the API only exposes operations that can be performed when running at EL1 (i.e. kernel mode). There's also an `El2VirtualTimer` and a `El0VirtualTimer`, but they touch the same hardware and only differ in the APIs they offer.

[`embassy-time`]: https://docs.embassy.dev/embassy-time/0.5.1/default/index.html
[`embassy-time-driver`]: https://docs.embassy.dev/embassy-time-driver/0.2.2/default/index.html
[`El1VirtualTimer`]: https://docs.rs/aarch32-cpu/0.3.0/aarch32_cpu/generic_timer/struct.El1VirtualTimer.html

First, we need a timer queue. This maintains a sorted list (or maybe a heap?) of events that are scheduled for various points in the future, with the event that's coming up next at the top. We then calculate how long it is until that moment, convert it to some number of ticks, and put that value into the Generic Timer as a compare value for the count-up timer. When that time comes around, the alarm goes off and the IRQ exception is raised on the processor. The IRQ handler will talk to the Generic Interrupt Controller, discover that it was a Virtual Timer Private Peripheral Interrupt, and then jump off into the standard [`embassy-time-driver`] code.

Here's our global timer:

```rust
/// Our timer queue, containing shared mutable state wrapped
/// in an critical-section based embassy Mutex
struct Aarch32VirtualTimerQueue {
    inner: Mutex<CriticalSectionRawMutex, RefCell<Aarch32VirtualTimerQueueInner>>,
}

/// Our shared mutable state is a basic timer queue
struct Aarch32VirtualTimerQueueInner {
    queue: embassy_time_queue_utils::Queue,
}

/// This macro creates a static variable, and makes sure the embassy APIs know about it
/// because there is exactly one Embassy time implementation in the system, and
/// this is it
embassy_time_driver::time_driver_impl!(
    static DRIVER: Aarch32VirtualTimerQueue = Aarch32VirtualTimerQueue {
        inner: Mutex::new(RefCell::new(
            Aarch32VirtualTimerQueueInner {
                queue: embassy_time_queue_utils::Queue::new(),
            }
        ))
    }
);
```

We implement the `embassy_time_driver::Driver` trait on `Aarch32VirtualTimerQueue` to give it the required functionality:

```rust
impl embassy_time_driver::Driver for Aarch32VirtualTimerQueue {
    /// A free-standing function that does an atomic 64-bit System Register read
    fn now(&self) -> u64 {
        aarch32_cpu::generic_timer::read_virtual_timer()
    }

    /// Locks the queue and checks if a new alarm needs scheduling
    fn schedule_wake(&self, at: u64, waker: &Waker) {
        critical_section::with(|cs| {
            let mut inner = self.inner.borrow(cs).borrow_mut();
            inner.schedule_wake(at, waker);
        });
    }
}
```

Let's also give ourselves a function we can call from the interrupt handler:

```rust
impl Aarch32VirtualTimerQueue {
    /// Call this from the interrupt handler when it goes off
    fn on_irq(&self) {
        critical_section::with(|cs| {
            let mut inner = self.inner.borrow(cs).borrow_mut();
            inner.update_alarm();
        });
    }
}
```

And now we need some methods on that juicy inner mutable state that we've protected with the mutex:

```rust
impl Aarch32VirtualTimerQueueInner {
    /// Schedule a wake-up for the next thing in the queue
    fn schedule_wake(&mut self, at: u64, waker: &Waker) {
        // put it in the queue
        if self.queue.schedule_wake(at, waker) {
            // the alarm needs updating
            self.update_alarm();
        }
    }

    /// Check the time, and the queue, and maybe set an alarm (or turn it off)
    fn update_alarm(&mut self) {
        let now = aarch32_cpu::generic_timer::read_virtual_timer();
        let next = self.queue.next_expiration(now);

        // SAFETY: we have &mut on this timer driver, and it's the only thing that owns
        // a timer.
        let mut vt = unsafe { generic_timer::El1VirtualTimer::new() };
        if next == u64::MAX {
            // turn the timer interrupt off
            vt.interrupt_mask(true);
        } else {
            // set an alarm - will fire instantly if it's in the past
            vt.counter_compare_set(next);
            vt.interrupt_mask(false);
            vt.enable(true);
        }
    }
}
```

Rather than carry around an `El1VirtualTimer` inside the time structure, I elected to unsafely conjure one up whenever I need it. It's therefore on me to read all the other `unsafe` code in the codebase and make sure no-one else is trying to access the same timer.  You could try and fix this with a magic object that can only be created exactly once, but it's probably easier just to do a code review by searching for `VirtualTimer`.

Now, I'm not an expert on `embassy-time`, but I think is correct. It certainly seems to let me run a couple of async tasks that print periodically. If you have QEMU 9 or newer, you can try it for yourself with this example I wrote:

```rust
#![no_std]
#![no_main]

#[embassy_executor::main(entry = "aarch32_rt::entry")]
async fn main(_spawner: embassy_executor::Spawner) -> ! {
    let _p = embassy_mps3_an536_examples::Board::new().unwrap();
    arm_gic::gicv3::GicCpuInterface::set_priority_mask(0xFF);
    // SAFETY: we are not in an interrupt-protected critical section right now
    unsafe {
        aarch32_cpu::interrupt::enable();
    }
    loop {
        defmt::info!("Hello World!");
        embassy_time::Timer::after_secs(1).await;
    }
}

#[aarch32_rt::irq]
fn irq_handler() {
    use arm_gic::gicv3::{GicCpuInterface, InterruptGroup};
    defmt::debug!("> IRQ");
    while let Some(int_id) = GicCpuInterface::get_and_acknowledge_interrupt(InterruptGroup::Group1) {
        match int_id {
            VIRTUAL_TIMER_PPI => {
                DRIVER.on_irq();
            }
            _ => unreachable!("We handle all enabled IRQs"),
        }
        GicCpuInterface::end_interrupt(int_id, InterruptGroup::Group1);
    }
    defmt::debug!("< IRQ");
}
```

It's in the embassy tree, so you can run:

```bash
cargo install qemu-run
git clone https://github.com/embassy-rs/embassy.git
cd embassy/examples/mps3-an536
cargo run --bin hello
```

You'll see something like:

```text
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 16.67s
     Running `qemu-run --machine mps3-an536 --cpu cortex-r52 --arg smp=2 target/armv8r-none-eabihf/debug/hello`
0.002750 (Core0) INFO  Board::new()...
0.003166 (Core0) INFO  Configure GIC...
0.003196 (Core0) INFO  Making a gic...
0.003256 (Core0) INFO  Found PERIPHBASE 0xf0000000
0.003444 (Core0) INFO  Calling gic.setup(0)
0.005426 (Core0) INFO  Calling gic.init_cpu(1)
0.005460 (Core0) INFO  Made a gic...
0.005488 (Core0) INFO  Configure virtual timer interrupts on core 0...
0.006040 (Core0) INFO  Configure virtual timer interrupts on core 1...
0.006222 (Core0) INFO  Hello World!
1.012290 (Core0) DEBUG > IRQ
1.012438 (Core0) DEBUG - Timer fired, resetting
1.012808 (Core0) DEBUG < IRQ
1.012936 (Core0) INFO  Hello World!
2.018124 (Core0) DEBUG > IRQ
2.018168 (Core0) DEBUG - Timer fired, resetting
2.018244 (Core0) DEBUG < IRQ
2.018274 (Core0) INFO  Hello World!
```

Core0? Core1? Yes, I subsequently updated this example to support dual-core operation, and as each core has its own timer, each core also has its own timer queue. But look! It's like a blinky, but with async delays and defmt logging.

## RTIC

On the face of it, time on RTIC works in a similar fashion to Embassy - there is a global timer queue, and some traits that you need to implement to adapt it to your specific timer. However, there's a larger issue which is that on Arm, RTIC only supports the *Microcontroller profile* architectures - it has no support for Armv7-A, or Armv8-R, or anything like that.

Well it didn't. I have an ugly work in progress and next time around, I'll walk you through how the timer part works at least.
