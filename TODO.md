# TODO

## Zgłoszone zapotrzebowanie (Agentic OS / Hermes)
- [ ] Dodać pakiety `portaudio-devel` i `python3-devel` (oraz ewentualnie GCC, jeśli brakuje do kompilacji paczek pip) do bazowego obrazu `Containerfile`. Wynika to z faktu, że skrypty Voice Chat (oparte na `pyaudio`) nie mogą skompilować zależności na domyślnym systemie immutable. Zgłoszone przez Agenta (Antigravity).
