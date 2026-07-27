# Part V First-Principles Audit — 2026-07-27 (rev. scope)

**Scope.** *The Last Application* Part V (`book/17`–`23`) against **Closure Platform as built**, plus only deeper theory that is directly useful on that path.

**Question (revised).** What must the technical appendices carry so the paradigm is rigorous *for the product*, without importing the foundation books’ AI/physics program?

---

## Scope correction (same day)

**Finding:** The first pass borrowed spectral $\chi$, Ware’s Law, Thm 4.3 proof approaches, Approach C, $\oplus_\chi$, agency commutators, and χ-budget Prop 4.2 because they sit next to “semantic closure” in `closure-books`. **Platform does not implement them. They are not required to justify or ship the product paradigm.**

| Borrowed from books | Keep in Part V? | Why |
|---------------------|-----------------|-----|
| Spectral $\chi$ / $\lambda_2$ / Cor 32.1 routing | **No** | Not in Platform; not next concrete step |
| Ware redline / $m^2$ | **No** | Physics/AI track |
| Full Thm 4.3 (Hilbert, $\delta S_{\mathrm{coh}}=0$, Approaches A/B/C) | **No** as load-bearing | Optional “go deeper”; product ladder is engineering |
| $\oplus_\chi$ formula | **No** | Not a runtime operator |
| Agency commutator | **No** | AI/physics |
| Approach C / App H coalgebra | **No** | Not implementing |
| $F \in R(S)$ membership | **Yes** | Exact product claim |
| Typed graph $G$ as SoT | **Yes** | What Platform is |
| $\delta$: propose → validate → commit | **Yes** | What write-through / workflows / loops do |
| Four integrity classes as **verify target** | **Yes** | Immediately actionable hardenings |
| SIV-lite + craft/promote honesty | **Yes** | What ships |
| Workflows, parallel write-safety, loops | **Yes** | What ships |
| Pillars / brand / IDE–Console / ladder | **Yes** | What ships |

Appendix A was rewritten the same day to match this table. Architecture chapters (21–23) stay Platform-native; honesty boxes no longer apologize for missing spectral $\chi$.

---

## Verdict (after scope correction)

| Layer | Verdict |
|-------|---------|
| **Formal core** | Sufficient: membership + graph SoT + gated $\delta$ + integrity target |
| **Architecture** | Expresses that core |
| **Runtime** | Projection of that core; next work is **harden verify / events / settings-on-G**, not import $\chi$ |

**One-line answer.** No reason was found to keep spectral (or coalgebraic) machinery in the product appendices. Keep the paradigm objects Platform already runs; invest in verify depth.

---

## What we should implement next (product path)

Ordered by direct connection to $F \in R(S)$:

1. **Enforce-mode SIV-lite** (fail-closed typing) on production write-through  
2. **Hard referential** checks (drop soft-ref skip where safe)  
3. **Complete event emit** on graph commits (memory inside $R(S)$)  
4. **Governance settings on $G`** (or document as deliberate kernel config)  
5. Stronger **semantic/policy** class via craft + promote gates (already the right surface)

**Not on the immediate list:** spectral $\chi$ diagnostics, χ-invariance routing, coalgebraic runtimes.

---

## Side discoveries worth keeping (product-useful only)

| ID | Connection | Use now |
|----|------------|---------|
| D4 | Loops = gated $\delta$ | Invest in verifiers, not model self-grade |
| D5 | Ladder = admissible mutations | Trust center is part of $R(S)$, not bureaucracy |
| D6 | Brand `--cp-*` = projection discipline | Craft fail-on-hex protects SoT |
| D7 | Events vs Issues | Memory vs judgment — both belong on $G$ |
| D10 | Unrepresentable change = Ch 2 split | Product language; no $m^2$ required |

Dropped from load-bearing discovery list: Approach C↔SIV, redline/collapse dual regime, Prop 4.2 χ-budget formalism, Cor 32.1 + Thm 33.5 spectral entanglement.

---

## Sources (after correction)

- **Primary:** Closure Platform docs + `packages/semantic` + Part V manuscript  
- **Optional:** `closurenetwork/books` for readers who want the physics/AI program — not cited as requirements in Part V body
