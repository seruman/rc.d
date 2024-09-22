from qutebrowser.config.config import ConfigContainer
from qutebrowser.config.configfiles import ConfigAPI

import catppuccin

# pyright: reportUndefinedVariable=false
config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103


config.load_autoconfig()

catppuccin.setup(c, "latte", True)

config.set("fonts.default_size", "14pt")
config.set("window.hide_decoration", False)
config.set("colors.webpage.darkmode.enabled", False)
config.set("editor.command", ["neovide", "{file}", "--", "-c", "normal {line}G{column0}l"])


c.bindings.commands = {
    "insert": {
        "<Ctrl-f>": "fake-key <Right>",
        "<Ctrl-b>": "fake-key <Left>",
        "<Ctrl-a>": "fake-key <Home>",
        "<Ctrl-e>": "fake-key <End>",
        "<Ctrl-n>": "fake-key <Down>",
        "<Ctrl-p>": "fake-key <Up>",
        "<Ctrl-w>": "fake-key <Ctrl-backspace>",
        "<Alt-v>": "fake-key <PgUp>",
        "<Ctrl-v>": "fake-key <PgDown>",
        "<Alt-f>": "fake-key <Ctrl-Right>",
        "<Alt-b>": "fake-key <Ctrl-Left>",
        "<Ctrl-d>": "fake-key <Delete>",
        "<Alt-d>": "fake-key <Ctrl-Delete>",
        "<Alt-Backspace>": "fake-key <Ctrl-Backspace>",
        "<Ctrl-y>": "insert-text {primary}",
    },
    "normal": {
        "<Ctrl-o>": "back",
        "<Ctrl-i>": "forward",
    },
}

config.bind(
    ",ko",
    "jseval (function () { "
    + '  var i, elements = document.querySelectorAll("body *");'
    + ""
    + "  for (i = 0; i < elements.length; i++) {"
    + "    var pos = getComputedStyle(elements[i]).position;"
    + '    if (pos === "fixed" || pos == "sticky") {'
    + "      elements[i].parentNode.removeChild(elements[i]);"
    + "    }"
    + "  }"
    + "})();",
)


config.bind(
    ",ya",
    " ;; ".join(
        [
            "set -u {domain} content.javascript.clipboard access",
            "message-warning 'Clipboard enabled for 10 seconds'",
            "cmd-later 10s set content.javascript.clipboard none",
        ]
    ),
)

for p in [
    r"*://github.com",
    r"*://gitlab.com",
    r"*://chatgpt.com",
    r"*://youtube.com",
    r"*://reddit.com",
]:
    with config.pattern(p) as p:
        p.content.javascript.clipboard = "access-paste"
