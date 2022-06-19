local utils = require('utils')
local file_exists = utils.file_exists

local function is_typescript_project()
    local tsconfig_path = vim.loop.cwd() .. '/tsconfig.json'

    return file_exists(tsconfig_path)
end

return {
  settings = {
    vetur = {
      format = {
       enabled = false
      },
      validation = {
        style = false
      },
      experimental = {
        templateInterpolationService = is_typescript_project()
      }
    }
  }
}
