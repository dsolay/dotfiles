local configs = require("lspconfig.configs")
local util = require("lspconfig.util")

local function get_typescript_server_path(root_dir)
    local project_root = util.find_node_modules_ancestor(root_dir)

    local local_tsserverlib = project_root ~= nil and util.path.join(project_root, "node_modules", "typescript", "lib")

    if local_tsserverlib and util.path.exists(local_tsserverlib) then
        return local_tsserverlib
    else
        local version = vim.fn.system([[nodenv version | awk '{print $1}']])

        local global_tsserverlib = table.concat({
            os.getenv("HOME"),
            "/.anyenv/envs/nodenv/versions/",
            string.gsub(version, "\n", ""),
            "/lib/node_modules/typescript/lib",
        })

        return global_tsserverlib
    end
end

local function on_new_config(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
end

local servers_dir = os.getenv("HOME") .. "/.local/share/nvim/lsp_servers"

local volar_cmd = {
    servers_dir .. "/volar/node_modules/.bin/vue-language-server",
    "--stdio",
}
local volar_root_dir = util.root_pattern("package.json")

print()

configs.volar_api = {
    default_config = {
        cmd = volar_cmd,
        root_dir = volar_root_dir,
        -- on_new_config = on_new_config,

        -- filetypes = {'vue'},
        -- If you want to use Volar's Take Over Mode (if you know, you know)
        filetypes = {
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "vue",
            "json",
        },
        init_options = {
            typescript = { tsdk = "node_modules/typescript/lib" },
        },
    },
}

configs.volar_doc = {
    default_config = {
        cmd = volar_cmd,
        root_dir = volar_root_dir,
        -- on_new_config = on_new_config,

        -- filetypes = {'vue'},
        -- If you want to use Volar's Take Over Mode (if you know, you know):
        filetypes = {
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "vue",
            "json",
        },
        init_options = {
            typescript = { tsdk = "node_modules/typescript/lib" },
        },
    },
}

configs.volar_html = {
    default_config = {
        cmd = volar_cmd,
        root_dir = volar_root_dir,
        -- on_new_config = on_new_config,

        -- filetypes = {'vue'},
        -- If you want to use Volar's Take Over Mode (if you know, you know), intentionally no 'json':
        filetypes = {
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "vue",
        },
        init_options = {
            typescript = { tsdk = "node_modules/typescript/lib" },
        },
    },
}

local function setup(lspconfig, on_attach, capabilities)
    local config = {
        capabilities = capabilities,
        on_attach = on_attach,
        -- on_attach = function(client, bufnr)
        --     on_attach(client, bufnr)
        --
        --     client.server_capabilities.documentFormattingProvider = false
        --     client.server_capabilities.documentRangeFormattingProvider = false
        -- end,
        settings = {
            css = { validate = false },
            less = { validate = false },
            scss = { validate = false },
        },
    }

    lspconfig.volar_api.setup(config)
    lspconfig.volar_doc.setup(config)
    lspconfig.volar_html.setup(config)
end

return setup
