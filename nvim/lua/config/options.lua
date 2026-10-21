-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use 4 spaces for indentation
local opt = vim.opt

opt.tabstop = 4 -- number of spaces a <Tab> counts for
opt.softtabstop = 4 -- number of spaces inserted/deleted when editing
opt.shiftwidth = 4 -- number of spaces used for autoindent
opt.expandtab = true -- convert tabs to spaces

-- Set GUI font for Neovim GUI clients (Neovide, etc.) to match the minimalist theme
opt.guifont = "JetBrainsMono Nerd Font:h12"
