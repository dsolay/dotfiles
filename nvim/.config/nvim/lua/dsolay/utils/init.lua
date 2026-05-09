-- ============================================================================
-- Utils Module
-- ============================================================================
-- Re-exports all utility submodules for convenient access.
--
-- Usage (flat):
--   local utils = require("dsolay.utils")
--   utils.file_exists("path")
--   utils.root()
--   utils.get_absolute_path("path")
--
-- Usage (granular):
--   local root = require("dsolay.utils.root")
--   root.get()
-- ============================================================================

local M = {}

M._root = require("dsolay.utils.root")
M.fs = require("dsolay.utils.fs")
M.table = require("dsolay.utils.table")
M.env = require("dsolay.utils.env")
M.hi = require("dsolay.utils.hi")
M.lsp = require("dsolay.utils.lsp")

M.root_git = M._root.get_git
M.root = M._root.get

M.add_hi = M.hi.add_hi
M.file_exists = M.fs.file_exists
M.includes = M.table.includes
M.merge_tables = M.table.merge_tables
M.get_absolute_path = M.fs.get_absolute_path
M.get_basename = M.fs.get_basename
M.read_theme_mode = M.fs.read_theme_mode
M.get_env_values = M.env.get_values
M.enable_lsp_servers = M.lsp.enable_lsp_servers

return M
