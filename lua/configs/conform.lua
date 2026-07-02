local prettier = "prettierd" -- or replace with "prettier" if you prefer

local options = {
  lsp_fallback = true,

  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { prettier },         -- No changes here
    typescript = { prettier },         -- No changes here
    javascriptreact = { prettier },    -- No changes here
    typescriptreact = { prettier },    -- No changes here
    json = { prettier },               -- No changes here
    jsonc = { prettier },              -- No changes here
    css = { prettier },                -- No changes here
    html = { prettier },               -- No changes here
    markdown = { prettier },           -- No changes here
    c = { "clang-format" },
    cpp = { "clang-format" },
    nix = { "alejandra" },
    go = { "goimports", "gofumpt" },
    rust = { "rustfmt" },
    python = { "isort", "black" },
    elixir = { "mix" },
    heex = { "mix" },
  },

  format_on_save = {
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  },
}

require("conform").setup(options)
