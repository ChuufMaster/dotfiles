hl.monitor({
    output = "DP-1",
    mode = "3440x1440@143.97",
    position = "0x0",
    scale = "1",
    cm = "auto",
    -- cm = "hdr",
    -- bitdepth = 10,
    -- sdr_min_luminance = 10,
})

hl.monitor({
    output = "DP-2",
    mode = "2560x1440@99.95",
    position = "3440x-720",
    scale = "1.0",
    transform = 1,
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "2560x1440@75",
    position = "3440x0",
    scale = "1.333333",
    transform = 1,
})

hl.config({
    xwayland = {
        force_zero_scaling = false,
    },
})
