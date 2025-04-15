local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

ls.config.set_config({
    history = true,
    -- treesitter-hl has 100, use something higher (default is 200).
    ext_base_prio = 200,
    -- minimal increase in priority.
    ext_prio_increase = 1,
    enable_autosnippets = false,
    store_selection_keys = "<TAB>",
})

ls.add_snippets(nil, {
    cs = {
        s(
            {
                trig = "///",
                descr = "XML comment summary",
            },
            fmt(
                [[
    /// <summary>
    /// {}
    /// </summary>{}
    ]],
                {
                    i(1),
                    i(2),
                }
            ),
            {
                callbacks = {
                    [-1] = {
                        -- Set vim comment mode to help continue writing the XML comment
                        -- Pressing the trigger of '///' again would trigger the snippet again
                        [events.enter] = function()
                            vim.cmd("set formatoptions+=cro")
                        end,
                    },

                    [2] = {
                        -- Disable the vim settings after leaving the snippet
                        [events.leave] = function()
                            vim.cmd("set formatoptions-=cro")
                        end,
                    },
                },
            }
        ),
        s(
            "XML XML",
            fmt([[{}]], {
                c(1, {
                    sn(
                        nil,
                        fmt(
                            [[
                   <summary>{}</summary>
                   ]],
                            {
                                i(1, "Test test test"),
                            }
                        )
                    ),

                    sn(
                        nil,
                        fmt(
                            [[
                   <value>{}</value>
                   ]],
                            {
                                i(1, "Test test test"),
                            }
                        )
                    ),

                    sn(
                        nil,
                        fmt(
                            [[
                 <remarks>{}</remarks>
                 ]],
                            {
                                i(
                                    1,
                                    "Specifies that text contains supplementary information about the program element"
                                ),
                            }
                        )
                    ),

                    sn(
                        nil,
                        fmt(
                            [[
                <param name="{}">{}</param>
                ]],
                            {
                                i(1),
                                i(2, "Specifies the name and description for a function or method parameter"),
                            }
                        )
                    ),

                    sn(
                        nil,
                        fmt(
                            [[
                <typeparam name="{}">{}</typeparam>
                ]],
                            {
                                i(1),
                                i(2, "Specifies the name and description for a type parameter"),
                            }
                        )
                    ),

                    sn(
                        nil,
                        fmt(
                            [[
                <returns>{}</returns>
                ]],
                            {
                                i(1, "Describe the return value of a function or method"),
                            }
                        )
                    ),

                    sn(
                        nil,
                        fmt(
                            [[
                <exception cref="{}">{}</exception>
                ]],
                            {
                                i(1, "Exception type"),
                                i(
                                    2,
                                    "Specifies the type of exception that can be generated and the circumstances under which it is thrown"
                                ),
                            }
                        )
                    ),

                    sn(
                        nil,
                        fmt(
                            [[
                <seealso cref="{}"/>
                ]],
                            {
                                i(
                                    1,
                                    "Specifies the type of exception that can be generated and the circumstances under which it is thrown"
                                ),
                            }
                        )
                    ),

                    sn(
                        nil,
                        fmt(
                            [[
                <para>{}</para>
                ]],
                            {
                                i(
                                    1,
                                    "Specifies a paragraph of text. This is used to separate text inside the remarks tag"
                                ),
                            }
                        )
                    ),

                    sn(
                        nil,
                        fmt(
                            [[
                <code>{}</code>
                ]],
                            {
                                i(
                                    1,
                                    "Specifies that text is multiple lines of code. This tag can be used by generators to display text in a font that is appropriate for code"
                                ),
                            }
                        )
                    ),

                    sn(
                        nil,
                        fmt(
                            [[
                <paramref name="{}"/>
                ]],
                            {
                                i(1, "Specifies a reference to a parameter in the same documentation comment"),
                            }
                        )
                    ),

                    sn(
                        nil,
                        fmt(
                            [[
                <typeparamref name="{}"/>
                ]],
                            {
                                i(1, "Specifies a reference to a type parameter in the same documentation comment"),
                            }
                        )
                    ),

                    sn(
                        nil,
                        fmt(
                            [[
                <c>{}</c>
                ]],
                            {
                                i(1, "Specifies a reference to a type parameter in the same documentation comment"),
                            }
                        )
                    ),

                    sn(
                        nil,
                        fmt(
                            [[
                <see cref="{}">{}</see>
                ]],
                            {
                                i(1, "reference"),
                                i(2, "Specifies a reference to a type parameter in the same documentation comment"),
                            }
                        )
                    ),

                    --
                }),
            })
        ),
    },
    sh = {
        s("shebang", {
            t({ "#!/bin/sh", "" }),
            i(0),
        }),
    },
    markdown = {
        -- Select link, press C-s, enter link to receive snippet
        s({
            trig = "link",
            namr = "markdown_link",
            dscr = "Create markdown link [txt](url)",
        }, {
            t("["),
            i(1),
            t("]("),
            f(function(_, snip)
                return snip.env.TM_SELECTED_TEXT[1] or {}
            end, {}),
            t(")"),
            i(0),
        }),
        s({
            trig = "codewrap",
            namr = "markdown_code_wrap",
            dscr = "Create markdown code block from existing text",
        }, {
            t("``` "),
            i(1, "Language"),
            t({ "", "" }),
            f(function(_, snip)
                local tmp = {}
                tmp = snip.env.TM_SELECTED_TEXT
                tmp[0] = nil
                return tmp or {}
            end, {}),
            t({ "", "```", "" }),
            i(0),
        }),
        s({
            trig = "codeempty",
            namr = "markdown_code_empty",
            dscr = "Create empty markdown code block",
        }, {
            t("``` "),
            i(1, "Language"),
            t({ "", "" }),
            i(2, "Content"),
            t({ "", "```", "" }),
            i(0),
        }),
        s({
            trig = "meta",
            namr = "Metadata",
            dscr = "Yaml metadata format for markdown",
        }, {
            t({ "---", "title: " }),
            i(1, "note_title"),
            t({ "", "author: " }),
            i(2, "author"),
            t({ "", "date: " }),
            f(date, {}),
            t({ "", "cathegories: [" }),
            i(3, ""),
            t({ "]", "lastmod: " }),
            f(date, {}),
            t({ "", "tags: [" }),
            i(4),
            t({ "]", "comments: true", "---", "" }),
            i(0),
        }),
    },
})
