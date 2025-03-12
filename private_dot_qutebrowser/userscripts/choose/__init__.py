from typing import Sequence, overload, Literal

import subprocess


@overload
def choose(
    items: Sequence[str],
    return_index: Literal[True],
    num_rows: int | None = None,
    width: int | None = None,
    font: str | None = None,
    font_size: int | None = None,
    highlight_color: str | None = None,
    background_color: str | None = None,
    disable_underline: bool = False,
    return_query_on_no_match: bool = False,
    prompt: str | None = None,
    output_results: bool = False,
    choose_bin: str = "choose",
) -> int | None: ...


@overload
def choose(
    items: Sequence[str],
    return_index: Literal[False] = False,
    num_rows: int | None = None,
    width: int | None = None,
    font: str | None = None,
    font_size: int | None = None,
    highlight_color: str | None = None,
    background_color: str | None = None,
    disable_underline: bool = False,
    return_query_on_no_match: bool = False,
    prompt: str | None = None,
    output_results: bool = False,
    choose_bin: str = "choose",
) -> str | None: ...


def choose(
    items: Sequence[str],
    return_index: bool = False,
    num_rows: int | None = None,
    width: int | None = None,
    font: str | None = None,
    font_size: int | None = None,
    highlight_color: str | None = None,
    background_color: str | None = None,
    disable_underline: bool = False,
    return_query_on_no_match: bool = False,
    prompt: str | None = None,
    output_results: bool = False,
    choose_bin: str = "choose",
) -> str | int | None:
    """
    A Python wrapper for the 'choose' macOS fuzzy picker tool.

    Args:
        items: List of strings to choose from
        return_index: Return index of selected element instead of the element itself
        num_rows: Number of rows to display (default: 10)
        width: Width of choose window (default: 50)
        font: Font used by choose (default: Menlo)
        font_size: Font size used by choose (default: 26)
        highlight_color: Highlight color for matched string in hex (default: 0000FF)
        background_color: Background color of selected element in hex (default: 222222)
        disable_underline: Disable underline and use background for matched string
        return_query_on_no_match: Return the query string if it doesn't match any item
        prompt: Text to display when query field is empty
        output_results: Given a query, outputs results to standard output

    Returns:
        If return_index is True, returns the selected index as an integer.
        Otherwise, returns the selected string.
        Returns None if the user cancels or no selection is made.

    Raises:
        FileNotFoundError: If the 'choose' command is not found on the system
        subprocess.CalledProcessError: If 'choose' returns a non-zero exit code
    """
    cmd = [choose_bin]

    if return_index:
        cmd.append("-i")

    if num_rows is not None:
        cmd.extend(["-n", str(num_rows)])

    if width is not None:
        cmd.extend(["-w", str(width)])

    if font is not None:
        cmd.extend(["-f", font])

    if font_size is not None:
        cmd.extend(["-s", str(font_size)])

    if highlight_color is not None:
        cmd.extend(["-c", highlight_color])

    if background_color is not None:
        cmd.extend(["-b", background_color])

    if disable_underline:
        cmd.append("-u")

    if return_query_on_no_match:
        cmd.append("-m")

    if prompt is not None:
        cmd.extend(["-p", prompt])

    if output_results:
        cmd.append("-o")

    try:
        result = subprocess.run(
            cmd,
            input="\n".join(items).encode(),
            capture_output=True,
            check=True,
        )

        output = result.stdout.decode().strip()

        if not output:
            return None

        if return_index:
            return int(output)
        else:
            return output

    except subprocess.CalledProcessError as e:
        if e.returncode == 1:
            return None
        raise
