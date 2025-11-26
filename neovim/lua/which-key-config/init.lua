local M = {}

function M.setup(ctx)

    table.insert(ctx.lazy,
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        keys = {
            { "<leader>c", group = "[C]onsole" },

            { "<leader>f", group = "[F]iles" },

            { "<leader>h", group = "[H]arpoon" },

            { "<leader>s", group = "[S]earch" },

            { "<leader>s", group = "[R]efactor" },
            { "<leader>rr", vim.lsp.buf.rename, desc = "[r]ename" },
                
            { "<leader>g", group = "[G]it" },
            
            { "<leader>d", group = "[D]ebug" },
            
            { "<leader>t", group = "[T]ests" },
            
            { "<leader>p", group = "[P]roject" },
        },
    })
end

return M
