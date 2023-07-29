local status, telescope = pcall(require, "telescope")
local troubleStatus, trouble = pcall(require, "trouble.providers.telescope")

if not status or not troubleStatus then
    return
end

telescope.load_extension("project")
telescope.load_extension("fzf")

telescope.setup({
    defaults = {
        layout_strategy = "flex",
        mappings = {
            i = { ["<c-j>"] = trouble.open_with_trouble },
            n = { ["<c-j>"] = trouble.open_with_trouble },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        project = { hidden_files = true },
    },
})
