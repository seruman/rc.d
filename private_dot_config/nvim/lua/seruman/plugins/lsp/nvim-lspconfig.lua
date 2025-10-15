return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "saghen/blink.cmp" },

			-- TODO(selman): Pin fidget.nvim as it's being rewritten.
			{ "j-hui/fidget.nvim", tag = "legacy", config = true },
			{ "ibhagwan/fzf-lua" },
			{ "mfussenegger/nvim-jdtls" },
			{
				"stevearc/conform.nvim",
				-- enabled = false,
				opts = {
					formatters_by_ft = {
						lua = { "stylua" },
						typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
						typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
						javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
						javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
						json = { "prettierd", "prettier", stop_after_first = true },
						html = { "prettierd", "prettier", stop_after_first = true },
						css = { "prettierd", "prettier", stop_after_first = true },
						sh = { "shfmt" },
						bash = { "shfmt" },
						zsh = { "shfmt" },
						go = { "gofumpt", "goimports" },
						python = {
							"ruff_fix",
							"ruff_format",
							-- "ruff_organize_imports",
						},
						templ = { "templ" },
						java = { "palantir_java_format" },
						groovy = { "npm-groovy-lint" },
					},
					formatters = {
						goimports = {
							prepend_args = function(self, ctx)
								local local_ = table.concat({
									"github.com/seruman",
									vim.env.GOPLS_LOCAL,
								}, ",")

								return {
									"--local",
									local_,
								}
							end,
						},
						ruff_format = {
							append_args = function(self, ctx)
								return {
									"--line-length",
									"120",
								}
							end,
						},
						google_java_format = {
							command = "",
							args = { "-" },
							range_args = function(self, ctx)
								return {
									"--lines",
									ctx.range.start[1] .. ":" .. ctx.range["end"][1],
									"--skip-sorting-imports",
									"--skip-removing-unused-imports",
									"--skip-javadoc-formatting",
									"--skip-reflowing-long-strings",
									"-",
								}
							end,
						},
						palantir_java_format = {
							command = "palantir-java-format",
							args = { "--palantir", "-" },
							range_args = function(self, ctx)
								return {
									"--palantir",
									"--lines",
									ctx.range.start[1] .. ":" .. ctx.range["end"][1],
									"-",
								}
							end,
						},
					},
					format_on_save = function(bufnr)
						-- Disable with a global or buffer-local variable
						if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
							return
						end
						return { timeout_ms = 500, lsp_format = "fallback" }
					end,
				},
			},
		},
		config = function()
			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, lsp_fallback = true, range = range })
			end, { range = true })

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})

			local function setup_gopls()
				-- Format on save.
				-- TODO(selman): organizeImports breaks imports some how, could not figure out why.

				local tags = "-tags="
					.. table.concat({
						"integration",
						"selman",
						"tools",
						"testmain",
					}, ",")

				return {
					settings = {
						gopls = {
							-- Build
							env = { GOFLAGS = tags },
							buildFlags = { tags },

							-- Formatting
							gofumpt = true,
							["local"] = table.concat({
								"github.com/seruman",
								vim.env.GOPLS_LOCAL,
							}, ","),

							-- Diagnostics
							analyses = {
								nilness = true,
								-- NOTE(selman): Tired of warnings for`if err := ...; err != nil`.
								shadow = false,
								unusedparams = true,
								unusedwrite = true,
								unusedvariable = true,
								useany = true,
							},
							staticcheck = true,

							-- UI
							-- Code Lenses
							codelenses = {
								generate = true,
								test = true,
								tidy = true,
								vendor = true,
							},
							experimentalPostfixCompletions = true,
							semanticTokens = false,
						},
					},
				}
			end

			local function setup_lua_ls()
				local runtime_path = vim.split(package.path, ";")
				table.insert(runtime_path, "lua/?.lua")
				table.insert(runtime_path, "lua/?/init.lua")

				return {
					settings = {
						Lua = {
							-- Disable telemetry
							telemetry = { enable = false },
							runtime = {
								-- Tell the language server which version of Lua you're using
								-- (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
								path = runtime_path,
							},
							diagnostics = {
								-- Get the language server to recognize the `vim` global
								globals = { "vim" },
							},
							workspace = {
								checkThirdParty = false,
								library = {
									-- Make the server aware of Neovim runtime files
									vim.fn.expand("$VIMRUNTIME/lua"),
									vim.fn.stdpath("config") .. "/lua",
								},
							},
						},
					},
				}
			end

			local function setup_pyright()
				return {
					settings = {
						pyright = {
							disableOrganizeImports = true,
							autoImportCompletions = true,
							disableTaggedHints = false,
						},
						python = {
							analysis = {
								indexing = true,
								typeCheckingMode = "basic",
								-- diagnosticMode = "openFilesOnly",
								-- TODO(selman): not sure if works :(
								diagnosticSeverityOverrides = {
									reportAttributeAccessIssue = "warning",
									reportCallIssue = "error",
									reportMissingTypeStubs = "none",
									reportImportCycles = "error",
									reportUnusedImport = "none", -- Ruff handles this.
									reportUnusedClass = "warning",
									reportUnusedFunction = "warning",
									reportUnusedVariable = "warning",
									reportDuplicateImport = "warning",
									reportDeprecated = "warning",
									reportMissingSuperCall = "none",
									reportUnnecessaryIsInstance = "information",
									reportUnnecessaryCast = "information",
									reportUnnecessaryComparison = "warning",
									reportUnnecessaryContains = "warning",
									reportImplicitStringConcatenation = "warning",
									reportUnusedCallResult = "none",
									reportUnusedExpression = "information",
									reportUnnecessaryTypeIgnoreComment = "warning",
									reportMatchNotExhaustive = "warning",
									reportShadowedImports = "warning",
								},
							},
						},
					},
				}
			end

			local function setup_basedpyright()
				return {
					settings = {
						basedpyright = {
							disableOrganizeImports = true,
							autoImportCompletions = true,
							disableTaggedHints = false,
							analysis = {
								indexing = true,
								typeCheckingMode = "basic",
								-- diagnosticMode = "openFilesOnly",
								-- TODO(selman): not sure if works :(
								diagnosticSeverityOverrides = {
									reportAttributeAccessIssue = "warning",
									reportCallIssue = "error",
									reportMissingTypeStubs = "none",
									reportImportCycles = "error",
									reportUnusedImport = "none", -- Ruff handles this.
									reportUnusedClass = "warning",
									reportUnusedFunction = "warning",
									reportUnusedVariable = "warning",
									reportDuplicateImport = "warning",
									reportDeprecated = "warning",
									reportMissingSuperCall = "none",
									reportUnnecessaryIsInstance = "information",
									reportUnnecessaryCast = "information",
									reportUnnecessaryComparison = "warning",
									reportUnnecessaryContains = "warning",
									reportImplicitStringConcatenation = "warning",
									reportUnusedCallResult = "none",
									reportUnusedExpression = "information",
									reportUnnecessaryTypeIgnoreComment = "warning",
									reportMatchNotExhaustive = "warning",
									reportShadowedImports = "warning",
								},
							},
						},
					},
				}
			end

			local function setup_ruff()
				return {
					on_attach = function(client, _)
						if client.name == "ruff" then
							-- Disable hover in favor of Pyright
							client.server_capabilities.hoverProvider = false
						end
					end,
					init_options = {
						settings = {
							lineLength = 120,
						},
					},
				}
			end

			local function setup_rust_analyzer()
				local ok, rust_analyzer_bin = pcall(vim.fn.system, { "rustup", "which", "rust-analyzer" })
				if not ok then
					rust_analyzer_bin = "rust-analyzer"
				end

				rust_analyzer_bin = string.gsub(rust_analyzer_bin, "\n$", "")

				return {
					cmd = { rust_analyzer_bin },
				}
			end

			local function setup_yamlls()
				local schemas = {}
				local env_project_schemas = vim.env.YAMLLS_PROJECT_SCHEMAS
				if env_project_schemas ~= nil then
					local ok, decoded = pcall(vim.fn.json_decode, env_project_schemas)
					if ok then
						for _, schema in ipairs(decoded) do
							for uri, matcher in pairs(schema) do
								schemas[uri] = matcher
							end
						end
					end
				end

				return {
					settings = {
						yaml = {
							redhat = { telemetry = { enable = false } },
							keyOrdering = false,
							schemas = schemas,
						},
					},
				}
			end

			local function setup_typos_lsp()
				return {
					init_options = {
						diagnosticSeverity = "Warning",
					},
				}
			end

			local function setup_clangd()
				-- No proto please
				return {
					filetypes = { "c", "cpp", "objc", "objcpp" },
				}
			end

			local function setup_default()
				return {}
			end

			local servers = {
				gopls = setup_gopls,
				pyright = setup_pyright,
				-- TODO: https://github.com/DetachHead/basedpyright/issues/513
				-- basedpyright = setup_basedpyright,
				ruff = setup_ruff,
				bashls = setup_default,
				lua_ls = setup_lua_ls,
				ts_ls = setup_default,
				jsonls = setup_default,
				yamlls = setup_yamlls,
				terraformls = setup_default,
				rust_analyzer = setup_rust_analyzer,
				zls = setup_default,
				clangd = setup_clangd,
				tailwindcss = setup_default,
				typos_lsp = setup_typos_lsp,
				nim_langserver = setup_default,
				taplo = setup_default,
				["protobuf-language-server"] = setup_default,
				html = setup_default,
				["fish-lsp"] = setup_default,
				biome = setup_default,
				jsonnet_ls = setup_default,
			}

			local configs = require("lspconfig.configs")
			local util = require("lspconfig.util")

			configs["protobuf-language-server"] = {
				default_config = {
					cmd = { "protobuf-language-server" },
					filetypes = { "proto", "cpp" },
					root_dir = util.root_pattern(".git"),
					single_file_support = true,
					settings = {},
				},
			}

			configs["fish-lsp"] = {
				default_config = {
					name = "fish-lsp",
					cmd = { "fish-lsp", "start" },
					cmd_env = { fish_lsp_show_client_popups = false },
					filetypes = { "fish" },
					root_dir = function(fname)
						return util.root_pattern(".git")(fname) or util.path.dirname(fname)
					end,
					single_file_support = true,
					settings = {},
				},
			}

			-- Set global LSP defaults for all servers
			vim.lsp.config("*", {
				flags = { debounce_text_changes = 150 },
			})

			-- Configure each server with server-specific settings
			-- nvim-lspconfig will provide base configs that get merged automatically
			for server, setupfn in pairs(servers) do
				vim.lsp.config(server, setupfn())
			end

			-- Enable all configured servers
			vim.lsp.enable(vim.tbl_keys(servers))

			-- Configure diagnostic display globally
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				update_in_insert = false,
				underline = true,
			})

			-- Set mappings on LSP attach.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local function fzfopts(o)
						return vim.tbl_extend("force", {
							jump1 = true,
							ignore_current_line = true,
						}, o or {})
					end

					local function opts(o)
						return vim.tbl_extend("keep", { buffer = ev.buf }, o or {})
					end

					-- TODO(selman): not using TBH, but keeping it for future reference.
					-- vim.keymap.set("n", "gD", function()
					-- 	require("fzf-lua").lsp_declarations(fzfopts())
					-- end, opts({ desc = "LSP declarations" }))
					vim.keymap.set("n", "gD", function()
						require("fzf-lua").lsp_definitions(fzfopts({
							jump1_action = require("fzf-lua.actions").file_vsplit,
						}))
					end, opts({ desc = "LSP definitions" }))
					vim.keymap.set("n", "gT", function()
						require("fzf-lua").lsp_definitions(fzfopts({
							jump1_action = require("fzf-lua.actions").file_tabedit,
						}))
					end, opts({ desc = "LSP definitions" }))
					vim.keymap.set("n", "gd", function()
						require("fzf-lua").lsp_definitions(fzfopts())
					end, opts({ desc = "LSP definitions" }))
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts({ desc = "LSP hover" }))
					vim.keymap.set("n", "gi", function()
						require("fzf-lua").lsp_implementations(fzfopts())
					end, opts({ desc = "LSP implementations" }))
					vim.keymap.set(
						{ "n", "i" },
						"<C-k>",
						vim.lsp.buf.signature_help,
						opts({ desc = "LSP signature help" })
					)
					vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts({ desc = "LSP rename" }))
					vim.keymap.set(
						{ "n", "v" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						opts({ desc = "LSP code action" })
					)
					vim.keymap.set({ "n", "v" }, "<leader>cl", vim.lsp.codelens.run, opts({ desc = "LSP code lens" }))
					vim.keymap.set("n", "gr", function()
						require("fzf-lua").lsp_references(fzfopts())
					end, opts({ desc = "LSP references" }))
					vim.keymap.set(
						"n",
						"<space>f",
						":Format<CR>",
						opts({ desc = "Conform format with LSP fallback", silent = true })
					)
					vim.keymap.set(
						"v",
						"<space>f",
						":Format<CR>",
						opts({ desc = "Conform format with LSP fallback", silent = true })
					)
					vim.keymap.set("n", "<leader>dd", function()
						require("fzf-lua").lsp_document_diagnostics(fzfopts())
					end, opts({ desc = "LSP diagnostics (document)" }))
					vim.keymap.set("n", "<leader>dw", function()
						require("fzf-lua").lsp_workspace_diagnostics(fzfopts())
					end, opts({ desc = "LSP diagnostics (workspace)" }))

					vim.keymap.set("n", "<space>d", function()
						vim.diagnostic.open_float({
							border = "rounded",
							header = "",
							close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
							source = true,
						})
					end, opts({ desc = "LSP diagnostic under cursor (popup)" }))
					vim.keymap.set("n", "<leader>ic", function()
						require("fzf-lua").lsp_incoming_calls(fzfopts())
					end, opts({ desc = "LSP incoming calls" }))
					vim.keymap.set("n", "<leader>oc", function()
						require("fzf-lua").lsp_incoming_calls(fzfopts())
					end, opts({ desc = "LSP outgound calls" }))
					vim.keymap.set("n", "<leader>sd", function()
						require("fzf-lua").lsp_document_symbols(fzfopts())
					end, opts({ desc = "LSP symbols (document)" }))
					vim.keymap.set("n", "<leader>sw", function()
						require("fzf-lua").lsp_live_workspace_symbols(fzfopts())
					end, opts({ desc = "LSP symbold (workspace)" }))
					vim.keymap.set("n", "<leader>td", function()
						require("fzf-lua").lsp_typedefs(fzfopts())
					end, opts({ desc = "LSP typedefs" }))
					vim.keymap.set("n", "<space>lr", function()
						vim.cmd("LspRestart")
					end, opts({ desc = "LSP restart" }))
					vim.keymap.set("n", "<space>*", function()
						vim.lsp.buf.document_highlight()
					end, opts({ desc = "LSP restart" }))
					vim.keymap.set("n", "<space>nh", function()
						vim.lsp.buf.clear_references()
					end, opts({ desc = "LSP restart" }))
				end,
			})
		end,
	},
}
