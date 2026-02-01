local rust_analyzer_bin = "rust-analyzer"

local result = vim.system({ "rustup", "which", "rust-analyzer" }, { text = true }):wait()
if result.code == 0 then
	rust_analyzer_bin = vim.trim(result.stdout)
end

return {
	cmd = { rust_analyzer_bin },
}
