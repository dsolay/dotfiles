local alpha_status, alpha = pcall(require, "alpha")
local dashboard_status, dashboard = pcall(require, "alpha.themes.dashboard")

if not alpha_status or not dashboard_status then
    return
end

local function button(sc, txt, keybind, keybind_opts)
    local b = dashboard.button(sc, txt, keybind, keybind_opts)
    b.opts.hl = "Function"
    b.opts.hl_shortcut = "Type"
    return b
end

-- Set header
dashboard.section.header.val = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
}

-- Set menu
dashboard.section.buttons.val = {
    button("n", "  New file", "<cmd>enew<cr>"),
    button("r", "  Recently opened files", function()
        Snacks.picker.recent()
    end),
    button("f", "󰱼  Find file", function()
        Snacks.picker.files()
    end),
    button("w", "  Find word", function()
        Snacks.picker.grep()
    end),
    button("p", "  Find project", function()
        Snacks.picker.projects({
            dev = { "~/workspace", "~/workspace/aplin/projects", "~/workspace/chivo", "~/workspace/chivo/hub" },
        })
    end),
    button("o", "  Open session"),
    button("t", "  TODO", function()
        Snacks.picker.todo_comments()
    end),
    button("s", "  Settings", function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
    end),
    button("q", "󰗼  Quit", "<cmd>qa<cr>"),
}

dashboard.section.footer.val = "Do one thing, do it well - Unix philosophy"

-- Send config to alpha
alpha.setup(dashboard.opts)
