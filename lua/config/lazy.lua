-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "

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

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { 'nyoom-engineering/oxocarbon.nvim' },
    {
      "NeogitOrg/neogit",
      lazy = true,
      dependencies = {
        "nvim-lua/plenary.nvim",         -- required
        "sindrets/diffview.nvim",        -- optional - Diff integration

        -- Only one of these is needed.
        "nvim-telescope/telescope.nvim", -- optional
        "ibhagwan/fzf-lua",              -- optional
        "nvim-mini/mini.pick",           -- optional
        "folke/snacks.nvim",             -- optional
      },
      cmd = "Neogit",
      keys = {
        { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
      }
    },
    {
      'nvim-telescope/telescope.nvim', tag = 'v0.2.1',
      dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      }
    },
    {
	    'nvim-treesitter/nvim-treesitter',
	    lazy = false,
	    build = ':TSUpdate'
    },
    {
	    "nvim-neo-tree/neo-tree.nvim",
	    branch = "v3.x",
	    dependencies = {
		    "nvim-lua/plenary.nvim",
		    "MunifTanjim/nui.nvim",
		    "nvim-tree/nvim-web-devicons", -- optional, but recommended
	    },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false
        }
      },
	    lazy = false, -- neo-tree will lazily load itself
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        "clangd",                  -- c++
        "pyright",                 -- python
        "ts_ls",                   -- typescript / javascript
        "rust_analyzer",           -- rust
        "lua_ls",                  -- lua
        "arduino_language_server", -- arduino
        "jdtls"                    -- java
      },
      dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
      },
    },
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
          ensure_installed = {
            "clangd",
            "pyright",
            "ts_ls",
            "rust_analyzer",
            "lua_ls",
            "arduino_language_server",
            "jdtls"
          },
        })
      end,
    }
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- LSP settings
vim.lsp.enable('clangd')
vim.lsp.enable('pyright')
vim.lsp.enable('ts_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('lua_ls')
vim.lsp.enable('arduino_language_server')
vim.lsp.enable('jdtls')

vim.keymap.set('n', 'H', vim.lsp.buf.hover, {})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {}) -- TODO
vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {}) -- TODO

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-g>', builtin.live_grep, { desc = 'Telescope live grep' })

-- Toggle file tree viewer
vim.keymap.set('n', '<C-e>', ':Neotree toggle<CR>')

vim.opt.background = "dark" -- set this to dark or light
vim.cmd.colorscheme "oxocarbon"

