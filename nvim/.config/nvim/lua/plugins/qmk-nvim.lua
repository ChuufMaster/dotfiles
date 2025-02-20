local group = vim.api.nvim_create_augroup("MyQMK", {})

local keymap_overrides = {
    ALT_L = "  l  ",
    ALT_S = "  s  ",
    BS_MED = "bspc",
    CTL_D = "  d  ",
    CTL_ESC = " esc ",
    CTL_K = "  k  ",
    ENT_NAV = " ent ",
    ENT_NUM = " ent ",
    GUI_A = "  a  ",
    GUI_SCN = "  ;  ",
    KC_A = "  a  ",
    KC_D = "  d  ",
    KC_F = "  f  ",
    KC_G = "  g  ",
    KC_H = "  h  ",
    KC_J = "  j  ",
    KC_K = "  k  ",
    KC_L = "  l  ",
    KC_QUOT = "  '  ",
    KC_S = "  s  ",
    KC_SCLN = "  ;  ",
    LALT_CAP = "lalt",
    MO_FN2 = "FN2",
    MO_WIN_FN1 = "FN1",
    NUM_C = "  c  ",
    NUM_M = "  m  ",
    RALT_CAP = "ralt",
    RGB_MOD = " RGB ",
    SFT_F = "  f  ",
    SFT_J = "  j  ",
    SFT_TAB = " tab ",
    SPC_NAV = "spc",
    SPC_NUM = "spc",
    TAB_MED = " tab ",
    TL_LOWR = "lowr",
    TL_UPPR = "uppr",
}

vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Format Keychron",
    group = group,
    pattern = "*k6_pro/ansi/**/keymap.c", -- this is a pattern to match the filepath of whatever board you wish to target
    callback = function()
        require("qmk").setup({
            name = "LAYOUT_ansi_68",
            auto_format_pattern = "*k6_pro/ansi/**/keymap.c",
            layout = {
                "x x x x x x x x x x x x x x x",
                "x x x x x x x x x x x x x x x",
                "x x x x x x x x x x x x x^x x",
                "x x x x x x x x x x x x^x x x",
                "x x x xxxxx^xxxxx x x x x x x",
            },
            comment_preview = {
                keymap_overrides = keymap_overrides,
            },
        })
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Format overlap keymap",
    group = group,
    pattern = "*chuufmaster/keymaps/**/keymap.c",
    callback = function()
        require("qmk").setup({
            name = "LAYOUT",
            auto_format_pattern = "*chuufmaster/keymaps/**/keymap.c",
            layout = {
                "x x x x x x _ _ _ x x x x x x",
                "x x x x x x _ _ _ x x x x x x",
                "x x x x x x _ _ _ x x x x x x",
                "x x x x x x x _ x x x x x x x",
                "_ _ x x x x x _ x x x x x _ _",
            },
            comment_preview = {
                keymap_overrides = keymap_overrides,
            },
        })
    end,
})

return {
    "codethread/qmk.nvim",
    cmd = {
        "QMKFormat",
    },
}
