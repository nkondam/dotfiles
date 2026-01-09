return {
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            -- Mason still uses the standard setup pattern for its internal UI
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "ts_ls",
                    "html",
                    "lua_ls",
                    "gopls",
                    "jdtls",
                },
            })
        end,
    },
    { "mfussenegger/nvim-jdtls" },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            { "antosha417/nvim-lsp-file-operations", config = true },
            {
                "j-hui/fidget.nvim",
                opts = {
                    lsp = {
                        progress_ringbuf_size = 0,
                        log_handler = false,
                    },
                },
            },
            { "folke/neodev.nvim", opts = {} },
        },
        config = function()
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local keymap = vim.keymap

            -- Global LspAttach autocommand (Replaces individual on_attach functions)
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf, silent = true }

                    -- Keybindings
                    opts.desc = "Show LSP references"
                    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
                    opts.desc = "Go to declaration"
                    keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    opts.desc = "Show LSP definitions"
                    keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
                    opts.desc = "Show LSP implementations"
                    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
                    opts.desc = "Show LSP type definitions"
                    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
                    opts.desc = "See available code actions"
                    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                    opts.desc = "Smart rename"
                    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    opts.desc = "Show buffer diagnostics"
                    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
                    opts.desc = "Show line diagnostics"
                    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
                    opts.desc = "Go to previous diagnostic"
                    keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                    opts.desc = "Go to next diagnostic"
                    keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                    opts.desc = "Show documentation"
                    keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    opts.desc = "Restart LSP"
                    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
                end,
            })

            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- Configure Diagnostic Signs
            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            ---------------------------------------------------------
            -- NEW 0.11+ LUA CONFIGURATION (vim.lsp.config)
            ---------------------------------------------------------

            -- 1. Define Server Configurations
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        completion = { callSnippet = "Replace" },
                    },
                },
            })

            vim.lsp.config("gopls", {
                capabilities = capabilities,
                settings = {
                    gopls = {
                        experimentalPostfixCompletions = true,
                        analyses = { unusedparams = true, shadow = true },
                        staticcheck = true,
                    },
                },
            })

            -- Generic config for simple servers
            local simple_servers = { "ts_ls", "html" }
            for _, server in ipairs(simple_servers) do
                vim.lsp.config(server, { capabilities = capabilities })
            end

            -- 2. Enable Servers
            -- This replaces lspconfig[server].setup({})
            vim.lsp.enable({ "lua_ls", "gopls", "ts_ls", "html" })

            -- Note: jdtls is typically managed by nvim-jdtls plugin specifically 
            -- and doesn't require a manual vim.lsp.enable call here.
        end,
    },
}
