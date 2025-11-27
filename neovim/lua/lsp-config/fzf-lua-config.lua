local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy, {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    })
end


function M.run(ctx)
    require("fzf-lua").setup({
        "telescope"
    })
end

return M
