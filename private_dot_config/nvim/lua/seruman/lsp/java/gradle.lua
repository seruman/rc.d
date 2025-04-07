-- Gradle wrapper checksum handling
local M = {}

local home = vim.fn.expand("~")
local checksums_file = home .. "/.cache/jdtls/trusted_gradle_checksums.json"
local checksums_dir = vim.fn.fnamemodify(checksums_file, ":h")
local trusted_checksums = {}

-- Initialize checksums
function M.init()
	-- Create directory if it doesn't exist
	if vim.fn.isdirectory(checksums_dir) ~= 1 then
		vim.fn.mkdir(checksums_dir, "p")
	end

	-- Load existing checksums
	if vim.fn.filereadable(checksums_file) == 1 then
		local file = io.open(checksums_file, "r")
		if file then
			local content = file:read("*all")
			file:close()
			local ok, decoded = pcall(vim.json.decode, content)
			if ok and type(decoded) == "table" then
				trusted_checksums = decoded
			end
		end
	end

	-- Always include the default checksum
	if not vim.tbl_contains(trusted_checksums, "41c8aa7a337a44af18d8cda0d632ebba469aef34f3041827624ef5c1a4e4419d") then
		table.insert(trusted_checksums, "41c8aa7a337a44af18d8cda0d632ebba469aef34f3041827624ef5c1a4e4419d")
	end

	-- Save now to ensure the file exists with at least the default checksum
	M.save_checksums()

	return trusted_checksums
end

-- Save checksums to file
function M.save_checksums()
	local file = io.open(checksums_file, "w")
	if file then
		file:write(vim.json.encode(trusted_checksums))
		file:close()
	end
end

-- Get trusted checksums
function M.get_trusted_checksums()
	return trusted_checksums
end

-- Return module
return M
