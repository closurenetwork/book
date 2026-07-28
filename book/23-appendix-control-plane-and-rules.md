# Control Plane and Operational Rules

Mathematics without admissibility is a rewrite engine. This chapter defines environments, roles, admissible operators, the promotion ladder, and the IDE/Console split — the institutional form of “under governance, while running.”

## Environments as indexed graphs

**Definition 23.1 (Environment).** Let $\mathsf{Env}$ be a finite set of environment labels. Typical:

$$\mathsf{Env} = \{\mathsf{Personal},\, \mathsf{Dev},\, \mathsf{Test},\, \mathsf{Prod}\}.$$

For each $e \in \mathsf{Env}$, write $G_e$ for the product graph (or pinned view) visible in that environment. Personal graphs are per principal; Dev/Test/Prod are organization-scoped.

**Definition 23.2 (Pin / release).** A **release** is an immutable snapshot $R^\star = \mathsf{Snap}(G_{\mathsf{Dev}})$. A **pin** binds an environment to a release:

$$\mathsf{pin}: \{\mathsf{Test},\, \mathsf{Prod}\} \to \mathsf{Releases}.$$

## Admissible operators

**Definition 23.3 (Context).** An operator context is

$$c = (\mathsf{actor},\, e,\, \mathsf{role},\, \mathsf{caps})$$

with capabilities including an MCP/IDE flag.

**Definition 23.4 (Admissible set).**

$$\mathcal{A}(c) \subseteq \mathsf{Operators}$$

is the set of operators actor may invoke on $G_e$. In the worked example, $\mathcal{A}(c)$ is computed from active `schema:policy` documents (deny $>$ require_human $>$ allow) over Principal × Action × Resource × Condition. Bootstrap Policies encode the historical role×pillar matrix; orgs may refine further. Viewers typically have $\mathcal{A}$ empty for write operators.

**Axiom 23.1 (No ungated prod craft).** Direct write operators on $G_{\mathsf{Prod}}$ lie outside $\mathcal{A}$ for ordinary builders. Production changes enter through promote (below).

## Ladder

**Definition 23.5 (Merge).** A merge request is a proposal

$$\mathsf{MR}: G_{\mathsf{Personal}} \rightsquigarrow G_{\mathsf{Dev}}$$

subject to Dev policy (including $N$-approver thresholds and change windows).

**Definition 23.6 (Promote).** A promote request is a proposal to update a pin:

$$\mathsf{PR}: R^\star \mapsto \mathsf{pin}(e), \quad e \in \{\mathsf{Test},\, \mathsf{Prod}\}$$

subject to policy, windows, and quality gates (Issue severity, craft coverage, …) — instances of $I_{\mathrm{sem}}$.

```
Personal --merge--> Dev --release--> snapshot
                         |
                    promote (HITL / window / N-approvers)
                         v
                   Test pin --> Prod pin
```

**Definition 23.7 (Change window).** A window $W_t \subset \mathsf{Time}$ restricts when merge/promote operators are in $\mathcal{A}$. Outside $W_t$, those operators are undefined (rejected).

## IDE builds; Console governs

**Definition 23.8 (Surface split).**

| Surface | Allowed effects |
|---------|-----------------|
| **IDE** (tools over MCP) | Operators in $\mathcal{A}$ on Personal/Dev: craft, scaffold, build, verify, submit merge/promote *requests*, fulfill $\mathsf{waiting\_ide}$ |
| **Console** | Approvals, policy, team, brand settings, Trust center, audit — govern $\mathcal{A}$ and queues |

**Axiom 23.2 (Secrets).** Secret collection is an operator that returns only sealed handles. Plaintext secrets are never arguments to IDE tools and never fields in ungated chat.

## Tool surface as typed operators

**Definition 23.9 (IDE tool).** A tool is a typed signature

$$\mathsf{tool}: \mathsf{Args} \to \mathsf{Result}$$

that, when authorized, induces $\mathcal{O} \in \mathcal{A}(c)$ and thus a proposal $\Delta$. Examples of tool classes:

- Inspect: $\pi_{\mathrm{IDE}}$ reads (status, experience tree, taxonomy, governance status)
- Mutate: craft, unlink, delete, scaffold
- Verify: run deterministic $V$ (Chapter 20 loops); optional remediate
- Build: start workflow runs; agent task fetch/submit for $\mathsf{waiting\_ide}$
- Collect: open sealed form runs
- Govern: submit merge; read queues (approve remains Console)

## Trust center

**Definition 23.10 (Governance hub).** The Trust center is the Console projection of:

$$\mathsf{Gov} = (\mathsf{Identity},\, \mathsf{Change},\, \mathsf{Assurance},\, \mathsf{Integrations},\, \mathsf{Agents},\, \mathsf{Evidence})$$

posture over $\mathcal{A}$, ladders, gates, sealed connectors, agent wait states, and audit export. It is not a promote-only queue; it is the human-readable face of admissibility.

## Skills as Knowledge

**Definition 23.11 (Skill pull).** Let $\Sigma_{\mathrm{skill}} \subset G$. An IDE session with stale marker $v$ refreshes when

$$v < \mathsf{version}(\Sigma_{\mathrm{skill}})$$

and materializes doctrine locally as a cache of $\pi_{\mathrm{IDE}}(\Sigma_{\mathrm{skill}})$. The SoT remains $G$.

## Closing fixed point

The paradigm is a fixed point of three maps:

$$
\begin{aligned}
\mathsf{Math}&: S \mapsto (G,\, \delta,\, I,\, W,\, \rho) \\
\mathsf{Arch}&: G \mapsto \{\text{pillars},\, \pi_j,\, \mathsf{Store}\} \\
\mathsf{Ctrl}&: (G_e,\, c) \mapsto \mathcal{A}(c)
\end{aligned}
$$

A system is semantically closed in the operational sense when every product change is an operator in some $\mathcal{A}(c)$, every such operator’s proposal passes $I$ before commit, and every facet of the product lies in $G$.

## Operational rules (summary)

1. Graph is SoT — projections and local files are not.
2. IDE builds; Console governs.
3. Secrets only via sealed collect.
4. Verify before ship — deterministic $V$; loops budgeted; HITL on exhaust.
5. One org brand stack — Experiences inherit design system.
6. Events and Issues are memory and judgment on (or keyed to) $G$.
7. Harden $I$ toward enforce on the product path — that is the work, not a different paradigm.

## The point

Chapter 3 stated seven clauses in English. Through Chapter 23, Part V states them as $F \in R(S)$, a typed graph $G$, gated $\delta$, process and agentic workflows $W$, pillars and projections $\pi$, and admissible operators $\mathcal{A}$. Chapters 24–25 give the same objects in JSON-LD and walk a concrete run. When the runtime is thinner than $I$, the mathematics still names the gap — and the product path is to close it.
