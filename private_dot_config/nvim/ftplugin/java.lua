-- Java LSP configuration for Neovim
local jdtls = require("jdtls")
local utils = require("seruman.lsp.java.utils")
local gradle = require("seruman.lsp.java.gradle")

local home = vim.fn.expand("~")
local workspace_dir = home .. "/.cache/jdtls/workspace"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_project_dir = workspace_dir .. "/" .. project_name
local root_dir =
	vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml", "build.gradle" }, { upward = true })[1])

local java_home = utils.find_java_home()
local java_bin = java_home .. "/bin/java"
local lombok_path = utils.ensure_lombok(workspace_dir)
local project_java_version = utils.detect_project_java_version(root_dir)
local trusted_checksums = gradle.init()

-- Test bundles are disabled (you'll handle this later)
local test_bundles = {}

local config = {
	cmd = {
		"jdtls",
		"--java-executable",
		java_bin,
		"--jvm-arg=-javaagent:" .. lombok_path,
		"--jvm-arg=-Xmx2G", -- Increase heap size for larger projects
		"-data",
		workspace_project_dir,
	},
	root_dir = root_dir,
	init_options = {
		bundles = test_bundles,
		java = {
			imports = {
				gradle = {
					wrapper = {
						checksums = utils.setup_gradle_checksums(root_dir, trusted_checksums, gradle.save_checksums),
					},
				},
			},
		},
	},
	settings = {
		java = {
			configuration = {
				runtimes = utils.get_java_runtimes(java_home, project_java_version),
			},
			eclipse = {
				downloadSources = true,
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.Assume.*",
					"org.junit.jupiter.api.Assertions.*",
					"org.junit.jupiter.api.Assumptions.*",
					"org.junit.jupiter.api.DynamicContainer.*",
					"org.junit.jupiter.api.DynamicTest.*",
					"org.mockito.Mockito.*",
					"org.mockito.ArgumentMatchers.*",
					"org.assertj.core.api.Assertions.*",
				},
				importOrder = {
					"java",
					"javax",
					"com",
					"org",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			format = {
				enabled = false, -- Disable JDTLS formatting in favor of Conform with palantir_java_format
			},
			signatureHelp = {
				enabled = true,
			},
			contentProvider = {
				preferred = "fernflower",
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				hashCodeEquals = {
					useJava7Objects = true,
				},
				useBlocks = true,
			},
			autobuild = {
				enabled = true,
			},
		},
	},
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	on_attach = function(_, bufnr)
		local opts = { noremap = true, silent = true, buffer = bufnr }

		vim.keymap.set(
			"n",
			"<leader>jo",
			jdtls.organize_imports,
			vim.tbl_extend("force", opts, { desc = "Java: Organize imports" })
		)

		vim.keymap.set(
			"n",
			"<leader>jv",
			jdtls.extract_variable,
			vim.tbl_extend("force", opts, { desc = "Java: Extract variable" })
		)

		vim.keymap.set("v", "<leader>jv", function()
			jdtls.extract_variable(true)
		end, vim.tbl_extend("force", opts, { desc = "Java: Extract variable" }))

		vim.keymap.set(
			"n",
			"<leader>jc",
			jdtls.extract_constant,
			vim.tbl_extend("force", opts, { desc = "Java: Extract constant" })
		)

		vim.keymap.set("v", "<leader>jc", function()
			jdtls.extract_constant(true)
		end, vim.tbl_extend("force", opts, { desc = "Java: Extract constant" }))

		vim.keymap.set("v", "<leader>jm", function()
			jdtls.extract_method(true)
		end, vim.tbl_extend("force", opts, { desc = "Java: Extract method" }))

		-- Testing (disabled)
		vim.keymap.set("n", "<leader>jt", function()
			vim.notify(
				"Java test functionality is disabled. You'll need to set up test extensions first.",
				vim.log.levels.WARN
			)
		end, vim.tbl_extend("force", opts, { desc = "Java: Test nearest method (disabled)" }))

		vim.keymap.set("n", "<leader>jT", function()
			vim.notify(
				"Java test functionality is disabled. You'll need to set up test extensions first.",
				vim.log.levels.WARN
			)
		end, vim.tbl_extend("force", opts, { desc = "Java: Test class (disabled)" }))

		vim.keymap.set("n", "<leader>jr", function()
			if vim.fn.filereadable(root_dir .. "/gradlew") == 1 then
				vim.cmd("!cd " .. root_dir .. " && ./gradlew run")
			elseif vim.fn.filereadable(root_dir .. "/mvnw") == 1 then
				vim.cmd("!cd " .. root_dir .. " && ./mvnw exec:java")
			else
				print("No supported build system found")
			end
		end, vim.tbl_extend("force", opts, { desc = "Java: Run project" }))
	end,
}

jdtls.start_or_attach(config)
