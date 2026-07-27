# Pillars and Projections

This chapter assigns mathematics to each pillar and to the projections that make $G$ usable without becoming a second model.

## Pillars as subgraphs

Recall the pillar cover $\mathsf{Pillars}$ from Definition 21.3. For each pillar $P$, write $G_P$ for the subgraph (objects + induced links) assigned to $P$.

### Experiences

**Definition 22.1 (Experience).** An experience root $e$ determines a finite tree (or DAG) of pages and components:

$$T_e = (N_e,\, \mathsf{parent}: N_e \rightharpoonup N_e,\, \mathsf{route},\, \mathsf{props})$$

with $e \in N_e$ the root. The renderer $\pi_{\mathrm{UI}}(G)$ is a function of $T_e$ and the bound design system.

**Composition patterns** and **layout shells** are data on pages/experiences — elements of $d(o)$ — not forks of renderer source.

### Workflows

Workflow objects and their graphs $W$ (Chapter 20) constitute $G_{\mathsf{Wf}}$. Runs $\rho$ are either objects in $G$ or rows in a run store keyed by workflow id; in either case they are addressable memory of process, not ephemeral chat.

### Knowledge

**Definition 22.2 (Knowledge).** Knowledge is a triple

$$K = (S_{\mathrm{src}},\, C_{\mathrm{chunk}},\, \Sigma_{\mathrm{skill}})$$

sources, chunks, and skills. Retrieval is a map

$$\mathsf{Retr}: \mathsf{Query} \times K \to \mathsf{List}(\mathsf{Passage})$$

used by Assistant and craft. Skills are doctrine objects: versioned instructions that IDE agents pull so rails live in $G$, not only in editor config.

### Integrations

**Definition 22.3 (Connector).** A connector $c$ is an object with an adapter identity and sealed secret handles $h$ such that plaintext secrets never appear in $D$, tool arguments, or chat. Effects on external systems of record are

$$\mathsf{Adapt}(c, h, \mathsf{cmd}) \mapsto \mathsf{result}$$

with audit via events. Integrations extend $R(S)$; they do not replace $G$ as SoT.

### Events

**Definition 22.4 (Organizational memory).** The event stream is a time-ordered set $\mathcal{E} \subset V$ (or a store isomorphic to it). Evolution recommendations and healing are functions of $(\mathcal{E}, G)$, not of log archaeology outside $R(S)$.

## Projections, systematically

**Definition 22.5 (Projection family).** A finite family $\{\pi_j\}_{j \in J}$ with

$$\pi_j: G \to \mathsf{View}_j$$

includes at least:

| $j$ | $\mathsf{View}_j$ |
|-----|-------------------|
| UI | Rendered Experience |
| Q | Query API results |
| IDE | Page trees, related walkers, taxonomy dumps |
| Form | Collect / seal microforms |
| Assist | Retrieved passages + tool results |
| Brand | CSS variable map (below) |

**Axiom 22.1.** For all $j$, authorship that matters updates $G$, not $\mathsf{View}_j$ alone.

## Brand as structured projection

**Definition 22.6 (Brand stack).** Brand is a chain of objects

$$\mathsf{Tokens} \to \mathsf{Themes} \to \mathsf{DesignSystem} \to \mathsf{DesignSpec} \to e.\mathsf{theme}$$

culminating in a CSS variable map

$$\pi_{\mathrm{Brand}}(G) = \{ \texttt{--cp-*} \mapsto \mathsf{value} \}.$$

Semantic roles (surface, on-surface, border, accent, …) are the only colorimetric vocabulary components consume. Hard-coded product hex in component payloads is a SoT leak: it makes $\pi_{\mathrm{UI}}$ author color outside the brand stack.

**Identity style.** $\mathsf{type}$ (mark + wordmark) or $\mathsf{image}$ (logo URLs) is data on the design system — still in $G$.

## Packs

**Definition 22.7 (Pack).** A pack is a finite set of objects $P \subset V$ with install rules. Installing a pack is a mutation $\Delta_P$ (creates/updates under $I$). Packs are how product slices move between organizations without forking platform source for IA and copy.

## The point

Pillars partition meaning; projections deliver it; brand is one more projection with unusual leverage. The final chapter restricts who may run which operators on which environment’s graph.
