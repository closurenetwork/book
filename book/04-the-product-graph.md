# The Product Graph

The last chapter defined the property and left an IOU. Semantic closure requires a self-description that is complete and structured — one substrate, typed objects — and I promised to build it from the ground. So here is the question that chapter owes you, asked as bluntly as I can: if the product is not code, then what, exactly, is it?

The wrong answers are easy to reach for. "The product is the data" — but which data? The customer records in the database are not the product; they are what the product operates *on*. The product is not a database of records at all, nor a folder of documents, a pile of config files, or a diagram in a wiki. Each of those describes a slice and leaves the rest in code. The answer that actually satisfies the completeness clause is stranger and simpler: the product is a **graph of meaning** — a connected body of typed objects that, taken together, *are* the application, in the way that a score is the music and not a description of it.

Let me make that concrete before it floats away, because "graph of meaning" is exactly the kind of phrase that gets a book thrown across a room.

## A pricing page, before and after

Consider the pricing page from chapter 2 — the two hundred words an intelligence could rewrite in an afternoon and was not allowed to touch. In the world we have, that page is not a thing. It is a *distribution*: a React component laying out the plan cards, a CSS file (or three) styling them, a translations bundle so the page speaks French, a feature flag deciding whether the "Enterprise" tier is visible this quarter, a config table with the actual prices because someone learned not to hardcode dollar amounts, and a stripe of logic in a billing service deciding what "Enterprise" entitles you to. The pricing page, as an object you could point at, does not exist. It is an emergent property of six files owned by four teams, and the only place it is truly assembled is on the screen, at runtime, in front of the user — which is why, in chapter 5, I will call the screen the place where product truth goes to die.

Now consider the same pricing page as one typed, addressable object:

```json
{
  "@id": "urn:uuid:9b6c2f14-3e77-4a90-8a1e-2d5f0c1b7e42",
  "schemaRef": "schema:page",
  "orgId": "org_northwind",
  "state": "active",
  "data": {
    "slug": "pricing",
    "title": "Plans & Pricing",
    "root": "urn:uuid:1f0a9c33-8b21-4d6e-9f77-6c4e2a11d8b0"
  }
}
```

That is not the whole page — the `root` field points at a component, which points at its children, which point at the plan cards, which bind to the prices, and so on down the graph — but it is the *whole idea*. The page has an identity you can name. It has a type you can check it against. It has an owner. It has a lifecycle state. And it has a payload that references other objects by their identities, so that the page, the components, the theme, the prices, and the entitlement policy are not six files in four repositories — they are connected nodes in one store that a runtime renders, a reasoning engine reads, and a governance system watches. When the intelligence changes the title, it changes *this object*, and every place the page appears changes with it, because there is no second copy to drift.

The rest of this chapter is about what that object actually is, why the objects form a *graph* rather than a table or a document, how the graph is expressed, what layers it comes in, and what stays code. It is the least glamorous part of the book and the most load-bearing, because everything in Part III depends on the product having exactly this shape.

## The anatomy of a governed object

Every part of a semantic application is the same kind of thing: a **governed object**. Not a page-object and a workflow-object and a policy-object with different plumbing each — one object type, many schemas, which is the trick that lets a single runtime and a single governance system handle the entire product without special cases. Built from the ground up, a governed object has five parts, and I will introduce each as a requirement rather than a field, because each one earns its place.

**Identity.** Every object carries a globally unique identifier — in the worked example, a `@id` of the form `urn:uuid:…`. This is the *addressability* clause made concrete: if you cannot name a thing, you cannot link to it, permission it, version it, or verify it. The uuid is deliberately opaque and deliberately not a human slug like `page:pricing`, because slugs collide, get reused, and quietly change meaning, and an identity that can change meaning is not an identity. Everything in the product — every page, component, workflow, connector, policy, and the record of every change — has one of these. Addressability is not a nicety here; it is the precondition for governance, which is why the platform enforces the identifier shape rather than leaving it to taste.

