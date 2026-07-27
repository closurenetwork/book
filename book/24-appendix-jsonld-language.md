# The Language of the Graph

Chapters 18–23 defined $G$ in mathematics and architecture. This chapter shows the **concrete syntax**: JSON-LD as the native language of DataObjects — not a dump format bolted on after the fact. Field names track a shipping product lattice; the shapes are illustrative and slightly simplified so a reader can hold an entire miniature organization in one view.

## Why JSON-LD

Definition 18.4 said an object is

$$o = (\mathrm{id}(o),\, L(o),\, d(o),\, \ell(o)).$$

JSON-LD is how that tuple is written for machines and humans at once:

| Math | Concrete field |
|------|----------------|
| $\mathrm{id}(o)$ | `@id` (URI, typically `urn:uuid:…`) |
| $L(o)$ | `@type` and/or `schemaRef` (e.g. `schema:experience`) |
| $d(o)$ | `data` (typed payload) |
| $\ell(o)$ | references inside `data` (`pageIds`, `rootComponentId`, …) and/or a `links` map |

A document may bundle many objects:

```json
{
  "@context": "https://closureapps.com/ns/context.jsonld",
  "@graph": [ /* objects */ ]
}
```

The `@graph` array is a finite piece of $V$. Edges are references by `@id`. That is $G = (V, E, L)$ in the language the runtime actually stores.

**Axiom (concrete).** Editing HTML, a slide, or a chat transcript without updating the corresponding object in `@graph` is exactly the unrepresentable component $F_\perp$ of Chapter 18.

## Lean taxonomy

Schemas are themselves names in a finite alphabet $\Sigma$. The lean product lattice groups as follows. (Legacy aliases exist in running systems; prefer the rows marked primary.)

| Family | Schema id | Role |
|--------|-----------|------|
| Meta | `schema:data_schema` | Schemas about schemas |
| Meta | `schema:pack` | Installable product slice |
| Experience | `schema:experience` | App root: nav, pages, theme binding |
| Experience | `schema:page` | Routable surface |
| Experience | `schema:component` | UI node in a page tree |
| Design | `schema:design_token_set` | Tokens by category |
| Design | `schema:design_theme` | Light/dark composition |
| Design | `schema:design_system` | Brand family |
| Design | `schema:design_spec` | Kit + component style contracts |
| Process | `schema:workflow` | Workflow graph $W$ as data |
| Process | `schema:workflow_ref` | Experience to workflow pointer |
| Knowledge | `schema:knowledge_source` | Corpus / doctrine document |
| Knowledge | `schema:knowledge_chunk` | Retrievable passage |
| Tools | `schema:tool` | Callable metadata |
| Tools | `schema:tool_pack` | Library of tools |
| Integration | `schema:connector` | SoR adapter catalog row |
| Telemetry | `schema:org_event` | Organizational memory |
| Governance | `schema:issue` | Judgment opened by a gate/workflow |
| Governance | `schema:goal` | Evolution attractor |
| Governance | `schema:change_request` | Executable work order |
| Quality | `schema:test` / `schema:test_run` | Semantic tests |

Pillars from Chapter 21 are covers over these families — not separate databases.

## Miniature organization (`@graph`)

The following document is a **toy** org: one Experience with a home page, a hybrid workflow stub (expanded in Chapter 25), a knowledge chunk, a design system binding, and an event. Identifiers are stable UUIDs for readability in prose.

