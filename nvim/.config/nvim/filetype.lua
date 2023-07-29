vim.g.do_filetype_lua = 1

vim.filetype.add({
    extension = {
        dockerignore = "dockerignore",
    },
    filename = {
        [".env"] = "env",
        [".cts"] = "typescript",
        ["Dockerfile"] = "dockerfile",
        [".dockerignore"] = "dockerignore",
    },
    pattern = {
        [".env.*"] = "env",
        ["*.dockerignore"] = "dockerignore",
        ["Dockerfile.*"] = "dockerfile",
    },
})
