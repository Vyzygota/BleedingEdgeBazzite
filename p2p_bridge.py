import os
import time
import subprocess
import sys

CHAT_FILE = ".agents/chat/conversation.log"
MAX_TURNS = 10

def initialize():
    os.makedirs(os.path.dirname(CHAT_FILE), exist_ok=True)
    if not os.path.exists(CHAT_FILE):
        with open(CHAT_FILE, "w", encoding="utf-8") as f:
            f.write("--- AI_CHAT INITIALIZED ---\n")
    print(f"P2P Bridge started. Watching {CHAT_FILE}")

def check_for_agy_message():
    with open(CHAT_FILE, "r", encoding="utf-8") as f:
        lines = f.readlines()
    
    if not lines:
        return None
        
    last_line = lines[-1].strip()
    if "[AGY]:" in last_line and "[PROCESSED]" not in last_line:
        return last_line
    return None

def count_turns():
    with open(CHAT_FILE, "r", encoding="utf-8") as f:
        text = f.read()
    return text.count("[TURN ")

def mark_processed():
    with open(CHAT_FILE, "a", encoding="utf-8") as f:
        f.write(" [PROCESSED]\n")

def run():
    initialize()
    last_mod_time = os.path.getmtime(CHAT_FILE) if os.path.exists(CHAT_FILE) else 0

    while True:
        try:
            current_mod_time = os.path.getmtime(CHAT_FILE)
            if current_mod_time > last_mod_time:
                last_mod_time = current_mod_time
                
                turns = count_turns()
                if turns >= MAX_TURNS:
                    print(f"MAX_TURNS ({MAX_TURNS}) reached. Halting P2P Chat.")
                    with open(CHAT_FILE, "a", encoding="utf-8") as f:
                        f.write("\n[SYSTEM]: MAX_TURNS reached. Escalate to human.\n")
                    break
                
                msg = check_for_agy_message()
                if msg:
                    if "[ESCALATE]" in msg:
                        print("Safeword [ESCALATE] detected from AGY. Halting.")
                        break
                        
                    print(f"Detected AGY message: {msg}")
                    mark_processed()
                    
                    next_turn = turns + 1
                    
                    print("Invoking Claude Code...")
                    prompt = f"Oto wiadomość od agenta AGY: '{msg}'. Odpowiedz krótko. Użyj formatu [TURN {next_turn}] [ACL]: <odpowiedź>. Użyj [ESCALATE] jeśli nie możecie dojść do zgody."
                    
                    result = subprocess.run(["claude", "-p", prompt], capture_output=True, text=True)
                    acl_response = result.stdout.strip()
                    
                    with open(CHAT_FILE, "a", encoding="utf-8") as f:
                        f.write(f"[TURN {next_turn}] [ACL]: {acl_response}\n")
                    
                    if "[ESCALATE]" in acl_response:
                        print("Safeword [ESCALATE] detected from ACL. Halting.")
                        break
                        
                    last_mod_time = os.path.getmtime(CHAT_FILE)

            time.sleep(1)
        except KeyboardInterrupt:
            break
        except Exception as e:
            print(f"Error: {e}")
            time.sleep(2)

if __name__ == "__main__":
    run()
