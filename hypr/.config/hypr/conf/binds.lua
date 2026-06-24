-- Hyprland Lua config - keybinds
-- Converted from hyprlang (.conf) to Lua for Hyprland 0.55+
-- Place at: ~/.config/hypr/hyprland.lua
-- Docs: https://wiki.hypr.land/Configuring/Start/

local mainMod = "SUPER"
local scripts = "~/scripts"

-- ─────────────────────────────────────────────
-- BINDS CONFIG
-- ─────────────────────────────────────────────
hl.config({
    binds = {
        window_direction_monitor_fallback = true,
        movefocus_cycles_groupfirst = false,
    },
})

-- ─────────────────────────────────────────────
-- ACTIONS
-- ─────────────────────────────────────────────
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd("kitty --class floating btop"))
hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd("nm-connection-editor"))
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd("rofi-rbw"))
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.exec_cmd("kitty --class floating"))
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd("blueman-manager"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(scripts .. "/reload-waybar.sh"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("rofi -show calc"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(scripts .. "/emoji.sh"))
hl.bind(mainMod .. " + SHIFT + Home", hl.dsp.exec_cmd(scripts .. "/keybindings.sh"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("PREVIEW=true " .. scripts .. "/wallpaperSelect.sh"))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(scripts .. "/vpn_picker.sh"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(scripts .. "/reload-swaync.sh"))
hl.bind(mainMod .. " + SHIFT + semicolon", hl.dsp.exec_cmd("rofi -show window"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("~/.config/ml4w/settings/browser.sh"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("zen-browser"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("~/.config/ml4w/settings/filemanager.sh"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + P", hl.dsp.layout("pseudo"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd('rofi -ssh-command "{terminal} -e {ssh-client} {host} -t bash -o vi" -show ssh'))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(
    mainMod .. " + V",
    hl.dsp.exec_cmd(
        "rofi -modi clipboard:/home/chuufmaster/scripts/cliphist-rofi-img.sh"
            .. " -show clipboard -show-icons"
            .. " -theme $HOME/.config/rofi/themes/clipboard.rasi"
    )
)
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("wlogout -b 4"))
hl.bind(mainMod .. " + Y", hl.dsp.layout("togglesplit"))

-- ─────────────────────────────────────────────
-- OVERVIEW / TAB
-- ─────────────────────────────────────────────
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("qs ipc -c overview call overview toggle"))

-- ─────────────────────────────────────────────
-- SCREENSHOTS
-- ─────────────────────────────────────────────
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot -m window --clipboard-only"))
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("hyprshot -m window --clipboard-only"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output --clipboard-only"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

-- ─────────────────────────────────────────────
-- FOCUS SWITCHING
-- ─────────────────────────────────────────────
hl.bind("ALT + Tab", hl.dsp.focus({ last = true }))
hl.bind(mainMod .. " + A", hl.dsp.focus({ last = true }))

-- ─────────────────────────────────────────────
-- GROUPS
-- ─────────────────────────────────────────────
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + left", hl.dsp.group.prev())
hl.bind(mainMod .. " + right", hl.dsp.group.next())
hl.bind(mainMod .. " + down", hl.dsp.group.move_window({ forward = true }))
hl.bind(mainMod .. " + up", hl.dsp.group.move_window({ forward = false }))

local left_right = { "left", "right", "up", "down" }
for _, dir in ipairs(left_right) do
    hl.bind(mainMod .. " + SHIFT + " .. dir, function()
        local active_window = hl.get_active_window()
        if active_window == nil then
            return
        end
        if active_window.group == nil then
            if hl.get_active_workspace().tiled_layout == "scrolling" then
                hl.dispatch(hl.dsp.window.move({ direction = dir }))
            end
            hl.dispatch(hl.dsp.window.move({ into_group = dir }))
        else
            hl.dispatch(hl.dsp.window.move({ out_of_group = dir }))
        end
    end)
end

-- ─────────────────────────────────────────────
-- WINDOW FOCUS (vim-style)
-- ─────────────────────────────────────────────
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))

hl.bind(mainMod .. "+ ALT + H", hl.dsp.focus({ monitor = "l" }))
hl.bind(mainMod .. "+ ALT + L", hl.dsp.focus({ monitor = "r" }))
hl.bind(mainMod .. "+ ALT + K", hl.dsp.focus({ monitor = "u" }))
hl.bind(mainMod .. "+ ALT + J", hl.dsp.focus({ monitor = "d" }))

-- ─────────────────────────────────────────────
-- MONITOR / WORKSPACE CYCLING
-- ─────────────────────────────────────────────
hl.bind(mainMod .. " + bracketleft", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + bracketright", hl.dsp.focus({ workspace = "e+1" }))

-- ─────────────────────────────────────────────
-- RESIZE WINDOWS (repeating)
-- ─────────────────────────────────────────────
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })

-- ─────────────────────────────────────────────
-- MOVE WINDOWS
-- ─────────────────────────────────────────────
-- hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
-- hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

local left_right_dir = { { "H", "l" }, { "L", "r" }, { "J", "d" }, { "K", "u" } }
for _, dir in ipairs(left_right_dir) do
    hl.bind(mainMod .. " + SHIFT + " .. dir[1], function()
        local active_workspace = hl.get_active_workspace()
        if active_workspace == nil then
            return
        end
        if active_workspace.tiled_layout == "dwindle" then
            hl.dispatch(hl.dsp.window.move({ direction = dir[2] }))
        elseif active_workspace.tiled_layout == "scrolling" then
            hl.dispatch(hl.dsp.layout("swapcol " .. dir[2]))
        end
    end)
end

hl.bind(mainMod .. " + COMMA", function()
    local workspace = hl.get_active_workspace()
    hl.notification.create({ text = workspace.tiled_layout, duration = 3000, icon = "ok" })
end)

-- ─────────────────────────────────────────────
-- SWITCH WORKSPACES (mainMod + 0-9)
-- ─────────────────────────────────────────────
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- ALT mapping (mirrors workspaces 1-5 <-> 6-10)
local altMap = { 6, 7, 8, 9, 10, 1, 2, 3, 4, 5 }
for i, ws in ipairs(altMap) do
    local key = i == 10 and "0" or tostring(i)
    hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.focus({ workspace = ws }))
end

-- ─────────────────────────────────────────────
-- MOVE WINDOW TO WORKSPACE (mainMod + SHIFT/CTRL + 0-9)
-- ─────────────────────────────────────────────
for i = 1, 9 do
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
end
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))
hl.bind(mainMod .. " + CTRL + 0", hl.dsp.window.move({ workspace = 10, follow = false }))