**Type.** Every object declares its type through a `schemaRef` — `schema:page`, `schema:component`, `schema:workflow`, and so on. The type says what shape the object's payload must take and what it is allowed to link to. And here is the move that makes the whole thing self-supporting: **the schema is itself an object in the graph.** `schema:page` is not a class compiled into the runtime; it is a `data_schema` object with its own identity, sitting in the same store as the pages that conform to it. The graph describes its own types. That is the clause that makes verification possible — the system can check a page against its schema because the schema is *right there*, readable, versioned, and governed like everything else — and I flag it now because it is the hinge that Part III's governance swings on.

**Payload.** The `data` field holds what is specific to this object — the page's title and slug, the workflow's nodes, the connector's endpoints. The payload is where the product's actual content lives, and it is structured according to the object's schema, so it is checkable rather than free-form. Note what is *not* in the payload: behavior. The `data` describes what the object is, not how to execute it; execution is the runtime's job, and keeping the two separate is what lets the same page object render on a screen, be read by an agent, and be checked by a policy without any of them running the others' code.

**Tenancy.** Every object carries an `orgId`. A semantic application is almost never a single product for a single customer; it is a runtime hosting many organizations' products at once, and tenancy is how the store keeps them separate — whose product this object belongs to, whose governance applies, whose intelligence may read it. This is the ERP-and-Salesforce lineage from the last chapter made concrete: one runtime, many tenants' descriptions, kept apart by a field rather than by separate deployments.

**Lifecycle.** Every object carries a `state` — `draft`, `active`, and the rest of a small vocabulary of where the object is in its life. This is the seam where governance grabs hold: a `draft` object exists and can be reviewed but is not yet the operative description; an `active` object is what the runtime executes. The mere existence of this field is what makes "a change is an artifact you can review before it takes effect" mechanically possible, because a proposed change can *be* an object in `draft` state, sitting in the graph, fully inspectable, before anyone promotes it to `active`. I am deliberately not explaining the promotion machinery here — draft, approve, active, and the environments they move through are chapter 9's territory — but I want you to see that the *hook* for all of it is one field on every object.

Five parts: identity, type, payload, tenancy, lifecycle. `@id`, `schemaRef`, `data`, `orgId`, `state`. Every page, workflow, policy, connector, schema, and recorded event — the same five-part shape. The uniformity is the point: a store that holds one kind of thing can be reasoned about, secured, and governed uniformly, and a reasoning engine that learns the shape once can read the entire product. Contrast that with the pricing page's six files in four formats owned by four teams, and you can already feel the completeness clause paying rent.

## Why a graph, and not tables or documents

I keep saying *graph*, and the word is doing real work, so let me defend it against the two obvious alternatives.

A **relational database** — tables of rows — is superb at storing many instances of a fixed shape and answering aggregate questions about them. But a product is not many instances of one shape; it is a small number of highly *connected* objects of many shapes, and in a product the connections *are the meaning*. A pricing page is interesting not because of its title but because it belongs to an experience, is composed of components, references prices, is gated by a policy, is changed by a workflow, and emits events when a user acts on it. Model that in tables and the relationships fragment into join tables and foreign keys — present, but scattered, legible only to someone who already holds the schema in their head. The one thing you cannot easily do is *hand the whole connected object to a reader and let it traverse*.

A **document store** — self-contained JSON blobs — has the opposite failing. It keeps each object whole and readable but treats the links as incidental strings rather than first-class edges, so the connectedness that carries the meaning is the part it does not model. You can store a page as a document; you cannot ask the document store "what breaks if I change this theme?" without leaving the store and reasoning in code.

A **graph** models the objects *and* the edges between them as first-class, and it does so because in a product the edges are where the meaning lives. The platform docs put it in a line I will borrow: meaning travels with the objects. A page *owns* components; a component *triggers* a workflow; a workflow *writes through* a connector; a connector *is governed by* a policy; the whole run *emits* events. Those verbs are edges, and they are the difference between a pile of records and a description of a business.

