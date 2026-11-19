/-
  Braid

  The `braid` dialect and its logic. See `braid/README.md`.
-/

module

public import Braid.IR.Syntax
public import Braid.IR.Semantics
public import Braid.IR.Mem
public import Braid.IR.Exec
public import Braid.IR.Print
public import Braid.Pass.Dce
public import Braid.Pass.Fuse
public import Braid.Pass.DeadFlags
public import Braid.Pass.Simplify
public import Braid.Pass.DceFast
public import Braid.Pass.Plan
public import Braid.Logic
