
local null_ls = require("null-ls")

local b = null_ls.builtins

local opts = {
  sources = {
    b.formatting.prettierd,
    b.formatting.stylua,

    -- nix
    b.code_actions.statix,
    b.formatting.alejandra,
    b.diagnostics.deadnix,

    -- go
    b.code_actions.gomodifytags,
    b.code_actions.impl,
    b.formatting.gofumpt,
    b.formatting.goimports,
    b.diagnostics.staticcheck,

    -- C++
    b.formatting.clang_format,
    b.diagnostics.cpplint,

    -- Python
    b.formatting.black,
    b.formatting.isort,
    b.diagnostics.pylint,
    b.diagnostics.mypy,
  },
  -- Disable none-ls as a formatter and let conform.nvim handle formatting.
  -- This avoids calling into none-ls' custom supports_method implementation,
  -- which is currently failing against your Neovim version.
  on_attach = function(client, _)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}

return opts
