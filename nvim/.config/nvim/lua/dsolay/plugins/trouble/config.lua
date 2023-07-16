local status, trouble = pcall(require, "trouble")

if not status then
    return
end

trouble.setup({
    use_diagnostic_signs = true,
})
