# BleedingEdgeBazzite

![Build Status](https://github.com/Vyzygota/BleedingEdgeBazzite/actions/workflows/build.yml/badge.svg)

Bootowalne OCI image na bazie [Bazzite](https://bazzite.gg) z **najnowszym stabilnym** kernelem Linuxa i sterownikami NVIDIA — skompilowanymi przez dedykowaną fabrykę zanim trafią do oficjalnych repozytoriów.

## Co to jest

BleedingEdgeBazzite (BEB) dziedziczy pełne doświadczenie Bazzite (KDE Plasma, Steam, Gamescope, MangoHud) i zastępuje kernel oraz moduły NVIDIA wersjami zbudowanymi przez fabrykę [akmods-nvidia-custom](https://github.com/Vyzygota/akmods-nvidia-custom). Obraz jest dynamicznie rebazowany na najnowszą stabilną Fedorę.

Dodatkowo BEB dołącza w obrazie:
- **Google Antigravity 2.0** — platforma agentów AI, dostępna jako `/usr/bin/antigravity`
- **Google Antigravity IDE** — środowisko programistyczne z AI, dostępne jako `/usr/bin/antigravity-ide`
- **LenovoLegionLinux** — sterownik dla laptopów Lenovo Legion (LOQ 15ARP9i i inne): kontrola wentylatorów, tryby zasilania, battery conservation
- **spacenavd** — demon HID dla myszy 3DConnexion SpaceMouse

## Jak działa potok

```
Źródła zewnętrzne                 Fabryka (akmods-nvidia-custom)
─────────────────                 ──────────────────────────────
Fedora releases page   ──────→    Cyber-Pająk wykrywa wersje
NVIDIA latest.txt      ──────→    codziennie o 03:00 UTC
COPR kernel-vanilla    ──────→    jeśli zmiany → buduje kernel RPMs
  stable-fedora-releases            + NVIDIA kmods (.ko)
                                    + pushuje do GHCR
                                    + wysyła dispatch do BEB
                                          │
                                          ▼
                              BleedingEdgeBazzite (ten repo)
                              ─────────────────────────────
                              FROM bazzite-deck-nvidia:unstable-{FEDORA}
                                + kernel RPMs z Fabryki
                                + NVIDIA kmods z Fabryki
                                + blacklist nouveau (4 poziomy)
                                + SELinux permissive dla gamescope
                                + beb-firstboot-diag service
                                + Return.desktop fix
                                + Antigravity 2.0 (latest stable)
                                + Antigravity IDE (latest stable)
                                + LenovoLegionLinux kmod (z Fabryki)
                                + spacenavd (3DConnexion SpaceMouse)
                              → ghcr.io/vyzygota/bleedingedgebazzite:latest
                                          │
                                          ▼
                                    BEB-installer.iso
                                   (GitHub Releases)
```

## Źródła wersji

| Składnik | Źródło | Metoda wykrywania |
|---|---|---|
| Fedora | `dl.fedoraproject.org/pub/fedora/linux/releases/` | Najwyższy numer katalogu |
| Kernel | COPR `@kernel-vanilla/fedora` → `stable-fedora-releases` | API COPR dla aktywnego chroota `fedora-{VER}-x86_64` |
| NVIDIA driver | `download.nvidia.com/XFree86/Linux-x86_64/latest.txt` | Pierwsze pole pierwszej linii |
| Base image | `ghcr.io/ublue-os/bazzite-deck-nvidia:unstable-{FEDORA}` | Wersja Fedory z dispatcha Fabryki |
| Antigravity 2.0 | `antigravity.google/releases` | Playwright (`scripts/get-antigravity-urls.mjs`) — pierwszy link Linux x64 |
| Antigravity IDE | `antigravity.google/download` | Playwright — link Linux x64 dla `Antigravity IDE.tar.gz` |
| LenovoLegionLinux | źródła z Fabryki | akmod kompilowany przez `akmods-nvidia-custom`, `.ko` wstrzykiwane do kernela |
| spacenavd | Fedora repos | `dnf install spacenavd` w Containerfile BEB |

> **Kernel:** `kernel.org` podaje `latest_stable`, ale COPR `stable-fedora-releases` buduje z ~1–3 tygodniowym opóźnieniem. Pająk pyta COPR co faktycznie jest dostępne dla aktywnej Fedory — to gwarantuje że instalowany kernel istnieje w repozytorium.

## Automatyzacja

Fabryka sprawdza wersje raz dziennie (03:00 UTC) i buduje tylko gdy coś się zmieniło (`versions.lock`). Każdy udany build Fabryki wyzwala BEB, każdy udany BEB wyzwala ISO — bez ręcznej interwencji.

Watchdog (`fabryka-watchdog.yml`) alarmuje na Discord jeśli Fabryka milczy ponad 2 dni.

## Instalacja

### Opcja A — ISO (świeża instalacja)

Pobierz `BEB-installer.iso` z [Releases](https://github.com/Vyzygota/BleedingEdgeBazzite/releases/tag/installer-latest), zapisz na USB i uruchom. Anaconda pobierze obraz z GHCR i zainstaluje na dysk. Wymagane połączenie z internetem.

```bash
# Zapis na USB (zastąp /dev/sdX właściwym dyskiem)
dd if=BEB-installer.iso of=/dev/sdX bs=4M status=progress
```

### Opcja B — Rebase z istniejącego systemu Fedora Atomic

Z dowolnego systemu Fedora Atomic (Bazzite, uBlue, Silverblue):

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/vyzygota/bleedingedgebazzite:latest
```

Po reboocie. Powrót do poprzedniego obrazu w dowolnym momencie:

```bash
rpm-ostree rollback
```

> Jeśli pojawia się `error: Old and new refs are equal` — jesteś już na BEB. Użyj `rpm-ostree upgrade` żeby pobrać najnowszy build.

## Aktualizacje

Obrazy przebudowują się automatycznie gdy Fabryka wykryje nowy kernel lub sterownik. Żeby pobrać najnowszy build:

```bash
rpm-ostree upgrade
```

## Uwagi dla deweloperów

### Ścieżki niepisalne podczas `docker build` (ostree/Bazzite)

W obrazach ostree następujące katalogi to **symlinki** do `/var/` i nie można do nich pisać podczas budowania obrazu:

| Ścieżka | Cel symlinka | Objaw błędu |
|---|---|---|
| `/opt` | `/var/opt` | `tar: /opt: Cannot open: No such file or directory` |
| `/usr/local` | `/var/usrlocal` | `mkdir: cannot create directory '/usr/local': File exists` |
| `/home` | `/var/home` | analogicznie |

**Zasada:** pliki aplikacji → `/usr/lib/<nazwa>/`, symlinki/binarki → `/usr/bin/`.

### Preflight przed każdym commitem do Containerfile

```bash
# 1. Lint (wtyczka vscode-hadolint lub podman)
podman run --rm -i ghcr.io/hadolint/hadolint < Containerfile

# 2. Lokalny build (bez push)
podman build \
  --build-arg FEDORA_VERSION=44 \
  --build-arg ANTIGRAVITY_URL=<url> \
  --build-arg ANTIGRAVITY_IDE_URL=<url> \
  --file Containerfile --tag beb:test .

# 3. Dopiero wtedy commit
```

> **Uwaga:** hadolint zgłasza false positive na liniach z heredokiem (`<< 'SCRIPT'`) — to znane ograniczenie narzędzia, nie prawdziwy błąd.

### Fabryka (`akmods-nvidia-custom`)

**Dwa repo — nie mylić:**
- `akmods-nvidia-custom` — **aktywna Fabryka** (GitHub Actions, ghcr.io)
- `akmods-nvidia-bazzite-custom` — **zarchiwizowane** (lokalna kopia, nie edytować)

Zanim cokolwiek zmienisz w Fabryce, zweryfikuj aktywne repo:
```bash
gh api repos/Vyzygota/akmods-nvidia-custom/contents/Containerfile
gh repo view Vyzygota/akmods-nvidia-custom --json isArchived
```

---

*Zbudowane przez Vyzygota z pomocą [Claude Code](https://claude.ai/code) (Anthropic)*
