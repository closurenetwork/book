# Control Plane and Operational Rules

Mathematics without admissibility is a rewrite engine. This chapter defines **governance as policy enforcement**: environments, principals, the decision request, the effect algebra that computes $\mathcal{A}(c)$, the promotion ladder, dual containment (humans and agents), and the IDE/Console split — the institutional form of “under governance, while running.”

**Bridge (foundations).** Closure Network engineering and the Law of Coherence treat governance as constitutive of coherent agency (Authority Principle, Bill of Invariants, Intent Filter, Moral Metric $\Delta\chi$, Greenbeard). This appendix is the **product-paradigm** form of that doctrine: Policies are DataObjects on $G$; one Policy Decision Point (PDP) evaluates them; SIV remains integrity $I$, not authorization.

---

## Environments as indexed graphs

**Definition 23.1 (Environment).** Let $\mathsf{Env}$ be a finite set of environment labels. Typical:

$$\mathsf{Env} = \{\mathsf{Personal},\, \mathsf{Dev},\, \mathsf{Test},\, \mathsf{Prod}\}.$$

For each $e \in \mathsf{Env}$, write $G_e$ for the product graph (or pinned view) visible in that environment. Personal graphs are per principal; Dev/Test/Prod are organization-scoped.

**Definition 23.2 (Pin / release).** A **release** is an immutable snapshot $R^\star = \mathsf{Snap}(G_{\mathsf{Dev}})$. A **pin** binds an environment to a release:

$$\mathsf{pin}: \{\mathsf{Test},\, \mathsf{Prod}\} \to \mathsf{Releases}.$$

---

## Principals — who may act

**Definition 23.3 (Principal).** A principal $p$ is a first-class identity on $G$ (or a signed session bound to one). Three kinds are distinct — not one kind with flags:

| Kind | Notation | Holds |
|------|----------|--------|
| **Human** | $p_H$ | Org role(s): owner, admin, builder, viewer, … |
| **Agent** | $p_A$ | Machine intelligence under its own `@id` and tool allowlist |
| **Service** | $p_S$ | External program via signed, scoped credentials |

**Axiom 23.0 (No borrowed identity).** An agent or service MUST NOT act under a human’s credentials in the audit sense. The version, event, and decision record name $p_A$ or $p_S$. Humans remain attributable only for human acts (including approve / escalate).

**Definition 23.3b (Context).** An operator context is

$$c = (p,\, e,\, \mathsf{role},\, \mathsf{kind},\, \mathsf{caps})$$

with $\mathsf{kind} \in \{\mathsf{human},\, \mathsf{agent},\, \mathsf{service}\}$ and capabilities including an MCP/IDE flag.

Customers of the product (end-users of an Experience) are **not** principals over $G$’s definition. Confusing them with $p_H$ is a category error governance must refuse.

---

## Governance = policy enforcement

**Definition 23.4 (Policy document).** A Policy is a DataObject with $\mathsf{schemaRef} = \mathsf{schema:policy}$ and payload

$$\pi = (\mathsf{effect},\, \mathsf{actions},\, \mathsf{principals},\, \mathsf{resources},\, \mathsf{conditions},\, \mathsf{priority}).$$

Effect $\mathsf{effect} \in \{\mathsf{deny},\, \mathsf{require\_human},\, \mathsf{allow}\}$.

**Definition 23.5 (Decision request).** Every consequential attempt is a request

$$q = (\mathsf{action},\, c,\, \mathsf{resource},\, \mathsf{now})$$

where $\mathsf{action}$ is drawn from a finite alphabet (e.g. `graph.write`, `merge.submit`, `promote.pin`, `agent.invoke`, `secret.use`, `policy.mutate`, `integration.call`, …) and $\mathsf{resource}$ carries environment, pillar, schema, object id, and optional control name.

**Definition 23.6 (PDP).** The Policy Decision Point is a pure map

$$\mathsf{PDP}: (q,\, \Pi) \mapsto d$$

where $\Pi$ is the set of **active** Policy documents on the org graph and $d$ is a decision

