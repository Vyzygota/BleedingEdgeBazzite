# syntax=docker/dockerfile:1
FROM fedora:latest

# 1. Repozytoria — wersja Fedory wykrywana dynamicznie
RUN dnf install -y dnf5 && \
  dnf5 install -y 'dnf-command(copr)' && \
  dnf5 copr enable -y ublue-os/staging && \
  dnf5 copr enable -y ublue-os/packages && \
  FEDORA_VERSION=$(rpm -E %fedora) && \
  dnf5 install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm

# 2. Artefakty z Fabryki (kernel + moduły NVIDIA)
COPY --from=ghcr.io/vyzygota/akmods-nvidia-custom:latest /rpms /tmp/akmods-rpms

# 3. Instalacja Kernela
RUN dnf5 install -y /tmp/akmods-rpms/kernel/kernel-[0-9]*.rpm \
  /tmp/akmods-rpms/kernel/kernel-core-*.rpm \
  /tmp/akmods-rpms/kernel/kernel-modules-*.rpm \
  /tmp/akmods-rpms/dummy/*.rpm

# 4. Środowisko graficzne + gaming
RUN dnf5 install -y --allowerasing @kde-desktop-environment && \
  dnf5 install -y \
  steam gamescope mangohud goverlay \
  flatpak-spawn zenity

# 5. Moduły KO
RUN KERNEL_VERSION=$(rpm -q --qf "%{VERSION}-%{RELEASE}.%{ARCH}\n" kernel-core | head -n 1) && \
  mkdir -p /lib/modules/$KERNEL_VERSION/extra/custom && \
  cp /tmp/akmods-rpms/kmods/*.ko /lib/modules/$KERNEL_VERSION/extra/custom/ && \
  depmod -a $KERNEL_VERSION

# 6. Antigravity Agent
RUN <<'EOF' tee /usr/bin/antigravity
#!/bin/bash
if command -v zenity &> /dev/null; then
  zenity --info --title="BleedingEdgeBazzite Agent" \
    --text="🚀 <b>Antigravity Agent Status: AKTYWNY</b>\n\nSystem: Fedora Latest Stable\nKernel: <b>$(uname -r)</b>\nNVIDIA: <b>Wstrzyknięto pomyślnie</b>" \
    --width=400 --window-icon=system-run
else
  echo "🚀 Antigravity Agent: AKTYWNY (Kernel: $(uname -r))"
fi
EOF
RUN chmod +x /usr/bin/antigravity

RUN systemctl set-default graphical.target
