lang pl_PL.UTF-8
keyboard --vckeymap=pl --xlayouts=pl
timezone Europe/Warsaw --utc
rootpw --lock
bootloader --timeout=5
zerombr
clearpart --all --initlabel --disklabel=gpt
autopart --type=btrfs

ostreecontainer --url=ghcr.io/vyzygota/bleedingedgebazzite:latest --no-signature-verification

reboot
