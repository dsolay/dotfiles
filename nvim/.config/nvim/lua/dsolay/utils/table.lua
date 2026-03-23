-- ============================================================================
-- Table Utilities
-- ============================================================================
-- Table manipulation helper functions.
-- ============================================================================

local M = {}

--- Check if a value exists in an array.
--- @param tab table Array to search
--- @param val any Value to find
--- @return boolean True if value is found
function M.includes(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

--- Deep-merge source table into destination table.
--- @param dest table Destination table (modified in place)
--- @param src table Source table to merge from
--- @return table The destination table
function M.merge_tables(dest, src)
    for key, value in pairs(src) do
        if type(value) == "table" then
            if type(dest[key] or false) == "table" then
                M.merge_tables(dest[key], value)
            else
                dest[key] = value
            end
        else
            dest[key] = value
        end
    end
    return dest
end

return M
