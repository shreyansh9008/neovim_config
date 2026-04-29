-- Basic editor settings
vim.g.mapleader = " "

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true

vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.updatetime = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.cursorline = true
vim.o.clipboard = "unnamedplus"
-- Better completion menu for built-in omnifunc completion.
-- Trigger with Ctrl-x Ctrl-o in insert mode.
vim.o.completeopt = "menuone,noselect,popup"

-- Diagnostic display
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

-- LSP keymaps.
-- Neovim 0.12 already provides some default LSP maps, but these are familiar.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local bufnr = event.buf

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        buffer = bufnr,
        silent = true,
        desc = desc,
      })
    end

    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "gr", vim.lsp.buf.references, "References")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, "Format")

    map("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Previous diagnostic")

    map("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Next diagnostic")

    map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic")
  end,
})

-- Global LSP defaults
vim.lsp.config("*", {
  root_markers = { ".git" },
})

-- Go LSP: gopls
vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = {
    "go.work",
    "go.mod",
    ".git",
  },
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      analyses = {
        unusedparams = true,
        unusedwrite = true,
        nilness = true,
      },
    },
  },
})

-- C/C++ LSP: clangd
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--fallback-style=llvm",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git",
  },
})

-- Enable the servers.
-- Neovim 0.12 uses vim.lsp.config() + vim.lsp.enable().
vim.lsp.enable({
  "gopls",
  "clangd",
})

-- Autocomplete: nvim-cmp
local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")

local capabilities = cmp_lsp.default_capabilities()

cmp.setup({
  completion = {
    completeopt = "menu,menuone,noinsert",
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),

    ["<CR>"] = cmp.mapping.confirm({
      select = false,
    }),

    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),

    ["<C-e>"] = cmp.mapping.abort(),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
  }),
})

-- Treesitter
require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

local treesitter_filetypes = {
  "go",
  "gomod",
  "gosum",
  "gowork",
  "c",
  "cpp",
  "lua",
  "vim",
  "vimdoc",
  "query",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = treesitter_filetypes,
  callback = function()
    vim.treesitter.start()
    vim.bo.syntax = "off"
  end,
})

-- Theme
vim.o.termguicolors = true
vim.o.background = "dark"

require("rose-pine").setup({
  variant = "main", -- "main", "moon", or "dawn"
  dark_variant = "main",
  styles = {
    bold = true,
    italic = false,
    transparency = true,
  },
})

vim.cmd.colorscheme("rose-pine")

