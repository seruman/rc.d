#!/opt/homebrew/bin/uv run -s -q
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "typer==0.15.2",
# ]
# ///

import os
from urllib.parse import urlencode, urljoin
from typing import Annotated, Protocol

import typer
from choose import choose


class SupportsWrite[T]:
    def write(self, data: T) -> None: ...


class Action(Protocol):
    def __call__(self, qute_pipe: SupportsWrite[str]) -> None: ...


def summarize(qute_pipe: SupportsWrite[str]) -> None:
    url = os.getenv("QUTE_URL")
    if not url:
        qute_pipe.write("No URL found in QUTE_URL environment variable.\n")
        return

    query = urlencode({"summary": "takeaway", "url": url})
    target = urljoin("https://kagi.com/summarizer/", f"?{query}")

    qute_pipe.write(f"open -t {target}\n")


def open_go_playground(qute_pipe: SupportsWrite[str]) -> None:
    target = "https://go.dev/play/"
    qute_pipe.write(f"open -t {target}\n")


ACTIONS: dict[str, Action] = {
    "Summarise w/ Kagi": summarize,
    "Open Go Playground": open_go_playground,
}


def main(
    qute_pipe: Annotated[typer.FileTextWrite, typer.Option(envvar="QUTE_FIFO")],
):
    got = choose(
        prompt="Actions>",
        items=list(ACTIONS.keys()),
        match_from_beginning=True,
        rank_early_matches_higher=True,
        choose_bin="/opt/homebrew/bin/choose",
    )

    if got is None:
        return

    action = ACTIONS[got]
    action(qute_pipe)


if __name__ == "__main__":
    typer.run(main)