```json
{
  "@context": {
    "@vocab": "https://closureapps.com/ns#",
    "schema": "https://closureapps.com/ns/schema/",
    "data": "https://closureapps.com/ns#data"
  },
  "@graph": [
    {
      "@id": "urn:uuid:11111111-1111-4111-8111-111111111101",
      "@type": "schema:design_system",
      "name": "Northwind Brand",
      "data": {
        "slug": "northwind",
        "brand": "Northwind",
        "identityStyle": "type",
        "themeIds": ["urn:uuid:11111111-1111-4111-8111-111111111102"]
      }
    },
    {
      "@id": "urn:uuid:11111111-1111-4111-8111-111111111102",
      "@type": "schema:design_theme",
      "name": "Northwind Light",
      "data": {
        "slug": "northwind-light",
        "appearance": "light",
        "tokenSetIds": []
      }
    },
    {
      "@id": "urn:uuid:22222222-2222-4222-8222-222222222201",
      "@type": "schema:component",
      "name": "Home hero",
      "data": {
        "kind": "hero",
        "props": {
          "headline": "Claims that heal themselves",
          "subcopy": "Governed intake, research, and approval — on one graph."
        },
        "children": []
      }
    },
    {
      "@id": "urn:uuid:22222222-2222-4222-8222-222222222202",
      "@type": "schema:page",
      "name": "Home",
      "data": {
        "route": "/",
        "rootComponentId": "urn:uuid:22222222-2222-4222-8222-222222222201",
        "compositionPattern": "stack"
      }
    },
    {
      "@id": "urn:uuid:22222222-2222-4222-8222-222222222200",
      "@type": "schema:experience",
      "name": "Northwind Claims",
      "data": {
        "slug": "northwind-claims",
        "homePath": "/",
        "homePageId": "urn:uuid:22222222-2222-4222-8222-222222222202",
        "pageIds": ["urn:uuid:22222222-2222-4222-8222-222222222202"],
        "theme": {
          "designSystemId": "urn:uuid:11111111-1111-4111-8111-111111111101"
        },
        "workflowRefIds": ["urn:uuid:33333333-3333-4333-8333-333333333301"]
      }
    },
    {
      "@id": "urn:uuid:33333333-3333-4333-8333-333333333301",
      "@type": "schema:workflow_ref",
      "name": "Intake ref",
      "data": {
        "workflowId": "urn:uuid:33333333-3333-4333-8333-333333333300"
      }
    },
    {
      "@id": "urn:uuid:33333333-3333-4333-8333-333333333300",
      "@type": "schema:workflow",
      "name": "Claims intake (hybrid)",
      "data": {
        "workflowId": "wf-northwind-claims",
        "kind": "hybrid",
        "graph": {
          "id": "wf-northwind-claims",
          "entryNodeId": "start",
          "nodes": [],
          "edges": []
        }
      }
    },
    {
      "@id": "urn:uuid:44444444-4444-4444-8444-444444444401",
      "@type": "schema:knowledge_source",
      "name": "Claims playbook",
      "data": {
        "kind": "doctrine",
        "title": "Northwind claims playbook"
      }
    },
    {
      "@id": "urn:uuid:44444444-4444-4444-8444-444444444402",
      "@type": "schema:knowledge_chunk",
      "name": "Triage rule",
      "data": {
        "sourceId": "urn:uuid:44444444-4444-4444-8444-444444444401",
        "text": "Express path when priority is low and payload validates; otherwise full enrich."
      }
    },
    {
      "@id": "urn:uuid:55555555-5555-4555-8555-555555555501",
      "@type": "schema:org_event",
      "name": "Experience published",
      "data": {
        "family": "experience",
        "kind": "experience.published",
        "at": "2026-07-27T12:00:00.000Z",
        "subjectId": "urn:uuid:22222222-2222-4222-8222-222222222200"
      }
    }
  ]
}
```

Read it as $G$: the experience points at a page; the page points at a component; the experience points at a workflow ref; the ref points at a workflow; knowledge chunks point at sources; the event points at the experience. The empty `nodes` / `edges` arrays are filled in Chapter 25 — same object, richer $W$.

## Composability in the concrete

Two intents compose when they share identifiers:

- A component `@id` appearing in `children` and as `rootComponentId` is one vertex, not two copies.
- A `designSystemId` on an experience is an edge into the design family.
- A `workflowId` shared by a ref and a workflow object is the glue between Experience and Process pillars.

That is the pushout intuition of Definition 20.18, written as JSON references.

## The point

JSON-LD is not “how we export the product.” It is how the product *is*. The next chapter expands the workflow object and walks a run — proposal, integrity, commit, event — in the same language.
