hl.layer_rule({
    name = "logout_dialog",
    blur = true,
    match = {
        namespace = "logout_dialog",
    },
})

hl.layer_rule({
    name = "swww",
    blur = true,
    match = {
        namespace = "awww-daemon",
    },
})

hl.layer_rule({
    name = "rofi",
    blur = true,
    ignore_alpha = 0,
    match = {
        namespace = "rofi",
    },
})

hl.layer_rule({
    name = "swaync",
    blur = true,
    ignore_alpha = 0.5,
    match = {
        namespace = "swaync-control-center",
    },
})

hl.layer_rule({
    name = "swaync-notification",
    blur = true,
    ignore_alpha = 0.5,
    match = {
        namespace = "swaync-notification-window",
    },
})
