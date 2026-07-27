# Workflows: Process, Agentic, and Hybrid

A workflow is not a second product. It is a typed object in $G$ whose payload is itself a graph of steps. This chapter gives that graph a mathematics covering **process** (BPM-class), **agentic** orchestration, **hybrid** composition, **runs**, and **loops**.

## Workflow as an object in $G$

**Definition 20.1 (Workflow object).** A workflow is an object $w \in V$ with schema in the workflow family and payload containing a workflow graph $W$. Write $w \hookrightarrow W$.

**Definition 20.2 (Workflow graph).**

$$W = (N, A, \kappa, \mu, n_0)$$

where:

- $N$ is a finite set of **nodes** (steps).
- $A \subseteq N \times N$ is a finite set of **arcs** (control-flow edges), each optionally gated by a predicate $\gamma: \mathsf{Data} \to \{0,1\}$.
- $\kappa: N \to K$ assigns a **kind** from a finite kind alphabet $K$.
- $\mu: N \to \mathsf{Meta}$ assigns finite metadata (forms, adapters, orchestration, waits, …).
- $n_0 \in N$ is the **entry** node.

**Kind alphabet (representative).**

$$K \;\supseteq\; \{\mathsf{start},\, \mathsf{end},\, \mathsf{collect},\, \mathsf{decision},\, \mathsf{gateway},\, \mathsf{human},\, \mathsf{agent},\, \mathsf{tool},\, \mathsf{transform},\, \mathsf{integration},\, \mathsf{subprocess},\, \mathsf{wait},\, \mathsf{timer}\}.$$

**Catalog facet.** A workflow object also carries a facet tag

$$\mathsf{facet}(w) \in \{\mathsf{process},\, \mathsf{agentic},\, \mathsf{hybrid}\}$$

used for authoring and cataloguing. Facet is not a second graph format: both process and agentic workflows are instances of Definition 20.2.

## Run state

**Definition 20.3 (Run).** A run is a tuple

$$\rho = (w,\, s,\, \mathsf{tok},\, D,\, H)$$

where:

- $w$ identifies the workflow object,
- $s \in \{\mathsf{running},\, \mathsf{waiting},\, \mathsf{completed},\, \mathsf{failed},\, \mathsf{cancelled}\}$ is status,
- $\mathsf{tok} \subseteq N$ is the set of **active tokens** (marking),
- $D$ is a finite **run data** map (keys to values),
- $H$ is a finite **history** of step events.

**Definition 20.4 (Waiting modes).** When $s = \mathsf{waiting}$, a mode

$$m \in \{\mathsf{waiting\_human},\, \mathsf{waiting\_ide},\, \mathsf{waiting\_external},\, \mathsf{waiting\_timer}\}$$

records which external agency must resume the run.

## Firing a step

**Definition 20.5 (Step effect).** Firing node $n$ in run $\rho$ against product graph $G$ produces:

1. An optional product mutation $\Delta_n = \mathrm{Prop}(n, G, D)$,
2. An updated data map $D'$,
3. A next marking $\mathsf{tok}'$,
4. A status $s'$ (possibly waiting).

The product update, when present, is always through Chapter 19:

$$G \leftarrow \delta(G, \Delta_n) \quad \text{only if } I(G, \Delta_n) = 1.$$

A step that would violate integrity does not commit; the run records failure or routes to repair according to $W$.

**Definition 20.6 (Sequential advance).** On an ordinary arc $(n, n')$ with gate $\gamma$:

$$\mathsf{tok}' = (\mathsf{tok} \setminus \{n\}) \cup \{n'\} \quad \text{iff } \gamma(D) = 1.$$

## Process (BPM-class) structure

Process workflows emphasize business control flow.

**Definition 20.7 (Decision).** If $\kappa(n) = \mathsf{decision}$, metadata supplies a finite branch map

$$\beta: \mathsf{Keys} \rightharpoonup N$$

and a key extraction $k = \mathrm{key}(D)$. The successor is $\beta(k)$ when defined; otherwise a default or failure arc.

**Definition 20.8 (Gateway).** A gateway node implements AND/OR split or join. For a parallel split with successors $n_1, \ldots, n_k$:

$$\mathsf{tok}' = (\mathsf{tok} \setminus \{n\}) \cup \{n_1, \ldots, n_k\}.$$

For a join of predecessors $p_1, \ldots, p_k$, the gateway fires when $\{p_1, \ldots, p_k\} \subseteq \mathsf{arrived}$, then emits a single successor token.

**Definition 20.9 (Human / collect / integration).**

- $\mathsf{collect}$ — binds a form schema; completion writes fields into $D$ and may seal secrets into a vault handle (never into chat).
- $\mathsf{human}$ — sets $m = \mathsf{waiting\_human}$; resume requires an authorized actor.
- $\mathsf{integration}$ — invokes a sealed connector; effects outside $G$ are mediated by handles recorded in $D$ and events.

**Definition 20.10 (Domain of a step).** The write-domain $\mathrm{dom}(n) \subseteq V$ is the set of product objects $n$ may modify. Two steps $n_a, n_b$ are **write-disjoint** when

$$\mathrm{write}(n_a) \cap \mathrm{dom}(n_b) = \emptyset \;\;\wedge\;\; \mathrm{write}(n_b) \cap \mathrm{dom}(n_a) = \emptyset.$$

**Proposition 20.1 (Parallel safety).** If a parallel split fires write-disjoint steps and each child proposal is validated, the merged mutation

$$\Delta = \Delta_a \cup \Delta_b$$

