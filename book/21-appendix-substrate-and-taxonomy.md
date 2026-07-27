# Substrate and Taxonomy

Chapters 18–20 defined the mathematics of state, mutation, and workflows. This chapter expresses that mathematics as an architecture: a single store, a schema lattice, and the interpreters that surround it — without a second product codebase.

## Architectural claim

> The product exists as governed data. Code is the runtime around it.

Formally: $M = G$ (Chapter 18), and $X$ is the fixed family of interpreters $\{\pi_i\} \cup \{\mathsf{Engine}_W\} \cup \{\mathsf{Store}\}$. Creating an application is a sequence of gated mutations on $G$, not the shipment of a parallel page tree as source of truth.

## The store

**Definition 21.1 (Store).** A store is a persistence + memory pair

$$\mathsf{Store} = (\mathsf{Disk},\, \mathsf{RAM})$$

with hydration $\mathsf{Disk} \to \mathsf{RAM}$ on boot and write-through $\mathsf{RAM} \to \mathsf{Disk}$ on commit. On live systems, durable rows are the source of truth; RAM is a working image.

Each row realizes a DataObject $o = (\mathrm{id}, L, d, \ell)$ (Definition 18.4). Query and mutation APIs (for example typed GraphQL derived from $\Sigma$) are projections and operator surfaces over $\mathsf{Store}$, not alternative models.

## Schema lattice

**Definition 21.2 (Lean lattice).** The schema alphabet $\Sigma$ is finite and versioned. Representative families:

| Family | Role in $G$ |
|--------|-------------|
| Meta | Schemas about schemas; packs |
| Experience | Experience roots, pages, components, themes |
| Process | Workflows, runs (as objects or run stores keyed by workflow) |
| Knowledge | Sources, chunks, skills (doctrine) |
| Integration | Connectors, sealed handles |
| Telemetry | Organizational events |
| Governance | Issues, goals, change requests, policy bindings |
| Design | Token sets, themes, design systems, specs |

**Definition 21.3 (Pillar partition).** A pillar map is a partition (or soft cover) of live objects:

$$\mathsf{Pillars} = \{\mathsf{Exp},\, \mathsf{Wf},\, \mathsf{Know},\, \mathsf{Int},\, \mathsf{Evt}\}$$

with $\Phi$ from Definition 18.6 landing each facet in one or more pillars. Soft cover allows meta/design objects to serve multiple pillars.

## Integrity in the architecture

Chapter 19’s ideal predicate $I = I_{\mathrm{str}} \wedge I_{\mathrm{type}} \wedge I_{\mathrm{ref}} \wedge I_{\mathrm{sem}}$ is expressed as layered gates:

| Layer | Implements | Typical strength |
|-------|------------|------------------|
| Write-through validator | $I_{\mathrm{type}}$, partial $I_{\mathrm{ref}}$ | May warn or enforce |
| Craft / ship verifiers | subset of $I_{\mathrm{sem}}$ (page, brand, accessibility, …) | Deterministic in loops |
| Promote / issue gates | subset of $I_{\mathrm{sem}}$ (severity, severity) | Fail-closed when entitled |

**Honesty.** Write-through may run as $I^\circ \le I$. Default shipping mode may warn and soften referential checks so pack installs can upsert out of order; **enforce** mode rejects on typing and hard $I_{\mathrm{ref}}$. The architecture still *states* the full $I$ of Chapter 19. Closing remaining gaps (stronger $I_{\mathrm{sem}}$, complete event coverage on every path) is implementation of the theory, not a new theory.

## Interpreters in $X$

| Interpreter | Symbol | Reads |
|-------------|--------|-------|
| Experience renderer | $\pi_{\mathrm{UI}}$ | Experience / page / component subgraph |
| Query API | $\pi_{\mathrm{Q}}$ | Arbitrary typed slices of $G$ |
| Workflow engine | $\mathsf{Engine}_W$ | Workflow objects + run state $\rho$ |
| Knowledge retriever | $\pi_{\mathrm{K}}$ | Sources, chunks, skills |
| Integration adapters | $\mathsf{Adapt}$ | Connector objects + vault handles |
| IDE tool surface | $\pi_{\mathrm{IDE}}$ | Same $G$, gated by $\mathcal{A}$ |

All are functions of $(G, X)$. None may become SoT.

## Diagram

```
                    +-----------------------------+
                    |     DataObject store G      |
                    |     schemas · durable DB    |
                    +--------------+--------------+
           +-----------+-----------+-----------+-----------+
           v           v           v           v           v
      Renderer      Query API   Workflows   Knowledge    Events
                                   ^
                          Assistant · IDE tools
```

## The point

Architecture is the store, the lattice, and the interpreters. The mathematics does not change when we name Postgres or GraphQL; those are choices of $X$. The next chapter develops pillars and projections in detail — including brand as a structured projection.
