# BleedingEdgeBazzite — kontekst projektu

## PODSTAWOWE ZAŁOŻENIE PROJEKTU — przeczytaj to najpierw

> **ALL LATEST STABLE** — wszystkie składowe paczki mają być zawsze w najnowszej stabilnej wersji.

Dotyczy to **każdego** elementu potoku:
- Kernel Linux → najnowszy stable z COPR `@kernel-vanilla/fedora` (vanilla, bez patchy dystrybucji)
- Sterownik NVIDIA → najnowszy stable `.run` z `download.nvidia.com`
- Fedora → najnowsza stabilna wersja jako baza
- Bazzite base image → `bazzite-deck-nvidia:unstable-{FEDORA_VERSION}`

**Jeśli proponujesz zablokowanie wersji, cofnięcie do starszej lub pominięcie aktualizacji — uzasadnij to konkretnym technicznym blokerem, nie ostrożnością.** Projekt nazywa się *BleedingEdge* z powodu.

Jedyne przyjęte ustępstwo: kernel pochodzi z COPR (vanilla Fedora packaging), nie kompilowany ze źródeł kernel.org — ze względu na czas buildu (1-2h vs 5 min).

---

## Cel projektu

Bootowalne OCI image na bazie Bazzite z **najnowszym stabilnym** kernelem,
sterownikami NVIDIA i Fedorą. Nazwa "Bleeding Edge" to cel, nie ozdobnik.

## Architektura potoku (od źródła do użytkownika)

```
kernel.org / COPR             NVIDIA           Fedora
     ↓ latest stable              ↓ latest stable    ↓ latest stable
     └──────────────────────────────────────────────┘
                         Fabryka
              (github.com/Vyzygota/akmods-nvidia-custom)
              • Cyber-Pająk wykrywa nowe wersje codziennie o 03:00 UTC
              • Buduje kernel RPMs + NVIDIA kmods + dummy RPM
              • Pcha obraz → ghcr.io/vyzygota/akmods-nvidia-custom:latest
              • Wysyła repository_dispatch → BEB z fedora_version w payload
                         ↓
                   Containerfile  ← centrum projektu
              • FROM bazzite-deck-nvidia:unstable-${FEDORA_VERSION}
              • Injectuje kernel RPMs z Fabryki
              • Injectuje NVIDIA kmods
              • Konfiguruje SELinux, nouveau blacklist, kargs
              • Ustawia beb-firstboot-diag service
                         ↓
              ghcr.io/vyzygota/bleedingedgebazzite:latest
                         ↓
              BEB-installer.iso (GitHub Releases)
```

## Kluczowe pliki

| Plik | Rola |
|---|---|
| `Containerfile` | Serce projektu — definiuje obraz BEB |
| `.github/workflows/build.yml` | Buduje obraz po push lub dispatch z Fabryki |
| `.github/workflows/iso.yml` | Buduje installer ISO (triggerowany po każdym BEB build) |
| `.github/workflows/fabryka-watchdog.yml` | Alarmuje gdy Fabryka milczy >2 dni |
| `installer/beb.ks` | Kickstart — instaluje BEB na dysk |

## Zasady projektu

- **All Latest Stable**: kernel, NVIDIA, Fedora — zawsze najnowsze stabilne wersje
- **Fabryka → BEB**: zmiany kernela/NVIDIA wchodzą tylko przez Fabrykę, nie ręcznie
- **Fedora version tracking**: Fabryka przekazuje `fedora_version` w dispatch payload; BEB używa go jako ARG
- **NEVER push directly to main** (od feature branches)
- **Przed rebootem**: zapisz stan sprintu do pamięci Claude

## Zewnętrzne zależności

| Zależność | Źródło | Śledzona przez |
|---|---|---|
| Base image | `ghcr.io/ublue-os/bazzite-deck-nvidia:unstable-{FEDORA}` | Fabryka (dispatch) |
| Kernel RPMs | COPR `@kernel-vanilla/fedora` `stable-fedora-releases` | Fabryka (Cyber-Pająk) |
| NVIDIA driver | `download.nvidia.com/XFree86/Linux-x86_64/latest.txt` | Fabryka (Cyber-Pająk) |
| akmods-nvidia-custom | `ghcr.io/vyzygota/akmods-nvidia-custom:latest` | Fabryka watchdog |
