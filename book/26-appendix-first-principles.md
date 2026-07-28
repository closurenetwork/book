# First Principles

Part V defined objects and transitions. This chapter names the **axioms** those objects obey — the first principles of the paradigm. They are not theorems of nature. They are the load-bearing assumptions under which $F \in R(S)$, gated $\delta$, and self-evolving applications make sense. Prize-class science begins only when one of them yields a quantitative, falsifiable prediction (see § From axioms to laws).

Notation follows Chapters 17–19: semantic state $S = (X, M, R)$, model as typed graph $G$, mutation $\Delta$, integrity $I$, commit $\delta$, admissible operators $\mathcal{A}$, projections $\pi$.

## The six axioms

**Axiom A1 (Representation before intelligence).**  
Admissible evolution acts on the internal model. Formally: for every $F \in \mathcal{O}_{\mathrm{adm}}(S)$, the product-facing meaning of $F$ lies in $R(S)$ — equivalently, there is no silent $F_\perp$ whose only home is code, chat, or a forked UI tree. Intelligence without an addressable model cannot *own* product change; it can only generate more illegible text.

**Axiom A2 (Description equals behavior).**  
Projections are disposable:

$$\pi: G \to \mathsf{View}, \qquad \pi(G) \text{ regenerable from } G.$$

Editing $\pi(G)$ without a validated $\Delta$ on $G$ is exactly $F_\perp$ (Axiom 19.1). The graph is the source of truth; the screen is not.

**Axiom A3 (Verification before autonomy).**  
Commit is gated:

$$\delta(G, \Delta) \;=\;
\begin{cases}
G \oplus \Delta & \text{if } I(G, \Delta) = 1 \\
G & \text{otherwise.}
\end{cases}$$

Autonomy is not the absence of gates. Without $I$, rewrite is fire. Runtime may evaluate $I^\circ \le I$; the axiom still names the ideal.

**Axiom A4 (Governance is constitutive).**  
Only operators in the admissible set may propose commits that the organization treats as product evolution:

$$\mathcal{O} \in \mathcal{A}(c) \quad\text{for context } c = (p,\, e,\, \mathsf{role},\, \mathsf{kind},\, \mathsf{caps}).$$

$\mathcal{A}(c)$ is computed from active Policies $\Pi$ by a single $\mathsf{PDP}$ (Chapter 23): deny dominates; write-class actions fail closed; humans, agents, and services are distinct principals. Integrity $I$ remains separate. $\mathcal{A}$ is not bureaucracy bolted on afterward — it is what makes power grantable to humans and machines alike, and what contains both when they go rogue.

**Axiom A5 (Completeness of the product facet set).**  
Let $\mathcal{P}$ be the facets the organization treats as first-class product. Descriptive completeness (Definition 18.6) requires a surjective assignment $\Phi: \mathcal{P} \twoheadrightarrow \mathsf{Parts}(G)$ such that runtime behavior attributed to each $p \in \mathcal{P}$ is a function of $\Phi(p)$ and $X$ alone. Partial models lose; second descriptions lose.

**Axiom A6 (Live interpreters).**  
Interpreters in the substrate $X$ read the live graph $G$ without a compile step that forks $M$ into a generated artifact. “While running” is the clause that closes the model-driven gap: there is no authoritative generated side beside $G$.

## How the axioms hang together

```
A5 completeness  ->  A1 representation worth having
A2 no second SoT ->  A6 interpreters stay honest
A3 I gates δ     ->  A4 A makes autonomy grantable
```

Drop any one and the seven clauses of Chapter 3 collapse into something the industry has already built and outgrown.

## From axioms to laws (predictions, not trophies)

Axioms are assumptions. **Laws** would be quantitative claims derived from them and tested in the wild. Candidates the Closure meta-lab is built to attack (Goals → change requests → measured outcomes):

| Candidate law | Prediction | Measure |
|---------------|------------|---------|
| **Autonomy–Integrity Tradeoff** | Safe autonomous rewrite rate is bounded by the strength of $I$ (and $\mathcal{A}$); weakening $I$ raises defect escape | Reject rate, escape defects, autonomy % |
| **Illegibility Cost** | Maintenance / rewrite cost tracks the unrepresentable fraction of product meaning ($\lvert F_\perp\rvert$), not LOC alone | Share of change that cannot land as $\Delta$; rewrite spend |
| **Closure Score** | A computable $C(G, I, \mathcal{E})$ (completeness × integrity coverage × event completeness) predicts heal/evolve success | Calibrate $C$ on orgs; correlate with loop outcomes |

Until measured, these remain **conjectures**. The book’s load-bearing claim stays the barrier and its removal — not inevitability, not AI inventing new base models.

## The Closure meta-lab

On the worked example’s home organization, these axioms are operationalized as **Goals** — attractors for evolution — not as a separate product surface. Active Goals draft **change requests** (executable briefs). Humans remain in $\mathcal{A}$: they approve intent and work orders. Agents propose; gates decide; events remember.

That loop dogfoods the paradigm: theory, architecture, and implementation stay on $G$, under the same first principles. It does **not** claim the loop invents prize-grade science unaided. Validated laws still require conjecture, measurement, and public failure.

Deeper physical theory and “AI building AI” belong to a careful **bridge** Goal — proposals and links, never an automatic import into product $I$.

## The point

Six axioms — representation before intelligence, description equals behavior, verification before autonomy, constitutive governance, facet completeness, live interpreters — are the first principles of semantic closure. They underwrite $F \in R(S)$ and gated $\delta$. Turning them into laws means measuring predictions, not writing more adjectives. The next step in the worked example is not a new chapter: it is Goals on the Closure organization, grounded in this book as Knowledge, evolving the substrate under $\mathcal{A}$.