$$d = (\mathsf{effect},\, \mathsf{matched},\, \mathsf{reason},\, \mathsf{source}).$$

**Axiom 23.1 (Single PDP).** Every gated surface — graph mutate, GraphQL, merge, promote, vault, workflow control, agent invoke, MCP tool — MUST call the same $\mathsf{PDP}$ (or an equivalent projection of it). Parallel matrices that disagree with $\Pi$ are debt, not doctrine.

**Definition 23.7 (Effect algebra).** Let $M(q) \subseteq \Pi$ be the Policies that match $q$ (principal ∩ action ∩ resource ∩ conditions). Then:

$$
\mathsf{effect}(d) =
\begin{cases}
\mathsf{deny} & \text{if } \exists\, \pi \in M(q):\ \pi.\mathsf{effect}=\mathsf{deny} \\
\mathsf{require\_human} & \text{else if } \exists\, \pi \in M:\ \mathsf{require\_human} \\
\mathsf{allow} & \text{else if } \exists\, \pi \in M:\ \mathsf{allow} \\
\mathsf{default} & \text{otherwise (see Axiom 23.3)}
\end{cases}
$$

Priority breaks ties within the same effect class. Deny always dominates.

**Definition 23.8 (Admissible set).**

$$\mathcal{A}(c) = \{\, \mathsf{action} \mid \mathsf{PDP}(q_{\mathsf{action}}, \Pi).\mathsf{effect} = \mathsf{allow} \,\}.$$

Operators that yield $\mathsf{require\_human}$ are **pending**, not admissible until a distinct human principal completes the required act. Operators that yield $\mathsf{deny}$ are undefined for $c$.

**Axiom 23.2 (Separation of $I$ and $\mathcal{A}$).** Integrity $I(G,\Delta)$ answers *whether $\Delta$ is well-formed*. $\mathsf{PDP}$ answers *whether $c$ may attempt it*. Neither substitutes for the other. A well-typed $\Delta$ from a denied principal MUST NOT commit. An allowed principal’s ill-typed $\Delta$ MUST NOT commit.

**Axiom 23.3 (Default posture).** For write-class actions on shared org graphs ($\mathsf{Dev}$ and above), the unmatched default is $\mathsf{deny}$ (fail closed). Read-class inspect tools may default allow under authenticated session. Bootstrap Policies encode the historical role×pillar matrix so dogfood remains usable; orgs refine $\Pi$ without inventing a second language.

**Axiom 23.4 (Meta-governance).** Mutating or activating Policies is itself gated by actions `policy.mutate` / `policy.activate`. No principal may unilaterally widen $\mathcal{A}$ for all kinds without a matching allow (typically owner/admin + optional $\mathsf{require\_human}$).

---

## Dual containment — neither agents nor humans go rogue

Governance that only constrains machines invites human bypass. Governance that only constrains humans invites agent sprawl. The doctrine is **symmetric attribution + asymmetric capability**:

| Threat | Mechanism |
|--------|-----------|
| **Agent rogue** | Own principal $p_A$; tool allowlists ⊂ $\mathcal{A}(c_A)$; no secret plaintext in tool args; drafts before active; $\mathsf{require\_human}$ on escalate; kill/revoke session; audit every tool call |
| **Human rogue** | Same $\mathsf{PDP}$ as agents; no ungated Prod craft (Axiom 23.5); N-approver / change windows as conditions; separation of duties (submitter ≠ sole approver when $\mathsf{minApprovers} \ge 2$); Policy changes gated; audit export; break-glass is an explicit, time-boxed Policy — never an env flag that skips $\mathsf{PDP}$ |
| **Service rogue** | Scoped credentials; least privilege actions; rotation; connector seal ≠ product mutate unless $\Pi$ says so |

**Definition 23.9 (Break-glass).** A temporary elevation is a Policy (or Policy set) with explicit `conditions` (time bound, ticket id) and mandatory audit. Escape hatches that skip $\mathsf{PDP}$ entirely are **out of paradigm**.

