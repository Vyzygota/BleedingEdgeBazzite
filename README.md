# BleedingEdgeBazzite

![Build Status](https://github.com/Vyzygota/BleedingEdgeBazzite/actions/workflows/build.yml/badge.svg)

A custom [Bazzite](https://bazzite.gg) image that ships the latest stable Linux kernel and bleeding-edge NVIDIA drivers — compiled fresh before they reach official repositories.

## What it is

BleedingEdgeBazzite is a bootable OCI image built on top of `ghcr.io/ublue-os/bazzite:latest`. It inherits the full Bazzite experience (KDE Plasma, Steam, Gamescope, MangoHud) and replaces the kernel and NVIDIA modules with versions built by the companion [akmods-nvidia-custom](https://github.com/Vyzygota/akmods-nvidia-custom) factory.

## How it works

```
akmods-nvidia-custom (Factory)        BleedingEdgeBazzite
──────────────────────────────        ──────────────────────────────
Cyber-Spider detects:                 bazzite:latest
  • Fedora latest stable       →        + latest stable kernel RPMs
  • NVIDIA latest stable       →        + bleeding-edge NVIDIA kmods
  • Linux kernel latest stable →        + ostree.bootable label
Compiles modules, packages RPMs
Pushes OCI → ghcr.io          ──────→  ready to rebase
```

The factory runs daily at 03:00 UTC. If any version changed since the last build, it compiles new packages and automatically triggers a BleedingEdgeBazzite rebuild. If nothing changed, no compute is wasted.

## Installation

From any Fedora Atomic system (Bazzite, uBlue, Silverblue):

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/vyzygota/bleedingedgebazzite:latest
```

Then reboot. To revert to your previous image at any time:

```bash
rpm-ostree rollback
```

## Updates

Images rebuild automatically when the factory produces new drivers or kernel. No action needed — the next `rpm-ostree upgrade` will pick up the new image.

---

*Built by Vyzygota with [Claude Code](https://claude.ai/code) (Anthropic)*
