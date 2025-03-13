import pkgutil
from importlib.machinery import FileFinder, SourceFileLoader
from typing import Iterator, cast

from qutebrowser.app import loader
from qutebrowser.utils import log

import components


def load_components() -> None:
    original_load_components = loader.load_components

    def _load_components() -> None:
        original_load_components()
        _custom_load_components()

    loader.load_components = _load_components


def _custom_load_components() -> None:
    try:
        for source_loader, info in _walk_components():
            source_loader.load_module(info.name)
            loader._load_component(info)

    except ImportError as e:
        log.extensions.error(f"[seruman] Failed to load components: {e}")


def _walk_components() -> Iterator[tuple[SourceFileLoader, loader.ExtensionInfo]]:
    def _on_walk_error(name: str) -> None:
        raise ImportError(f"Failed to import {name}")

    module_infos = pkgutil.walk_packages(
        path=components.__path__,
        prefix=components.__name__ + ".",
        onerror=_on_walk_error,
    )

    for module_finder, name, ispkg in module_infos:
        if ispkg:
            continue

        finder = cast(FileFinder, module_finder)
        spec = finder.find_spec(name)
        if not spec:
            log.extensions.debug(f"[seruman] Skipping {name}, spec not found")
            continue

        if not spec.loader:
            log.extensions.debug(f"[seruman] Skipping {name}, loader not found")

        source_loader = cast(SourceFileLoader, spec.loader)

        yield source_loader, loader.ExtensionInfo(name=name)
