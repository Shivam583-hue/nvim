-- Typst: type $$ to expand into a block math skeleton, cursor left in the middle
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  callback = function(args)
    vim.keymap.set("i", "$$", "$<CR><CR>$<Up><End>", { buffer = args.buf, desc = "Typst math block" })
  end,
})

-- Insert the CP template into freshly created .cpp files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.cpp",
  callback = function()
    local template = vim.fn.stdpath("config") .. "/templates/cp.cpp"
    if vim.fn.filereadable(template) == 1 then
      vim.cmd("0r " .. vim.fn.fnameescape(template))
      -- remove the trailing empty line left over from the originally empty buffer
      vim.api.nvim_buf_set_lines(0, -2, -1, false, {})
      -- put the cursor inside solve()
      vim.fn.search("void solve", "w")
      vim.cmd("normal! j")
    end
  end,
})
