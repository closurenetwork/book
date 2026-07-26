# Knowledge Is What You Can Do

The first thing enterprises did when language models became useful was feed them the employee handbook.

I am not exaggerating for effect; I watched it happen, repeatedly, in the same eighteen months. The recipe was everywhere: take the corporate knowledge base — the policies, the product docs, the troubleshooting guides — and stuff as much of it as would fit into the model's context window, alongside the user's question. When the windows grew, the stuffing grew to fill them. When the corpus outgrew even the larger windows, the industry invented retrieval-augmented generation, a genuinely good idea — fetch only the relevant passages, feed the model those — and then deployed it in the only architecture it knew: as a bolt-on. A vector database over here, an embedding pipeline over there, a retrieval service in between, all standing beside the product it was meant to inform. If chapter 2's four decades of intelligence-in-the-annex taught us anything, it is that we would recognize this move. The annex now had a library wing.

And what a library it drew from. The corpus fed into these pipelines was, in most enterprises, the wiki — the sprawling internal encyclopedia whose defining property is that writing to it is a virtue and reading from it is an accident. The enterprise wiki is where documentation goes to be safe from readers. Its pages contradict each other across years; its "current process" articles describe three processes ago; nobody can delete anything because nobody is sure what is load-bearing. We took this and made it the ground truth of the corporate intelligence, chunk by chunk, and then expressed surprise when the assistant confidently cited a policy retired in 2021. The failure was not retrieval. Retrieval worked fine. The failure was that the knowledge lived nowhere near the product, carried no governance, and had no notion of what the intelligence reading it was *for*.

This chapter builds the alternative from the ground up: what knowledge actually is for an intelligence that operates a product, and why every shape of it belongs on the same governed graph as the product itself.

## Four shapes of knowing

Ask what an intelligence embedded in a product genuinely needs to know, and the flat corpus dissolves almost immediately. The needs are not one kind of thing. They are four, and each has a different shape, a different freshness, and — this is the part the bolt-on architectures miss — a different correct way of reaching the model's context.

**The first shape is doctrine**: short, dense playbooks that encode *how we work here*. How this organization writes a customer email. What the brand permits. What the triage policy actually is, in the judgment cases the flowchart doesn't cover. Doctrine is small — paragraphs, not volumes — and it earns the highest priority in context: you want it present, or eagerly boosted, in nearly every relevant task, the way a good employee carries the house style in their head rather than looking it up. The worked example, Closure, calls these **Skills**, and treats them as first-class objects grouped into named libraries.

**The second shape is evidence**: the document corpus. Policies, contracts, specifications, recorded calls, the PDF the regulator sent — longer material, consulted selectively. This is where retrieval genuinely belongs: files are ingested, their content extracted into text — the design extends to captions for images and transcripts for audio and video, with extractors for the richer media types still landing as I write — then chunked, indexed, and retrieved when relevant. In the worked example these are **Files**, and a file declares its *purpose*: grounding for retrieval, asset for use in the product's interfaces, or both — the same object can be evidence for the assistant and imagery for a page.

**The third shape is the live state of the business**, and here the flat corpus is not merely inefficient but wrong. What is this customer's current plan? How many claims are open past their deadline? Embedding yesterday's export of the answer is how the assistant cites the retired policy. Live data should be *queried*, not remembered — reached as structured objects through the same interfaces the product itself uses, at the moment of need. The worked example exposes this as **Data**: the graph's objects, queryable by the assistant and by agent nodes, never dumped into the retrieval corpus as prose.

**The fourth shape is capability** — and it is the title of this chapter, so I will give it a section of its own.

Because the shapes differ in how they should reach the model, it is worth laying the taxonomy out flat, with the worked example's names alongside the general concept:

| Shape | The worked example's name | Route into context |
|-------|---------------------------|--------------------|
| Doctrine — short playbooks | Skills | Injected or boosted; present by default in relevant work |
| Evidence — document corpus | Files | Extracted, chunked, retrieved on demand |
| Live business state | Data | Queried as structured objects at the moment of need |
| Capability — callable tools | Tools | Declared to the model with schemas; never embedded in the corpus |

To see why the distinctions matter, walk one question through all four. A customer writes: *"I was double-charged in June — can you refund one of these?"* Doctrine tells the assistant how this organization speaks to upset customers and what its refund posture is in spirit. Evidence supplies the letter: the actual refund policy document, retrieved because it is relevant now. Live data answers the questions no document can — this customer's invoices, the two charges, their amounts — queried fresh, not remembered from an export. And capability closes the loop: a refund tool exists, takes an invoice and an amount, and operates under policy. Four shapes, one answer. Flatten them into a single corpus and each is degraded in its own way: the doctrine is diluted into retrievable fragments that may not surface, the policy competes with its own superseded drafts, the invoice data is stale the moment it is embedded, and the tool is not there at all — because a flat corpus has no way to represent the fact that something can be *done*.

