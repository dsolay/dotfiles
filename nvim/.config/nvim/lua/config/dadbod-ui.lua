vim.g.db_ui_table_helpers = {
    postgresql = {
        Constraints = [[
SELECT con.*
FROM pg_catalog.pg_constraint con
INNER JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
INNER JOIN pg_catalog.pg_namespace nsp ON nsp.oid = connamespace
WHERE nsp.nspname = '{schema}' AND rel.relname = '{table}';]],
        ['Add Foreign Key'] = [[
ALTER TABLE "{schema}"."{table}"
ADD CONSTRAINT {table}_field_fkey FOREIGN KEY (field)
REFERENCES "{schema}".foreign_table (id)
ON UPDATE NO ACTION
ON DELETE CASCADE
NOT VALID;]],
        ['Add Unique Index'] = [[
ALTER TABLE {schema}.{table}
ADD CONSTRAINT {table}_field_key UNIQUE (field);]],
        Delete = 'DELETE FROM "{schema}"."{table}"',
        ['Delete Column'] = 'ALTER TABLE "{schema}"."{table}" DROP COLUMN :col ;',
        ['Delete By Id'] = 'DELETE FROM "{schema}"."{table}" WHERE ID = :id',
        ['Bulk Delete'] = 'DELETE FROM "{schema}"."{table}" WHERE id IN (:ids)',
        ['Drop Table'] = 'DROP TABLE IF EXISTS {table}',
    },
    mysql = {
        ['Add Foreign Key'] = [[ALTER TABLE `{table}`
ADD CONSTRAINT FK_field
FOREIGN KEY (field)
REFERENCES foreign_table(foreign_field)
ON DELETE CASCADE;]],
        Constrains = [[USE INFORMATION_SCHEMA;
SELECT TABLE_NAME,
       COLUMN_NAME,
       CONSTRAINT_NAME,
       REFERENCED_TABLE_NAME,
       REFERENCED_COLUMN_NAME
FROM KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = `{dbname}`
  AND TABLE_NAME = `{table}`]],
        Delete = 'DELETE FROM `{table}`',
        ['Delete By Id'] = 'DELETE FROM `{table}` WHERE ID = :id',
        Explain = 'EXPLAIN ANALYZE {last_query}',
        Count = 'SELECT COUNT(*) FROM {table}',
    },
}
vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_force_echo_notifications = 1
vim.g.db_ui_win_position = 'right'

