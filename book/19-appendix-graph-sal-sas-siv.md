# Graph Dynamics and Integrity

Chapter 18 fixed $G$ as the model. This chapter defines change: proposals, integrity, commit, events, and projections.

## Mutations

**Definition 19.1 (Mutation).** A mutation $\Delta$ is a finite triple

$$\Delta = (C, U, D)$$

where $C$ is a set of objects to create, $U$ a set of $(\mathrm{id}, d')$ payload updates (and optional link rewrites), and $D$ a set of identifiers to delete.

Write $|\Delta|$ for the number of affected objects. The empty mutation is $\Delta = (\emptyset, \emptyset, \emptyset)$.

**Definition 19.2 (Application).** Given well-formed $G$ and $\Delta$, the raw application $G \oplus \Delta$ is the graph obtained by inserting $C$, applying $U$, and removing $D$ (and all edges incident to deleted nodes). Raw application need not preserve Axioms 18.1–18.3.

## Integrity

**Definition 19.3 (Integrity predicate).** An integrity predicate is a boolean

$$I(G, \Delta) \in \{0, 1\}.$$

$\Delta$ is **admissible** at $G$ when $I(G, \Delta) = 1$.

**Definition 19.4 (Four integrity classes).** Decompose

$$I(G, \Delta) \;=\; I_{\mathrm{str}} \wedge I_{\mathrm{type}} \wedge I_{\mathrm{ref}} \wedge I_{\mathrm{sem}}$$

where, writing $G' = G \oplus \Delta$:

1. **Structural** $I_{\mathrm{str}}$ — $G'$ has no forbidden cycles or orphan components relative to the structural rules of $\Sigma$ (for example: every page reachable from an experience root; no component parenting cycles).
2. **Typing** $I_{\mathrm{type}}$ — for every $o \in V(G')$, $d(o) \models L(o)$.
3. **Referential** $I_{\mathrm{ref}}$ — every edge target in $G'$ exists in $V(G')$.
4. **Semantic** $I_{\mathrm{sem}}$ — all declared domain invariants and policy constraints hold (quality gates, brand rules, environment policy, constitutional flags).

**Ideal.** Commit only when $I = 1$.

**Runtime approximation.** A deployed system may evaluate $I^\circ \le I$ (for example typing plus soft referential checks) and treat some failures as warnings rather than hard rejects. The mathematics of the paradigm remains the full $I$; $I^\circ$ is an implementation gap to close, not a different theory (same claim in Chapter 21).

## The transition $\delta$

**Definition 19.5 (Gated transition).** The commit map is

$$\delta(G, \Delta) \;=\;
\begin{cases}
G \oplus \Delta & \text{if } I(G, \Delta) = 1 \\
G & \text{otherwise.}
\end{cases}$$

**Definition 19.6 (Action pipeline).** An action $a$ (craft step, workflow step, API mutation, heal) induces a proposal $\mathrm{Prop}(a, G) = \Delta_a$. The full pipeline is

$$G \;\xrightarrow{\;a\;}\; \Delta_a \;\xrightarrow{\;I\;}\; \delta(G, \Delta_a) \;=\; G'.$$

Mnemonic: **execute → propose → validate → commit**.

**Proposition 19.1 (Closure under gated transition).** If $G$ satisfies Axioms 18.1–18.3 and $I$ includes at least $I_{\mathrm{type}} \wedge I_{\mathrm{ref}} \wedge I_{\mathrm{str}}$, then $G' = \delta(G, \Delta)$ satisfies the same axioms whenever $I(G, \Delta) = 1$.

*Proof sketch.* Typing and referential classes are exactly Axioms 18.2–18.3 on $G'$; structural class restores well-formed reachability; identity injectivity is preserved if creates mint fresh ids and updates do not rebind $\mathrm{id}$. $\square$

## Events

**Definition 19.7 (Event).** An event $e$ is an object with schema in the event family, recording a transition:

$$e = (\mathrm{id},\, t,\, \mathsf{actor},\, \mathsf{kind},\, \mathsf{payload})$$

with timestamp $t$ and a payload sufficient to audit $\Delta$ (or a redacted digest).

**Ideal.** Every successful commit emits at least one event. Incomplete emit paths are holes in organizational memory — $R(S)$ that cannot see its own past.

**Definition 19.8 (Issue).** An issue is a judgment object opened by a workflow or gate, distinct from a raw event: events say *what happened*; issues say *what must be resolved*.

## Projections

**Definition 19.9 (Projection).** A projection is a map

$$\pi: \mathbf{Graph} \to \mathsf{View}$$

computable from $G$ (and configuration in $X$) alone. Examples: Experience HTML, GraphQL responses, IDE page trees, Assistant retrieval contexts, brand CSS variables.

**Axiom 19.1 (Disposable views).** If $\pi(G)$ is lost, it is regenerable from $G$. No projection is a second source of truth. Editing $\pi(G)$ without updating $G$ is exactly $F_\perp$.

## Operators and admissibility

**Definition 19.10 (Operator).** An operator $\mathcal{O}$ is a (possibly nondeterministic) map that, given $G$ and a context $c$ (user, run, environment), produces a proposal $\Delta = \mathcal{O}(G, c)$.

Governance (Chapter 23) restricts operators to an admissible set $\mathcal{A}$. Semantic closure under governance is

$$\forall\, \mathcal{O} \in \mathcal{A}:\quad I\big(G,\, \mathcal{O}(G, c)\big) = 1 \;\Rightarrow\; \delta\big(G,\, \mathcal{O}(G, c)\big) \text{ remains descriptively complete.}$$

## The point

$G$ moves only by gated $\delta$. Integrity is four predicates. Projections read; they do not author. The next chapter specializes operators to **workflows** — BPM-class process and agentic orchestration — as mathematical objects on the same graph.
