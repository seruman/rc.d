local colors_name = "seruzen"
vim.g.colors_name = colors_name -- Required when defining a colorscheme

local lush = require("lush")
local hsluv = lush.hsluv -- Human-friendly hsl
local util = require("zenbones.util")

local bg = vim.o.background

-- Define a palette. Use `palette_extend` to fill unspecified colors
-- Based on https://github.com/gruvbox-community/gruvbox#palette
-- local palette
-- if bg == "light" then
-- 	palette = util.palette_extend({
-- 		bg = hsluv "#fbf1c7",
-- 		fg = hsluv "#3c3836",
-- 		rose = hsluv "#9d0006",
-- 		leaf = hsluv "#79740e",
-- 		wood = hsluv "#b57614",
-- 		water = hsluv "#076678",
-- 		blossom = hsluv "#8f3f71",
-- 		sky = hsluv "#427b58",
-- 	}, bg)
-- else
-- 	palette = util.palette_extend({
-- 		bg = hsluv "#282828",
-- 		fg = hsluv "#ebdbb2",
-- 		rose = hsluv "#fb4934",
-- 		leaf = hsluv "#b8bb26",
-- 		wood = hsluv "#fabd2f",
-- 		water = hsluv "#83a598",
-- 		blossom = hsluv "#d3869b",
-- 		sky = hsluv "#83c07c",
-- 	}, bg)
-- end
local palette = util.palette_extend({
	bg = hsluv("#f4f0ed"),
	fg = hsluv("#6b5c4d"),
	-- fg = hsluv "#433930",

	-- rose = hsluv("#fb4934"),
	rose = hsluv("#C65333"),

	-- leaf = hsluv("#b8bb26"),
	leaf = hsluv("#659E69"),

	-- wood = hsluv("#fabd2f"),
	wood = hsluv("#C29830"),
	--
	-- water = hsluv("#83a598"),
	water = hsluv("#485F84"),

	-- blossom = hsluv("#d3869b"),
	blossom = hsluv("#d7898c"),

	sky = hsluv("#83B887"),
}, bg)

-- Generate the lush specs using the generator util
local generator = require("zenbones.specs")
local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))

-- Optionally extend specs using Lush
local specs = lush.extends({ base_specs }).with(function()
	return {
		MatchParen { gui = "bold" },
		-- Statement { base_specs.Statement, fg = palette.rose },
		-- Special { fg = palette.water },
		-- Type { fg = palette.sky, gui = "italic" },
	}
end)

-- Pass the specs to lush to apply
lush(specs)

-- Optionally set term colors
-- require("zenbones.term").apply_colors(palette)
