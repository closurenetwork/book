# Notes and Sources

This book wears its sources in the prose, where they belong, rather than in footnotes, where they interrupt. But an argument this size should let its reader pull any thread without an expedition, so this section collects the works, systems, and milestones behind each chapter's claims. Where a figure is an estimate, I say whose estimate; where a claim is common industry experience with no canonical citation, I say that too — which is more than most footnotes ever admit.

## Introduction

- Smalltalk as a live, inspectable programming world: Adele Goldberg and David Robson, *Smalltalk-80: The Language and Its Implementation* (Addison-Wesley, 1983).
- The Semantic Web's self-describing data: Tim Berners-Lee, James Hendler, and Ora Lassila, "The Semantic Web," *Scientific American*, May 2001.
- Salesforce founded 1999 on "The End of Software" positioning — company milestone; the "no software" campaign belongs to the company's earliest years.
- Kubernetes and the declared-state-plus-reconciliation pattern: Google, open-sourced June 2014.

## Chapter 1 — A Brief History of the Application

- The bank hunting for a reader of its 1974 COBOL accrual program: presented in the text as a secondhand, representative story — the kind every enterprise veteran carries a version of — not as a documented public event.
- "A couple hundred billion lines of COBOL" in production: the book presents this as an estimate. Commonly cited sources include a 2017 Reuters graphic ("COBOL blues," ~220 billion lines) and later Micro Focus/Vanson Bourne surveys, which produced substantially higher figures; the literature does not agree on a number, only on the scale.
- COBOL itself: designed by the CODASYL committee, 1959.
- Client-server era tooling: Visual Basic (Microsoft, 1991), PowerBuilder (Powersoft, 1991), Oracle Forms.
- Workflow-era standards: WS-BPEL (OASIS, 2.0 in 2007) and BPMN (BPMI, later OMG; 2.0 in 2011).
- Salesforce launched 1999 promising the "end of software" — company milestone; see Introduction note.
- Programs as theories that die with their authors: Peter Naur, "Programming as Theory Building," *Microprocessing and Microprogramming* 15 (1985): 253–261.
- The second-system effect: Fred Brooks, *The Mythical Man-Month* (Addison-Wesley, 1975).
- CASE tools and the round-tripping collapse: Excelerator (Index Technology) and the Information Engineering Facility (Texas Instruments), 1980s. The market's collapse is well-documented industry history; the round-tripping diagnosis is stated in the text as common industry experience, with no single canonical source.
- 4GLs (FOCUS, RAMIS, Natural) and the era's ambition: James Martin, *Application Development Without Programmers* (Prentice-Hall, 1981).
- UML 1.1 adopted by the Object Management Group, 1997; the OMG's Model-Driven Architecture initiative launched 2001.
- "Low-code" coined at Forrester: Clay Richardson and John Rymer, "New Development Platforms Emerge for Customer-Facing Applications," Forrester Research, June 2014. Platforms named: OutSystems, Mendix, Appian, Power Apps.
- The RPA boom of the late 2010s (UiPath and its cohort): industry history; the characterization of screen-scraping fragility is common experience, no single canonical source.

## Chapter 2 — The Great Split

- The bar exam result: OpenAI, "GPT-4 Technical Report," March 2023, reporting roughly 90th-percentile performance on the Uniform Bar Exam. The percentile was later disputed — see Eric Martínez, "Re-evaluating GPT-4's Bar Exam Performance," *Artificial Intelligence and Law* (2024) — and the chapter says so.
- DEC's expert system for configuring computer orders: John McDermott, "R1: A Rule-Based Configurer of Computer Systems," *Artificial Intelligence* 19 (1982); developed circa 1980 and deployed at Digital Equipment Corporation, where it was known as XCON.
- The data-warehouse movement's "single source of truth": industry phrase of the 1990s (the tradition of Inmon and Kimball); no single canonical coinage.
- "Bots are the new apps": Satya Nadella, Microsoft Build keynote, 2016.
- The copilots' arrival: GitHub Copilot, technical preview June 2021, general availability June 2022.
- Rising code churn and copy-paste-shaped commits in the copilot era: GitClear's code-quality analyses of AI-assisted codebases (2024).
- Change controls as law for public companies: the Sarbanes-Oxley Act of 2002 and the IT general controls regime built on it.

