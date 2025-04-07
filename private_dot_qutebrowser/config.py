import os

from qutebrowser.config.config import ConfigContainer
from qutebrowser.config.configfiles import ConfigAPI
from pathlib import Path
from monkey_patch import load_components

load_components()


currentdir = Path(__file__).parent

# pyright: reportUndefinedVariable=false
config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103

# Load autoconfig and theme
config.load_autoconfig()

config_dir = os.path.dirname(os.path.abspath(__file__))


# Basic settings
c.fonts.default_size = "15pt"
# c.fonts.statusbar = "bold default_size default_family"
# c.fonts.tabs.selected = "bold default_size default_family"
# c.fonts.tabs.unselected = "bold default_size default_family"
# c.fonts.completion.category = "bold default_size default_family"
# c.fonts.completion.entry = "bold default_size default_family"
c.window.hide_decoration = False
c.colors.webpage.darkmode.enabled = False
c.editor.command = [
    "open",
    "-W",
    "-a",
    "Ghostty",
    "-n",
    "--args",
    '--command=/opt/homebrew/bin/fish -c \'nvim "{file}" -c "normal {line}G{column0}|"\'',
    "--config-file=" + os.path.expanduser("~/.config/ghostty/config-qute"),
    "--config-default-files=false",
    "--quit-after-last-window-closed=true",
]
c.url.start_pages = ["about:blank"]
c.scrolling.smooth = True
c.statusbar.show = "always"
c.url.default_page = "https://kagi.com"
c.url.start_pages = ["about:blank"]
c.content.autoplay = False
c.auto_save.session = True
c.tabs.pinned.frozen = True
c.tabs.width = 200

DEFAULT_CLIPBOARD_ACCESS = "access-paste"
c.content.javascript.clipboard = DEFAULT_CLIPBOARD_ACCESS


# Insert mode bindings
config.bind("<Ctrl-f>", "fake-key <Right>", mode="insert")
config.bind("<Ctrl-b>", "fake-key <Left>", mode="insert")
config.bind("<Ctrl-a>", "fake-key <Home>", mode="insert")
config.bind("<Ctrl-e>", "fake-key <End>", mode="insert")
config.bind("<Ctrl-n>", "fake-key <Down>", mode="insert")
config.bind("<Ctrl-p>", "fake-key <Up>", mode="insert")
config.bind("<Alt-f>", "fake-key <Ctrl-Right>", mode="insert")
config.bind("<Alt-b>", "fake-key <Ctrl-Left>", mode="insert")
config.bind("<Alt-v>", "fake-key <PgUp>", mode="insert")
config.bind("<Ctrl-v>", "fake-key <PgDown>", mode="insert")
config.bind("<Ctrl-w>", "fake-key <Ctrl-backspace>", mode="insert")
config.bind("<Ctrl-d>", "fake-key <Delete>", mode="insert")
config.bind("<Alt-d>", "fake-key <Ctrl-Delete>", mode="insert")
config.bind("<Alt-Backspace>", "fake-key <Ctrl-Backspace>", mode="insert")
config.bind("<Ctrl-y>", "insert-text {primary}", mode="insert")
config.bind("<Ctrl-x><Ctrl-e>", "edit-text", mode="insert")

# Normal mode bindings
config.bind("\\w", "session-save", mode="normal")
config.bind("\\ff", "cmd-set-text -s :tab-select", mode="normal")
config.bind("gt", "tab-next", mode="normal")
config.bind("gT", "tab-prev", mode="normal")
config.bind("\\nh", "search", mode="normal")
config.bind("<Ctrl-o>", "back", mode="normal")
config.bind("<Ctrl-i>", "forward", mode="normal")
config.bind("<Ctrl-[>", "back", mode="normal")
config.bind("<Ctrl-]>", "forward", mode="normal")
config.bind("\\tt", "config-cycle tabs.position left top", mode="normal")
config.bind(
    ",ko",
    'jseval (function () { var i, elements = document.querySelectorAll("body *"); for (i = 0; i < elements.length; i++) { var pos = getComputedStyle(elements[i]).position; if (pos === "fixed" || pos == "sticky") { elements[i].parentNode.removeChild(elements[i]); } }})()',
    mode="normal",
)

config.bind(
    ",ya",
    f"set -u {{domain}} content.javascript.clipboard access ;; message-warning 'Clipboard enabled for 10 seconds' ;; cmd-later 10s set content.javascript.clipboard {DEFAULT_CLIPBOARD_ACCESS}",
    mode="normal",
)
config.bind("\\<Ctrl-f>", "spawn --userscript qute-1pass", mode="normal")
config.bind("\\\\", "clear-messages", mode="normal")
config.bind("\\<Ctrl-c>", "hint code userscript code_select.py", mode="normal")
config.bind("\\<Ctrl-x><Ctrl-e>", "edit-text", mode="normal")
config.bind("\\sr", "spawn --userscript save-to-readwise-reader", mode="normal")
config.bind("\\<space><space>", f"spawn --userscript sites.py {currentdir}/sites.json", mode="normal")
config.bind("\\so", "spawn --userscript search-selected.py", mode="normal")
config.bind(",m", "hint links spawn mpv {hint-url}", mode="normal")

