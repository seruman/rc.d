import pkgutil
import sys
import types
from importlib.machinery import FileFinder, SourceFileLoader
from typing import Any, Callable, Iterator, cast

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
            namespaced_loader, namespaced_info = create_namespaced_loader(source_loader, info)

            namespaced_loader()
            loader._load_component(namespaced_info)

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


def create_namespaced_loader(
    source_loader: SourceFileLoader,
    info: loader.ExtensionInfo,
    namespace_prefix: str = "seruman",
) -> tuple[Callable[[], types.ModuleType], loader.ExtensionInfo]:
    namespaced_name = f"{namespace_prefix}.{info.name}"
    namespaced_info = loader.ExtensionInfo(name=namespaced_name)

    def namespaced_loader() -> Any:
        module = source_loader.load_module(info.name)

        if namespace_prefix not in sys.modules:
            parent_module = types.ModuleType(namespace_prefix)
            sys.modules[namespace_prefix] = parent_module

        components_namespace = f"{namespace_prefix}.components"
        if components_namespace not in sys.modules:
            components_module = types.ModuleType(components_namespace)
            sys.modules[components_namespace] = components_module
            setattr(sys.modules[namespace_prefix], "components", components_module)

        sys.modules[namespaced_name] = module

        component_name = info.name.split(".")[-1]
        setattr(sys.modules[components_namespace], component_name, module)

        return module

    return namespaced_loader, namespaced_info