## Chapter 3 — Semantic Closure

- Self-reproducing automata and the dual-role description: John von Neumann, *Theory of Self-Reproducing Automata*, edited and completed by Arthur W. Burks (University of Illinois Press, 1966), from work begun in the late 1940s.
- The term "semantic closure": Howard Pattee, in theoretical biology and biosemiotics — see "The Physics of Symbols: Bridging the Epistemic Cut," *BioSystems* 60 (2001), and his earlier papers from the 1980s onward where the term originates.
- Self-reference in formal systems: Kurt Gödel, "Über formal unentscheidbare Sätze der Principia Mathematica und verwandter Systeme I," *Monatshefte für Mathematik und Physik* 38 (1931); Douglas Hofstadter, *Gödel, Escher, Bach: An Eternal Golden Braid* (Basic Books, 1979).
- Lisp's homoiconicity: John McCarthy, "Recursive Functions of Symbolic Expressions and Their Computation by Machine, Part I," *Communications of the ACM* 3 (1960); the language took shape 1958–60.
- Smalltalk's live image: Goldberg and Robson, *Smalltalk-80* (1983); see Introduction note.
- The Semantic Web stack: RDF (W3C Recommendation, 1999); OWL (W3C, 2004); JSON-LD 1.0 (W3C Recommendation, January 2014); and the manifesto, Berners-Lee, Hendler, and Lassila, *Scientific American*, May 2001.
- HATEOAS: Roy T. Fielding, "Architectural Styles and the Design of Network-based Software Architectures" (PhD dissertation, University of California, Irvine, 2000).
- ERP metadata at scale: SAP R/3's Data Dictionary (DDIC), per SAP's own documentation.
- Salesforce's metadata-driven multitenancy: Craig Weissman and Steve Bobrowski, "The Design of the Force.com Multitenant Internet Application Development Platform," *SIGMOD* 2009.
- Kubernetes: Google, open-sourced June 2014.
- The author's disclosed position: U.S. Provisional Patent Application No. 63/974,920, filed February 2026 — see the closing note below.
- Formal grounding of the seven clauses (restated in Part V): representability $F \in R(S)$ and the product graph as source of truth — scoped to what Closure Platform implements. Optional broader physics/AI program in [closurenetwork/books](https://github.com/closurenetwork/books) is not required for Part V.

## Chapter 4 — The Product Graph

- The worked example's notation and plumbing: JSON-LD (JSON-LD 1.0, W3C Recommendation, January 2014); PostgreSQL's JSONB storage; GraphQL (developed at Facebook, open-sourced 2015).

## Chapter 6 — Process as Data

- The deterministic process vocabulary — gateways (parallel, inclusive, event-based), timers, compensation, subprocesses, human tasks — descends from the BPMN 2.0 specification (OMG, 2011) and the WS-BPEL 2.0 standard (OASIS, 2007).
- LangGraph, named as an example of the enterprise agent frameworks the external executor accommodates: LangChain's agent-orchestration library.

## Chapter 7 — Knowledge Is What You Can Do

- Retrieval-augmented generation: Patrick Lewis et al., "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks," *NeurIPS* 2020.
- MCP, the protocol by which external systems advertise capabilities to models: Model Context Protocol, introduced by Anthropic, November 2024.

## Chapter 9 — Governance, or Why Freedom Requires Gates

- Change management, separation of duties, and the four-eyes principle as enterprise doctrine: long-standing practice, codified for public companies in the Sarbanes-Oxley Act of 2002 and the audit regimes built on it.

## Chapter 11 — The Evolution Loop

- The change-advisory discipline the loop implements natively — request, assessment, authorization, implementation as distinct records with distinct approvers: the ITIL change-management tradition and its change-advisory board.

## Chapter 12 — The Author and the Instrument

- The editor-to-graph protocol in the worked example: Model Context Protocol (Anthropic, November 2024); editors named: Cursor, Claude Code, VS Code.
- The compiler transition and the assembly programmers' resistance: common history of the FORTRAN era (IBM, 1957); for the period's skepticism, see John Backus, "The History of FORTRAN I, II, and III," in *History of Programming Languages* (ACM, 1978). The generalization about incumbent predictions is the author's characterization of that record.

## Chapter 13 — The Economics of Living Software

- Maintenance as 60–80 percent of lifetime cost: the book presents this as the range of published estimates. The foundational survey work is B. P. Lientz and E. B. Swanson, *Software Maintenance Management* (Addison-Wesley, 1980); for the later literature and its spread, Robert L. Glass, *Facts and Fallacies of Software Engineering* (Addison-Wesley, 2002).
- Comprehension as roughly half of maintenance effort: presented as an estimate; commonly cited sources include R. K. Fjeldstad and W. T. Hamlen's IBM application-maintenance study (1983) and T. A. Corbi, "Program Understanding: Challenge for the 1990s," *IBM Systems Journal* 28 (1989).
- Legacy modernization sized "in the hundreds of billions of dollars": presented as a characterization of analyst sizing of the modernization-and-related-services market; estimates vary widely with the definition used, and no single figure is canonical.
- The COBOL installed base: see the Chapter 1 note.
- Software amortization over roughly five years: standard accounting convention for capitalized internal-use software.

## Chapter 14 — The Semantic Enterprise

- "Acquisitions fail most often at integration": stated in the text as common industry experience; the high failure rate of M&A integration is a staple of the management literature, but no single canonical source is cited.

## Chapter 15 — The Last Application

- The bank, its 1974 COBOL accrual program, and the missing binder reprise Chapter 1; see the notes there.
- FORTRAN as the start of the first era: IBM, 1957.

## Part V — Technical Appendices

Part V is self-contained public mathematics, architecture, and JSON-LD concrete syntax for the semantic paradigm (state, graph dynamics, process and agentic workflows, pillars, control plane, taxonomy, execution traces). It does not depend on repository paths or internal doc filenames. The worked example is the Closure product described in the main chapters. Definition 18.2 is stated as the **Semantic Closure Criterion** ($F \in R(S)$), not as a theorem of pure mathematics — see the paper draft in this repository’s `papers/` directory for an academic framing. Chapter 26 states six first-principle axioms (A1–A6) and points at Goals on the Closure organization as the operational meta-lab.

## Related Work Matrix

Where neighboring traditions sit relative to the seven clauses (complete, structured, read, verify, rewrite, governance, while running). “Partial” means the tradition held some clauses strongly and lacked others that this book treats as load-bearing.

| Tradition | Strong clauses | Typical gap vs this book |
|-----------|----------------|--------------------------|
| Lisp / Smalltalk | structured, rewrite, while running | governance, enterprise-scale types, distribution |
| Semantic Web (RDF/OWL/JSON-LD) | structured, (machine) read *of data* | rewrite of a live *product*; governance; a reader that arrived late |
| HATEOAS | read (process as hypermedia) | complete product substrate; rewrite under gates |
| ERP metadata / Salesforce | complete, structured (vendor surface) | open product graph; machine rewrite; non-human reader |
| Model-driven architecture / UML | structured (design-time) | while running — generated side forks |
| Low-code / RPA | rewrite (limited surface) | complete authoritative description; verify depth |
| Kubernetes | structured, verify, while running (infra) | product pages/pricing/meaning — wrong domain |
| Copilots on codebases | read/rewrite *code* | product as governed data; shared $\delta$ / $I$ |
| Agent frameworks alone | rewrite (tools/chat) | complete typed $G$; verify; governance as SoT |
| **This book / Closure example** | all seven as one loop | runtime may still approximate $I$ as $I^\circ$ (named honestly) |

The matrix is a map for readers and reviewers, not a claim that every cited system “failed.” Each contributed clauses; the synthesis claim is the closed loop on a product with a machine reader.

## A Note on the Worked Example

The platform used throughout as the worked example, Closure, is documented at its own site, and the system and method described are the subject of U.S. Provisional Patent Application No. 63/974,920, "System and Method for Semantic Closure in Agentic Full-Stack Application Development Using Linked JSON-LD Graphs," filed February 3, 2026.
