-- ============================================================================
-- Root Directory Utilities
-- ============================================================================
-- Utilities for finding project root directories using vim.fs.root().
--
-- Usage:
--   local root = require("dsolay.utils.root")
--   local dir = root.get()           -- Root of current buffer
--   local dir = root.get(bufnr)      -- Root of specific buffer
--   local dir = root.get_git()      -- Git root only (.git marker)
--   local dir = root.has()          -- Check if root marker exists
-- ============================================================================

local M = {}

-- ============================================================================
-- Configuration
-- ============================================================================

M.DEFAULT_MARKERS = {
    ".git",
    ".svn",
    ".hg",
    "package.json",
    "Cargo.toml",
    "go.mod",
    "pyproject.toml",
    "Makefile",
    ".env",
    ".env.local",
}

M.markers = M.DEFAULT_MARKERS

-- ============================================================================
-- Functions
-- ============================================================================

--- Get the root directory for a buffer using configured markers.
--- @param bufnr integer|nil Buffer number (nil for current buffer)
--- @return string|nil Root directory path or nil if not found
function M.get(bufnr)
    return vim.fs.root(bufnr or 0, M.markers)
end

--- Get the git root directory for a buffer.
--- @param bufnr integer|nil Buffer number (nil for current buffer)
--- @return string|nil Git root path or nil if not in a git repo
function M.get_git(bufnr)
    return vim.fs.root(bufnr or 0, ".git")
end

--- Check if a root directory marker exists in the path.
--- @param bufnr integer|nil Buffer number (nil for current buffer)
--- @return boolean True if a root marker was found
function M.has(bufnr)
    return M.get(bufnr) ~= nil
end

--- Set custom markers for root detection.
--- @param markers table Array of marker names
function M.set_markers(markers)
    M.markers = markers
end

--- Reset markers to default configuration.
function M.reset_markers()
    M.markers = M.DEFAULT_MARKERS
end

--- Check if a path is inside the root directory.
--- @param path string|nil Path to check (nil for current buffer's path)
--- @return boolean True if path is inside root
function M.is_inside(path)
    local root = M.get()
    if not root or not path then
        return false
    end
    local full_path = vim.fs.normalize(path)
    return full_path:find("^" .. vim.pesc(root)) ~= nil
end

return M
