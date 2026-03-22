-- ============================================================================
-- Environment Utilities
-- ============================================================================
-- Environment variable helper functions.
-- ============================================================================

local M = {}

--- Split an environment variable value by a delimiter.
--- @param env string Environment variable name
--- @param sep string|nil Delimiter (defaults to ";")
--- @return table Array of values
function M.get_values(env, sep)
    return vim.split(os.getenv(env) or "", sep or ";")
end

return M