There is also a plainer, economic argument, and it deserves a sentence of respect: the context window is the scarcest resource in the whole architecture. Every token spent on an irrelevant wiki fragment is a token unavailable to the task, and a model reasoning over noise is a model reasoning worse. The four routes are not taxonomy for its own sake; they are a budget discipline — spend the window on doctrine always, evidence when relevant, data when asked, and capability as compact declarations — so that what fills the window is what the work actually requires.

The point to carry from the taxonomy is architectural: these four are not four products. They are four kinds of object on one graph — the same graph that holds the pages and the processes. The doctrine that governs triage sits beside the triage process it governs. The policy document sits beside the workflow that must honor it. The query reaches the same objects the product renders. When chapter 6's agent node declared `skills` and `allowedTools` and a `knowledgeRef`, it was pointing *at this layer*, by identity, on the same substrate. There is no pipe to the annex, because there is no annex.

## What you can do is what you know

Here is the claim the chapter's title makes, stated plainly: **for an agent, a tool is knowledge.**

This sounds like wordplay until you sit with what a tool actually asserts. A callable capability is a fact about the world. "Refunds can be issued against a paid invoice, through this capability, with these inputs, under this policy" is exactly as much a piece of organizational knowledge as "our refund policy allows thirty days" — arguably more, since the capability is the policy with the ambiguity removed. An agent that knows the policy but not the capability can only sympathize. An agent that knows both can act. What an intelligence *can do* is part of what it *knows*, and an architecture that stores the two in different systems — documents in the knowledge base, capabilities scattered across API configurations and prompt-buried tool lists — has split a single body of knowledge down the middle.

So the fourth shape joins the other three: **tools as governed objects on the same shelf.** In the worked example, a tool is a typed object with a declared input schema, grouped into packs, and it arrives from four directions: built-in platform capabilities, HTTP endpoints, tools synced from connected MCP servers — the emerging standard by which external systems advertise capabilities to models — and sandboxed code functions, which are statically scanned before they may run. Minimal shape:

```json
{
  "@id": "urn:uuid:c7a3f2d4-…",
  "schemaRef": "schema:tool",
  "orgId": "org_meridian",
  "state": "active",
  "data": {
    "name": "issue_refund",
    "kind": "http",
    "packId": "urn:uuid:88f0…",
    "description": "Issue a refund against a paid invoice, within policy limits.",
    "inputSchema": {
      "type": "object",
      "properties": {
        "invoiceId": { "type": "string" },
        "amount": { "type": "number" }
      },
      "required": ["invoiceId", "amount"]
    }
  }
}
```

Notice what becomes possible the moment this object exists on the governed graph, and only then. The agent node in chapter 6 said `"allowedTools": ["score_risk", "knowledge_search"]` — an allowlist, attached to a process step, naming governed objects. That sentence is enforceable because tools are addressable. Permissions can attach to them. Versions can track them. And — the property I would nominate as the quiet centerpiece of the whole layer — the organization can now *read its agent's capability surface*. Open the shelf and you see, in one governed place, what the intelligence knows **and** what it can reach: every document it might cite and every lever it might pull, each one an object with an identity, a state, and an owner. Compare that to the status quo of chapter 2, where an agent's capabilities were whatever API keys someone pasted into its configuration, discoverable chiefly by incident. You cannot audit an intention — but you can audit a shelf.

The four provenances deserve a moment each, because they trace the perimeter of where capability actually comes from in an enterprise. Built-in tools are the platform's own verbs — search the knowledge layer, read the graph, report status. HTTP tools wrap the endpoints the organization already runs. Sandboxed code tools cover the awkward residue — the calculation or transformation too specific to exist anywhere else — and they pay for the privilege by being statically scanned before they may execute, which is the correct price for admitting arbitrary logic onto a governed shelf. And MCP-synced tools are the diplomatic entry: when an external system advertises its capabilities over the protocol, those capabilities land on the shelf as governed objects like any others — synced in the way the previous section will describe for facts, discoverable, allowlistable, and revocable. Note the symmetry with chapter 6's executors: there, outside intelligence was welcomed in under the process's governance; here, outside capability is welcomed in under the shelf's. The paradigm's posture toward the existing world is consistent — compose it, govern it, never require its abandonment.

