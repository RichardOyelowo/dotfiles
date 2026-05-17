return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local mason = vim.fn.stdpath("data") .. "/mason"

            ----------------------------------------------------
            -- Python
            ----------------------------------------------------
            dap.adapters.python = {
                type = "executable",
                command = mason .. "/bin/debugpy",
                args = { "-m", "debugpy.adapter" },
            }

            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    pythonPath = function()
                        local venv = os.getenv("VIRTUAL_ENV")
                        if venv then
                            return venv .. "/bin/python"
                        end
                        return "python3"
                    end,
                },
            }

            ----------------------------------------------------
            -- JS / TS
            ----------------------------------------------------
            local js_debug_path = vim.fn.glob(mason .. "/packages/js-debug-adapter/*/js-debug/src/dapDebugServer.js")
            if js_debug_path == "" then
                js_debug_path = mason .. "/bin/js-debug-adapter"
            end

            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = 8123,
                executable = {
                    command = "node",
                    args = { js_debug_path, "8123" },
                },
            }

            local js_config = {
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                    sourceMaps = true,
                },
            }

            dap.configurations.javascript = js_config
            dap.configurations.typescript = js_config
            dap.configurations.javascriptreact = js_config
            dap.configurations.typescriptreact = js_config

            ----------------------------------------------------
            -- C / C++
            ----------------------------------------------------
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = vim.fn.exepath("codelldb") ~= "" and vim.fn.exepath("codelldb")
                        or mason .. "/bin/codelldb",
                    args = { "--port", "${port}" },
                },
            }

            dap.configurations.cpp = {
                {
                    name = "Launch C++",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }

            dap.configurations.c = dap.configurations.cpp
        end,
    },
}
