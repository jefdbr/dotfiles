-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins

return {
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        enabled = false,
      },
      messages = {
        enabled = false, -- Disable the message popup
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        ignored = false,
        hidden = false,
      },
    },
  },
  -- {
  --   "stevearc/conform.nvim",
  --   opts = function()
  --     return {
  --       formatters_by_ft = {
  --         python = { "ruff" },
  --       },
  --     }
  --   end,
  -- },
}
