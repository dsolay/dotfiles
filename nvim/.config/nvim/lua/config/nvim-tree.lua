require('nvim-tree').setup {
  disable_netrw   = false,
  hijack_netrw    = false,
  auto_close      = true,
  lsp_diagnostics = true,
  ignore_ft_on_setup  = { 'startify', 'dashboard' },
}
