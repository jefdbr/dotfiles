-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Buffer navigation using Tab + hjkl-style keys
vim.keymap.set("n", "<M-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<M-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
