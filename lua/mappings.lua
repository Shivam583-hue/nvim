
require("nvchad.mappings")

local map = vim.keymap.set
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- ===============================
-- 🚀 Competitive Programming Setup
-- ===============================

local cp_run = function()
  if vim.bo.filetype ~= "cpp" then
    print("Not a C++ file")
    return
  end

  vim.cmd("w")

  local file = vim.fn.expand("%")
  local output = vim.fn.expand("%:r")

  local compile_cmd =
    string.format(
      "g++ -std=gnu++17 -O2 -Wall -Wextra -Wshadow -Wconversion -DLOCAL %s -o %s",
      file,
      output
    )

  require("nvchad.term").toggle({
    pos = "float",
    id = "cp_run",
    float_opts = float_opts,
    cmd = compile_cmd .. " && ./" .. output,
  })
end

map("n", "<F5>", cp_run, { desc = "CP Compile & Run" })-- Toggle Floating Terminal
local toggleTerm = function()
  require("nvchad.term").toggle({ pos = "float", id = "float", float_opts = float_opts })
end

-- Toggle Lazygit
local toggleLazygit = function()
  require("nvchad.term").toggle({ pos = "float", id = "lazygit", float_opts = float_opts, cmd = "lazygit" })
end

-- Toggle Carbon Now.nvim 
map("v", "<leader>cn", ":CarbonNow<CR>", {silent = true})

-- Treesitter Join
local toggleTreesj = function()
  require("treesj").toggle()
end

-- Close All Buffers
local closeAllBuffer = function()
  require("nvchad.tabufline").closeAllBufs()
end

-- Increment and Decrement
map("n", "+", "<C-a>", opts)
map("n", "-", "<C-x>", opts)

-- Save File and Quit
map("n", "<Leader>w", ":update<Return>", opts)
map("n", "<Leader>q", ":quit<Return>", opts)
map("n", "<Leader>Q", ":qa<Return>", opts)

-- Format for C++
map("n", "<Leader>fkk", ":Format<CR>", opts)

-- Wrap word in quotes
map("n", '<leader>"', 'ciw"<C-r>""<Esc>', { desc = "Wrap word in double quotes" })

-- Select All
map("n", "<C-a>", "gg<S-v>G", opts)

-- Split Window
map("n", "ss", ":split<Return>", opts)
map("n", "sv", ":vsplit<Return>", opts)

-- Move Window
map("n", "sh", "<C-w>h", opts)
map("n", "sk", "<C-w>k", opts)
map("n", "sj", "<C-w>j", opts)
map("n", "sl", "<C-w>l", opts)

-- Resize Window
map("n", "<C-w><left>", "<C-w><", opts)
map("n", "<C-w><right>", "<C-w>>", opts)
map("n", "<C-w><up>", "<C-w>+", opts)
map("n", "<C-w><down>", "<C-w>-", opts)

-- Tab Management
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- NvChad-Specific Keymaps
map({ "n", "t" }, "<F7>", toggleTerm, { desc = "Toggle Floating Terminal" })
map({ "n", "t" }, "<F8>", toggleLazygit, { desc = "Toggle Lazygit" })
map("n", "<leader>Sl", function() require("persistence").load({ last = true }) end, { desc = "Load last session" })
map("n", "<leader>Ss", function() require("persistence").save() end, { desc = "Save this session" })
map("n", "<leader>Sd", function() require("persistence").stop() end, { desc = "Stop session recording" })
map("n", "<leader>Sf", function() require("persistence").select() end, { desc = "Select session" })
map("n", "<leader>S.", function() require("persistence").load() end, { desc = "Load session for cwd" })
map("n", "<leader>tt", "<cmd>TroubleToggle<cr>", { desc = "Toggle diagnostics" })
map("n", "<leader>td", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME,BUG,TEST,NOTE<cr>", { desc = "Todo/Fix/Fixme" })
map("n", "<leader>m", toggleTreesj, { desc = "Toggle Treesitter Join" })
map("n", "<leader>o", "<cmd>Outline<cr>", { desc = "Toggle Outline" })
map("n", "<leader>X", closeAllBuffer, { desc = "Close all buffers" })

-- Debug Adapter Protocol (DAP)
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>", { desc = "Toggle break point" })
map("n", "<leader>dc", "<cmd>DapContinue<cr>", { desc = "Continue" })
map("n", "<leader>dt", "<cmd>DapTerminate<cr>", { desc = "Terminate" })
map("n", "<leader>do", "<cmd>DapStepOver<cr>", { desc = "Step over" })

-- Go To Tab
for i = 1, 9, 1 do
  map("n", string.format("<A-%s>", i), function()
    vim.api.nvim_set_current_buf(vim.t.bufs[i])
  end, { desc = string.format("Go to tab %d", i) })
end
