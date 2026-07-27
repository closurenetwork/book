# Semantic Closure as a Criterion for Self-Evolving Enterprise Applications

**Draft — not yet submitted**  
Leroy Ware · 2026  
Companion to *The Last Application* (closurenetwork/book) and the Closure platform case study.

---

## Abstract

Enterprise software still treats product meaning as code that only scarce humans can safely change. Large language models can read and rewrite text, but pointing them at opaque codebases does not yield governed product evolution. We define **semantic closure** as a *criterion* on a product system: every admissible evolution must be representable in an internal model $M$ carried by the running system. For product systems we identify $M$ with a typed graph $G$ and define gated mutation $\delta$ under an integrity predicate $I$. We situate the criterion against metadata platforms, the Semantic Web, model-driven architecture, Kubernetes-style reconciliation, and agent frameworks; report a case study (Closure) that projects Experiences, BPM- and agentic workflows, knowledge, integrations, and events onto one $G$; and state what would falsify the broader claim that such substrates end the enterprise rewrite cycle.

**Keywords:** semantic closure, software architecture, model-driven systems, agentic workflows, governance, JSON-LD

---

## 1. Introduction

Seventy years of enterprise applications fused *product meaning* with *compiled artifacts*. Change required an aperture of humans who could read the code. Documentation, diagrams, and tickets became second descriptions and lost. Generative models widened the aperture for *code generation* without relocating the product into a substrate machines can verify and govern.

We argue the missing property is **semantic closure**: a system whose self-description is complete and structured enough that it can read, verify, and rewrite that description under governance while running. We formalize this as a **criterion** $F \in R(S)$, not as a theorem of mathematics, and show how a shipping platform instantiates it.

**Contributions.** (1) A seven-clause informal definition aligned to a formal criterion and typed-graph dynamics. (2) A related-work matrix locating prior traditions by missing clauses. (3) An architecture and case study: one product graph $G$, integrity $I$, workflows (BPM + agentic), projections, and admissible operators $\mathcal{A}$. (4) A falsifier for the “last rewrite” thesis.

---

## 2. Criterion

Let $S = (X, M, R)$ be a semantic state: substrate $X$, internal model $M$, representational relation $R$ (typing, linking, rendering, execution, policy). Let $\mathcal{O}_{\mathrm{adm}}(S)$ be admissible evolutions (human craft, agent edit, workflow commit, promote, heal).

**Semantic Closure Criterion.** $S$ is semantically closed when

$$F \in R(S) \quad \text{for all } F \in \mathcal{O}_{\mathrm{adm}}(S).$$

Unrepresentable change $F_\perp$ (forked UI trees, chat-only doctrine, engineer memory as SoT) witnesses failure.

For product systems we take $M \leftrightarrow G = (V,E,L)$, objects as typed DataObjects, and commit

$$\delta(G,\Delta) = G \oplus \Delta \text{ if } I(G,\Delta)=1,\ \text{else } G,$$

with $I = I_{\mathrm{str}} \wedge I_{\mathrm{type}} \wedge I_{\mathrm{ref}} \wedge I_{\mathrm{sem}}$. Projections $\pi(G)$ are disposable views, not second sources of truth.

**Seven clauses (informal ↔ formal).** Complete ↔ descriptive completeness; structured ↔ axioms on $G$; read ↔ projections and machine readers; verify ↔ $I$; rewrite ↔ $\Delta/\delta$; governance ↔ admissible set $\mathcal{A}$; while running ↔ interpreters read live $G$ without a compile fork of $M$.

---

## 3. Related work

| Tradition | Held | Gap vs criterion |
|-----------|------|------------------|
| Lisp / Smalltalk | live rewrite | enterprise governance / types |
| Semantic Web | structured linked data | live product rewrite + late reader |
| MDA / UML | design models | generated side forks at runtime |
| Salesforce / ERP metadata | product as config | sealed vendor surface; human aperture |
| Kubernetes | declared state + reconcile | infrastructure, not product meaning |
| Copilots / agents on code | read/write code | no shared governed $G$ / $I$ |

