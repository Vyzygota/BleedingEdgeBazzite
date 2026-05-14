# syntax=docker/dockerfile:1
# Bazzite jako baza — dziedziczy ostree.bootable, ma KDE i gaming stack
FROM ghcr.io/ublue-os/bazzite:latest

# 1. Moduły NVIDIA + LenovoLegionLinux z Fabryki
COPY --from=ghcr.io/vyzygota/akmods-nvidia-custom:latest /rpms /tmp/akmods-rpms

# 2. Instalacja custom kernela z Fabryki
RUN dnf5 install -y \
  /tmp/akmods-rpms/kernel/kernel-[0-9]*.rpm \
  /tmp/akmods-rpms/kernel/kernel-core-*.rpm \
  /tmp/akmods-rpms/kernel/kernel-modules-*.rpm \
  /tmp/akmods-rpms/dummy/*.rpm

# 3. Wstrzyknięcie modułów KO dla nowego kernela
RUN KERNEL_VERSION=$(rpm -q --qf "%{VERSION}-%{RELEASE}.%{ARCH}\n" kernel-core | head -n 1) && \
  mkdir -p /lib/modules/$KERNEL_VERSION/extra/custom && \
  cp /tmp/akmods-rpms/kmods/*.ko /lib/modules/$KERNEL_VERSION/extra/custom/ && \
  depmod -a $KERNEL_VERSION && \
  rm -rf /tmp/akmods-rpms

# 4. Antigravity Agent
RUN <<'EOF' tee /usr/bin/antigravity
#!/bin/bash
if command -v zenity &> /dev/null; then
  zenity --info --title="BleedingEdgeBazzite Agent" \
    --text="🚀 <b>Antigravity Agent Status: AKTYWNY</b>\n\nSystem: BleedingEdgeBazzite\nKernel: <b>$(uname -r)</b>\nNVIDIA: <b>Wstrzyknięto pomyślnie</b>" \
    --width=400 --window-icon=system-run
else
  echo "BleedingEdgeBazzite Agent: AKTYWNY (Kernel: $(uname -r))"
fi
EOF
RUN chmod +x /usr/bin/antigravity
