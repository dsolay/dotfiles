require'nvim-tree.events'.on_nvim_tree_ready(function ()
  vim.cmd("NvimTreeRefresh")
end)
