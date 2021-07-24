vim.g.db_ui_table_helpers = {
    postgresql = {
        Delete = 'DELETE FROM "{table}"',
        DeleteById = 'DELETE FROM "{table}" WHERE ID = :Id',
        BulkDelete = 'DELETE FROM "{table}" WHERE id IN ()',
    },
}
vim.g.db_ui_force_echo_notifications = 1
vim.g.db_ui_win_position = 'right'
