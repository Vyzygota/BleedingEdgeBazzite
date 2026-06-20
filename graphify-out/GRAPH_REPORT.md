# Graph Report - BleedingEdgeBazzite  (2026-06-20)

## Corpus Check
- 5 files · ~2,126 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 32 nodes · 31 edges · 6 communities (5 shown, 1 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `606dfb52`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]

## God Nodes (most connected - your core abstractions)
1. `BleedingEdgeBazzite — kontekst projektu` - 7 edges
2. `BleedingEdgeBazzite` - 7 edges
3. `run()` - 5 edges
4. `ai-chat` - 4 edges
5. `Instalacja` - 3 edges
6. `initialize()` - 2 edges
7. `check_for_agy_message()` - 2 edges
8. `count_turns()` - 2 edges
9. `mark_processed()` - 2 edges
10. `ag2Url` - 1 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Import Cycles
- None detected.

## Communities (6 total, 1 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.25
Nodes (7): Architektura potoku (od źródła do użytkownika), BleedingEdgeBazzite — kontekst projektu, Cel projektu, Kluczowe pliki, PODSTAWOWE ZAŁOŻENIE PROJEKTU — przeczytaj to najpierw, Zasady projektu, Zewnętrzne zależności

### Community 1 - "Community 1"
Cohesion: 0.29
Nodes (6): Aktualizacje, Automatyzacja, BleedingEdgeBazzite, Co to jest, Jak działa potok, Źródła wersji

### Community 2 - "Community 2"
Cohesion: 0.60
Nodes (5): check_for_agy_message(), count_turns(), initialize(), mark_processed(), run()

### Community 3 - "Community 3"
Cohesion: 0.40
Nodes (4): ai-chat, Installation in a Live Project, Overview, Workflow

### Community 4 - "Community 4"
Cohesion: 0.67
Nodes (3): Instalacja, Opcja A — ISO (świeża instalacja), Opcja B — Rebase z istniejącego systemu Fedora Atomic

## Knowledge Gaps
- **18 isolated node(s):** `ag2Url`, `agIdeUrl`, `Overview`, `Installation in a Live Project`, `Workflow` (+13 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `BleedingEdgeBazzite` connect `Community 1` to `Community 4`?**
  _High betweenness centrality (0.071) - this node is a cross-community bridge._
- **Why does `Instalacja` connect `Community 4` to `Community 1`?**
  _High betweenness centrality (0.032) - this node is a cross-community bridge._
- **What connects `ag2Url`, `agIdeUrl`, `Overview` to the rest of the system?**
  _18 weakly-connected nodes found - possible documentation gaps or missing edges._