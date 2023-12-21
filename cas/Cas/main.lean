import Lean
import Cas.algebraic
open Lean Lean.Expr Lean.Meta
open Algebraic Polynomial

inductive Cmd :=
  | roots (p : poly) : Cmd

def Spec (cmd : Cmd) : Prop := match cmd with
  | Cmd.roots p => ∃ a : algebraic, a.root_of = p

def callSage (query : String) : IO String := sorry

def findRoot (p : poly) : IO algebraic := do
  let serialized := toString p
  let query := sorry
  let res ← callSage query
  let parse_algebraic (s : String) : algebraic := sorry
  pure $ parse_algebraic res

def runCmd (cmd : Cmd) : MetaM Unit :=
  let spec := Spec cmd
  match cmd with
  | Cmd.roots p => do
    let r ← findRoot p
    sorry
