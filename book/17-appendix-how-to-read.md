# How to Read These Appendices

Parts I–IV argue in prose. Part V makes the same claim precise: a formal core, an architecture that expresses it, a runtime that projects it, and the concrete language (JSON-LD) in which the graph is written. These chapters are for public readers — engineers, architects, and skeptics. Everything needed is stated here.

## Four layers

| Layer | Chapters | Question answered |
|-------|----------|-------------------|
| **A — Formal theory** | 18–20 | What objects and transitions define a semantically closed product? |
| **B — Architecture** | 21–23 | How are those objects stored, pillared, projected, and governed? |
| **C — Concrete syntax** | 24–25 | What does $G$ look like as JSON-LD, and how does a run actually move? |
| **D — Thesis** | close of 17 + close of 25 | Why autonomous product evolution was improbable before — and what this book does *not* claim |
| **E — First principles** | 26 | Six axioms (A1–A6); conjectures toward laws; meta-lab via Goals |

Read A then B then C the first time. After that, Chapter 20 (workflows), Chapter 23 (control plane), and Chapter 25 (execution in the concrete) are the usual return visits.

## Notation

| Symbol | Meaning |
|--------|---------|
| $S = (X, M, R)$ | Semantic state: substrate, model, representational relation |
| $F \in R(S)$ | Semantic closure: evolution is representable in the model |
| $G = (V, E, L)$ | Typed product graph (objects, links, labels) |
| $o \in V$ | A DataObject (identity, schema, payload, links) |
| $\Delta$ | A proposed mutation (finite set of creates, updates, deletes) |
| $\delta$ | Commit map: validate then apply $\Delta$ to $G$ |
| $I(G, \Delta)$ | Integrity predicate (true iff $\Delta$ may commit) |
| $I^\circ$ | Runtime approximation of $I$ (may be weaker; see Ch 19–21) |
| $W = (N, A, \kappa, \mu)$ | Workflow graph: nodes, arcs, kind map, metadata |
| $\rho$ | Run state of a workflow instance |
| $\pi$ | A projection $G \to$ view (Experience, API, IDE tree, …) |
| $\mathcal{A}$ | Set of admissible operators from $\mathsf{PDP}(\Pi)$ (Ch 23) |
| $\Pi$ | Active `schema:policy` documents on $G$ |
| $\mathsf{PDP}$ | Policy Decision Point: request → effect |
| `@graph` | JSON-LD document array realizing a finite piece of $G$ |

Inline math uses single dollars; displays use double dollars. JSON examples use fenced code blocks.

## What “exhaustive” means here

Exhaustive for the **paradigm of the product**: every facet that must be self-describing — Experiences, process (BPM-class), agentic orchestration, knowledge, integrations, events, brand, governance — is given a mathematical object, an architectural place, and (in Chapters 24–25) a concrete JSON-LD shape. Where a shipping runtime evaluates only $I^\circ \le I$ (for example typing with warn-mode write-through), the ideal $I$ is still the theory; the approximation is named honestly in Chapters 19 and 21.

## The load-bearing claim (and what we do not claim)

**Before this paradigm:** product meaning lived chiefly in code that only humans could safely change. Machine intelligence could generate more code, but it could not *own* product evolution under shared governance while the system ran.

**After semantic closure:** product meaning lives in a complete, typed, governed graph $G$ with $F \in R(S)$. The same intelligence — and humans — can propose, verify, and commit evolution under admissible operators $\mathcal{A}$ while interpreters in $X$ keep running.

That is a theory of **self-evolving applications**: embedded product intelligence plus gates. It removes the structural barrier that made autonomous product evolution improbable. Whether that accelerates a broader “singularity” is a consequence others may debate; this book’s load-bearing claim is the barrier and its removal — not inevitability, and not AI inventing new base models or training loops. That separate program (intelligence evolving intelligence itself) lies outside these appendices.

## The point

Chapter 3’s seven clauses are load-bearing English. Part V is the same clauses as equations, architecture, and JSON-LD — the multiplication table of the theory.
