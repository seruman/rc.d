-- Java LSP utility functions
local M = {}

local home = vim.fn.expand("~")

-- Get all installed Java versions from SDKMAN
function M.get_sdkman_java_versions()
	local sdkman_java_dir = home .. "/.sdkman/candidates/java"
	local java_version_pattern = "(%d+)%.(%d+)%.(%d+)[%-_]?([^/]*)"

	-- Check if SDKMAN is installed
	if vim.fn.isdirectory(sdkman_java_dir) ~= 1 then
		return {}
	end

	-- Read all subdirectories in the SDKMAN Java directory
	local handle = io.popen("ls -1 " .. sdkman_java_dir .. " 2>/dev/null")
	if not handle then
		return {}
	end

	local found_versions = {}

	for line in handle:lines() do
		if line ~= "current" then
			local path = sdkman_java_dir .. "/" .. line

			-- Parse version from directory name
			local major = line:match(java_version_pattern)
			if major then
				major = tonumber(major)
				table.insert(found_versions, {
					path = path,
					version = line,
					major = major,
					is_default = vim.fn.isdirectory(sdkman_java_dir .. "/current") == 1
						and vim.fn.resolve(sdkman_java_dir .. "/current") == path,
				})
			end
		end
	end

	handle:close()

	-- Sort versions by major (descending) so newest appears first
	table.sort(found_versions, function(a, b)
		return a.major > b.major
	end)

	return found_versions
end

-- Find Java installations (prefer SDKMAN first, fallback to system Java)
function M.find_java_home()
	local versions = M.get_sdkman_java_versions()

	-- Use first (newest) SDKMAN version if available
	if #versions > 0 then
		return versions[1].path
	end

	-- Fall back to JAVA_HOME environment variable
	if vim.env.JAVA_HOME and vim.fn.isdirectory(vim.env.JAVA_HOME) == 1 then
		return vim.env.JAVA_HOME
	end

	-- Last resort - try to find java in PATH
	local handle = io.popen("which java 2>/dev/null")
	if handle then
		local java_path = handle:read("*l")
		handle:close()
		if java_path then
			-- Extract JAVA_HOME from the java path (remove /bin/java)
			return vim.fn.fnamemodify(java_path, ":h:h")
		end
	end

	-- Default to a common location if nothing found
	return "/usr/lib/jvm/java-17-openjdk"
end

-- Check project JVM version from various files
function M.detect_project_java_version(root_dir)
	local version_files = {
		".java-version", -- common version file
		".sdkmanrc", -- SDKMAN version file
		".tool-versions", -- asdf version file
		"build.gradle", -- Gradle
		"pom.xml", -- Maven
	}

	for _, file in ipairs(version_files) do
		local file_path = root_dir .. "/" .. file
		if vim.fn.filereadable(file_path) == 1 then
			local handle = io.open(file_path, "r")
			if handle then
				local content = handle:read("*all")
				handle:close()

				-- Look for version patterns
				local version_patterns = {
					"sourceCompatibility%s*=%s*['\"]([%d%.]+)['\"]", -- Gradle
					"<java%.version>([%d%.]+)</java%.version>", -- Maven
					"java=([%d%.]+)", -- .sdkmanrc
					"java%s+([%d%.]+)", -- .tool-versions
					"^([%d%.]+)$", -- .java-version
				}

				for _, pattern in ipairs(version_patterns) do
					local match = string.match(content, pattern)
					if match then
						local major = string.match(match, "^(%d+)")
						if major then
							return tonumber(major)
						end
					end
				end
			end
		end
	end

	-- Default to Java 17 if we can't detect
	return 17
end

