local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy,
    {
        -- Theme inspired by Atom
        'navarasu/onedark.nvim',
        priority = 1000,
    })
end

function M.run(ctx)
    local onedark = require('onedark')
    onedark.setup({
        style = 'cool'
    })
    onedark.load()
end

return M
