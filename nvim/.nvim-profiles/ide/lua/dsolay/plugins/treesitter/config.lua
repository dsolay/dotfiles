local status, ts_configs = pcall(require, "nvim-treesitter.configs")

if (not status) then
    return
end

ts_configs.setup({
    ensure_installed = {
        "bash",
        "c",
        "c_sharp",
        "css",
        "dockerfile",
        "gitattributes",
        "gitignore",
        "go",
        "graphql",
        "haskell",
        "html",
        "java",
        "javascript",
        "json",
        "jsonc",
        "kotlin",
        "latex",
        "lua",
        "php",
        "python",
        "regex",
        "rust",
        "scss",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vue",
        "yaml",
    },
    highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = true,
    },
    indent = { enable = false },
    rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
        config = {
            sql = { __default = '-- %s', __multiline = '/* %s */' },
        },
    },
    -- matchup = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
})
