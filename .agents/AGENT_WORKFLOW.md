# Agent Workflow — BleedingEdgeBazzite

> Session log. Newest entries at top. Tags: #keyword for memory index.

---

## 2026-06-20 18:30 — Claude Sonnet 4.6 — audit pipeline + LLL + spacenavd + self-audit

Tags: #LenovoLegionLinux #spacenavd #3DConnexion #self-audit #graphify #agent-rules #Fabryka

→ WORKFLOW.md#2026-06-20-fundament

**Done:**
- Odkryto że `akmods-nvidia-bazzite-custom` to archiwum; aktywna Fabryka to `akmods-nvidia-custom`
- Naprawiono BEB Containerfile (przywrócono `/rpms` COPY + kernel steps)
- Dodano spacenavd (3DConnexion SpaceMouse) do BEB krok 8
- Naprawiono git remote BEB (był przestawiony na zarchiwizowane repo)
- Zapisano memory: feedback-repo-verification, project-akmods-nvidia (pełna), project-bleedingedgebazzite (pełna)
- Dodano `agent-rules` jako źródło prawdy
- Wykonano audit pipeline: graphify (Pass 1, 32 węzły) → self-audit → agent-workflow → warp-watch check
- Utworzono brakujące pliki: AGENTS.md, .agents/rules/WORKSPACE.md, skills-lock.json, .claude/settings.json, specs/

**Open / next:**
- graphify: docs (README, CLAUDE.md) bez semantycznej ekstrakcji — rozważyć API key dla Pass 3
- .agentskills symlink niemożliwy (exFAT) — udokumentowane w AGENTS.md
