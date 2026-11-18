/-
  Braid.Logic.Tactic

  Tactics for symbolic execution. `braid_step` runs the block at the program counter on the
  symbolic state, and `braid_run` keeps going until execution reaches an address the program
  has no block for, such as a return address, or a branch whose direction is not known.

  ## Main definitions

  * `braid_at`, `braid_upd`: find an atom in the symbolic state
  * `braid_norm`: put values and addresses in normal form
  * `braid_block`, `braid_step`, `braid_run`: run a block, one block of a program, a program
  * `braid_done`: finish, when the symbolic state is the postcondition
-/

module

public import Braid.Logic.Exec

public section

namespace Braid

/-- Find an atom in the symbolic state. -/
macro "braid_at" : tactic =>
  `(tactic| repeat (first | exact Atoms.At.here | apply Atoms.At.there))

/-- Find an atom in the symbolic state, and build the state with it replaced. -/
macro "braid_upd" : tactic =>
  `(tactic| repeat (first | exact Atoms.Upd.here | apply Atoms.Upd.there))

/-- Put values and addresses in normal form: look up SSA values, evaluate operations, and
fold constants. -/
macro "braid_norm" loc:(Lean.Parser.Tactic.location)? : tactic =>
  `(tactic| try simp only [Env.set_apply, Nat.reduceEqDiff, ↓reduceIte,
    BinOp.eval_add, BinOp.eval_sub, BinOp.eval_mul, BinOp.eval_mulhu, BinOp.eval_mulhs,
    BinOp.eval_mulhsu, BinOp.eval_udiv, BinOp.eval_urem, BinOp.eval_sdiv, BinOp.eval_srem,
    BinOp.eval_and, BinOp.eval_or, BinOp.eval_xor, BinOp.eval_shl, BinOp.eval_lshr,
    BinOp.eval_ashr, BinOp.eval_rotr, BinOp.eval_eq, BinOp.eval_ne, BinOp.eval_ult,
    BinOp.eval_ule, BinOp.eval_slt, BinOp.eval_sle, UnOp.eval_not, UnOp.eval_neg,
    UnOp.eval_clz, UnOp.eval_popcnt, UnOp.eval_rbit, UnOp.eval_bswap, UnOp.eval_sext,
    UnOp.eval_zext, Width.bytes, Width.bits, BitVec.add_assoc, BitVec.reduceAdd,
    BitVec.reduceSub, BitVec.reduceNeg, BitVec.reduceMul, BitVec.add_zero, BitVec.zero_add,
    ne_eq, ofBool_eq_zero, ofBool_bne_zero, Bool.not_eq_false, beq_iff_eq, bne_iff_ne, beq_eq_false_iff_ne, BitVec.reduceEq, BitVec.reduceNe,
    BitVec.reduceULT, BitVec.reduceULE, BitVec.reduceSLT, BitVec.reduceSLE, reduceCtorEq,
    not_true_eq_false, not_false_eq_true, Decidable.not_not] $[$loc]?)

/-- Run one operation on the symbolic state. -/
macro "braid_op" : tactic =>
  `(tactic| first
    | apply OpsSpec.const
    | apply OpsSpec.un
    | apply OpsSpec.bin
    | apply OpsSpec.select
    | apply OpsSpec.get (by braid_at)
    | apply OpsSpec.set (by braid_upd)
    | apply OpsSpec.getf (by braid_at)
    | apply OpsSpec.setf (by braid_upd)
    | apply OpsSpec.load (by braid_at)
    | apply OpsSpec.store (by braid_upd)
    | (apply OpsSpec.havoc; intro _)
    | apply OpsSpec.guard)

/-- Run a terminator on the symbolic state. A conditional branch leaves two goals, each
with the condition as the hypothesis `hbr`. -/
macro "braid_term" : tactic => do
  let hbr := Lean.mkIdent `hbr
  `(tactic| first
    | apply TermSpec.jump (by braid_upd)
    | apply TermSpec.jumpInd (by braid_upd)
    | (apply TermSpec.branch (by braid_upd) (by braid_upd) <;>
        (intro $hbr:ident; braid_norm at $hbr:ident)))

/-- Run a block on the symbolic state. -/
macro "braid_block" : tactic =>
  `(tactic| (apply BlockSpec.intro
             repeat (braid_op; braid_norm)
             apply OpsSpec.nil
             braid_term <;> braid_norm))

/-- Run the block at the program counter. -/
macro "braid_step" : tactic =>
  `(tactic| (apply Triple.step (by braid_at) (by rfl); braid_block))

/-- Run blocks for as long as the program has one at the program counter. -/
macro "braid_run" : tactic =>
  `(tactic| repeat braid_step)

/-- Finish: the symbolic state is the postcondition. -/
macro "braid_done" : tactic =>
  `(tactic| (apply Triple.done_eq; first | rfl | simp_all))

end Braid
