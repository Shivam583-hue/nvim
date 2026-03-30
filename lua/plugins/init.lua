local overrides = require("configs.overrides")

local plugins = {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("configs.conform")
    end,
  },
  {
    "NvChad/base46",
    lazy = true,
  },
  {
"ellisonleao/carbon-now.nvim",
  lazy = true,
  cmd = "CarbonNow",
  ---@param opts cn.ConfigSchema
  opts = { [[ your custom config here ]] }
  },
  {
  "sphamba/smear-cursor.nvim",
  opts = {},
  },
  {
  "supermaven-inc/supermaven-nvim",
  event = "VeryLazy",
  config = function()
    require("configs.supermaven")
  end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("configs.harpoon")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        winblend = 10,
        sorting_strategy = "ascending",
        file_sorter = require("telescope.sorters").get_fzy_sorter, -- Ensure fzy_native is installed
        layout_config = {
          horizontal = { mirror = false },
          vertical = { mirror = false },
        },
      },
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
    },
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = function()
      return require("configs.noice")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require("configs.lspconfig")
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    -- Temporarily disable none-ls to avoid crashes in its client.lua
    -- (attempt to index field '_request_name_to_capability') when
    -- other plugins query LSP capabilities on BufWritePre.
    enabled = false,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
  },
  {
    "Wansmer/treesj",
    cmd = { "TSJToggle" },
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    opts = {},
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    config = true,
  },
  {
    "folke/neodev.nvim",
    event = "VeryLazy",
    config = function()
      require("neodev").setup({
        library = {
          plugins = { "nvim-dap-ui" },
          types = true,
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("configs.dap")
    end,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
  },
  {
    "nat-418/boole.nvim",
    event = "VeryLazy",
    config = function()
      require("boole").setup()
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPost",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("configs.ts")
    end,
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    event = { "CmdlineEnter" },
    config = function()
      require("configs.go")
    end,
    ft = {
      "go",
      "gomod",
      "gosum",
      "gowork",
      "gotmpl",
    },
    build = ':lua require("go.install").update_all_sync()',
  },
  
  {
    "OXY2DEV/markview.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "ibhagwan/smartyank.nvim",
    event = "VeryLazy",
    config = function()
      require("configs.smart-yank")
    end,
  },
{ 'wakatime/vim-wakatime', lazy = false },
  {
    "andweeb/presence.nvim",
    event = "VeryLazy",
    config = function()
      require("presence").setup({
        auto_update = true,
        neovim_image_text = "The Supreme Editor",
        main_image = "neovim",
        client_id = "793271441293967371",
        log_level = nil,
        debounce_timeout = 10,
        enable_line_number = false,
        editing_text = "Editing %s",
        file_explorer_text = "Browsing %s",
        git_commit_text = "Committing changes",
        plugin_manager_text = "Managing plugins",
        reading_text = "Reading %s",
        workspace_text = "Working on %s",
        line_number_text = "Line %s out of %s",
      })
    end,
  },
  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup {
        -- Use a single Elixir LSP. nextls is disabled unless installed explicitly.
        credo = { enable = true },
        elixirls = {
          enable = true,
          settings = elixirls.settings {
            dialyzerEnabled = true,
            enableTestLenses = true,
          },
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true })
            vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true })
            vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true })
          end,
        }
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}

return plugins
