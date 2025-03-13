from functools import partial
from typing import cast
from qutebrowser.api import cmdutils, message, hook, apitypes
from qutebrowser.keyinput import modeman
from qutebrowser.utils.usertypes import KeyMode
from qutebrowser.misc import objects
from qutebrowser.utils import objreg
from qutebrowser.config import config


def ngetattr(obj, attr_path, default=None):
    try:
        attrs = attr_path.split(".")
        value = obj

        for attr in attrs:
            value = getattr(value, attr)

        return value
    except (AttributeError, TypeError):
        return default


def apply_alpha(hexcolor: str | None, alpha: float = 1.0):
    if hexcolor is None:
        return None
    return f"{hexcolor}{int(alpha * 255):02x}"


def update_border(win_id, mode_name, border_style: str | None):
    bs = border_style or "none"

    js_code = f"""
    (function() {{
        try {{
            var existingStyle = document.getElementById('qutebrowser-mode-border');
            if (existingStyle) {{
                existingStyle.parentNode.removeChild(existingStyle);
            }}

            var style = document.createElement('style');
            style.id = 'qutebrowser-mode-border';

            if ("{bs}" === "none") {{
                style.innerHTML = "";
            }} else {{
                style.innerHTML = `
                    body::before {{
                        content: "";
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        z-index: 2147483647; /* Highest possible z-index */
                        pointer-events: none; /* Allow clicks to pass through */
                        border: {bs} !important;
                        box-sizing: border-box !important;
                    }}
                `;
            }}

            document.head.appendChild(style);

            return true;
        }} catch (e) {{
            return false;
        }}
    }})();
    """

    tabbed_browser = objreg.get("tabbed-browser", scope="window", window=win_id)
    current_tab = tabbed_browser.widget.currentWidget()
    if current_tab:
        current_tab.run_js_async(js_code)


@cmdutils.register()
def setup_mode_hooks(border_styles: dict[str, str]):
    def on_enter_insert_mode(win_id, mode: KeyMode):
        update_border(win_id, mode.name, border_styles.get(mode.name))

    def on_leave_insert_mode(win_id, mode: KeyMode):
        update_border(win_id, "normal", border_styles.get("normal"))

    def set_hooks_for_window(win_id):
        mode_manager = modeman.instance(win_id)
        mode_manager.entered.connect(partial(on_enter_insert_mode, win_id))
        mode_manager.left.connect(partial(on_leave_insert_mode, win_id))

    def on_new_window(window):
        set_hooks_for_window(window.win_id)

    objects.qapp.new_window.connect(on_new_window)

    for win_id in objreg.window_registry:
        set_hooks_for_window(win_id)

    message.info("Mode hooks set up successfully")


@hook.init()
def init(context: apitypes.InitContext) -> None:
    """Initialize mode hooks when this module is loaded."""
    message.info("Mode hooks init hook called")

    cfg = config.val
    insert_color: str = cast(str | None, ngetattr(cfg, "colors.statusbar.insert.fg")) or "none"
    command_color: str = cast(str | None, ngetattr(cfg, "colors.statusbar.command.fg")) or "none"
    passthrough_color: str = cast(str | None, ngetattr(cfg, "colors.statusbar.passthrough.fg")) or "none"
    caret_color: str = cast(str | None, ngetattr(cfg, "colors.statusbar.caret.fg")) or "none"
    hint_color: str = cast(str | None, ngetattr(cfg, "colors.keyhint.fg")) or "none"

    def border(hex: str):
        if hex == "none":
            return f"{hex}"

        a = apply_alpha(hex, 0.5)
        return f"{a} 10px solid"

    BORDER_STYLES = {
        "normal": "none",
        "insert": border(insert_color),
        "command": border(command_color),
        "passthrough": border(passthrough_color),
        "caret": border(caret_color),
        "hint": border(hint_color),
    }
    setup_mode_hooks(BORDER_STYLES)
