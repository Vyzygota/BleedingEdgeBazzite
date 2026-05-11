# 🕷️ BleedingEdgeBazzite

![Build Status](https://github.com/Vyzygota/BleedingEdgeBazzite/actions/workflows/build.yml/badge.svg)

**BleedingEdgeBazzite** to eksperymentalny obraz systemowy oparty na **Fedora Rawhide**, zaprojektowany dla entuzjastów chcących korzystać z najnowszego uzbrojenia Linuxa bez czekania na oficjalne wydania.

## 🚀 Kluczowe cechy
*   **Kernel 7.x+**: Zawsze najnowsza stabilna wersja Vanilla prosto z `kernel.org`.
*   **NVIDIA Bleeding Edge**: Sterowniki kompilowane z "Wytrychem" (Lockpick) dla GCC 16.
*   **Bazzite Experience**: Integracja z Steam, Gamescope i narzędziami uBlue na bazie Rawhide.
*   **Antigravity Integrated**: Wbudowany agent monitorujący status modułów jądra.

## 🏗️ Architektura
Projekt działa w ścisłej symbiozie z [akmods-nvidia-custom](https://github.com/Vyzygota/akmods-nvidia-custom), który pełni rolę "Fabryki" modułów binarnych.

## 📦 Instalacja (Rebase)
Jeśli korzystasz z Fedory Atomic (Bazzite/uBlue), możesz przejść na tę wersję komendą:
```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/vyzygota/bleedingedgebazzite:latest
```

---
*Powered by Vyzygota & Antigravity Agent*
