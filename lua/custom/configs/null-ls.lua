local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local null_ls = require("null-ls")

local opts = {
  sources = {
    -- cpp
    null_ls.builtins.formatting.clang_format,
    -- go
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.goimports_reviser,
    null_ls.builtins.formatting.golines,
    -- lua
    null_ls.builtins.formatting.stylua,
    -- js/ts
    null_ls.builtins.formatting.prettier,
    -- sql
    null_ls.builtins.formatting.sql_formatter.with { command = { "sleek" } },
    -- yaml
    null_ls.builtins.diagnostics.yamllint,
    null_ls.builtins.formatting.yamlfix,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
}

return opts
