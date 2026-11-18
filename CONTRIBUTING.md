# Contributing

Contributions are welcome: lowerings for more instructions, proofs of more examples, better
automation, new front ends for the decompiler, fixes and documentation.

## Where to start

**Get in touch first.** The project is young and its design is still moving. Before you start
work, please reach out to the maintainer, Derek Sorensen, for example on the
[Lean Zulip](https://leanprover.zulipchat.com). A short conversation about what you have in
mind and where it fits saves work on both sides.

- [`README.md`](README.md) explains the idea and the layout.
- [`docs/Architecture.md`](docs/Architecture.md) explains the design and the theorems that hold
  it together.
- [`docs/Walkthrough.md`](docs/Walkthrough.md) follows one function from source to a theorem
  about the machine. Read it before writing a proof.
- [`docs/Roadmap.md`](docs/Roadmap.md) says what exists, what does not, and what is next.
- [`docs/Trust.md`](docs/Trust.md) lists what is trusted.
- [`STYLE.md`](STYLE.md) is the style guide.
- Every core directory has a `README.md`.

### Larger contributions

Before a large piece of work, open an issue describing it. Examples are a new instruction set,
a new operation of the dialect, or a new layer of the logic. For a design that will take more
than a few pull requests, write a short design note in `docs/` first. It should state the
goal, the key definitions and theorems, what will be trusted, and the open choices.

## Ground rules

These hold for every change. A pull request that breaks one is not merged.

### Proofs

- **No `sorry`, no `axiom`, no `native_decide`.** `bv_decide` is allowed. Check with
  `#print axioms`: a theorem may depend on `propext`, `Classical.choice` and `Quot.sound`,
  plus the axioms of any `bv_decide` it uses, and nothing else
  ([`docs/Trust.md`](docs/Trust.md)).
- **Zero warnings.** The build is warning-free and stays so. Fix a warning rather than
  silencing it: do not disable a linter with `set_option`. If a warning can only be fixed by a
  decision that is the maintainer's, say so in the pull request.
- **No vacuous results.** A specification must constrain states the program reaches. A
  premise that remains in a top-level theorem must be satisfiable, and the pull request says
  why.
- **Untrusted producers, trusted checker.** The decompiler writes Lean definitions and the
  certificate that they are the lowering of the instructions. The Lean kernel checks the
  certificate. Nothing in `braid/`, `Lowering/` or a proof under `Examples/` imports `Tools/`.

### Semantics and trust

- **One semantics per instruction set.** RISC-V is riscv-zkvm's `step`, x86-64 is Kraken's x64
  semantics, and AArch64 is the trusted package of arm64-semantics, each used unmodified at
  its pinned revision ([`docs/ISA.md`](docs/ISA.md)). Do not add a second semantics for any of
  them. If a model lacks something, the place to add it is the model.
- **One dialect.** Every instruction set lowers into the same operations. A new operation
  needs a reason that holds for more than one instruction set, a weakest-precondition
  equation, an execution rule in the logic, and a line in the printers.
- **Every lowering is proved.** An instruction is lowered when its block is proved sound
  against the model. Until then it lowers to `trap`, which is always sound.
- **One logic.** Specifications are `Triple`s, so that results compose through `Triple.seq`,
  `Triple.frame` and `Triple.call`. Do not add a second judgement beside it.

### Dependencies

- The dialect and the logic (`braid/`) depend on iris-lean and nothing else. They must not
  import an instruction-set model.
- The Lean toolchain is kept at the newest release the dependencies build on.
- Code taken from another project is ported, not vendored unchanged: it is adapted until it
  meets these rules, and its origin and licence are recorded in the module header.

## Workflow

### Building and checking

```sh
lake build                       # the lowerings and the tools (the default)
lake build Braid BraidTest       # the dialect and the logic, and their tests
lake build Examples              # the example corpus
lake env lean path/to/File.lean  # check one file
Examples/build.sh                # recompile the examples and lower them again
```

Before opening a pull request:

1. Build every module you touched and every module that imports it.
2. Confirm there are no warnings.
3. Run `#print axioms` on the theorems you added or changed.
4. If you changed a lowering, run `braid-difftest` on the examples of that instruction set.

### Pull requests

**Titles** follow `<type>(<optional scope>): <subject>`. Types are `feat`, `fix`, `proof`,
`doc`, `refactor`, `perf`, `test`, `chore` and `ci`. The scope is a directory, such as
`braid/logic`, `lowering/arm` or `examples`. The subject is imperative and lower case, with no
final full stop: `feat(lowering/x86): lower rotate instructions`.

**Descriptions** say what the change does and why, what is now proved that was not, anything
left open, and the checks you ran.

**One change per pull request.** A new rule of the logic and an example that uses it can be
two pull requests.

**Statements are an interface.** If you change the statement of a theorem others use, fix the
callers in the same pull request, or keep the old name as a deprecated alias.

### Commits

Write commit messages in the imperative, with a short first line and a body that explains why.
Keep commits buildable where you can.

## Adding an instruction to a lowering

1. Write its block in `Lowering/<ISA>/Lower.lean`, in place of the `trap`. Every case in
   which the model does not simply run the instruction must make the block fault.
2. Prove the block sound in `Lowering/<ISA>/Sound.lean`. Reuse the lemmas for the block shapes
   that are already there.
3. Add the instruction to the coverage table in `Lowering/README.md`.
4. Add or extend an example that uses it, and run `braid-difftest`.

## Adding an example

1. Add the source under `Examples/src/<language>/`, and a line to `Examples/build.sh`.
2. Run `Examples/build.sh <name>`. It writes `Examples/<Name>/<ISA>/Image.lean`, which holds
   the instructions, the lowered functions and the certificates. Do not edit it.
3. Write the specifications and proofs in `Examples/<Name>/<ISA>/Proofs.lean`. State the top
   theorem of each function about the machine, with `machine_sound`.
4. Add a row to the table in `Examples/README.md`.

## Conduct

Be respectful and constructive. Assume good faith, critique work rather than people, and help
newcomers find their way. Report unacceptable behaviour to the maintainer.