may be validated atomically; under write-disjointness, $\delta(G, \Delta_a)$ then $\delta(G', \Delta_b)$ coincides with $\delta(G, \Delta)$ when both orders pass $I$.

*Proof sketch.* Disjoint writes imply commuting updates on $G$; integrity on the merge is the conjunction of local typing/referential obligations plus shared structural constraints. $\square$

## Agentic structure

Agentic substance lives **inside** agent nodes, not as a parallel BPM of specialists.

**Definition 20.11 (Orchestration).** If $\kappa(n) = \mathsf{agent}$, metadata may include an orchestration

$$O = (P,\, \mathcal{Ag},\, H_{\leftrightarrow},\, J,\, B)$$

where:

- $P \in \{\mathsf{single},\, \mathsf{pipeline},\, \mathsf{supervisor},\, \mathsf{swarm}\}$ is the pattern,
- $\mathcal{Ag} = \{a_1, \ldots, a_m\}$ is a finite set of **specialist agents** (roles, tools, prompts as data),
- $H_{\leftrightarrow} \subseteq \mathcal{Ag} \times \mathcal{Ag}$ is the **handoff** relation (who may call whom),
- $J$ is a finite set of **interrupt** points (HITL mid-orchestration),
- $B$ is a **budget** (step cap, token cap, time cap).

**Definition 20.12 (Agentic step as an operator).** Executing $n$ with orchestration $O$ induces a finite interaction trace

$$\tau = (a_{i_1}, \ldots, a_{i_\ell}), \quad \ell \le B$$

and a proposal $\Delta_n = \mathrm{Prop}(\tau, G, D)$. Interrupts pause with $m = \mathsf{waiting\_human}$ or $m = \mathsf{waiting\_ide}$ when an IDE-capable agent node is declared.

**Definition 20.13 (IDE-capable node).** A node may declare $\mathsf{ideCapable} = \mathsf{true}$. Then the run may enter $m = \mathsf{waiting\_ide}$; an external IDE agent fetches a task, performs work, and submits a result that resumes $\rho$ — still through $\mathrm{Prop}$ and $I$, never as an ungated side channel.

**Axiom 20.1 (One audit trail).** Whether the muscle of an agent step is hosted inference, an IDE agent, or an external executor, the run $\rho$ and product mutations $\Delta$ remain the system of record. Executors are pluggable; $W$ and $\rho$ are not.

## Hybrid

**Definition 20.14 (Hybrid workflow).** $\mathsf{facet}(w) = \mathsf{hybrid}$ when $W$ contains both BPM-class control nodes (collect, gateway, human, integration, …) and at least one agent node (possibly with $O$). Formally:

$$\exists\, n \in N:\; \kappa(n) \in \{\mathsf{collect},\, \mathsf{human},\, \mathsf{gateway},\, \mathsf{integration}\} \;\;\wedge\;\; \exists\, n' \in N:\; \kappa(n') = \mathsf{agent}.$$

Hybrid is the product claim in one sentence: **business process and agentic judgment share one governed graph and one run.**

## Loops (governed iteration)

**Definition 20.15 (Loop).** A loop is a subgraph pattern with a distinguished decision node $n_\ell$ carrying

$$L_\ell = (\mathsf{id},\, b,\, \mathsf{passKey},\, \mathsf{proves})$$

where $b \in \mathbb{N}$ is a fail budget and $\mathsf{passKey}$ names a boolean in $D$ set by a **deterministic verifier** (not by model self-assessment).

Branches:

$$
\begin{aligned}
\mathsf{pass} &\quad\text{if } D[\mathsf{passKey}] = \mathsf{true}, \\
\mathsf{fail} &\quad\text{if } D[\mathsf{passKey}] = \mathsf{false} \;\wedge\; c < b, \\
\mathsf{exhausted} &\quad\text{if } D[\mathsf{passKey}] = \mathsf{false} \;\wedge\; c \ge b,
\end{aligned}
$$

with counter $c$ incremented on each fail. Exhaustion routes to HITL.

**Formal reading.** A loop is $\delta$ with an explicit validate stage: body proposes, verify evaluates a predicate $V(G, D) \in \{0,1\}$, pass commits onward, fail repairs, exhausted escalates.

## Composition of workflows

**Definition 20.16 (Subprocess).** If $\kappa(n) = \mathsf{subprocess}$, metadata references another workflow $w^\dagger$. Firing $n$ spawns a child run $\rho^\dagger$ whose completion writes outputs into $D$ and returns a token to the parent.

**Definition 20.17 (Sequential composition of workflows).** $w_a ; w_b$ is the workflow that runs $w_b$ after $w_a$ completes, either by arc or by subprocess. Product mutations accumulate as

$$G_{i+1} = \delta(G_i, \Delta_i)$$

along the run.

**Definition 20.18 (Intent composition, informal).** When two product intents share typed structure and the same gated store, their composition is the pushout of their subgraphs in $G$ (shared identifiers glue). When they do not share $G$, composition degenerates to integration by convention — outside $R(S)$.

## Soundness obligations

| Obligation | Statement |
|------------|-----------|
| Graph SoT | $W$ lives in $G$; runtime does not keep a shadow process definition |
| Gated effects | Every product write uses $\delta$ and $I$ |
| Parallel safety | Parallel tokens respect write-disjointness or merged validate |
| Agentic enclosure | Specialists live in $O$, not as ungated side graphs |
| Loop honesty | Pass/fail from deterministic $V$, not model self-grade |
| Waiting integrity | Resume from human/IDE/external re-enters the same $\rho$ |

## The point

Process and agentic work are one mathematics: workflow graphs, markings, gated mutations. Hybrid is their conjunction. Loops are governed $\delta$. Architecture chapters next place these objects among pillars and projections.
