# Composition and Execution in the Concrete

Chapter 20 defined workflows mathematically. Chapter 24 showed $G$ as JSON-LD. This chapter puts a **hybrid** workflow into that language, walks a **run** through propose / validate / commit, shows a **loop** gate, and closes Part V with the thesis of self-evolving applications.

## The hybrid workflow (same $W$, now filled)

Recall Definition 20.2: $W = (N, A, \kappa, \mu, n_0)$ with facet $\mathsf{hybrid}$. Below is the `data.graph` payload for the Northwind claims workflow introduced in Chapter 24 — collect (BPM), then agent with orchestration (agentic), then human, then end. Simplified for reading; isomorphic to the shipping node alphabet.

```json
{
  "id": "wf-northwind-claims",
  "name": "Claims intake (hybrid)",
  "version": 1,
  "kind": "hybrid",
  "entryNodeId": "start",
  "policyPack": "regulated",
  "nodes": [
    { "id": "start", "kind": "start", "label": "Start" },
    {
      "id": "intake",
      "kind": "collect",
      "label": "Claim intake",
      "meta": {
        "fields": [
          { "name": "claimId", "label": "Claim ID", "type": "text", "required": true },
          { "name": "priority", "label": "Priority", "type": "text", "required": true },
          { "name": "payload", "label": "Details", "type": "textarea", "required": true }
        ]
      }
    },
    {
      "id": "research",
      "kind": "agent",
      "label": "Research brief",
      "meta": {
        "goal": "Synthesize a short brief from intake and Knowledge.",
        "executorId": "hosted",
        "allowedTools": ["knowledge_search", "objects.query"],
        "orchestration": {
          "pattern": "supervisor",
          "agents": [
            {
              "id": "lead",
              "role": "supervisor",
              "goal": "Coordinate research; produce the brief",
              "maxTurns": 4
            },
            {
              "id": "researcher",
              "goal": "Gather evidence from Knowledge",
              "allowedTools": ["knowledge_search"],
              "maxTurns": 3
            }
          ],
          "handoffs": [
            { "from": "lead", "to": ["researcher"] },
            { "from": "researcher", "to": ["lead"] }
          ],
          "interrupts": [
            { "when": "confidence < 40", "to": "human", "resume": true }
          ],
          "budget": { "maxTurns": 12, "maxToolCalls": 24 }
        }
      }
    },
    { "id": "approve", "kind": "human", "label": "Adjuster approval" },
    { "id": "end", "kind": "end", "label": "Done" }
  ],
  "edges": [
    { "id": "e1", "from": "start", "to": "intake" },
    { "id": "e2", "from": "intake", "to": "research" },
    { "id": "e3", "from": "research", "to": "approve" },
    { "id": "e4", "from": "approve", "to": "end" }
  ]
}
```

**Read against Chapter 20.**

- $\kappa(\mathsf{intake}) = \mathsf{collect}$, $\kappa(\mathsf{research}) = \mathsf{agent}$, $\kappa(\mathsf{approve}) = \mathsf{human}$ — hybrid by Definition 20.14.
- Orchestration $O$ lives **inside** the agent node’s `meta`, not as a second BPM of specialist nodes (Definition 20.11).
- Specialists `lead` / `researcher` and handoffs $H_{\leftrightarrow}$ are data; the outer marking still advances one token from `research` to `approve`.

## A run trace

Definition 20.3: $\rho = (w,\, s,\, \mathsf{tok},\, D,\, H)$. Walk one happy path. After each product-facing step, Chapter 19 applies: $\Delta \mapsto I \mapsto \delta$.

### Step 0 — start

```json
{
  "runId": "run_northwind_001",
  "workflowId": "wf-northwind-claims",
  "status": "running",
  "tokens": ["start"],
  "data": {},
  "waiting": null
}
```

Fire `start`; token moves to `intake`.

### Step 1 — collect (propose run data, optional graph write)

Human (or embed) completes the form. Run data updates; if the step also upserts a claim artifact into $G$, that upsert is a mutation $\Delta_{\mathrm{intake}}$ subject to $I$.

```json
{
  "status": "running",
  "tokens": ["intake"],
  "data": {
    "claimId": "CLM-1042",
    "priority": "high",
    "payload": "Water damage, unit 4B"
  }
}
```

Advance to `research`.

### Step 2 — agent (orchestration, then proposal)

The engine expands `meta.orchestration`: supervisor `lead` may hand off to `researcher`, who calls `knowledge_search` against chunks in $G$ (Chapter 24). Suppose the team writes a brief into $D$ and proposes a graph update (e.g. attach brief text to an artifact).

**Proposal $\Delta$ (illustrative):**