---

## Ladder (change management as operators)

**Axiom 23.5 (No ungated prod craft).** Direct write operators on $G_{\mathsf{Prod}}$ lie outside $\mathcal{A}$ for ordinary builders and agents. Production changes enter through promote (below).

**Definition 23.10 (Merge).** A merge request is a proposal

$$\mathsf{MR}: G_{\mathsf{Personal}} \rightsquigarrow G_{\mathsf{Dev}}$$

subject to Dev policy (including $N$-approver thresholds and change windows as $\mathsf{conditions}$).

**Definition 23.11 (Promote).** A promote request is a proposal to update a pin:

$$\mathsf{PR}: R^\star \mapsto \mathsf{pin}(e), \quad e \in \{\mathsf{Test},\, \mathsf{Prod}\}$$

subject to policy, windows, and quality gates (Issue severity, craft coverage, …) — instances of $I_{\mathrm{sem}}$ composed with $\mathsf{PDP}$.

```
Personal --merge--> Dev --release--> snapshot
                         |
                    promote (HITL / window / N-approvers)
                         v
                   Test pin --> Prod pin
```

**Definition 23.12 (Change window).** A window $W_t \subset \mathsf{Time}$ appears as Policy `conditions.changeWindow`. Outside $W_t$, merge/promote approve actions are not in $\mathcal{A}$.

---

## IDE builds; Console governs

**Definition 23.13 (Surface split).**

| Surface | Allowed effects |
|---------|-----------------|
| **IDE** (tools over MCP) | Operators in $\mathcal{A}$ on Personal/Dev: craft, scaffold, build, verify, submit merge/promote *requests*, fulfill $\mathsf{waiting\_ide}$ |
| **Console** | Approvals, policy CRUD (gated), team, brand settings, Trust center, audit — govern $\Pi$ and queues |

**Axiom 23.6 (Secrets).** Secret collection is an operator that returns only sealed handles. Plaintext secrets are never arguments to IDE tools and never fields in ungated chat. `secret.use` / `secret.collect` are first-class actions in $\Pi$.

---

## Tool surface as typed operators

**Definition 23.14 (IDE tool).** A tool is a typed signature

$$\mathsf{tool}: \mathsf{Args} \to \mathsf{Result}$$

that, when authorized, induces $\mathsf{action} \in \mathcal{A}(c)$ and thus a proposal $\Delta$. Examples of tool classes:

- Inspect: $\pi_{\mathrm{IDE}}$ reads (status, experience tree, taxonomy, governance status)
- Mutate: craft, unlink, delete, scaffold → `graph.write` / `graph.delete`
- Verify: run deterministic $V$ (Chapter 20 loops); optional remediate
- Build: start workflow runs; agent task fetch/submit for $\mathsf{waiting\_ide}$
- Collect: open sealed form runs → `secret.collect`
- Govern: submit merge; simulate policy; read queues (approve remains Console)
- Agent: `agent.invoke` with kind=`agent` in $c$

Every tool entrypoint MUST construct $q$ and call $\mathsf{PDP}$ before side effects.

---

## Trust center and evidence

**Definition 23.15 (Governance hub).** The Trust center is the Console projection of:

$$\mathsf{Gov} = (\mathsf{Identity},\, \mathsf{Change},\, \mathsf{Assurance},\, \mathsf{Integrations},\, \mathsf{Agents},\, \mathsf{Policies},\, \mathsf{Evidence})$$

posture over $\Pi$, $\mathcal{A}$, ladders, gates, sealed connectors, agent wait states, and audit export.

**Definition 23.16 (Decision evidence).** Each $\mathsf{PDP}$ evaluation SHOULD emit an org event (`policy.evaluated`, `policy.denied`, `policy.require_human`) with $q$, $d$, and principal — queryable evidence, not a side log nobody owns.

---

## Skills as Knowledge

**Definition 23.17 (Skill pull).** Let $\Sigma_{\mathrm{skill}} \subset G$. An IDE session with stale marker $v$ refreshes when

