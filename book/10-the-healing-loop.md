# The Healing Loop

This book opened with a scene I promised was not science fiction: an application, somewhere in a data center, reading its own definition. It finds a page whose title runs long enough to break a search listing. It opens a formal record of the problem. It fixes the title, verifies the fix, files the evidence, and moves on — before the human who owns it has finished their coffee. And when it finds something it is not permitted to touch, it does not touch it. It asks.

Nine chapters later, every word of that scene can be unpacked into mechanism, and this chapter does the unpacking. The scene has three moving parts — a *scan* that finds the problem, a *record* that captures the judgment, and a *repair* that passes through governance — and together they form the first of the two loops that make an application something closer to an organism than an artifact. I will call it the healing loop, because that is what it does: it keeps a running product true to its own standards, continuously, the way a body keeps its temperature.

But to appreciate the loop, you first have to appreciate the disease.

## Drift

Every running product decays — not in the grand, Naurian sense of chapter 1, where theory evaporates over years, but in a smaller, faster, more embarrassing register. A page's title grows past what a search engine will display. A marketing page ships with a hex color that is almost, but not exactly, the brand's blue. The Spanish translation of the checkout flow falls one field behind the English. A form that should require review quietly doesn't. A workflow's contract with a connector drifts as the connector's shape changes. An agent's tool allowlist is wider than any policy ever approved. None of these is an outage. All of them are the product diverging from its own standards — and I will use the word **drift** for the whole family.

Here is the uncomfortable truth about drift in code-era software: it is invisible until a human notices, and humans notice by accident. Monitoring does not help, because monitoring watches the *runtime* — CPU, latency, error rates — and drift is not a runtime phenomenon. The off-brand page renders in a perfectly healthy two hundred milliseconds. The overlong title returns HTTP 200. There is no metric for "this violates our standards," because the standards live in a wiki and the product lives in code and nothing can read either one, let alone compare them. So enterprises staff the gap: brand reviews, accessibility audits, localization sweeps, security assessments — humans walking the product with clipboards, quarterly if the budget is good. The audit is a snapshot; the drift is a flow. The flow wins.

Now run the change this book keeps running. If the product is data — pages, workflows, policies, translations, tool grants, all typed objects on one graph — then *conformance is a query*. "Every page title under seventy characters" is not an aspiration in a style guide; it is a predicate you can evaluate against the graph in milliseconds, tonight and every night. "No component uses a raw hex color instead of a design token" — a query. "Every locale bundle covers every user-facing string" — a query. "No agent's allowlist exceeds its policy pack" — a query. The standards stop being prose and become assertions, and assertions against data can be checked by a machine, which never gets bored, never skips the last hundred pages, and does not bill quarterly.

## The scan tier

The first tier of the loop, then, is a set of processes that read the product and judge it. The vendor-neutral shape: **scan workflows** — governed processes, in the chapter 6 sense — that query the graph, evaluate the standards, and open a formal record for each violation found. The worked example ships a suite of them, which it calls the *drift suite*: scans for operations (stuck runs, failing integrations), brand conformance, internationalization coverage, discoverability, contract violations, and security posture. Each is an ordinary workflow: startable by hand, schedulable, auditable, made of the same stuff as the product's own intake flows.

What a scan produces is the load-bearing design decision of the whole loop. It does not send an email. It does not page anyone. It opens an **issue**: a typed object on the graph, with a severity, a kind, the evidence, and a link to the target it indicts. In the worked example the shape is exactly what you would now expect:

```json
{
  "@id": "urn:uuid:8c14b7e2-…",
  "orgId": "org_meridian",
  "schemaRef": "schema:issue",
  "state": "active",
  "data": {
    "severity": "medium",
    "kind": "seo.title_overflow",
    "title": "Page title exceeds search display limit",
    "links": ["urn:uuid:page-pricing-…"],
    "sourceRunId": "run_01J9…",
    "status": "open"
  }
}
```

Note `sourceRunId`. Every issue names the workflow run that opened it, because of a discipline the worked example enforces without exception and I would urge on any implementation: **only workflows may open issues. Raw telemetry never does.** Events — the organizational memory of chapter 8 — are emitted freely by everything; they are what happened. An issue is something else: a *judgment* that what happened is a problem. And judgments must be process citizens — produced by a governed, auditable, versioned process whose logic can be inspected and improved — not side effects of whatever threshold some handler hard-coded in 2024. The worked example learned this concretely: an early hard-coded detector inside the console was retired precisely because its judgments were nobody's responsibility. Now the logic lives in scan tools that workflows invoke, and when an issue is wrong, there is a run to inspect and a workflow to fix.

