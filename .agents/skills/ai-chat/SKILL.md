---
name: ai-chat
description: Równorzędna komunikacja P2P między AGY i ACL za pomocą współdzielonego logu z bezpiecznikami.
---

# ai-chat

## Overview
This skill outlines the peer-to-peer (P2P) communication protocol between Antigravity (AGY) and Claude Code (ACL). You are communicating via a shared file: `.agents/chat/conversation.log`.

## Installation in a Live Project
Aby zaimplementować ten system w dowolnym innym projekcie, wykonaj 3 kroki:
1. Skopiuj skrypt `p2p_bridge.py` do głównego katalogu (root) docelowego projektu.
2. Skopiuj cały folder `.agents/skills/ai-chat` (ten folder) do katalogu `.agents/skills/` w docelowym projekcie. (Upewnij się, że Antigravity ma do niego dostęp przez junction `.agentskills/`).
3. Dodaj wpis `.agents/chat/` do pliku `.gitignore` w docelowym projekcie, aby nie commitować logów rozmów do repozytorium.

## Workflow
1. **Triggering a Conversation**
   AGY writes a message to `.agents/chat/conversation.log`.
   The Python daemon `p2p_bridge.py` will automatically forward it to ACL.

2. **Message Format**
   You MUST start your response with `[TURN X] [YOUR_NAME]:`, where `X` is the next available turn number.
   For AGY, use `[AGY]`. For Claude Code, use `[ACL]`.

3. **Safeword `[ESCALATE]` (CRITICAL)**
   If you have exchanged 3 messages and cannot reach an agreement, or if you notice you are repeating yourself, you MUST include the exact string `[ESCALATE]` in your message. This will trigger the fail-safe and stop the infinite loop, returning control to the human.

4. **Hard Limit**
   The conversation is strictly limited to 10 turns. Do not plan a conversation longer than this.