One boundary keeps the shelf coherent: tools are knowledge, but they are not *corpus*. A tool's description and schema inform the model directly, as structured declarations; nobody embeds a tool into the retrieval index between two PDFs. The four shapes share a graph and a governance model precisely so that each can reach the context window by its own correct route — doctrine injected, evidence retrieved, data queried, capability declared. A single flat corpus would erase exactly the distinctions that make the knowledge usable.

## Retrieval as part of the product

In the bolt-on architecture, retrieval is plumbing: a service beside the product, doing its similarity search in the dark. Nobody governs what enters the corpus; nobody records what leaves it; the context window is assembled by machinery that the product cannot see and the auditor has never heard of. This is the annex's oldest defect in its newest clothing — meaning flowing through a pipe that carries no accountability.

Put knowledge on the product's own graph and retrieval changes character: it becomes *part of the product*, subject to the product's discipline at both doors. At the door in, ingestion is not a side-channel upload but a governed process — in the worked example, literally a workflow, of exactly the kind chapter 6 described: collect the source, classify its type, extract, chunk, index, land the file and its chunks as objects on the graph, and record the run. The corpus grows the way the product changes — through a definition that can be read, versioned, and audited — not through a script someone runs when they remember. At the door out, every retrieval leaves evidence: which query, by which actor, drew which sources, at what time. The worked example emits this retrieval audit on every search, and the consequence reaches further than compliance comfort. When an agent acts, the organization can reconstruct not just *what* it did but *what it was looking at when it decided* — which policy grounded the refusal, which document justified the escalation. The context window stops being an unwitnessed conversation between a pipeline and a model, and becomes what it always should have been: a governed assembly of governed objects, with a paper trail.

There is one more scoping discipline worth noting. Knowledge is organized into libraries, and the product's surfaces bind to the libraries they need — an experience declares which libraries ground its assistant. The customer-facing portal retrieves from the customer-facing corpus; the internal console sees the internal doctrine. Grounding follows the product's own structure, because it is stored in the product's own structure.

## Keeping it true

A knowledge layer that must be manually refreshed will be manually stale, and chapter 1 already named the law at work: second descriptions always lose. A copy of the CRM pasted into the corpus is a second description of the CRM, and it will lose to the original at the speed of every unsynchronized edit.

The remedy is to make currency *declared* rather than dutiful. In the worked example this takes the form of **SyncProfiles**: a declared statement, itself data on the graph, that a given external source — a CRM, a billing system, a document store, a webhook — feeds given objects, through named field mappings, via an ingest workflow that lands the external truth as governed objects on the graph. The emphasis falls on *declared* and *lean*. This is not the data-warehouse project of chapter 2, with its second source of truth assembled at civilizational expense; the systems of record remain authoritative, exactly as chapter 6's sealing discipline left them. The graph holds what the product's intelligence needs, mapped and fresh, with the sync itself visible and governable — a subscription to the truth rather than a copy of it. Where the mapping is declared, staleness stops being a moral failing of some team and becomes a detectable condition of an object; and detectable conditions, as Part III will show at length, are the kind of thing this paradigm knows how to act on.

## The assistant in the room

One consequence of this layer deserves a preview, though its full development belongs to chapter 12. Once knowledge lives on the product's graph, the assistant *inside* the product stops being the pop-up widget of chapter 2 — the one asking if you need help finding anything, connected to nothing. An assistant grounded on this layer stands inside the same graph it discusses: it retrieves the organization's actual doctrine, queries the product's actual objects, and reaches only the tools the organization has actually shelved and allowed. It is the difference between a kiosk in the lobby and a colleague with the same badge access you have — and when that colleague also *authors* — when the assistant's suggestions become governed changes to the graph itself — we will have arrived at the question of what authorship means in a semantic application. That is chapter 12's question. The substrate it requires is now in place.

## The point

For an intelligence operating a product, knowledge is not a corpus; it is four distinct shapes — doctrine, evidence, live data, and capability — each with its own correct route into the model's context, and all belonging on the same governed graph as the product they inform. The title's claim is the fourth shape: a tool is a fact about the world, so what an agent can do is part of what it knows, and shelving tools beside documents as governed objects is what makes an agent's capability surface readable and auditable — you can see what it knows and what it can reach, in one place, before it acts. Retrieval becomes part of the product: ingestion runs as a governed workflow, every search leaves an audit of who drew which sources to justify what. Currency is declared, not dutiful — synced from the systems of record without pretending to replace them. Ground an assistant on this layer and it stops being a widget beside the product and becomes an intelligence inside it.
