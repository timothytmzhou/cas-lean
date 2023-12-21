import Mathlib
import Mathlib.Data.Vector
import Lean

namespace Polynomial
  /-
    Polynomials are lists of rationals (the coefficients, in increasing power order)
  -/

  def poly : Type := List ℚ
    deriving Repr, ToString

  def eval_at_real (p : poly) (r : ℝ) : ℝ :=
    let rec sum_terms i p := match p with
    | [] => 0
    | x::xs => x * r^i + sum_terms (i+1) xs
    sum_terms 0 p

end Polynomial

namespace Interval
  -- closed intervals
  structure interval where
    (a : ℚ)
    (b : ℚ)
  deriving Repr

  def part_of (i : interval) (r : ℝ) : Prop := i.a ≤ r ∧ r ≤ i.b
end Interval

namespace Algebraic
  open Polynomial
  open Interval

  /-
    A polynomial p has an isolated root in an interval if there is a unique root for p in that interval
  -/
  def isolated_root (p : poly) (i : interval) : Prop := ∃! r : ℝ, (part_of i r) ∧ (eval_at_real p r = 0)

  -- this proof is a bit gross since I don't know the lean tactics
  lemma exact_is_isolated (p : poly) (rt : ℚ) (_ : eval_at_real p rt = 0) : isolated_root p ⟨rt, rt⟩ := by
    apply exists_unique_of_exists_of_unique
    case hex =>
      exists rt
    case hunique =>
      intros y1 y2
      intros h1 h2
      have : y1 = rt := by
        have : rt ≤ y1 := by apply (And.left (And.left h1))
        have : y1 ≤ rt := by apply (And.right (And.left h1))
        linarith
      have : y2 = rt := by
        have : rt ≤ y2 := by apply (And.left (And.left h2))
        have : y2 ≤ rt := by apply (And.right (And.left h2))
        linarith
      linarith

  /-
    An algebraic number is the root of a polynomial, represented by an interval containing an isolated root of that polynomial.
  -/
  structure algebraic where
    root_of : poly
    i : interval
    wd : isolated_root p i

end Algebraic
