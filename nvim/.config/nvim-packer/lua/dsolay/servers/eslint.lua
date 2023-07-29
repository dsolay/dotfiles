local utils_status, utils = pcall(require, "dsolay.utils")

if not utils_status then
    return
end

local function get_package_manager()
    local base_path = vim.loop.cwd() .. "/"
    local package_managers = { yarn = "yarn.lock", npm = "package-lock.json" }

    for key, value in pairs(package_managers) do
        if utils.file_exists(base_path .. value) then
            return key
        end
    end

    return "pnpm"
end

local function setup(lspconfig, on_attach, capabilities)
    lspconfig.eslint.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            packageManager = get_package_manager(),
        },
    })
end

return setup