Composite novelty: all seven clauses on a **product**, with a **machine reader**, under **native governance**.

---

## 4. Case study: Closure

Closure stores organization product state as JSON-LD–shaped DataObjects. Write-through evaluates SIV Lite ($I^\circ$ approximating $I$); modes `warn` | `enforce` | `off`. Enforce mode applies hard referential checks. Multi-object commits use batch write-through (RAM-upsert then validate) so scaffolds do not fail on forward refs. Deletes emit `graph.object.deleted`. A first semantic-class check rejects raw `#hex` outside `var(--cp-*)` on components/styles. Workflows unify BPM-class control and agentic orchestration. Healing and evolution loops open issues and change requests on $G$. IDE and Console split build vs govern under $\mathcal{A}$.

**Honesty.** Default mode remains `warn` until production soak under `enforce`. Some bulk seed/pack paths still bypass per-object SIV (documented). Closing those gaps is engineering, not a new theory.

### Structural metrics (repo snapshot, 2026-07)

| Metric | Value | Notes |
|--------|------:|-------|
| Lean schema alphabet (`PLATFORM_SCHEMAS`) | 33 | Experience → evolution_recommendation lattice |
| Integrity classes in SIV Lite | 4 | structural, typing, referential, semantic |
| Commit modes | 3 | `warn` (default), `enforce`, `off` |
| Graph audit event kinds (core) | 3 | `graph.object.upserted`, `graph.object.deleted`, `siv.rejected` |
| Batch commit helper | yes | `writeThroughBatch` for create/merge/scenarios |
| Book formalization | Part V Ch 17–25 | Criterion $F\in R(S)$, $\delta$, $I$, $W$, JSON-LD |

### Operational metrics (to collect before venue submit)

Instrument in staging/prod under `CLOSURE_SIV_LITE=enforce` for ≥2 weeks:

| Metric | How |
|--------|-----|
| SIV reject rate | count `siv.rejected` / count `graph.object.upserted` |
| Event completeness | upserts with matching org_event within 5s (sample) |
| Dangling-ref incidents | referential violations in enforce logs |
| Time-to-governed-change | CR approved → graph commit latency (p50/p95) |
| Hex-leak catch rate | semantic-class rejects vs brand Issue scanner |

Until those counters ship, §4 claims stay structural + qualitative (worked loops, falsifier, honesty about $I^\circ$).

---

## 5. Falsifier

The substrate thesis fails if a future enterprise paradigm cannot be expressed as governed data operated on by intelligence (new types, tools, loops on $G$). Form-factor bets frozen in code are not counterexamples; a genuinely non-representable computational relationship between description and behavior would be.

---

## 6. Conclusion

Semantic closure is a **criterion** for self-evolving applications: relocate product meaning into $G$, gate change with $I$, restrict operators with $\mathcal{A}$, keep projections disposable. The discovery is the barrier (representation) and its removal — not a new equation. Future work: strengthen $I_{\mathrm{sem}}$, mechanize preservation of graph axioms under $\delta$, and publish quantitative case metrics.

---

## References (seed)

- Berners-Lee, Hendler, Lassila. The Semantic Web. *Scientific American*, 2001.
- Fielding. *Architectural Styles…* PhD thesis, UC Irvine, 2000.
- Goldberg & Robson. *Smalltalk-80*, 1983.
- Naur. Programming as Theory Building. 1985.
- Pattee. The Physics of Symbols. *BioSystems*, 2001.
- Weissman & Bobrowski. Force.com multitenant platform. *SIGMOD*, 2009.
- Ware. *The Last Application*, 2026. https://closureapps.com/book
- U.S. Provisional Pat. App. 63/974,920 (method; criterion itself is not claimed as pure math).

---

## Submission notes (author)

- Target venues: *IEEE Software*, JSS, ICSE SEIP, MODELS (industry).
- Expand §4 with anonymizable metrics before submit.
- Keep spectral / physics programs out of this paper’s load-bearing claims.
