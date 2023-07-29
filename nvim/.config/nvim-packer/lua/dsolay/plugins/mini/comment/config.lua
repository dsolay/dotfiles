local status, comment = pcall(require, "mini.comment")

if not status then
    return
end

comment.setup({
    hooks = {
        pre = function()
            require("ts_context_commentstring.internal").update_commentstring()
        end,
    },
})
