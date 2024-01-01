import Mathlib
import Mathlib.Data.Vector

import Lean

namespace Polynomial
  /-
    Polynomials are lists of rationals (the coefficients, in increasing power order)
    TODO: we are defining a polynomial type because the one in Mathlib cannot be computed with directly. In particular, we need to be able to evaluate roots and such. However, we should probably be using the one in mathlib in stating isolated_root (then we can drop eval_at_real) and then proceed via reflection. For this we need to prove equivalence of definitions though, see https://leanprover.zulipchat.com/#narrow/stream/113488-general/topic/Way.20to.20recover.20computability.3F.
  -/

  def poly : Type := List ℚ
    deriving Repr, ToString

  def eval_at_rat (p : poly) (r : ℚ) : ℚ :=
    let rec sum_terms i p := match p with
    | [] => 0
    | x::xs => x * r^i + sum_terms (i+1) xs
    sum_terms 0 p

  def eval_at_real (p : poly) (r : ℝ) : ℝ :=
    let rec sum_terms i p := match p with
    | [] => 0
    | x::xs => x * r^i + sum_terms (i+1) xs
    sum_terms 0 p

  lemma rat_root_to_real {p : poly} {r : ℚ} : (eval_at_rat p r) = 0 → (eval_at_real p r = 0) := by
    have h2: (∀ i : ℕ, eval_at_real.sum_terms r i p = eval_at_rat.sum_terms r i p ) := by
      induction p with
      | nil =>
        unfold eval_at_rat.sum_terms
        unfold eval_at_real.sum_terms
        simp
      | cons _ _ ih =>
        intro i
        unfold eval_at_rat.sum_terms
        unfold eval_at_real.sum_terms
        simp
        apply (ih (i + 1))
    intro h1
    have h3 : eval_at_real p r = eval_at_rat p r := by
      unfold eval_at_rat
      unfold eval_at_real
      apply (h2 0)
    have h4 : eval_at_rat p r = (0 : ℝ) := by simp; apply h1
    exact (Eq.trans h3 h4)

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
    wd : isolated_root root_of i

end Algebraic