This distinction — memory versus judgment — is also what separates the loop from the monitoring tradition it superficially resembles. Monitoring's unit of output is the alert, and the alert's failure mode is famous: fatigue. A page wakes a human at 3 a.m. and demands triage *now*, with whatever context fits in a notification. An issue does something quieter and better: it enters a governed queue, carrying its evidence and severity, where it waits for the process that owns it — sortable, batchable, and above all *addressed to the system first and the human second*. The difference in daily texture is the difference between a smoke detector and an immune system.

One more subtlety in the scan tier deserves its sentence, because it prefigures the heal tier's economics. Not every judgment is a threshold. "This title is 84 characters" is deterministic — a cheap, exact tool evaluates it, no model involved. "This paragraph is off-brand" is a matter of taste, and taste requires a model. The worked example splits these deliberately: deterministic scan tools run free and constantly; judgment calls run as agent nodes inside scan workflows, which — as one of its documents puts it with commendable bluntness — spend credits *on purpose*. Reserving intelligence for questions that need it is not stinginess. It is what keeps the loop cheap enough to run always.

## The heal tier

Finding problems is diagnosis. The second tier is treatment: **heal workflows** that fix what policy allows — and the phrase *what policy allows* is doing exactly the work chapter 9 built it to do.

Heals are tiered, and the tiers follow the same economics as the scans. The first tier is **deterministic repair**: fixes that are mechanical, exact, and cheap. The overlong title is truncated to fit. The rogue hex color is replaced with the design token it approximates. A form's mode is corrected; a component is re-bound to its library source; an agent's over-broad tool allowlist is narrowed to its policy pack; an orphaned half-started run is cancelled. Every one of those examples ships in the worked example today as a named heal action, and none of them involves a model — a string operation does not need a neural network, and it is a small sign of the industry's current mood that this sentence needs writing.

Above that sits **model-assisted repair**, for fixes that are semantic rather than mechanical: translating the missing Spanish strings, shortening copy that overflows its container without butchering its meaning, pruning stale locale entries. The worked example runs these through the organization's own vaulted model connection — the repair is drafted by intelligence, but intelligence operating as a principal, inside a workflow, under chapter 9's gates.

And above that sits the tier that defines the system's character: **refusal**. Some findings, the heal tier must not fix — and the worked example is specific about two: a leaked secret, and suspected personally identifiable information where it does not belong. The temptation to auto-repair is real; the machine can see the secret sitting in the object and could scrub it in a millisecond. It must not — and not only because rotation requires a human decision. Think about what a silent fix *is*, in the forensic sense: a leaked credential is evidence of an incident, and a system that quietly deletes evidence of incidents has a name in the compliance literature, and the name is not "helpful." So the loop does the only honest thing: it acknowledges the issue, marks it as escalated with the reason, and waits for a person. The introduction's application that "will not touch it — it will ask" is this exact branch, shipping under the unglamorous field name `healEscalation`. There are things a machine should refuse to do quietly, and it turns out you can write that refusal down as data.

## The loop, closed

Scan, heal — and then scan again. The third movement is what makes it a loop rather than a script: after heals apply, the suite re-runs, and the issues it opened are checked against the repaired product.

```
        ┌────────────────────────────────────────────┐
        │                                            │
        ▼                                            │
   scan workflows ──► issues (typed, evidenced)      │
        │                   │                        │
        │                   ▼                        │
        │             heal workflows                 │
        │              │         │                   │
        │        fix (governed)  escalate (human)    │
        │              │                             │
        └──────────────┴──── re-scan ────────────────┘
```

Two disciplines keep this cycle honest, and both come from the same shipped machinery that governs the worked example's build processes. The first: **verification is deterministic.** Whether a repair worked is decided by verifier tools — exact checks against the graph — never by the model that made the repair grading its own homework. A model's confidence that it fixed something is an input the loop is specifically designed to ignore. The second: **iteration is budgeted.** A repair that fails verification may retry, but the retry count is a field on the process definition, not a hope, and when the budget exhausts, the loop's final branch is a human node — the problem arrives in a person's queue with the full history of what was tried. Unbounded self-repair is one of the classic nightmares of autonomous systems, and the answer to it turns out to be dull: a counter, a limit, and an escalation path, written into the process as data. Fixed issues resolve; stubborn ones remain open with their history intact; escalations sit flagged for their humans. On the worked example's higher plans this cycle runs **autonomously** — scan, heal, re-scan on a schedule, no operator in the loop for the tiers policy has cleared — with a manual "heal everything open" lever for organizations that want the machine's hands visible on the wheel. The run's summary reads like a shift report: `auto-heal 9/12, open 14 → 5`, with three of the survivors waiting on a person, as they should be.

