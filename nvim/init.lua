if vim == nil then
    _G.vim = require("vim")
end

vim.g.mapleader = " "
vim.o.ignorecase = true
vim.o.smartcase = true

vim.api.nvim_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })



-- Setup Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "hrsh7th/nvim-cmp",                                             -- Completion plugin
    "hrsh7th/cmp-nvim-lsp",                                         -- LSP source for nvim-cmp
    "hrsh7th/cmp-buffer",                                           -- Buffer source for nvim-cmp
    "hrsh7th/cmp-path",                                             -- Path source for nvim-cmp
    "hrsh7th/cmp-cmdline",                                          -- Command line source for nvim-cmp
    "L3MON4D3/LuaSnip",                                             -- Snippets plugin
    "saadparwaiz1/cmp_luasnip",                                     -- Snippet source for nvim-cmp
    "jose-elias-alvarez/null-ls.nvim",
    "neovim/nvim-lspconfig",                                        -- LSP support
    "nvim-telescope/telescope.nvim",                                -- Fuzzy finder
    "nvim-treesitter/nvim-treesitter",                              -- Syntax highlighting
    "williamboman/mason.nvim",                                      -- LSP installer
    "williamboman/mason-lspconfig.nvim",                            -- Bridges mason.nvim with lspconfig
    "nvim-lualine/lualine.nvim",                                    -- Status bar
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Speed up telescope
    "nvim-lua/plenary.nvim",
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    }
})

vim.cmd("colorscheme tokyonight-night")

-- Basic settings
vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = true     -- Relative line numbers
vim.opt.tabstop = 4               -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 4            -- Indent width
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.smartindent = true        -- Auto-indent new lines
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- Enable syntax highlighting and filetype detection
vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

-- Treesitter (Better syntax highlighting)
require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "python", "bash", "javascript", "html", "css", "haskell" },
    highlight = { enable = true },
}

-- Lualine (Status bar)
require("lualine").setup {
    options = {
        theme = "tokyonight",
    },
}

-- Telescope (Fuzzy finder)
require("telescope").setup {
    defaults = {
        file_ignore_patterns = { "node_modules", ".git" }, -- Ignore unnecessary files
    },
}


require("mason").setup()
require("mason-lspconfig").setup()

local lspconfig = require("lspconfig")

require("mason-lspconfig").setup_handlers({
    function(server)
        lspconfig[server].setup({
            -- Additional server configuration if necessary
        })
    end
})

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        -- For Python (black)
        null_ls.builtins.formatting.black.with({
            filetypes = { "python" },
        }),

        -- For JavaScript/TypeScript (prettier)
        null_ls.builtins.formatting.prettier.with({
            filetypes = { "javascript", "typescript", "json", "yaml", "markdown" },
        }),

        -- For C/C++ (clang-format)
        null_ls.builtins.formatting.clang_format.with({
            filetypes = { "c", "cpp" },
        }),

        null_ls.builtins.formatting.fourmolu.with({
            filetypes = { "haskell", "lhaskell" }
        })

        -- Add more formatters as needed...
    },
})

vim.cmd([[autocmd BufWritePost *.hs lua vim.lsp.buf.format()]])


local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })



local cmp = require("cmp")

cmp.setup({
    -- Completion settings
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body) -- Use LuaSnip for snippets
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),         -- Navigate to next item
        ["<C-p>"] = cmp.mapping.select_prev_item(),         -- Navigate to previous item
        ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- LSP completions
        { name = "buffer" },   -- Completion from buffer
        { name = "path" },     -- Path completions
    }),
})

-- Setup for command line completions
cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline" },
    }),
})

cmp.setup.cmdline("/", {
    sources = cmp.config.sources({
        { name = "buffer" },
    }),
})

vim.diagnostic.config({
    virtual_text = false
})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