-- Setup gradle checksums
function M.setup_gradle_checksums(root_dir, trusted_checksums, save_checksums_func)
	-- Prepare the checksum entries for JDTLS config
	local checksum_entries = {}
	for _, cs in ipairs(trusted_checksums) do
		table.insert(checksum_entries, {
			sha256 = cs,
			allowed = true,
		})
	end

	-- Check if gradle wrapper exists and get its checksum
	local gradle_wrapper_jar = root_dir .. "/gradle/wrapper/gradle-wrapper.jar"
	if vim.fn.filereadable(gradle_wrapper_jar) == 1 then
		-- Try to get checksum with sha256sum command
		local handle = io.popen("sha256sum " .. gradle_wrapper_jar .. " 2>/dev/null")
		local checksum = nil

		if handle then
			local result = handle:read("*a")
			handle:close()

			-- Extract checksum from output (first word)
			checksum = result:match("%w+")
		end

		-- Try openssl if sha256sum failed
		if not checksum then
			handle = io.popen("openssl dgst -sha256 " .. gradle_wrapper_jar .. " 2>/dev/null")
			if handle then
				local result = handle:read("*a")
				handle:close()

				-- Extract checksum from openssl output (last word)
				checksum = result:match("%w+$")
			end
		end

		-- If we have a checksum but it's not trusted yet, prompt user
		if checksum and not vim.tbl_contains(trusted_checksums, checksum) then
			vim.defer_fn(function()
				local choice = vim.fn.confirm("Trust Gradle wrapper with checksum: " .. checksum .. "?", "&Yes\n&No", 1)

				if choice == 1 then -- Yes
					-- Add to trusted checksums
					table.insert(trusted_checksums, checksum)
					save_checksums_func()

					-- Restart JDTLS
					local clients = vim.lsp.get_clients({ name = "jdtls" })
					if clients and #clients > 0 then
						vim.lsp.stop_client(clients[1].id)
					end

					-- Wait a bit then restart with the new configuration
					vim.defer_fn(function()
						vim.cmd("edit") -- Force buffer reload
					end, 500)

					vim.notify("Gradle checksum trusted and saved. JDTLS will restart.", vim.log.levels.INFO)
				else
					vim.notify("Gradle checksum not trusted. Some JDTLS features may not work.", vim.log.levels.WARN)
				end
			end, 100) -- Small delay to ensure the UI is ready
		end
	end

	return checksum_entries
end

-- Download Lombok jar if needed
function M.ensure_lombok(workspace_dir)
	local lombok_path = workspace_dir .. "/lombok.jar"
	if vim.fn.filereadable(lombok_path) ~= 1 then
		print("Lombok jar not found. Downloading...")
		local cmd = string.format("curl -L https://projectlombok.org/downloads/lombok.jar -o %s", lombok_path)
		os.execute(cmd)
	end
	return lombok_path
end

-- Get Java runtime configuration for JDTLS
function M.get_java_runtimes(java_home, project_java_version)
	local runtimes = {}
	local versions = M.get_sdkman_java_versions()

	-- Java version to JVM standard mapping
	local java_mapping = {
		[8] = "JavaSE-1.8",
		[9] = "JavaSE-9",
		[10] = "JavaSE-10",
		[11] = "JavaSE-11",
		[12] = "JavaSE-12",
		[13] = "JavaSE-13",
		[14] = "JavaSE-14",
		[15] = "JavaSE-15",
		[16] = "JavaSE-16",
		[17] = "JavaSE-17",
		[18] = "JavaSE-18",
		[19] = "JavaSE-19",
		[20] = "JavaSE-20",
		[21] = "JavaSE-21",
		[22] = "JavaSE-22",
	}

	-- Add all found Java versions from SDKMAN
	for _, version in ipairs(versions) do
		if java_mapping[version.major] then
			table.insert(runtimes, {
				name = java_mapping[version.major],
				path = version.path,
				-- Set default based on project version or select the latest as fallback
				default = (version.major == project_java_version)
					or (project_java_version == nil and version.is_default)
					or (#runtimes == 0 and not project_java_version),
			})
		end
	end

	-- If we have system Java, add it too (if we don't already have a runtime for its version)
	if vim.env.JAVA_HOME and vim.fn.isdirectory(vim.env.JAVA_HOME) == 1 then
		local handle = io.popen(vim.env.JAVA_HOME .. "/bin/java -version 2>&1")
		if handle then
			local output = handle:read("*a")
			handle:close()

			-- Try to extract version, typically in format: "openjdk version \"11.0.9\""
			local major = output:match('version%s+"(%d+)')
			if major then
				major = tonumber(major)

				-- Check if we already have this major version
				local has_version = false
				for _, runtime in ipairs(runtimes) do
					if runtime.name == java_mapping[major] then
						has_version = true
						break
					end
				end

				if not has_version and java_mapping[major] then
					table.insert(runtimes, {
						name = java_mapping[major],
						path = vim.env.JAVA_HOME,
						default = major == project_java_version and #runtimes == 0,
					})
				end
			end
		end
	end

	-- If no runtimes found, add a dummy to prevent errors, using the java_home we found earlier
	if #runtimes == 0 then
		vim.notify("Warning: No Java runtimes found. JDTLS may not work properly.", vim.log.levels.WARN)
		table.insert(runtimes, {
			name = "JavaSE-17", -- Most current LTS at time of writing
			path = java_home,
			default = true,
		})
	end

	return runtimes
end

-- Return module
return M
