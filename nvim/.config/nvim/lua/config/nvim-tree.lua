require('nvim-tree').setup {
  disable_netrw   = true,
  hijack_netrw    = true,
  auto_close      = true,
  diagnostics = {enable = true},
  ignore_ft_on_setup  = { 'startify', 'dashboard' },
}
