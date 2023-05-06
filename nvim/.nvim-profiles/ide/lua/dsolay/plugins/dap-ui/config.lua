local status, dapui = pcall(require, "dapui")

if not status then
    return
end

dapui.setup()
