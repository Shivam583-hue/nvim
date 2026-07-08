local configs = require("nvchad.configs.lspconfig")

local servers = {
  "eslint",
  "gopls",
  "templ",
  "pyright",
  "ruff",
  "rust_analyzer",
  "elixirls",
  "tinymist",
}

for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {})
  vim.lsp.enable(lsp)
end

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  init_options = {
    -- used for standalone files without compile_commands.json (the CP case)
    fallbackFlags = { "-std=gnu++17", "-Wall", "-Wextra", "-DLOCAL" },
  },
})
vim.lsp.enable("clangd")

vim.lsp.config("ruff", {
  on_attach = function(client)
    -- pyright already provides hover; ruff only needed for lint/format
    client.server_capabilities.hoverProvider = false
  end,
})

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
