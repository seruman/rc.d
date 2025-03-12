from functools import partial
from qutebrowser.api import cmdutils, message, hook, apitypes
from qutebrowser.keyinput import modeman
from qutebrowser.utils.usertypes import KeyMode
from qutebrowser.misc import objects
from qutebrowser.utils import objreg


BORDER_STYLES = {
    "normal": "none",
    "insert": "rgba(255, 100, 100, 0.7) 10px solid",
    "command": "rgba(100, 255, 100, 0.7) 10px solid",
    "passthrough": "rgba(100, 100, 255, 0.7) 10px solid",
    "hint": "rgba(255, 255, 100, 0.7) 10px solid",
    "caret": "rgba(255, 100, 255, 0.7) 10px solid",
    "register": "rgba(100, 255, 255, 0.7) 10px solid",
}


def update_border(win_id, mode_name):
    border_style = BORDER_STYLES.get(mode_name, "none")

    js_code = f"""
    (function() {{
        try {{
            console.log('Mode border script starting... Mode: {mode_name}');

            var existingStyle = document.getElementById('qutebrowser-mode-border');
            if (existingStyle) {{
                console.log('Removing existing mode border style');
                existingStyle.parentNode.removeChild(existingStyle);
            }}

            var style = document.createElement('style');
            style.id = 'qutebrowser-mode-border';

            if ("{border_style}" === "none") {{
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
                        border: {border_style} !important;
                        box-sizing: border-box !important;
                    }}
                `;
            }}

            document.head.appendChild(style);

            console.log('Mode border style successfully applied: {mode_name} - {border_style}');
            return true;
        }} catch (e) {{
            console.error('Error in mode border script:', e.message);
            return false;
        }}
    }})();
    """

    tabbed_browser = objreg.get("tabbed-browser", scope="window", window=win_id)
    current_tab = tabbed_browser.widget.currentWidget()
    if current_tab:
        current_tab.run_js_async(js_code)


@cmdutils.register()
def setup_mode_hooks():
    def on_enter_insert_mode(win_id, mode: KeyMode):
        # message.info(f"Entered {mode.name}")
        update_border(win_id, mode.name)

    def on_leave_insert_mode(win_id, mode: KeyMode):
        # message.info(f"Left {mode}")
        update_border(win_id, "normal")

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
    setup_mode_hooks()