```
Experience ──has──> Page ──renders──> Component ──triggers──> Workflow
                                                                  │
                                                            writes-through
                                                                  ▼
Policy <──governs── Connector <──seals-into── System of Record
```

Two reasons this shape matters beyond aesthetics, and they map onto the readers. The **runtime** understands the product by traversal — to render a page it walks from the page to its root component to that component's children; to execute a process it walks the workflow's nodes. And the **machine reader**, the LLM, reasons natively over connected concepts rather than isolated rows: ask a model to reason about a customer, an order, and a disputed invoice, and it does far better when those arrive as a connected subgraph — *customer owns order, order generated invoice, invoice disputed into a case* — than as three query results it must mentally join. The graph is not chosen because graphs are fashionable, but because both things that read the product read it best as a graph, and a representation should be shaped for its readers.

## How the graph is expressed

A graph has to be written down in some concrete notation, and the vendor-neutral requirement is modest: a way to express objects with **identity, type, and links** — a graph language, not merely a file format. The worked example uses JSON-LD, persisted as JSONB in Postgres, with GraphQL as the query surface, and the division of labor is worth stating precisely:

- **JSON-LD** is how objects carry identity, type, and links — the graph language. It is the format of the objects themselves.
- **Postgres JSONB** is how the objects are persisted — one `data_object` table, one shape, many schemas, stored as indexed JSON.
- **GraphQL** is how clients query and mutate the graph — the read/write surface the runtime, the IDE, and the assistant all speak.

The platform docs offer an analogy I find clarifying. Developers do not buy React "for JSX"; JSX is simply the best way to express components, and nobody mistakes the notation for the value. In the same spirit, nobody should buy a semantic platform "for JSON-LD." JSON-LD is how you express product meaning — the native language of products on this substrate — and the value is what the expression makes possible, not the punctuation. If a better graph notation comes along, the paradigm survives the swap, because the paradigm is the closed loop, not the file extension. The Semantic Web's long stall was partly a story of people falling in love with the notation and forgetting they were building for a reader that had not shown up yet. Do not fall in love with the notation.

One comparison from the platform docs makes the point sharper than I can in prose:

| Store | What it stores |
|-------|----------------|
| SQL | records |
| Mongo | documents |
| YAML | configuration |
| GraphQL | a query language over data |
| JSON-LD | meaning — identity, type, and links |

The row that matters is the last one. Records, documents, and configuration are all things a product *has*. Meaning — the objects and the edges between them — is what a product *is*.

## The layers of a full product graph

A pricing page is a fine first object, but a product is more than its screens, and the completeness clause demands that *all* of the changeable product live on the substrate, not just the UI. Described vendor-neutrally first, a full product graph has these layers — and then I will note what the worked example names them, so you can hold both:

- **The experience layer** — the interface as data: pages, components, themes, navigation, actions. This is what the user opens. Chapter 5 is entirely about it, so I will say no more here than that it is objects, not a codebase.
- **The process layer** — the workflows: the sequences of forms, decisions, agent steps, human gates, and seals that move work from started to finished. Chapter 6 owns process in depth; for this chapter it is enough that a process is a graph of typed nodes, not a service written in code.
- **The knowledge layer** — what the product's intelligence is supposed to know and be able to do: playbooks, documents, live business data, and the tools the agents may call. Chapter 7 owns knowledge; here it is one more region of the same graph.
- **The integration layer** — the connections to the outside systems that remain the systems of record: vaulted connectors that import, write, and trigger. The product graph does not replace your CRM or your ITSM; it links to them, and the links are objects.
- **The operations plane** — the record of how the product actually lives: the runs of its processes, the events they emit, the issues opened against the product, the goals set for it, and the versions it has moved through. Chapters 8 and 9 own memory and governance; the point for now is that even the *history* of the product is data on the same substrate, not logs in a different stack.

