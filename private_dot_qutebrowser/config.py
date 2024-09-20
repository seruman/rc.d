from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer

import catppuccin

# pyright: reportUndefinedVariable=false
config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103

config.load_autoconfig()
config.set("fonts.default_size", "14pt")
config.set("window.hide_decoration", False)
config.set("colors.webpage.darkmode.enabled", False)


config.bind("<Ctrl-o>", "back")
config.bind("<Ctrl-i>", "forward")

catppuccin.setup(c, "latte", True)
