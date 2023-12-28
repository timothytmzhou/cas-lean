This (work-in-progress) project aims to provide a partial interface between the Lean proof assistant and a small fragment of the SageMath computer algebra system. 
Specifically, we are currently working on a mechanism in Lean for explicitly finding (and certifying correct) real roots of polynomials in Q[x].
An algebraic number in Sage can be represented as a polynomial together with an isolated interval containing exactly one root.
The current plan is to use [Sturm's theorem](https://en.m.wikipedia.org/wiki/Sturm%27s_theorem) to give a certified version of such a representation in Lean.

Please note that this is ongoing work and parts are incomplete.
