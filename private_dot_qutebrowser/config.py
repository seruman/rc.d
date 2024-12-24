from qutebrowser.config.config import ConfigContainer
from qutebrowser.config.configfiles import ConfigAPI

import catppuccin

# pyright: reportUndefinedVariable=false
config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103

# Load autoconfig and theme
config.load_autoconfig()
catppuccin.setup(c, "seruzen", True)

# Basic settings
c.fonts.default_size = "15pt"
# c.fonts.statusbar = "bold default_size default_family"
# c.fonts.tabs.selected = "bold default_size default_family"
# c.fonts.tabs.unselected = "bold default_size default_family"
# c.fonts.completion.category = "bold default_size default_family"
# c.fonts.completion.entry = "bold default_size default_family"
c.window.hide_decoration = False
c.colors.webpage.darkmode.enabled = False
c.editor.command = ["/usr/local/bin/zed", "--wait", "{file}:{line}:{column0}"]
c.url.start_pages = ["about:blank"]

# All keybindings organized by mode
c.bindings.commands = {
    "insert": {
        # Cursor movement
        "<Ctrl-f>": "fake-key <Right>",
        "<Ctrl-b>": "fake-key <Left>",
        "<Ctrl-a>": "fake-key <Home>",
        "<Ctrl-e>": "fake-key <End>",
        "<Ctrl-n>": "fake-key <Down>",
        "<Ctrl-p>": "fake-key <Up>",
        "<Alt-f>": "fake-key <Ctrl-Right>",
        "<Alt-b>": "fake-key <Ctrl-Left>",
        # Page movement
        "<Alt-v>": "fake-key <PgUp>",
        "<Ctrl-v>": "fake-key <PgDown>",
        # Text editing
        "<Ctrl-w>": "fake-key <Ctrl-backspace>",
        "<Ctrl-d>": "fake-key <Delete>",
        "<Alt-d>": "fake-key <Ctrl-Delete>",
        "<Alt-Backspace>": "fake-key <Ctrl-Backspace>",
        "<Ctrl-y>": "insert-text {primary}",
    },
    "normal": {
        # Navigation
        "\\ff": "cmd-set-text -s :tab-select",
        "<Ctrl-o>": "back",
        "<Ctrl-i>": "forward",
        # Tab position toggle
        "\\tt": "config-cycle tabs.position left top",
        # Overlay killer
        ",ko": "jseval (function () { "
        + '  var i, elements = document.querySelectorAll("body *");'
        + "  for (i = 0; i < elements.length; i++) {"
        + "    var pos = getComputedStyle(elements[i]).position;"
        + '    if (pos === "fixed" || pos == "sticky") {'
        + "      elements[i].parentNode.removeChild(elements[i]);"
        + "    }"
        + "  }})();",
        # Clipboard access
        ",ya": " ;; ".join(
            [
                "set -u {domain} content.javascript.clipboard access",
                "message-warning 'Clipboard enabled for 10 seconds'",
                "cmd-later 10s set content.javascript.clipboard none",
            ]
        ),
    },
    "command": {
        "<Ctrl+e>": "edit-command",
    },
}

# Domain-specific clipboard settings
for pattern in [
    r"*://github.com",
    r"*://gitlab.com",
    r"*://chatgpt.com",
    r"*://youtube.com",
    r"*://reddit.com",
]:
    with config.pattern(pattern) as p:
        p.content.javascript.clipboard = "access-paste"

c.url.searchengines = {
    "DEFAULT": "https://kagi.com/search?q={}",
    "@gh": "https://github.com/search?q={}",
    "@ghr": "https://github.com/{}",
}
