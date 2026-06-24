hl.window_rule({
    name = "discord",
    workspace = 6,
    no_initial_focus = true,
    match = {
        title = "^(.*[D|d]iscord.*)$",
    },
})

hl.window_rule({
    name = "claude",
    workspace = 8,
    no_initial_focus = true,
    match = {
        title = "claude",
    },
})

hl.window_rule({
    name = "obisidian",
    opacity = "1.0 override",
    focus_on_activate = false,
    match = {
        class = "obsidian",
    },
})

hl.window_rule({
    name = "fullscreen",
    idle_inhibit = "fullscreen",
    no_anim = true,
    match = {
        fullscreen = true,
    },
})

hl.window_rule({
    name = "polkit-auth-agent",
    float = true,
    match = {
        class = "org.kde.polkit-kde-authentication-agent-1",
    },
})

hl.window_rule({
    name = "floaters",
    float = true,
    match = {
        class = "nm-connection-editor|blueman-manager|pavucontrol|eog|rofi|gnome-system-monitor|yad|launch_yazi.sh",
    },
})

hl.window_rule({
    name = "pulseaudio",
    float = true,
    size = { "monitor_wa * 0.5", "monitor_h * 0.5" },
    match = {
        class = "org.pulseaudio.pavucontrol",
    },
})

hl.window_rule({
    name = "floating",
    float = true,
    size = { "monitor_w * 0.5", "monitor_h * 0.5" },
    match = {
        class = "floating",
    },
})

hl.window_rule({
    name = "rofi",
    opacity = "0.9 0.6",
    match = {
        class = "^[Rr]ofi)$",
    },
})

hl.window_rule({
    name = "yad",
    opacity = "0.9 0.7",
    match = {
        class = "^(yad)$",
    },
})

hl.window_rule({
    name = "zathura",
    opacity = "1.0 override",
    match = {
        class = "^(org.pwmt.zathura)$",
    },
})

hl.window_rule({
    name = "picture-in-picture",
    opacity = "1.0 override",
    pin = true,
    float = true,
    size = { "monitor_w * 0.25", "monitor_h * 0.25" },
    move = { "monitor_w * 0.72", "monitor_h * 0.07" },
    match = {
        title = "^(Picture-in-Picture)$",
    },
})

hl.window_rule({
    name = "xwaylandvideobridge",
    opacity = "0.0 override 0.0 override",
    no_anim = true,
    no_initial_focus = true,
    max_size = { 1, 1 },
    no_blur = true,
    match = {
        class = "^(xwaylandvideobridge)$",
    },
})
