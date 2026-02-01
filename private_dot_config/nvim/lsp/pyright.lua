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
