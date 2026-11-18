# Machine-Checked (MLIR)

Take inspiration from [machine-checked](https://github.com/Verified-zkEVM/machine-checked/) BUT:
instead of decompiling into linear jasmin (LProg) or Pancake (Flapjack), use MLIR; come up with a realy nice MLIR dialect for verification that we can "lower" riscv, arm, and x86 into.
the idea remains the same: each ISA can be decompiled (in this case lowered) into one unified verification framework, and on top of that, we build proof infrastructure. Our goal: a strong and generic (widely useful) separation logic framework.

## MLIR dialect

I would expect this MLIR dialect to be something like a higher-order logic dialect, on top of which we should design a separation logic framework that can be used for formally verifying bytecode in each of these ISAs.
I want this to be super general, super usable. I would like to get a sense for how changes to the source code affect the bytecode decompilation (ideally it's somewhat continuous, in that small changes result in small-ish changes).

Use the same ISAs as machine-checked in terms of the Lean libraries. (if we need riscv-zkvm, great; if we can use just the SAIL, then great - I'm happy either way, we want the most general framework we can get.) I know there are some limitations to the ISAs like Kraken right now, and that's okay. It doesn't have to be perfect yet, but we want some reasonable amount of coverage for bytecode in each ISA.

## Testing and Hardening

Let's test the framework on a diversity of programs written in rust, javascript, python, go and other popular programming languages, compiled. I would like a robust library of examples that we work through.
Design this to be a representative sample that provides strong, generic coverage, and use this to find and fix bugs and improve confidence in what you're doing.

## Some optional thoughts 

Some optional thoughts:
- does [iris-lean](todo) have anything to offer? any other good, existing logical frameworks that could work? I would like this to build on the existing tooling as much as possible, to make it fit into the existing literature/work, especially the high-quality stuff.
- how about [veir](https://github.com/opencompl/veir/)? it would be really nice for this to be compatible with the work happening out of Tobias Grossner's Cambridge lab on MLIR in Lean

You may want to start with a literature review (look at the review done in machine-checked) to contextualize what you're doing, but don't restrict yourself to only what's been done before; please be creative.

## Formal Verification 

Once you're confident in the decompilers, the MLIR dialect target, and all of that, please formally verify each of the decompilers (the "lowerings").
Use this verification pass to find bugs, make sure your specs are good, general, and complete.

## Git and Documentation 

- make thorough and strong documentation, including visuals and instructions for use; I want good READMEs in each of the core directories
- like machine-checked, the repo should export a library that can be imported, as well as code where people can build the decompiler binary from source; someone should be able to have the binary installed locally, and then when using it and doing verification work, they should be able to just import the separation logic proof library that goes with it.
- in documentation, don't make any reference to [machine-checked](https://github.com/Verified-zkEVM/machine-checked/), apart *maybe* from one line indicating this is built on top of it 
- include an "early days" disclaimer in the README
- add contributing and styleguide guidelines
- initialize a git repository, make commits but don't coauthor them, and don't actually create the repo (just so we have a commit history) until I say so.
- don't coauthor commits

## Acceptance criteria

1. A usable decompiler for each of the three ISAs
2. A sizeable library of examples on which the decompiler works, which are formally verified.
3. A strong separation-logic framework that can be used in the examples (e.g. the examples import that library and use it in formal verification)
4. Everything is end-to-end formally verified

The interface with the ISAs doesn't have to be perfect yet, we can go improving how we "connect" this to real-world ELFs as we go along. I would like something nice though.
I'm mostly concerned with the stable core that connects the ISAs to the MLIR dialect and separation logic framework.