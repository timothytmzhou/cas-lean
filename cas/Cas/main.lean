import Lean
import Mathlib
import Cas.algebraic
open Lean Lean.Expr Lean.Meta
open Algebraic Polynomial

-- note that option only works with values of sort Type, so we can't use that
inductive Partial (P : Prop) : Type :=
| Proved : P → Partial P
| Failed

namespace Sage
  inductive Cmd : Type :=
    | roots (p : poly) : Cmd

  def Spec (cmd : Cmd) : Prop := match cmd with
    | Cmd.roots p => ∃ a : algebraic, a.root_of = p

  def callSage (query : String) : IO String := sorry

end Sage

namespace Roots
  inductive SageRootResult :=
  | Rat (r : ℚ) : SageRootResult
  | Interval (i : Interval.interval) : SageRootResult

  def intervalOfRootResult (srr : SageRootResult) : Interval.interval :=
    match srr with
    | SageRootResult.Rat r =>  ⟨r, r⟩
    | SageRootResult.Interval i => i

  def certifyRoot (p : poly) (srr : SageRootResult)
  : Partial (isolated_root p (intervalOfRootResult srr)) :=
    match srr with
    | SageRootResult.Rat r =>
      let res := eval_at_rat p r
      if h : (res = 0)
        then Partial.Proved $ exact_is_isolated p r (rat_root_to_real h)
        else Partial.Failed
    | _ => Partial.Failed -- TODO: Sturm's theorem for this case!

  def findRoot (p : poly) : IO (Option algebraic) := do
    let serialized := toString p
    let query := sorry
    let res ← Sage.callSage query
    let parse_res (s : String) : SageRootResult := sorry
    let srr := parse_res res
    pure $ match certifyRoot p srr with
    | Partial.Proved cert => some ⟨p, intervalOfRootResult srr, cert⟩
    | Partial.Failed => none

end Roots

open Sage Roots

def runCmd (cmd : Cmd) : MetaM Unit :=
  let spec := Spec cmd
  match cmd with
  | Cmd.roots p => do
    let r ← findRoot p
    sorry
