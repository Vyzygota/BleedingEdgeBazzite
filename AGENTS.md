# BleedingEdgeBazzite — Agent Rules

@/home/Vyzygota/agent-rules/AGENTS.md

## Project Context

Custom bootable OCI image on Bazzite base. Builds and bakes:
- Latest stable kernel (COPR @kernel-vanilla/fedora) via Fabryka
- NVIDIA kmods + LenovoLegionLinux kmods (compiled in Fabryka)
- Google Antigravity 2.0 + Antigravity IDE (Playwright-scraped URLs)
- spacenavd for 3DConnexion SpaceMouse

## Key Invariants

- **Fabryka is `github.com/Vyzygota/akmods-nvidia-custom`** — NOT the local archived `akmods-nvidia-bazzite-custom`
- **Factory output structure:** `/rpms/kernel/`, `/rpms/kmods/`, `/rpms/dummy/` — never split into nvidia/lll subdirs
- **BEB git remote:** `git@github.com:Vyzygota/BleedingEdgeBazzite.git`
- **All Latest Stable** — kernel, NVIDIA, Fedora always at newest stable

## First Action Each Session

1. Run `graphify update .` if graph is stale (check `graphify-out/GRAPH_REPORT.md` date vs `git rev-parse HEAD`)
2. Read `.agents/COMMUNICATION.md`
3. Before touching Fabryka: `gh api repos/Vyzygota/akmods-nvidia-custom/contents/Containerfile | python3 -c "import sys,json,base64; print(base64.b64decode(json.load(sys.stdin)['content']).decode())"`

## Skills Location

`.agents/skills/` (no symlink — exFAT filesystem does not support symlinks)
