import Lean
import Cas.algebraic
open Lean Lean.Expr Lean.Meta
open Algebraic Polynomial

inductive Cmd :=
  | roots (p : poly) : Cmd

def Spec (cmd : Cmd) : Prop := match cmd with
  | Cmd.roots p => ∃ a : algebraic, a.root_of = p

