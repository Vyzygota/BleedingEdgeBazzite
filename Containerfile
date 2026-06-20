# syntax=docker/dockerfile:1
ARG FEDORA_VERSION=44
FROM ghcr.io/ublue-os/bazzite-deck-nvidia:unstable-${FEDORA_VERSION}

ARG ANTIGRAVITY_URL
ARG ANTIGRAVITY_IDE_URL

LABEL org.opencontainers.image.title="BleedingEdgeBazzite" \
      ostree.bootable="true"

# 1. Blokada nouveau — cztery poziomy ochrony przed konfliktem z NVIDIA
# Poziom 0: parametry jądra (bootloader) — najwcześniejszy możliwy punkt
RUN mkdir -p /usr/lib/bootc/kargs.d && \
    printf '[kargs]\nkargs = ["rd.driver.blacklist=nouveau", "modprobe.blacklist=nouveau", "nvidia-drm.modeset=1"]\n' \
      > /usr/lib/bootc/kargs.d/nvidia.toml
# Poziom 1: initramfs (dracut) — przed startem systemd
RUN echo 'omit_drivers+=" nouveau "' \
      > /etc/dracut.conf.d/blacklist-nouveau.conf
# Poziom 2+3: userspace modprobe — blacklist + twardy zakaz ładowania
RUN echo -e "blacklist nouveau\ninstall nouveau /bin/false\noptions nouveau modeset=0" \
      > /etc/modprobe.d/blacklist-nouveau.conf && \
    echo -e "options nvidia-drm modeset=1\noptions nvidia NVreg_PreserveVideoMemoryAllocations=1" \
      > /etc/modprobe.d/nvidia.conf

# 2. Moduły NVIDIA + LenovoLegionLinux z Fabryki
COPY --from=ghcr.io/vyzygota/akmods-nvidia-custom:latest /rpms /tmp/akmods-rpms

# 3. Instalacja custom kernela z Fabryki
# rpm zamiast dnf5 — omija exclude filtering Bazzite na pakiety kernel
# Najpierw usuwamy stary kernel (rpm-ostree pozwala tylko na jeden w /usr/lib/modules)
RUN rpm -qa | grep -E '^kernel-(core|modules|modules-core|modules-extra)-' | xargs -r rpm -e --nodeps || true

RUN rpm -ivh --nodeps --force \
  /tmp/akmods-rpms/kernel/kernel-*.x86_64.rpm \
  /tmp/akmods-rpms/kernel/kernel-core-*.rpm \
  /tmp/akmods-rpms/kernel/kernel-modules-*.rpm \
  /tmp/akmods-rpms/dummy/*.rpm

# 4. Wstrzyknięcie modułów KO dla nowego kernela (NVIDIA + LenovoLegionLinux z Fabryki)
RUN KERNEL_VERSION=$(rpm -q --qf "%{VERSION}-%{RELEASE}.%{ARCH}\n" kernel-core | head -n 1) && \
  mkdir -p /lib/modules/$KERNEL_VERSION/extra/custom && \
  cp /tmp/akmods-rpms/kmods/*.ko /lib/modules/$KERNEL_VERSION/extra/custom/ && \
  depmod -a $KERNEL_VERSION && \
  rm -rf /tmp/akmods-rpms

# 5. SELinux — tryb permissive dla gamescope (F44 brakuje polityki execmem dla gamescope)
RUN semanage permissive -a gamescope_t 2>/dev/null || \
    sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

# 6. First Boot Diagnostics
RUN cat > /usr/bin/beb-firstboot-diag << 'SCRIPT'
#!/bin/bash
LOG=/var/log/beb-firstboot.log
{
  echo "=== BleedingEdgeBazzite First Boot Diagnostics ==="
  echo "Data: $(date)"
  echo ""
  echo "--- Kernel ---"
  uname -r
  echo ""
  echo "--- Cmdline ---"
  cat /proc/cmdline
  echo ""
  echo "--- Moduły nvidia/nouveau ---"
  lsmod | grep -E 'nvidia|nouveau' || echo "(brak)"
  echo ""
  echo "--- dmesg: nvidia/nouveau/drm ---"
  dmesg | grep -iE 'nvidia|nouveau|drm' || echo "(brak)"
  echo ""
  echo "--- Usługi które nie wystartowały ---"
  systemctl --failed --no-legend || echo "(brak)"
  echo ""
  echo "--- rpm-ostree status ---"
  rpm-ostree status 2>&1
} 2>&1 | tee $LOG
SCRIPT
RUN chmod +x /usr/bin/beb-firstboot-diag

RUN printf '[Unit]\nDescription=BleedingEdgeBazzite First Boot Diagnostics\nConditionPathExists=!/var/log/beb-firstboot.log\nAfter=multi-user.target\n\n[Service]\nType=oneshot\nExecStart=/usr/bin/beb-firstboot-diag\nRemainAfterExit=yes\n\n[Install]\nWantedBy=multi-user.target\n' \
  > /etc/systemd/system/beb-firstboot.service
RUN systemctl enable beb-firstboot.service

# 7. Antigravity 2.0 + Antigravity IDE
RUN curl -fsSL "${ANTIGRAVITY_URL}" \
    | tar -xz -C /opt/ && \
    mv /opt/Antigravity-x64 /opt/antigravity && \
    chmod 4755 /opt/antigravity/chrome-sandbox && \
    ln -sf /opt/antigravity/antigravity /usr/local/bin/antigravity

RUN curl -fsSL "${ANTIGRAVITY_IDE_URL}" \
    | tar -xz -C /opt/ && \
    mv "/opt/Antigravity IDE" /opt/antigravity-ide && \
    chmod 4755 /opt/antigravity-ide/chrome-sandbox && \
    ln -sf /opt/antigravity-ide/antigravity-ide /usr/local/bin/antigravity-ide

# 8. 3DConnexion SpaceMouse — spacenavd (demon HID dla myszy 3D)
RUN dnf install -y spacenavd && \
    systemctl enable spacenavd

# 9. Return.desktop — bit wykonywalny (brak w upstream skelecie F44)
RUN chmod +x /etc/skel/Desktop/Return.desktop

RUN printf '[Unit]\nDescription=Fix Return.desktop executable bit\nConditionPathExists=!/var/lib/beb-return-desktop-fixed\nAfter=local-fs.target\n\n[Service]\nType=oneshot\nExecStart=/bin/bash -c "find /home -maxdepth 2 -name Return.desktop -exec chmod +x {} \\; && touch /var/lib/beb-return-desktop-fixed"\nRemainAfterExit=yes\n\n[Install]\nWantedBy=multi-user.target\n' \
  > /etc/systemd/system/beb-fix-return-desktop.service
RUN systemctl enable beb-fix-return-desktop.service

