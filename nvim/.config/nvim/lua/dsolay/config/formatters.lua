-- ============================================================================
-- Formatter Configuration Module
-- ============================================================================
-- Central location for all formatter/linter LSP server configuration.
-- This module defines which language server is used for formatting each filetype.
--
-- Priority System:
--   Lower number = higher priority
--   When multiple formatters match a filetype, the one with lowest priority wins
--   Formatters with empty filetypes array = fallback for unmatched filetypes
--
-- Usage:
--   local formatters = require("dsolay.config.formatters")
--   local best = formatters.get_best_formatter("typescript")  -- Returns formatter table or nil
--   local priorities = formatters.PRIORITIES                  -- Access raw config
-- ============================================================================

local FORMATTERS = {}

-- ============================================================================
-- Formatter Priorities Configuration
-- ============================================================================
FORMATTERS.PRIORITIES = {
    -- Fallback formatter (lowest priority, used if no other matches)
    {
        name = "null-ls",
        priority = 2,
        description = "Default formatter and linter (Prettier, stylua, hadolint, markdownlint, shellcheck, fixjson, etc.)",
        filetypes = {}, -- Empty array = applies to all filetypes as fallback
    },

    -- JavaScript/TypeScript ecosystem
    {
        name = "eslint",
        priority = 1,
        description = "ESLint formatter and linter for JavaScript/TypeScript projects",
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
    },

    -- Database and ORM
    {
        name = "prismals",
        priority = 1,
        description = "Prisma schema formatter for database migrations",
        filetypes = { "prisma" },
    },

    -- Infrastructure and DevOps
    {
        name = "dockerls",
        priority = 1,
        description = "Dockerfile linter and formatter (hadolint)",
        filetypes = { "dockerfile" },
    },

    {
        name = "terraformls",
        priority = 1,
        description = "Terraform HCL formatter for infrastructure as code",
        filetypes = { "tf", "terraform", "hcl" },
    },

    -- Data formats
    {
        name = "jsonls",
        priority = 1,
        description = "JSON schema validation and formatting",
        filetypes = { "json", "jsonc" },
    },

    {
        name = "rumdl",
        priority = 1,
        description = "JSON schema validation and formatting",
        filetypes = { "markdown" },
    },
}

-- ============================================================================
-- Helper Functions
-- ============================================================================

--- Get the best formatter for a given filetype
--- @param filetype string The filetype to find formatter for
--- @return table|nil Formatter config table or nil if no match found
local function get_best_formatter(filetype)
    local best_formatter = nil
    local best_priority = math.huge

    for _, formatter in ipairs(FORMATTERS.PRIORITIES) do
        -- Check if formatter applies to this filetype
        if vim.tbl_contains(formatter.filetypes, filetype) or #formatter.filetypes == 0 then
            -- Keep track of formatter with lowest priority number
            if formatter.priority < best_priority then
                best_priority = formatter.priority
                best_formatter = formatter
            end
        end
    end

    return best_formatter
end

--- Get formatter by name
--- @param name string The formatter name (e.g., "eslint", "null-ls")
--- @return table|nil Formatter config table or nil if not found
local function get_formatter_by_name(name)
    for _, formatter in ipairs(FORMATTERS.PRIORITIES) do
        if formatter.name == name then
            return formatter
        end
    end
    return nil
end

--- Get all formatters for a given filetype (including fallback)
--- @param filetype string The filetype to find formatters for
--- @return table Array of matching formatter config tables
local function get_formatters_for_filetype(filetype)
    local formatters = {}
    for _, formatter in ipairs(FORMATTERS.PRIORITIES) do
        if vim.tbl_contains(formatter.filetypes, filetype) or #formatter.filetypes == 0 then
            table.insert(formatters, formatter)
        end
    end
    return formatters
end

-- ============================================================================
-- Public API
-- ============================================================================

FORMATTERS.get_best_formatter = get_best_formatter
FORMATTERS.get_formatter_by_name = get_formatter_by_name
FORMATTERS.get_formatters_for_filetype = get_formatters_for_filetype

return FORMATTERS
