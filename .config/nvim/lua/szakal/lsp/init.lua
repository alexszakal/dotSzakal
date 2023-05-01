local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "szakal.lsp.mason"
require("szakal.lsp.handlers").setup()
-- require "user.lsp.null-ls"
