
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()

-- Basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

-- Keymaps
vim.keymap.set("n", "<C-p>a", function() harpoon:list():append() end,
  { desc = "Add file to harpoon" })
vim.keymap.set("n", "<C-p>m", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
  { desc = "Show harpoon menu" })
vim.keymap.set("n", "<C-p>t", function() toggle_telescope(harpoon:list()) end,
  { desc = "Show harpoon in telescope" })

-- Navigation (using Alt key instead of Ctrl to avoid conflicts)
vim.keymap.set("n", "<A-1>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<A-2>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<A-3>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<A-4>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<A-p>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<A-n>", function() harpoon:list():next() end)