```json
{
  "create": [],
  "update": [
    {
      "@id": "urn:uuid:66666666-6666-4666-8666-666666666601",
      "schemaRef": "schema:artifact",
      "data": {
        "kind": "claim_brief",
        "title": "CLM-1042 brief",
        "body": "High priority water damage; playbook recommends full enrich.",
        "claimId": "CLM-1042"
      }
    }
  ],
  "delete": []
}
```

**Integrity $I$.** Typing: `data` matches `schema:artifact`. Referential: no dangling ids. Structural: artifact allowed as orphan or linked from experience policy. Semantic: policy pack `regulated` permits the write in Dev.

If $I = 1$, commit: $G' = \delta(G, \Delta)$. If $I = 0$, $G$ unchanged; run fails or routes to repair.

**Event (memory):**

```json
{
  "@id": "urn:uuid:55555555-5555-4555-8555-555555555502",
  "@type": "schema:org_event",
  "data": {
    "family": "workflow",
    "kind": "workflow.step.committed",
    "at": "2026-07-27T12:05:00.000Z",
    "runId": "run_northwind_001",
    "nodeId": "research",
    "mutationDigest": "sha256:…"
  }
}
```

### Step 3 — human (waiting mode)

```json
{
  "status": "waiting",
  "tokens": ["approve"],
  "waiting": "waiting_human",
  "data": {
    "claimId": "CLM-1042",
    "priority": "high",
    "brief": "High priority water damage; playbook recommends full enrich."
  }
}
```

Adjuster resumes; token moves to `end`; $s = \mathsf{completed}$. One audit trail $\rho$ whether the agent muscle was hosted or IDE-capable (`waiting_ide`).

## Loop gate in JSON

Definition 20.15 — deterministic verify, not model self-grade. A craft-style decision node:

```json
{
  "id": "craft_gate",
  "kind": "decision",
  "label": "Craft verify",
  "meta": {
    "loop": {
      "id": "craft",
      "budget": 4,
      "proves": "Per-page UX + brand + a11y gates",
      "passKey": "_craftPass"
    }
  },
  "branches": {
    "pass": "ship",
    "fail": "craft_repair",
    "exhausted": "craft_hitl"
  }
}
```

A verifier tool sets `data._craftPass` to `true` or `false`. Fail increments a counter; at budget, branch `exhausted` opens HITL — often minting a `schema:issue` rather than silent continue.

```json
{
  "@type": "schema:issue",
  "data": {
    "detector": "verify.page_craft",
    "severity": "high",
    "title": "Hero subcopy overflows mobile viewport",
    "status": "open",
    "subjectId": "urn:uuid:22222222-2222-4222-8222-222222222201"
  }
}
```

Issue = judgment; event = memory. Both belong on (or keyed to) $G$.

## Composition across pillars (one picture)

```
Experience (UI tree)
    | workflowRef
    v
Workflow W (hybrid nodes/edges)
    | agent tools
    v
Knowledge chunks  -->  retrieval during research
    |
    +--> artifact update (Delta) --> I --> G'
    |
    +--> org_event (audit)
    |
    +--> issue (if loop exhausted)
```

No second product database. Composability is shared `@id` and gated $\delta$.

## Thesis coda — self-evolving applications

Return to Chapter 17’s claim, now with concrete machinery in view.

For seventy years, an application’s meaning was trapped in code. Intelligence — human or machine — that could not read and rewrite that meaning under shared gates could not evolve the product safely while it ran. Generating more code did not dissolve the trap; it often deepened it.

Semantic closure relocates meaning into $G$, written here as JSON-LD, moved by $\delta$ under $I$, steered by workflows $W$ (process and agentic alike), and restricted by $\mathcal{A}$. Healing loops and evolution work orders (`schema:goal`, `schema:change_request`) are not metaphors; they are objects and runs on the same graph.

**What becomes structurally possible:** applications that propose, verify, and commit their own next version — with humans in the admissible set, not as the only aperture. That is self-evolving software with embedded intelligence.

**What this book does not claim:** that base models must invent their successors, or that a cosmic singularity is inevitable. Removing the barrier to autonomous *product* evolution may accelerate broader dynamics; the load-bearing result is the barrier’s removal. Intelligence evolving intelligence itself is a sibling research program, not a premise of these appendices.

The rewrite ends when the product can read itself. Part V is the theory of that sentence — in mathematics, architecture, and JSON.

## Closing Part V

| Layer | Chapters | You now have |
|-------|----------|----------------|
| A — Formal theory | 18–20 | $S$, $F\in R(S)$, $G$, $\delta$, $I$, $W$, $\rho$ |
| B — Architecture | 21–23 | Store, pillars, projections, $\mathcal{A}$, ladder |
| C — Concrete syntax | 24–25 | JSON-LD taxonomy, `@graph`, hybrid $W$, run trace |
| D — Thesis | 17 + here | Self-evolving applications; scope honesty |

Return to Chapter 3 when you want the clauses in English. Return here when you want the multiplication table.
