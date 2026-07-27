# Semantic State and Representability

This chapter defines semantic closure as a membership condition on evolution, and identifies the product’s internal model with a typed graph. Every later chapter assumes these definitions.

## Semantic state

**Definition 18.1 (Semantic state).** A system carries a semantic state

$$S = (X, M, R)$$

where:

- $X$ is the **substrate** — the physical and computational machinery that stores bits and runs interpreters (hosts, databases, engines, model APIs).
- $M$ is the **internal model** — a structured description of the product and the aspects of the world the product must know.
- $R$ is the **representational relation** — the correspondence between states of $M$ and states of the world, together with the causal paths by which changes in $M$ change what $X$ does.

$R$ is not a single function. It includes typing, linking, rendering, execution, and policy. What matters is that $R$ is *internal*: the system does not need an external manuscript to know what it is.

## Evolution and semantic closure

Let $\mathcal{O}(S)$ be the set of evolution operators available to the system at $S$ — every way the product may change: human craft, agent edit, workflow commit, promote, heal, install.

**Definition 18.2 (Semantic Closure Criterion).** The system is **semantically closed** at $S$ when every admissible evolution lies in the representational capacity of $S$:

$$F \in R(S) \quad \text{for all } F \in \mathcal{O}_{\mathrm{adm}}(S).$$

Equivalently: there is no admissible change whose meaning exists only outside $M$ (in a slide deck, a forked UI tree, an unrecorded chat, or an engineer’s memory). If such a change exists, write $F_\perp$ for its unrepresentable component; then $F \notin R(S)$.

**Reading.** This is a *criterion* on product systems, not a theorem of pure mathematics. Semantic closure is not Turing completeness. It is the absence of a silent second description of the product.

## The model as a typed graph

For product systems of the kind this book describes, $M$ is realized as a finite labeled directed graph.

**Definition 18.3 (Product graph).**

$$G = (V, E, L)$$

- $V$ is a finite set of **objects** (nodes).
- $E \subseteq V \times V$ is a finite set of **links** (directed edges), possibly with edge labels drawn from a finite alphabet.
- $L: V \to \Sigma$ assigns each object a **schema label** from a finite schema alphabet $\Sigma$.

**Definition 18.4 (DataObject).** An object $o \in V$ is a record

$$o = (\mathrm{id}(o),\, L(o),\, d(o),\, \ell(o))$$

where $\mathrm{id}(o)$ is a globally unique identifier, $L(o) \in \Sigma$ is its schema, $d(o)$ is a typed payload (a finite key–value structure conforming to the schema), and $\ell(o)$ is the set of outbound link targets in $V$.

**Definition 18.5 (Schema).** A schema $\sigma \in \Sigma$ is a signature

$$\sigma = (\mathrm{req}_\sigma,\, \mathrm{opt}_\sigma,\, \tau_\sigma)$$

where $\mathrm{req}_\sigma$ and $\mathrm{opt}_\sigma$ are finite sets of field names and $\tau_\sigma$ assigns each field a value type (string, boolean, number, enum, object, array, reference, …). Write $d(o) \models \sigma$ when the payload satisfies the signature.

**Axiom 18.1 (Identity).** $\mathrm{id}: V \to \mathsf{ID}$ is injective. No two live objects share an identifier.

**Axiom 18.2 (Typing).** For every $o \in V$, $d(o) \models L(o)$.

**Axiom 18.3 (Referential integrity).** For every link $(u, v) \in E$, $v \in V$.

When these axioms hold, $G$ is a well-formed product graph. Chapter 19 treats violations as rejected mutations.

## Completeness of the product description

Let $\mathcal{P}$ be the set of product facets the organization treats as first-class: experience structure, process definitions, knowledge, integrations, events, brand, policy, and skills.

**Definition 18.6 (Descriptive completeness).** $G$ is **descriptively complete** for $\mathcal{P}$ when there is a surjective assignment

$$\Phi: \mathcal{P} \twoheadrightarrow \mathsf{Parts}(G)$$

such that every facet $p \in \mathcal{P}$ is encoded as a (possibly empty) subgraph $\Phi(p) \subseteq G$, and every runtime behavior attributed to $p$ is a function of $\Phi(p)$ and $X$ alone.

If some facet lives only in $X$ (hard-coded pages, shadow process engines, chat-only doctrine), descriptive completeness fails and $F \in R(S)$ fails for changes to that facet.

## Chart of the state

**Definition 18.7 (Computational chart).** On the open set of well-formed graphs, identify

$$M \;\;\longleftrightarrow\;\; G$$

so that the semantic state for product work is effectively

$$S \;\;\simeq\;\; (X,\, G,\, R_G)$$

with $R_G$ the interpreters attached to $G$ (renderer, workflow engine, query API, agent tools, policy checker).

This is the sense in which **the graph is the source of truth**: $G$ is $M$, and projections of $G$ are not alternative models.

## Seven clauses, formalized

| Clause | Formal reading |
|--------|----------------|
| Complete | Descriptive completeness (Def 18.6); $F \in R(S)$ |
| Structured | $G$ with Axioms 18.1–18.3 |
| Read | Existence of projections $\pi$ and machine readers of $G$ |
| Verify | Integrity predicate $I$ before commit (Ch 19) |
| Rewrite | Mutations $\Delta$ applied by $\delta$ (Ch 19) |
| Under governance | Restriction to admissible operators $\mathcal{A}$ (Ch 23) |
| While running | Interpreters in $X$ read live $G$ without a compile step that forks $M$ |

## The point

Semantic closure is $F \in R(S)$. For this paradigm, $M$ is the typed graph $G$. The next chapter defines how $G$ moves.
