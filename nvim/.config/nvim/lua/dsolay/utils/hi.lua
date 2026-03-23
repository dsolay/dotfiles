-- ============================================================================
-- Highlight Utilities
-- ============================================================================
-- Neovim highlight helper functions.
-- ============================================================================

local M = {}

--- Add a vim highlight.
--- @param hi_name string Highlight group name
--- @param fg string Foreground color
--- @param bg string Background color
--- @param bold boolean|nil Whether to apply bold (default false)
function M.add_hi(hi_name, fg, bg, bold)
    vim.cmd(string.format("hi %s guifg=%s guibg=%s gui=%s", hi_name, fg, bg, bold and "bold" or "none"))
end

return M