# Command mode bindings
config.bind("<Ctrl+x><Ctrl-e>", "cmd-edit", mode="command")

# Passthrough mode bindings
config.bind("<Ctrl+Escape>", "mode-leave", mode="passthrough")

# caret mode bindings
config.bind("\\so", "spawn --userscript search-selected.py", mode="caret")

c.hints.selectors["code"] = [
    # Selects all code tags whose direct parent is not a pre tag
    ":not(pre) > code",
    "pre",
]
# Domain-specific clipboard settings
for pattern in [
    r"*://github.com",
    r"*://gitlab.com",
    r"*://chatgpt.com",
    r"*://youtube.com",
    r"*://reddit.com",
    r"*://bsky.app",
]:
    with config.pattern(pattern) as p:
        p.content.javascript.clipboard = "access-paste"

c.url.searchengines = {
    "DEFAULT": "https://kagi.com/search?q={}",
    "@gh": "https://github.com/search?q={}",
    "@ghr": "https://github.com/{}",
}

# colors
base00 = "#F4F0ED"  # background
base01 = "#d4cbc3"  # lighter background
base02 = "#a69582"  # selection
base03 = "#867462"  # comments
base04 = "#6B5C4D"  # dark foreground
base05 = "#6B5C4D"  # foreground
base06 = "#485f84"  # light foreground
base07 = "#FFFFFF"  # light background
base08 = "#d7898c"  # red
base09 = "#c65333"  # orange
base0A = "#cc7f2b"  # yellow
base0B = "#659e69"  # green
base0C = "#436460"  # teal
base0D = "#485f84"  # blue
base0E = "#854882"  # magenta
base0F = "#729893"  # brown

# set qutebrowser colors

# Text color of the completion widget. May be a single color to use for
# all columns or a list of three colors, one for each column.
c.colors.completion.fg = base05

# Background color of the completion widget for odd rows.
c.colors.completion.odd.bg = base00

# Background color of the completion widget for even rows.
c.colors.completion.even.bg = base00

# Foreground color of completion widget category headers.
c.colors.completion.category.fg = base0D

# Background color of the completion widget category headers.
c.colors.completion.category.bg = base00

# Top border color of the completion widget category headers.
c.colors.completion.category.border.top = base00

# Bottom border color of the completion widget category headers.
c.colors.completion.category.border.bottom = base00

# Foreground color of the selected completion item.
c.colors.completion.item.selected.fg = base05

# Background color of the selected completion item.
c.colors.completion.item.selected.bg = base02

# Top border color of the selected completion item.
c.colors.completion.item.selected.border.top = base02

# Bottom border color of the selected completion item.
c.colors.completion.item.selected.border.bottom = base02

# Foreground color of the matched text in the selected completion item.
c.colors.completion.item.selected.match.fg = base05

# Foreground color of the matched text in the completion.
c.colors.completion.match.fg = base09

# Color of the scrollbar handle in the completion view.
c.colors.completion.scrollbar.fg = base05

# Color of the scrollbar in the completion view.
c.colors.completion.scrollbar.bg = base00

# Background color of disabled items in the context menu.
c.colors.contextmenu.disabled.bg = base01

# Foreground color of disabled items in the context menu.
c.colors.contextmenu.disabled.fg = base04

# Background color of the context menu. If set to null, the Qt default is used.
c.colors.contextmenu.menu.bg = base00

# Foreground color of the context menu. If set to null, the Qt default is used.
c.colors.contextmenu.menu.fg = base05

# Background color of the context menu’s selected item. If set to null, the Qt default is used.
c.colors.contextmenu.selected.bg = base02

# Foreground color of the context menu’s selected item. If set to null, the Qt default is used.
c.colors.contextmenu.selected.fg = base05

# Background color for the download bar.
c.colors.downloads.bar.bg = base00

# Color gradient start for download text.
c.colors.downloads.start.fg = base00

# Color gradient start for download backgrounds.
c.colors.downloads.start.bg = base0D

# Color gradient end for download text.
c.colors.downloads.stop.fg = base00

# Color gradient stop for download backgrounds.
c.colors.downloads.stop.bg = base0C

# Foreground color for downloads with errors.
c.colors.downloads.error.fg = base08

# Font color for hints.
c.colors.hints.fg = base00

# Background color for hints. Note that you can use a `rgba(...)` value
# for transparency.
c.colors.hints.bg = base0A

