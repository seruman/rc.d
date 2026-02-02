set -l sdk_version "25.0"
set -l sdk_path "$HOME/opt/wasi-sdk/$sdk_version"

if not test -d "$sdk_path"
    return
end

set -gx WASI_SDK_PATH "$sdk_path"
set -gx WASI_SDK_CC "$WASI_SDK_PATH/bin/clang --sysroot=$WASI_SDK_PATH/share/wasi-sysroot"
