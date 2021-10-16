local utils = require('utils')
local file_exists = utils.file_exists

local function get_package_manager()
    local base_path = vim.loop.cwd()

    if (file_exists(base_path .. '/yarn.lock')) then
        return "yarn"
    elseif (file_exists(base_path .. '/package-lock.json')) then
        return 'npm'
    end

    return 'pnpm'
end

return {
    filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
        'vue',
    },
    settings = {format = false, packageManager = get_package_manager()},
}