# Font color for the matched part of hints.
c.colors.hints.match.fg = base05

# Text color for the keyhint widget.
c.colors.keyhint.fg = base05

# Highlight color for keys to complete the current keychain.
c.colors.keyhint.suffix.fg = base05

# Background color of the keyhint widget.
c.colors.keyhint.bg = base00

# Foreground color of an error message.
c.colors.messages.error.fg = base00

# Background color of an error message.
c.colors.messages.error.bg = base08

# Border color of an error message.
c.colors.messages.error.border = base08

# Foreground color of a warning message.
c.colors.messages.warning.fg = base00

# Background color of a warning message.
c.colors.messages.warning.bg = base0E

# Border color of a warning message.
c.colors.messages.warning.border = base0E

# Foreground color of an info message.
c.colors.messages.info.fg = base05

# Background color of an info message.
c.colors.messages.info.bg = base01

# Border color of an info message.
c.colors.messages.info.border = base00

# Foreground color for prompts.
c.colors.prompts.fg = base05

# Border used around UI elements in prompts.
c.colors.prompts.border = base00

# Background color for prompts.
c.colors.prompts.bg = base00

# Background color for the selected item in filename prompts.
c.colors.prompts.selected.bg = base02

# Foreground color for the selected item in filename prompts.
c.colors.prompts.selected.fg = base05

# Foreground color of the statusbar.
c.colors.statusbar.normal.fg = base05

# Background color of the statusbar.
c.colors.statusbar.normal.bg = base00

# Foreground color of the statusbar in insert mode.
c.colors.statusbar.insert.fg = base0C

# Background color of the statusbar in insert mode.
c.colors.statusbar.insert.bg = base00

# Foreground color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.fg = base0A

# Background color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.bg = base00

# Foreground color of the statusbar in private browsing mode.
c.colors.statusbar.private.fg = base0E

# Background color of the statusbar in private browsing mode.
c.colors.statusbar.private.bg = base00

# Foreground color of the statusbar in command mode.
c.colors.statusbar.command.fg = base04

# Background color of the statusbar in command mode.
c.colors.statusbar.command.bg = base01

# Foreground color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.fg = base0E

# Background color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.bg = base01

# Foreground color of the statusbar in caret mode.
c.colors.statusbar.caret.fg = base0D

# Background color of the statusbar in caret mode.
c.colors.statusbar.caret.bg = base00

# Foreground color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.fg = base0D

# Background color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.bg = base00

# Background color of the progress bar.
c.colors.statusbar.progress.bg = base0D

# Default foreground color of the URL in the statusbar.
c.colors.statusbar.url.fg = base05

# Foreground color of the URL in the statusbar on error.
c.colors.statusbar.url.error.fg = base08

# Foreground color of the URL in the statusbar for hovered links.
c.colors.statusbar.url.hover.fg = base09

# Foreground color of the URL in the statusbar on successful load
# (http).
c.colors.statusbar.url.success.http.fg = base0B

# Foreground color of the URL in the statusbar on successful load
# (https).
c.colors.statusbar.url.success.https.fg = base0B

# Foreground color of the URL in the statusbar when there's a warning.
c.colors.statusbar.url.warn.fg = base0E

# Background color of the tab bar.
c.colors.tabs.bar.bg = base01

# Color gradient start for the tab indicator.
c.colors.tabs.indicator.start = base0D

# Color gradient end for the tab indicator.
c.colors.tabs.indicator.stop = base0C

# Color for the tab indicator on errors.
c.colors.tabs.indicator.error = base08

# Foreground color of unselected odd tabs.
c.colors.tabs.odd.fg = base05

# Background color of unselected odd tabs.
c.colors.tabs.odd.bg = base01

# Foreground color of unselected even tabs.
c.colors.tabs.even.fg = base05

# Background color of unselected even tabs.
c.colors.tabs.even.bg = base01

# Background color of pinned unselected even tabs.
c.colors.tabs.pinned.even.bg = base0B

# Foreground color of pinned unselected even tabs.
c.colors.tabs.pinned.even.fg = base00

# Background color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.bg = base0B

# Foreground color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.fg = base00

# Background color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.bg = base02

# Foreground color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.fg = base05

# Background color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.bg = base02

# Foreground color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.fg = base05

# Foreground color of selected odd tabs.
c.colors.tabs.selected.odd.fg = base05

# Background color of selected odd tabs.
c.colors.tabs.selected.odd.bg = base00

# Foreground color of selected even tabs.
c.colors.tabs.selected.even.fg = base05

# Background color of selected even tabs.
c.colors.tabs.selected.even.bg = base00

# Background color for webpages if unset (or empty to use the theme's
# color).
c.colors.webpage.bg = base00

workcfg = os.path.expanduser("~/.config/work/qutebrowser/config.py")
if os.path.exists(workcfg):
    config.source(workcfg)
