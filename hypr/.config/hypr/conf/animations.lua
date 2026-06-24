hl.animation({
    enabled = false,
    leaf = "windows",
})

hl.animation({
    enabled = false,
    leaf = "global",
})

hl.curve("some_bezier", {
    type = "bezier",
    points = { { 1, 0 }, { 0, 1 } },
})

hl.animation({
    leaf = "windows",
    enabled = true,
    style = "slide",
    speed = 0.1,
    bezier = "some_bezier",
})
