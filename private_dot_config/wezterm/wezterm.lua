-- https://github.com/wez/wezterm/blob/main/assets/shell-integration/wezterm.sh
local wezterm = require 'wezterm'
local io = require 'io';
local os = require 'os';
wezterm.on("trigger-vim-with-scrollback", function(window, pane)
    -- Retrieve the current viewport's text.
    -- Pass an optional number of lines (eg: 2000) to retrieve
    -- that number of lines starting from the bottom of the viewport
    wezterm.log_info("trigger-vim-with-scrollback")
    local scrollback = pane:get_lines_as_text();

    -- Create a temporary file to pass to vim
    local name = os.tmpname();
    local f = io.open(name, "w+");
    f:write(scrollback);
    f:flush();
    f:close();

    -- Open a new window running vim and tell it to open the file
    window:perform_action(wezterm.action { SpawnCommandInNewTab = {
        args = { "nvim", name } }
    }, pane)
end)
wezterm.on('update-status', function(window, pane)
    local leader = ''
    if window:leader_is_active() then
        -- leader = ' WAIT '
        leader = wezterm.format {
            { Background = { Color = '#485F84' } },
            { Foreground = { Color = '#FEFEFE' } },
            { Text = ' WAIT ' },
            'ResetAttributes',
        }
    end

    local mode = ''
    local active_table = window:active_key_table()
    if active_table == 'copy_mode' then
        mode = wezterm.format {
            { Background = { Color = '#C1823E' } },
            { Foreground = { Color = '#FEFEFE' } },
            { Text = ' COPY ' },
            'ResetAttributes',
        }
    elseif active_table == 'search_mode' then
        mode = wezterm.format {
            { Background = { Color = '#869496' } },
            { Foreground = { Color = '#FEFEFE' } },
            { Text = ' SEARCH ' },
            'ResetAttributes',
        }
    end

    -- if both leader and mode set

    window:set_right_status(leader .. mode)
end)

local colorscheme = {
    foreground    = "#6B5C4D",
    background    = "#F4F0ED",
    cursor_bg     = "#6B5C4D",
    cursor_border = "#6B5C4D",
    cursor_fg     = "#F4F0ED",
    selection_bg  = "#CC7F2B",
    selection_fg  = "#F4F0ED",
    ansi          = {
        "#E9E1DB", -- black
        "#D7898C", -- red
        "#83B887", -- green
        "#CC7F2B", -- yellow
        "#485F84", -- blue
        "#BE79BB", -- magenta
        "#729893", -- cyan
        "#A38D78"  -- white
    },
    brights       = {
        "#867462", -- bright black
        "#C65333", -- bright red
        "#659E69", -- bright green
        "#C29830", -- bright yellow
        "#ABB9D6", -- bright blue
        "#854882", -- bright magenta
        "#436460", -- bright cyan
        "#6B5C4D"  -- bright white
    },
    split         = "#839496"
}


