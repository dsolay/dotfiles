local status, pairs = pcall(require, "mini.pairs")

if (not status) then
    return
end

pairs.setup({})
