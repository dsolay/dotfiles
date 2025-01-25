vim.g.do_filetype_lua = 1

vim.filetype.add({
    extension = {
        dockerignore = "dockerignore",
        hurl = "hurl",
        cts = "typescript",
        tf = "terraform",
    },
    filename = {
        [".env"] = "env",
        ["Dockerfile"] = "dockerfile",
        [".dockerignore"] = "dockerignore",
    },
    pattern = {
        [".env.*"] = "env",
        ["*.dockerignore"] = "dockerignore",
        ["Dockerfile.*"] = "dockerfile",
    },
})
