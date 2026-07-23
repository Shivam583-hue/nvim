if not vim.g.neovide then
  return
end

local map = vim.keymap.set
local g = vim.g

g.neovide_scale_factor = 0.7
g.neovide_opacity = 0.9
g.neovide_normal_opacity = 0.9
g.neovide_refresh_rate = 144
g.neovide_refresh_rate_idle = 5

local function change_scale(multiplier)
  local next_scale = g.neovide_scale_factor * multiplier
  g.neovide_scale_factor = math.max(0.5, math.min(3.0, next_scale))
end

map("n", "<C-=>", function() change_scale(1.1) end, { desc = "Zoom in (Neovide)" })
map("n", "<C-->", function() change_scale(1 / 1.1) end, { desc = "Zoom out (Neovide)" })

local function copy()
  vim.cmd([[normal! "+y]])
end

local function paste()
  vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
end

local copy_key = vim.fn.has("macunix") == 1 and "<D-c>" or "<C-S-c>"
local paste_key = vim.fn.has("macunix") == 1 and "<D-v>" or "<C-S-v>"

map("v", copy_key, copy, { silent = true, desc = "Copy to system clipboard" })
map({ "n", "i", "v", "c", "t" }, paste_key, paste, { silent = true, desc = "Paste from system clipboard" })
