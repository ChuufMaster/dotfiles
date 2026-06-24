for i = 1, 5 do
    hl.workspace_rule({ workspace = "" .. i, monitor = "DP-1" })
end

for i = 6, 7 do
    hl.workspace_rule({ workspace = "" .. i, monitor = "DP-2" })
end

hl.workspace_rule({ workspace = "2", layout = "scrolling" })
hl.workspace_rule({ workspace = "2", animation = "slide" })

-- hl.workspace_rule({ workspace = "6", monitor = "DP-2" })
-- hl.workspace_rule({ workspace = "6", monitor = "DP-2" })

-- hl.workspace_rule({ workspace = "7", monitor = "DP-2" })
-- hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })

-- hl.workspace_rule({ workspace = "8", monitor = "DP-2" })
-- hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
