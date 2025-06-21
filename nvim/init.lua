-- theme loader
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"

-- sets leader key to space
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- checks for lazy.nvim and installs from gh if not found
if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

-- loads lazy.nvim before anything else
vim.opt.rtp:prepend(lazypath)

-- declares a lua module to lazy_config
local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",  -- main repo
    lazy = false, -- load immediately
    branch = "v2.5", -- use branch v2.5
    import = "nvchad.plugins",  --import from nvchad.plugins
  },

  { import = "plugins" }, -- read folder plugins to impoty
}, lazy_config) -- pass as lazy.nvim config

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
