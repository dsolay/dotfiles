local cmd = vim.cmd

local function add_hi(hi_name, fg, bg, bold)
    local hi = string.format("hi %s guifg=%s guibg=%s gui=%s", hi_name, fg, bg, bold and "bold" or "none")

    cmd(hi)
end

local function file_exists(path)
    local file = io.open(path, "r")
    if file ~= nil then
        io.close(file)
        return true
    else
        return false
    end
end

local function includes(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function get_env_values(env)
    return vim.split(os.getenv(env) or "", ";")
end

local function merge_tables(dest, src)
    for key, value in pairs(src) do
        if type(value) == "table" then
            if type(dest[key] or false) == "table" then
                merge_tables(dest[key], value)
            else
                dest[key] = value
            end
        else
            dest[key] = value
        end
    end
    return dest
end

return {
    add_hi = add_hi,
    file_exists = file_exists,
    includes = includes,
    get_env_values = get_env_values,
    merge_tables = merge_tables,
}
