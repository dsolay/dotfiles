let g:db_ui_table_helpers = {
\   'postgresql': {
\     'Delete': 'DELETE FROM "{table}"',
\     'DeleteById': 'DELETE FROM "{table}" WHERE ID = :Id',
\     'BulkDelete': 'DELETE FROM "{table}" WHERE id IN ()'
\   }
\ }

let g:db_ui_force_echo_notifications = 1
let g:db_ui_use_nerd_fonts = 1
let g:db_ui_show_database_icon = 1
