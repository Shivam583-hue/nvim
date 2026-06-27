local configs = require("nvchad.configs.lspconfig")

local servers = {
  "eslint",
  "gopls",
  "templ",
  "clangd",
  "pyright",
  "rust_analyzer",
  "elixirls",
  "tinymist",
}

for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {})
  vim.lsp.enable(lsp)
end

vim.lsp.config("nil_ls", {
  filetypes = { "nix" },
  cmd = { "nil" },
  settings = {
    ["nil"] = {
      flake = {
        autoArchive = true,
      },
    },
  },
})
vim.lsp.enable("nil_ls")

vim.lsp.config("html", {
  filetypes = { "html", "templ" },
})
vim.lsp.enable("html")

vim.lsp.config("htmx", {
  filetypes = { "html", "templ" },
})
vim.lsp.enable("htmx")

vim.lsp.config("elixirls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/elixir-ls" },
})
vim.lsp.enable("elixirls")
