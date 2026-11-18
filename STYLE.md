# Style guide

Follow the Lean community's conventions (Mathlib's style and naming guides) unless a rule here
says otherwise. When in doubt, match the surrounding code.

## Files and namespaces

- Files are `UpperCamelCase.lean`. A file's namespace mirrors its library:
  `braid/Braid/Logic/Triple.lean` is in `Braid`, `Lowering/RiscV/Sound.lean` is in
  `Lowering.RiscV`, and `Examples/Memory/RiscV/Proofs.lean` is in `Examples.Memory.RiscV`.
- Every file is a `module`, with `@[expose] public section` for definitions a proof unfolds
  and `public section` otherwise. The tools are the exception: they import a decoder that is
  not a module.
- Keep lines under 100 characters, and indent by 2 spaces.
- Every new file is reachable from the root of its library (`Braid.lean`, `Braid/Logic.lean`).

## Naming

- Types and structures are `UpperCamelCase`, definitions are `lowerCamelCase`, and theorems
  are `snake_case`.
- A theorem's name describes its statement. `_of_` separates the conclusion from the
  hypotheses (`wp_of_exec`, `holds_of_sat`), and standard words name standard facts (`refl`,
  `symm`, `trans`, `mono`, `ext`, `iff`).
- Name a declaration for what it says, never for where it came from or when it was written.
  Do not put paper numbering, phase codes or dates in names. Citations go in the module
  header.
- The same thing has the same name in every instruction set: `arch`, `lower`, `Rel`,
  `lower_sound`, `triple_sound`, `machine_sound`.
- A function's specification is `<function>_spec`. Its theorem about the machine is
  `<function>_correct`.

## Definitions

- Define a function by pattern matching on its arguments, not by a `match` inside the body,
  when proofs will `simp` with it. Lean then gives one equation for each case, and `simp only`
  unfolds the definition only where a constructor is known.
- Give each operation of a datatype its own `@[simp]` equation (`BinOp.eval_add`), so that
  `simp` evaluates an operation it knows and leaves an unknown one alone.
- Write a literal bit-vector as `0#64`, not `0`, in the statement of a lemma. That is the form
  `simp` normalises to, and a lemma stated with `0` will not fire.

## Proofs

- **Make the structure visible.** Prefer named lemmas to long monolithic proofs. A lemma that
  recurs goes in the module that owns the definition.
- **One lemma for each shape of block.** A lowering has a handful of block shapes (register to
  register, load, store, branch). Prove each once and let the instructions share them.
- **Use automation on well-scoped goals.** `simp`, `omega`, `bv_omega`, `bv_decide` and
  `decide` are welcome as terminal steps, or after a step that leaves a clear goal.
- **Prepare goals for `bv_decide`.** Turn shifts by a natural number into shifts by a
  bit-vector, and `generalize` an application of an opaque function to a variable, before
  calling it.
- **Keep 64-bit literals away from the unifier.** `assumption` and `exact` at default
  transparency will unfold bit-vector arithmetic on large literals. Use `with_reducible` when
  a syntactic match is what you mean.
- **Be careful with resource limits.** Avoid raising `maxHeartbeats` or `maxRecDepth`. When it
  is needed, scope it to one declaration with `set_option … in`.

## Specifications

- A specification names every location the code touches, and no others. The frame rule adds
  the rest.
- State the atoms of a postcondition in the order of the precondition where you can. The
  proof then ends by `rfl`.
- A register the code clobbers is `.prop (regAny r)` in the postcondition, unless the caller
  needs its value.
- Write an offset from the stack pointer as `s - 16#64`. `braid_norm` turns it into the
  addition the code computes.
- State the top theorem of an example about the machine model, with no notion of the dialect
  in it.

## Documentation

- **Module headers.** Every file starts with a block comment that names the module and says
  what it contains, in a few sentences, followed by `## Main definitions` and
  `## Main results` where there are any.
- **Docstrings.** Every definition and every main theorem has a `/-- … -/` docstring that says
  what it means, not how it is proved.
- **READMEs.** When you add, remove or move a file, update the `README.md` of its directory.
  When you change what is trusted, update `docs/Trust.md`.
- **Clear prose.** Write plain, direct English. Use backticks for Lean names, and say what a
  theorem guarantees and under which assumptions.
