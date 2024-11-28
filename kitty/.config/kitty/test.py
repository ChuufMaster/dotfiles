import subprocess
import re
import time

POLL_INTERVAL = 1  # Time in seconds between each poll


def get_terminal_text():
    """Fetches all text from the Kitty terminal."""
    try:
        result = subprocess.run(
            ['kitty', '@', 'get-text', '--match', 'all'],
            capture_output=True, text=True
        )
        if result.returncode == 0:
            return result.stdout
        else:
            print(f"Error fetching terminal text: {result.stderr}")
            return ""
    except FileNotFoundError:
        print("Kitty is not installed or unavailable.")
        return ""


def replace_hex_colors(text):
    """Replaces hex color codes with 'COLOR'."""
    return re.sub(r'#[0-9A-Fa-f]{6}', 'COLOR', text)


def send_text_to_terminal(text):
    """Sends modified text to the Kitty terminal."""
    try:
        # Clear terminal and print new content
        subprocess.run(['kitty', '@', 'send-text', '--stdin'],
                       input=text, text=True)
    except FileNotFoundError:
        print("Kitty is not installed or unavailable.")


def monitor_terminal():
    """Continuously monitors and modifies terminal text."""
    last_text = ""  # Track the previous state to avoid redundant updates

    while True:
        current_text = get_terminal_text()
        if current_text and current_text != last_text:
            modified_text = replace_hex_colors(current_text)
            send_text_to_terminal(modified_text)
            last_text = current_text  # Update last_text to prevent re-processing

        time.sleep(POLL_INTERVAL)


if __name__ == "__main__":
    print("Monitoring terminal for hex color codes...")
    monitor_terminal()