$$v < \mathsf{version}(\Sigma_{\mathrm{skill}})$$

and materializes doctrine locally as a cache of $\pi_{\mathrm{IDE}}(\Sigma_{\mathrm{skill}})$. The SoT remains $G$. Skills do not bypass $\mathsf{PDP}$.

---

## Conditions (evaluation contract)

**Definition 23.18 (Condition satisfaction).** A Policy matches only if every declared condition holds of $q$. The contract includes at least:

| Condition | Meaning |
|-----------|---------|
| `minApprovers` | Approve actions require $N$ distinct human principals |
| `changeWindow` | `now ∈ W_t` for the org |
| `qualityGate` | Blocking Issues / craft coverage gate |
| `sivMode` | Require $I^\circ$ mode for the mutate path |
| `mcpIde` | Request originated from IDE/MCP capability |

Unevaluated condition fields MUST NOT silently match as true. Unknown condition keys fail closed for write-class actions.

---

## Closing fixed point

The paradigm is a fixed point of three maps:

$$
\begin{aligned}
\mathsf{Math}&: S \mapsto (G,\, \delta,\, I,\, W,\, \rho) \\
\mathsf{Arch}&: G \mapsto \{\text{pillars},\, \pi_j,\, \mathsf{Store}\} \\
\mathsf{Ctrl}&: (G_e,\, c,\, \Pi) \mapsto \mathcal{A}(c)
\end{aligned}
$$

A system is semantically closed in the operational sense when every product change is an operator in some $\mathcal{A}(c)$, every such operator’s proposal passes $I$ before commit, every facet of the product lies in $G$, and every grant of autonomy is explained by $\Pi$.

---

## Implementation alignment (honest)

The worked example (Closure Platform) implements Definitions 23.4–23.8 in `@closure-platform/governance` (`evaluatePolicyDecision`) with Studio `decidePolicy` and Trust center simulate. Bootstrap Policies preserve role×pillar dogfood. Gaps relative to this chapter are **named work**, not silent doctrine:

1. Collapse remaining parallel matrices (role×pillar accessors, workflow pack controls) into $\mathsf{PDP}$-only.
2. Enforce Axiom 23.3 (default-deny on write) where today unmatched may still allow.
3. Evaluate all of Definition 23.18 in the PDP (not only `mcpIde`).
4. Pass $\mathsf{kind} \in \{\mathsf{human},\, \mathsf{agent},\, \mathsf{service}\}$ on every request — agents must not default to `human`.
5. Unify decision evidence into one audit stream; retire skip-PDP escape hatches.
6. Separation-of-duties checks for $\mathsf{minApprovers}$.

Wave plan: platform `docs/WAVES-GOVERNANCE-THEORY.md`.

---

## Operational rules (summary)

1. Graph is SoT — projections and local files are not.
2. Governance is $\mathsf{PDP}(\Pi)$ — one decision point; Policies on $G$.
3. Deny > require_human > allow; write-class fail closed.
4. Humans, agents, and services are distinct principals — no borrowed identity.
5. $I$ is integrity; $\mathcal{A}$ is authorization — both required.
6. IDE builds; Console governs; secrets only via sealed collect.
7. Verify before ship — deterministic $V$; loops budgeted; HITL on exhaust.
8. No ungated Prod craft; promote is the door.
9. Meta-governance: Policies govern Policies.
10. Break-glass is a Policy, not a skipped PDP.
11. Harden $I$ toward enforce on the product path — that is the work, not a different paradigm.

## The point

Chapter 3 stated seven clauses in English. Through Chapter 23, Part V states them as $F \in R(S)$, a typed graph $G$, gated $\delta$, process and agentic workflows $W$, pillars and projections $\pi$, and admissible operators $\mathcal{A}$ computed from Policies. Chapters 24–25 give the same objects in JSON-LD and walk a concrete run. When the runtime is thinner than $I$ or $\mathsf{PDP}$, the mathematics still names the gap — and the product path is to close it.
