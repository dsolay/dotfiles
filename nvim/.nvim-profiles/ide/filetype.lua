vim.g.do_filetype_lua = 1

vim.filetype.add({
    extension = {
        dockerignore = "dockerignore",
    },
    filename = {
        [".env"] = "env",
        ["Dockerfile"] = "dockerfile",
    },
    pattern = {
        [".env.*"] = "env",
        ["*.dockerignore"] = "dockerignore",
        ["Dockerfile.*"] = "dockerfile",
    },
})
