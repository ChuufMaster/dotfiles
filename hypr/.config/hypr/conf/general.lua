local colors = loadfile(os.getenv("HOME") .. "/.cache/wal/colors-hyprland.lua")()

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 5,
        border_size = 2,
        col = {
            active_border = colors.color1,
            inactive_border = "rgba(595959aa)",
        },
        -- col.active_border = $color1 $color2 30deg
        -- col.active_border = colors.color1,
        -- col.inactive_border = "rgba(595959aa)",
        layout = "dwindle",
        resize_on_border = true,
    },
    group = {
        col = {
            border_active = colors.color1,
        },
        groupbar = {
            gradients = true,
            col = {
                active = colors.color1,
                inactive = colors.color8,
            },
            font_size = 14,
            text_offset = -1,
            keep_upper_gap = false,
            gaps_out = 0,
        },
    },

    binds = {
        workspace_back_and_forth = true,
    },
    debug = {
        disable_logs = false,
    },
})
