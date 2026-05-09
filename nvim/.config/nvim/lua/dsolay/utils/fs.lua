-- ============================================================================
-- Filesystem Utilities
-- ============================================================================
-- File system helper functions.
-- ============================================================================

local M = {}

--- Check if a file exists at the given path.
--- @param path string File path to check
--- @return boolean True if file exists and is readable
function M.file_exists(path)
    local file = io.open(path, "r")
    if file ~= nil then
        io.close(file)
        return true
    end
    return false
end

--- Get the basename of a file path.
--- @param file_path string Full file path
--- @return string Basename (last path component)
function M.get_basename(file_path)
    return file_path:match("([^/]+)$")
end

--- Get the absolute (resolved) path of a file.
--- @param file_path string File path to resolve
--- @return string Absolute path
function M.get_absolute_path(file_path)
    local handle = io.popen('readlink -f "' .. file_path .. '"')
    local result = handle:read("*a")
    handle:close()
    return result:gsub("\n", "")
end

function M.read_theme_mode()
    local theme_file = os.getenv("HOME") .. "/.theme_mode"
    local file = io.open(theme_file, "r")

    if file then
        local theme = file:read("*line")
        file:close()
        if theme then
            theme = theme:match("^%s*(.-)%s*$")
            if theme == "dark" or theme == "light" then
                return theme
            end
        end
    end
    return "dark"
end

return M
