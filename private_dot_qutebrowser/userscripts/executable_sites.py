#!/opt/homebrew/bin/uv run -s -q
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "pydantic==2.10.6",
#   "typer==0.15.2",
# ]
# ///

from typing import Annotated

import typer
from choose import choose
from pydantic import RootModel

Sites = RootModel[dict[str, str]]


def main(
    qute_pipe: Annotated[typer.FileTextWrite, typer.Option(envvar="QUTE_FIFO")],
    sites_file: Annotated[typer.FileText, typer.Argument(...)],
    prompt: Annotated[str, typer.Option(...)] = "Repositories>",
):
    repos = Sites.model_validate_json(sites_file.read()).model_dump()

    got = choose(
        prompt=prompt,
        items=list(repos.keys()),
        choose_bin="/opt/homebrew/bin/choose",
    )

    if got is None:
        return

    url = repos[got]
    qute_pipe.write(f"open -t {url}\n")


if __name__ == "__main__":
    typer.run(main)