And the loop connects to shipping through the gate chapter 9 gestured at: the **quality gate**. Promotion can be held while high-severity issues stand open against the product. Read that plainly: the application can decline to ship itself broken. Not because a release manager remembered to check a dashboard — because the release machinery and the conformance machinery share a substrate, and the pin consults the issues before it moves.

There is one more property of the loop that I consider its deepest, and it is easy to state because chapter 9 did the work: **every heal is a governed change.** A heal workflow's repair lands the way any change lands — drafted, attributed to the workflow's principal, versioned, reversible. Pull up the history of a self-repaired page and you read: an issue, opened by a named scan run, with evidence; a fix, applied by a named heal run, as a version; a verification; a resolution. Swap the principal for an employee and the trail would read identically, and that is the point — the audit trail of a self-repair reads like an employee's work *because structurally it is*. The organism metaphor earns its keep here. Nobody audits their own immune system; you audit this one the same way you audit your staff.

## What ships and what is specified

The register check, as promised in the introduction, and the worked example's own tracking documents are candid enough to make it easy. **Shipped today:** the events plane and its emitters; the issues surface with scan workflows as the only creators; the ops and security scanners; the deterministic heal tier and the model-assisted internationalization tier; autonomous scan-heal ticks on higher plans with the manual lever below; escalation-with-reason for secrets and PII; issue objects carrying severity, kind, evidence, and source run. **Specified — designed and partially built:** the full closing of the evidence loop, where every resolution and escalation lands back in organizational memory as its own event; the channel that feeds recurring heal patterns into the *other* loop as redesign candidates (a failure that keeps healing is a design asking to change — but that is chapter 11's machinery); and a triage skill that lets an IDE agent read the issue queue and propose heals from the editor. I am describing a system whose spine ships and whose reach is still extending, and the honest sentence is exactly that.

## Why this was impossible

I want to close by asking why nothing like this existed before, because the answer is a compact restatement of the whole book, and because "we could have built this years ago" is precisely wrong.

The loop stands on three legs. The product must be **readable** — a structured graph a process can query, or there is nothing to scan. The fix must be **expressible as data** — a mutation to typed objects, or there is nothing a workflow can safely apply. And the judgment must be **governable** — workflows under identity, policy, and versioning, or there is nothing that makes the repair trustworthy. Remove the first leg and you get monitoring: watching shadows on the runtime wall, paging humans to interpret them. Remove the second and you get a dashboard: findings that become tickets that become backlog — diagnosis with no pharmacy. Remove the third and you get the scariest of the three: a rogue script — cron jobs that "fix" production out of sight of any review, which every operations veteran has met and learned to fear, because an ungoverned repair is just an outage that hasn't introduced itself yet.

Code-era software could not supply the legs. The product was not readable — it was code. Fixes were not data — they were deployments. Automated judgment was not governable — it was scripts under a service account. So the industry built the best drift response the substrate allowed: monitoring for what the runtime could see, audits for what it couldn't, and heroics in between. The healing loop is not a cleverer version of that response. It is what the response was always trying to be, unlocked by moving the product itself into the only form where scanning it, fixing it, and governing the fixer are all the same kind of operation.

The loop, for all its machinery, only keeps the product *true to what it already is*. The more interesting question — how the product becomes something better — needs a different loop, with a human intention at the top of it. That is next.

## The point

Every running product drifts from its own standards, and in code-era software the drift is invisible, because nothing can read the product — so enterprises patrol it with periodic human audits that a continuous process always outruns. In a semantic application conformance is a query: scan workflows read the graph and open issues — typed, evidenced judgments produced only by governed processes, never by raw telemetry. Heal workflows repair what policy allows, deterministic tools first and model-assisted fixes above them, and refuse what they must not touch, escalating secrets and PII to humans because silently repairing evidence is destroying it. The loop closes — scan, heal, re-scan, autonomously where trust permits — and a quality gate can hold promotion while serious issues stay open, so the product will not ship itself broken. Every heal is a governed change, indistinguishable in the record from an employee's work; the loop requires a readable product, fixes as data, and governable judgment — and code could supply none of the three.
