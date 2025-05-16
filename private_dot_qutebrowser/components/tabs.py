from qutebrowser.utils import objreg
from qutebrowser.api import cmdutils, message
from qutebrowser.misc import editor
from qutebrowser.mainwindow import mainwindow


@cmdutils.register()
@cmdutils.argument("win_id", value=cmdutils.Value.win_id)
def tab_edit(win_id: int):
    tabs: dict[int, tuple[str, str]] = {}
    tab_widgets = {}

    tabbed_browser = objreg.get("tabbed-browser", scope="window", window=win_id)
    for idx, tab in enumerate(tabbed_browser.widgets()):
        urlstr = tab.url().toDisplayString()
        tabs[idx + 1] = (tab.title(), urlstr)
        tab_widgets[idx + 1] = tab

    text = "// vim: ft=qute-tab-edit\n"
    text += "// Delete the corresponding lines to close the tabs\n\n"

    for idx, (title, url) in tabs.items():
        text += f"{idx}: {title} ({url})\n"

    tabs_to_close = []

    def on_file_updated(text: str):
        tabs_to_close.clear()

        original = set(tabs.keys())
        new = set()
        for line in text.splitlines():
            if line.startswith("//") or not line.strip():
                continue
            try:
                idx, _ = line.split(":", 1)
                idx = int(idx.strip())
            except ValueError:
                continue

            new.add(idx)

        tabs_to_close.extend(original - new)

    def on_finished():
        for idx in sorted(tabs_to_close, reverse=True):
            tabbed_browser.close_tab(tab_widgets[idx])

        mainwindow.raise_window(objreg.last_focused_window(), alert=False)

    message.info("Editing tabs...")
    ed = editor.ExternalEditor(watch=True, parent=tabbed_browser)
    ed.file_updated.connect(on_file_updated)
    ed.editing_finished.connect(on_finished)
    ed.edit(text)