local window_frame = {
    -- The font used in the tab bar.
    -- Roboto Bold is the default; this font is bundled
    -- with wezterm.
    -- Whatever font is selected here, it will have the
    -- main font setting appended to it to pick up any
    -- fallback fonts you may have used there.
    -- font = wezterm.font { family = 'Roboto', weight = 'Bold' },
    -- font = wezterm.font('Berkeley Mono', { weight = 800, stretch = "Normal", style = "Normal" }),
    font = wezterm.font('Berkeley Mono', { weight = 800, stretch = "Normal", style = "Normal" }),
    -- The size of the font in the tab bar.
    -- Default to 10.0 on Windows but 12.0 on other systems
    font_size = 13.0,

    -- The overall background color of the tab bar when
    -- the window is focused
    active_titlebar_bg = '#eee8d5',

    -- The overall background color of the tab bar when
    -- the window is not focused
    inactive_titlebar_bg = '#eee8d5',
}
-- colorscheme.compose_cursor = 'blue'
colorscheme.tab_bar = {
    background = window_frame.active_titlebar_bg,
    inactive_tab_edge = '#eee8d5',
    active_tab = {
        bg_color = '#839496',
        fg_color = '#eee8d5',
    },

    inactive_tab = {
        bg_color = '#eee8d5',
        fg_color = '#839496',
    },
    inactive_tab_hover = {
        bg_color = '#eee8d5',
        fg_color = '#839496',
        italic = true,
        intensity = 'Bold',
    },

    new_tab = {
        bg_color = '#839496',
        fg_color = '#eee8d5',
    },
    new_tab_hover = {
        bg_color = '#839496',
        fg_color = '#eee8d5',
        italic = true,
    },
}
local keys = {
    -- {
    --     key = "v",
    --     mods = "CTRL",
    --     action = wezterm.action { EmitEvent = "trigger-vim-with-scrollback" }
    -- },
    { key = 'UpArrow',   mods = 'SHIFT', action = wezterm.action.ScrollToPrompt(-1) },
    { key = 'DownArrow', mods = 'SHIFT', action = wezterm.action.ScrollToPrompt(1) },
    {
        key = 'E',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
    {
        key = 'b',
        mods = 'LEADER|CTRL',
        action = wezterm.action.SendKey { key = 'b', mods = 'CTRL' },
    },
    {
        key = '\\',
        mods = 'LEADER',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = '-',
        mods = 'LEADER',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'c',
        mods = 'LEADER',
        action = wezterm.action.SpawnTab('CurrentPaneDomain')
    },
    -- p/n previous next tab
    {
        key = 'p',
        mods = 'LEADER',
        action = wezterm.action.ActivateTabRelative(-1),
    },
    {
        key = 'n',
        mods = 'LEADER',
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key = '[',
        mods = 'LEADER',
        action = wezterm.action.ActivateCopyMode
    },
    {
        mods = 'LEADER',
        key = 'z',
        action = wezterm.action.TogglePaneZoomState
    },

    -- h/j/k/l activate pane
    {
        key = 'h',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Left'),
    },
    {
        key = 'j',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Down'),
    },
    {
        key = 'k',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Up'),
    },
    {
        key = 'l',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Right'),
    },
}

for i = 1, 9 do
    table.insert(keys, {
        key = tostring(i),
        mods = 'LEADER',
        action = wezterm.action.ActivateTab(i - 1),
    })
end

local mouse_bindings = {
    {
        event = { Down = { streak = 3, button = 'Left' } },
        action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
        mods = 'NONE',
    },
}

-- See: https://github.com/azzamsa/dotfiles/blob/master/wezterm/.config/wezterm/configs/keymap.lua
-- https://www.florianbellmann.com/blog/switch-from-tmux-to-wezterm
-- https://github.com/crides/dotfiles/blob/249a84d00003efc485fc3f81cee05f2562d99585/config/wezterm/wezterm.lua#L329
-- https://github.com/mhanberg/.dotfiles/blob/3a82ead67b241d14ffba2cd7f55bbdb0b7cd925c/config/wezterm/wezterm.lua
local copy_mode = nil
local search_mode = nil
if wezterm.gui then
    copy_mode = wezterm.gui.default_key_tables().copy_mode
    local my_copy_mode = {
        {
            key = "Escape",
            mods = "NONE",
            action = wezterm.action.Multiple {
                wezterm.action.ClearSelection,
                wezterm.action { CopyMode = "ClearPattern" },
                wezterm.action { CopyMode = "Close" },
            }
        },
        { key = "h", mods = "NONE", action = wezterm.action { CopyMode = "MoveLeft" } },
        { key = "j", mods = "NONE", action = wezterm.action { CopyMode = "MoveDown" } },
        { key = "k", mods = "NONE", action = wezterm.action { CopyMode = "MoveUp" } },
        { key = "l", mods = "NONE", action = wezterm.action { CopyMode = "MoveRight" } },
        -- Enter search mode to edit the pattern.
        -- When the search pattern is an empty string the existing pattern is preserved
        {
            key = "/",
            mods = "NONE",
            action = wezterm.action { Search = { CaseSensitiveString = "" } },
        },
        -- navigate any search mode results
        { key = "n", mods = "NONE",  action = wezterm.action { CopyMode = "NextMatch" } },
        { key = "N", mods = "SHIFT", action = wezterm.action { CopyMode = "PriorMatch" } },
        { key = 'g', mods = 'NONE',  action = wezterm.action.CopyMode 'MoveToScrollbackTop', },
        { key = 'G', mods = 'NONE',  action = wezterm.action.CopyMode 'MoveToScrollbackBottom', },
    }

    search_mode = wezterm.gui.default_key_tables().search_mode
    local my_search_mode = {
        { key = "Escape", mods = "NONE", action = wezterm.action { CopyMode = "Close" } },
        -- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
        -- to navigate search results without conflicting with typing into the search area.
        { key = "Enter",  mods = "NONE", action = "ActivateCopyMode" },
    }

    for _, val in ipairs(my_copy_mode) do
        table.insert(copy_mode, val)
    end

    for _, val in ipairs(my_search_mode) do
        table.insert(search_mode, val)
    end
end

local function basename(s)
    return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
        local pane = tab.active_pane
        local title = basename(pane.foreground_process_name)
            .. ' '
            .. tab.tab_index + 1
        return {
            { Text = ' ' .. title .. ' ' },
        }
    end
)


return {
    -- NOTE(selman): causes redraw in neovim.
    -- unix_domains = {
    --     { name = "main" },
    -- },
    -- default_gui_startup_args = { "connect", "main" },
    -- default_prog = { '/opt/homebrew/bin/fish', '-l' },
    window_frame = window_frame,
    front_end = "WebGpu",
    webgpu_power_preference = 'HighPerformance',
    max_fps = 120,
    use_fancy_tab_bar = true,
    show_new_tab_button_in_tab_bar = true,
    colors = colorscheme,
    font = wezterm.font('Berkeley Mono', { weight = 800, stretch = "Normal", style = "Normal" }),
    -- freetype_load_flags = 'NO_HINTING'
    font_size = 15.0,
    -- NOTE(selman): to hide inactive cursor.
    -- cursor_thickness = -2,
    window_decorations = "NONE | RESIZE",
    adjust_window_size_when_changing_font_size = false,
    window_padding = {
        left = '2cell',
        right = '2cell',
        top = '0.5cell',
        bottom = '0.25cell',
    },
    keys = keys,
    key_tables = {
        copy_mode = copy_mode,
        search_mode = search_mode,
    },
    mouse_bindings = mouse_bindings,
    leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 },
    inactive_pane_hsb = {},
    force_reverse_video_cursor = true,
    tab_and_split_indices_are_zero_based = false,
}

-- for k, v in pairs(overrides) do
--     config[k] = v
-- end
--

-- return config
