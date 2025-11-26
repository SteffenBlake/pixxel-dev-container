local M = {}

function M.setup(ctx)
    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
      local lazyrepo = "https://github.com/folke/lazy.nvim.git"
      local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
      if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out, "WarningMsg" },
          { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
      end
    end
    vim.opt.rtp:prepend(lazypath)

    ctx.lazy = {

        -- NOTE : lsp-Config

        -- Adds cycling for overloads in signature popups for LSP
        'Issafalcon/lsp-overloads.nvim',
        -- mostly we use fzf in telescope mode for code actions
        {
            "ibhagwan/fzf-lua",
            dependencies = { "nvim-tree/nvim-web-devicons" },
        },
        {
            -- Autocompletion
            'hrsh7th/nvim-cmp',
            dependencies = {
                -- Snippet Engine & its associated nvim-cmp source
                'L3MON4D3/LuaSnip',
                'saadparwaiz1/cmp_luasnip',

                -- Adds LSP completion capabilities
                'hrsh7th/cmp-nvim-lsp',

                -- Adds a number of user-friendly snippets
                'rafamadriz/friendly-snippets',
                'onsails/lspkind.nvim',
            },
        },
        {
            -- Highlight, edit, and navigate code
            'nvim-treesitter/nvim-treesitter',
            dependencies = {
                'nvim-treesitter/nvim-treesitter-textobjects',
            },
            build = ':TSUpdate',
        },
        -- Comment/uncomment commands
        'terrortylor/nvim-comment',

        -- Auto-append closing brace/bracket/parenth/etc
        {
            'windwp/nvim-autopairs',
            event = "InsertEnter",
        },
    }

    -- NOTE : TMUX support
    if (os.getenv("TMUX") ~= nil) then
        table.insert(ctx.lazy, "tpope/vim-obsession")
        table.insert(ctx.lazy, "jabirali/vim-tmux-yank")
    end
end

function M.run(ctx)
    require('lazy').setup(ctx.lazy)
end

return M