In the worked example these are named Experiences, Workflows, Knowledge, Integrations, and the Ops plane (Runs, Events, Issues, Goals, Versions). The names are the platform's; the layering is the paradigm's. And here is the sentence that connects this chapter back to Part I: it is **one graph, not five stores**. Recall low-code's anatomy from chapter 1 — a form builder holding the pages, a workflow engine holding the processes, a rules engine holding the logic: three tools, three half-descriptions of one product, wired together with glue that was code by another name. A product graph refuses that fragmentation. The interface, the process, the knowledge, and the integrations can share one store because they are the same *kind* of thing — governed objects — and a reader can only reason about a product it can see whole. Five stores means a description complete nowhere. One graph means the completeness clause is achievable at all.

## Schemas are citizens too

I touched this above and I am returning to it because it is the quiet keystone of the whole design: the graph describes its own types. Every schema — `schema:page`, `schema:workflow`, `schema:component` — is not a class hardcoded into the runtime but a `data_schema` object living in the graph beside the objects it governs. This sounds like a technicality. It is the mechanism that makes the *verify* clause possible.

To check that a page is well-formed, the system needs to know what a well-formed page is — and if that knowledge lives in compiled runtime code, the definition of "valid page" can only change when the runtime is rebuilt and redeployed, which drags us back toward the compile-and-drift world we are leaving. When the schema is itself a governed object, "valid page" is data: readable by the intelligence, versioned like everything else, changeable under the same governance as the pages themselves. The product can reason about its own types, and — the part that will matter in Part III — it can notice when an object has drifted out of conformance, because the schema is something it can read rather than something buried in an engine. A system that carries its own rules as inspectable data is a system that can check itself. That is the setup; chapter 9 is the payoff.

## What stays code

I have spent a chapter insisting the product is data, so let me be equally clear about what is emphatically *not* — the paradigm dies the moment you overreach and try to make everything data. The **runtime stays code**, and should:

- The **renderer** that walks the experience objects and produces an interface.
- The **workflow engine** that executes the process objects.
- The **query and mutation API** — the GraphQL surface.
- The **vault** holding connector secrets, the identity and session machinery, the schema validator itself.

None of these belong in the graph, because none of them are the *product*. They are the engine the product runs on, and the cleanest way to hold the distinction is the analogy I opened the book with: a database engine is code; the database it carries is data; you do not rebuild Postgres to add a table. The renderer does not know or care whether it is rendering a pricing page or a patient intake form, exactly as Postgres does not know whether your table holds invoices or insects. That indifference is the whole trick. It lets the product change at the speed of data — weekly, daily, by an intelligence, under governance — while the engine underneath changes at the speed of code, slowly and deliberately, by the people who should be writing engines.

The line between the two is not a matter of taste; it is the line between what the business argues about and what it does not. Pricing tiers, intake questions, approval policies, the copy on a button — these change constantly and belong in the graph. Rendering, execution, persistence, cryptography — these change rarely and belong in code. Draw the line there and both halves get to be good at their jobs.

## The point

If the product is not code, it is a **graph of meaning**: a connected body of governed objects, each with an identity (`@id`), a type (`schemaRef`) whose schema is itself an object in the graph, a payload (`data`), a tenant (`orgId`), and a lifecycle (`state`) — the same five-part shape for pages, workflows, policies, connectors, and the record of change alike. It is a graph rather than tables or documents because in a product the relationships *are* the meaning, and because both readers that matter — the runtime by traversal, the LLM by reasoning over connected concepts — understand a product best as a graph; the worked example expresses it as JSON-LD over Postgres JSONB with GraphQL as the query surface, but the notation is not the paradigm. A full product graph carries the experience, process, knowledge, and integration layers plus an operations plane in one store rather than the five fragmented stores of low-code, which is what makes completeness reachable at all. Schemas live in the graph as citizens, so the product carries its own rules and can check itself. And the runtime stays code: it is the database engine; the product graph is the database it carries. Next, how that graph becomes something a human can actually see.
