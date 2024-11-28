import sys
from kittens.tui.handler import result_handler
from typing import List
from kitty.boss import Boss

# in main, STDIN is for the kitten process and will contain
# the contents of the screen


def main(args: List[str]) -> str:
    return sys.stdin.read()


# in handle_result, STDIN is for the kitty process itself, rather
# than the kitten process and should not be read from.


@result_handler(type_of_input='ha')
def handle_result(
        args: List[str],
        stdin_data: str,
        target_window_id: int,
        boss: Boss) -> None:
    # get the kitty window to which to send text
    w = boss.window_id_map.get(target_window_id)
    if w is not None:
        boss.call_remote_control(
            w, ('send-text', f'--match=id:{w.id}', stdin_data))

    pass
