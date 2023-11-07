-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- autosave
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "InsertLeave" }, {
    command = "silent! wa",
})

vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "BufWritePre" }, {
    pattern = {
        "*.lua",
        "*.py",
        "*.go",
        "*.nix",
    },
    command = "silent! lua vim.lsp.buf.format()",
})
-- vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
--   callback = function()
--     vim.lsp.buf.format()
--     vim.cmd("silent! wa'")
--   end,
-- })