-- ─────────────────────────────────────────────
-- SCROLL THROUGH WORKSPACES WITH MOUSE WHEEL
-- ─────────────────────────────────────────────
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- ─────────────────────────────────────────────
-- MOVE / RESIZE WINDOWS WITH MOUSE
-- ─────────────────────────────────────────────
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ─────────────────────────────────────────────
-- AUDIO / MEDIA KEYS
-- ─────────────────────────────────────────────
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volumectl up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volumectl down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volumectl toggle-mute"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("volumectl -m toggle-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("lightctl up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("lightctl down"))

-- ─────────────────────────────────────────────
-- SPOTIFY PLAYER CONTROLS
-- ─────────────────────────────────────────────
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("spotify_player playback play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("spotify_player playback next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("spotify_player playback previous"))

-- ─────────────────────────────────────────────
-- PASS KEYS TO SPECIFIC PROGRAMS
-- ─────────────────────────────────────────────
hl.bind(mainMod .. " + U", function()
    hl.dispatch(hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "space", window = "title:^(.*[Ss]lack.*)$" }))
    hl.dispatch(hl.dsp.exec_cmd("playerctl play-pause"))
end)

hl.bind("CTRL + SHIFT + space", hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "space", window = "title:^(.*[Ss]lack.*)$" }))
hl.bind("CTRL + SHIFT + M", hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "M", window = "title:^(.*[Dd]iscord.*)$" }))
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "M", window = "title:^(.*[Dd]iscord.*)$" }))

hl.bind("SUPER + SHIFT + I", function()
    -- Check actual process state instead of relying on the variable
    local handle = io.popen("pidof hypridle")
    local result = handle:read("*a")
    handle:close()
    local is_running = result ~= nil and result ~= ""

    if is_running then
        hl.dispatch(hl.dsp.exec_cmd("pkill hypridle"))
        hl.dispatch(hl.dsp.exec_cmd("notify-send -u normal -i dialog-warning 'Idle Inhibited' 'Screen will not sleep'"))
    else
        hl.dispatch(hl.dsp.exec_cmd("hypridle"))
        hl.dispatch(hl.dsp.exec_cmd("notify-send -u low -i dialog-information 'Idle Enabled' 'Screen will sleep normally'"))
    end
end, { description = "Toggle idle inhibit" })
