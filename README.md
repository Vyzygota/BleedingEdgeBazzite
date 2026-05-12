# 🕷️ BleedingEdgeBazzite

![Build Status](https://github.com/Vyzygota/BleedingEdgeBazzite/actions/workflows/build.yml/badge.svg)

**BleedingEdgeBazzite** to obraz systemowy oparty na **najnowszej stabilnej Fedorze**, zaprojektowany dla entuzjastów chcących korzystać z absolutnie najświeższego kernela i sterowników NVIDIA — bez czekania na oficjalne wydania dystrybucji.

## 🚀 Kluczowe cechy

*   **Kernel Latest Stable**: Zawsze najnowszy stable kernel prosto z `kernel.org` — wersja wykrywana automatycznie przy każdym buildzie.
*   **NVIDIA Bleeding Edge**: Najnowszy stabilny sterownik NVIDIA kompilowany bezpośrednio ze źródeł z `download.nvidia.com`.
*   **Fedora Latest Stable**: Baza zawsze aktualizowana do najnowszego stabilnego wydania Fedory — automatycznie przy każdym nowym releases.
*   **Bazzite Experience**: Integracja z Steam, Gamescope i narzędziami uBlue — środowisko graficzne w stylu SteamOS.
*   **Antigravity Integrated**: Wbudowany agent monitorujący status modułów jądra.

## 🏗️ Architektura

Projekt działa w ścisłej symbiozie z [akmods-nvidia-custom](https://github.com/Vyzygota/akmods-nvidia-custom), który pełni rolę **"Fabryki"** — kompiluje moduły NVIDIA i vanilla kernel, pakuje je jako RPM i udostępnia jako obraz OCI.

```
akmods-nvidia-custom              BleedingEdgeBazzite
─────────────────────             ──────────────────────────────
Cyber-Pająk wykrywa:              fedora:latest
 • Fedora latest stable    →      + KDE Plasma (SteamOS-like)
 • NVIDIA latest stable    →      + Steam, Gamescope, MangoHud
 • Kernel latest stable    →      + kernel RPMs z Fabryki
Kompiluje moduły NVIDIA           + moduły NVIDIA z Fabryki
Pakuje do OCI → ghcr.io   ──────→ gotowy obraz do rebase
```

## 📦 Instalacja (Rebase)

Jeśli korzystasz z Fedory Atomic (Bazzite/uBlue), możesz przejść na tę wersję komendą:

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/vyzygota/bleedingedgebazzite:latest
```

## 🔄 Automatyczne aktualizacje

Build uruchamiany jest automatycznie przy każdym pushu oraz codziennie o 6:00 UTC, aby wyłapać nowe wersje kernela i sterowników NVIDIA. Dependabot pilnuje aktualności akcji CI/CD.

---
*Powered by Vyzygota & Antigravity Agent*
