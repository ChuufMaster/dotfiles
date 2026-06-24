hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("~/scripts/wallpaper.sh &")
    hl.exec_cmd("swaync")
    hl.exec_cmd("avizo-service")
    -- hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprpm reload -n")
    hl.exec_cmd("nm-applet --indicator &")
    hl.exec_cmd("blueman-applet &")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("qs -c overview")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user import-environment QT_QPA_PLATFORMTHEME")
    hl.exec_cmd("kitty", {
        workspace = "1",
        no_initial_focus = true,
    })
    hl.exec_cmd("zen-browser", {
        workspace = "1",
        no_initial_focus = true,
    })
    hl.exec_cmd("spotify-launcher", {
        workspace = "3",
        no_initial_focus = true,
    })
    hl.exec_cmd("~/projects/librepods/linux/build/librepods", {
        workspace = "3",
        no_initial_focus = true,
    })
    hl.exec_cmd("thunderbird", {
        workspace = "4",
        no_initial_focus = true,
    })
    hl.exec_cmd("discord", {
        workspace = "6",
        no_initial_focus = true,
    })
    -- hl.exec_cmd("slack", {
    --     workspace = "6",
    --     no_initial_focus = true,
    -- })
    hl.exec_cmd("TMetricDesktop.AppImage &", {
        workspace = "7",
        no_initial_focus = true,
    })
    -- hl.exec_cmd("signal-desktop", {
    --     workspace = "7",
    --     no_initial_focus = true,
    -- })
    hl.exec_cmd("~/scripts/restart-xdg-portal.sh &")
end)
