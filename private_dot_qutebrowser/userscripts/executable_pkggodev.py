#!/opt/homebrew/bin/uv run -s -q

import os
import sys

from urllib.parse import urlparse


if __name__ == "__main__":
    url = os.getenv("QUTE_URL")
    if not url:
        print("No URL provided", file=sys.stderr)
        exit(1)

    qute_fifo = os.getenv("QUTE_FIFO")
    if not qute_fifo:
        print("No QUTE_FIFO provided", file=sys.stderr)
        exit(1)

    with open(qute_fifo, "w") as fifo:
        parsed_url = urlparse(url)
        pkg = f"{parsed_url.netloc}{parsed_url.path}"
        docurl = f"https://pkg.go.dev/{pkg}"

        print(f"open -t {docurl}", file=fifo)
