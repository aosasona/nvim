-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
--
-- Legacy gleam support
---@class ParserInfo
-- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
-- parser_config.gleam = {
--   install_info = {
--     url = "~/tree-sitter-gleam",
--     files = { "src/parser.c", "src/scanner.c" },
--     branch = "main",
--   },
--   filetype = "gleam",
-- }
--

--- Crystal tree-sitter parser
---@class ParserInfo
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.crystal = {
  install_info = {
    url = "~/personal/grammars/tree-sitter-crystal",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "crystal",
}

local user_utils = require "utils"

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        wrap = true, -- sets vim.opt.wrap
        termguicolors = true,
        background = "dark",
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        gruvbox_material_background = "hard",
        gruvbox_material_better_performance = 1,
        astro_typescript = "enable",
      },
    },
    -- Mappings can be configured through AstroCore as well.
    mappings = {
      -- first key is the mode
      n = {
        ["<C-Down>"] = false,
        ["<C-Left>"] = false,
        ["<C-Right>"] = false,
        ["<C-Up>"] = false,
        ["<C-q>"] = false,
        ["<C-s>"] = false,
        ["]b"] = false,
        ["[b"] = false,
        -- Increment and decrement
        ["-"] = { "<c-x>", desc = "Decrement number" },
        ["+"] = { "<c-a>", desc = "Increment number" },

        n = { user_utils.better_search "n", desc = "Next search" },
        N = { user_utils.better_search "N", desc = "Previous search" },

        ["gb"] = {
          "<cmd>Gitsigns toggle_current_line_blame<cr>",
          desc = "Toggle Git blame line",
        },

        -- Toggle inlay hints
        ["<leader>lH"] = {
          function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {}) end,
          desc = "Toggle inlay hints",
        },

        -- mappings seen under group name "Buffer"
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },

        -- Buffer navigation
        ["<S-l>"] = {
          function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
          desc = "Next buffer",
        },
        ["<S-h>"] = {
          function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
          desc = "Previous buffer",
        },

        --  neo-tree
        ["<leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
        ["<leader>o"] = {
          function()
            if vim.bo.filetype == "neo-tree" then
              vim.cmd.wincmd "p"
            else
              vim.cmd.Neotree "focus"
            end
          end,
          desc = "Toggle Explorer Focus",
        },

        -- Code actions
        ["<leader>a"] = { "<cmd>CodeActionMenu<CR>", desc = "Show code action menu" },
        -- refactoring
        ["<leader>r"] = { "<cmd>Refactor<cr>", desc = "Refactor" }, -- this is to set the prefix properly in which-key
        ["<leader>rr"] = {
          function() require("refactoring").select_refactor { show_success_message = true } end,
          desc = "Show refactoring options",
        },
        ["<leader>ri"] = { "<cmd>Refactor inline_var<cr>", desc = "Inline variable" },
        ["<leader>rb"] = { "<cmd>Refactor extract_block<cr>", desc = "Extract block" },
        ["<leader>rl"] = { "<cmd>Refactor extract_block_to_file<cr>", desc = "Extract block to file" },
        ["<leader>rp"] = {
          function() require("refactoring").debug.printf { below = false, show_success_message = true } end,
          desc = "Debugging - printf",
        },
        ["<leader>r`"] = {
          function() require("refactoring").debug.print_var { show_success_message = true } end,
          desc = "Debugging - print var",
        },
        ["<leader>rc"] = {
          function() require("refactoring").debug.cleanup { show_success_message = true } end,
          desc = "Debugging - cleanup",
        },
        ["]t"] = {
          function() require("todo-comments").jump_next() end,
          desc = "Next todo comment",
        },
        ["[t"] = {
          function() require("todo-comments").jump_prev() end,
          desc = "Previous todo comment",
        },

        -- Trouble.nvim
        ["<leader>x"] = { desc = "Trouble" },
        ["<leader>xx"] = { "<cmd>Trouble diagnostics toggle focus=true<cr>", desc = "Diagnostics (Trouble)" },
        ["<leader>xb"] = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
        ["<leader>xs"] = {
          "<cmd>Trouble symbols toggle pinned=true results.win.relative=win results.win.position=right<cr>",
          desc = "Symbols (Trouble)",
        },
        ["<leader>xL"] = {
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        ["<leader>xk"] = { "<cmd>Trouble diagnostics prev<cr>", desc = "Previous item" },
        ["<leader>xj"] = { "<cmd>Trouble diagnostics next<cr>", desc = "Next item" },
        ["<leader>xl"] = { "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
        ["<leader>xq"] = { "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },

        -- Sourcegraph (cody)
        ["<Leader>s"] = { desc = "Sourcegraph" },
        ["<leader>ss"] = {
          function() require("sg.extensions.telescope").fuzzy_search_results() end,
          desc = "Search using Sourcegraph",
        },
        ["<leader>sh"] = {
          function() require("sg.keymaps").help() end,
          desc = "Show keymaps help",
        },
        ["<leader>sc"] = {
          function() require("sg.cody.commands").toggle() end,
          desc = "Toggle Cody chat panel",
        },
        ["<leader>sf"] = {
          function() require("sg.cody.commands").history() end,
          desc = "Show Cody chat history",
        },
        ["<leader>sp"] = {
          function() require("sg.cody.commands").focus_prompt() end,
          desc = "Focus prompt pane",
        },

        ["<leader>\\"] = { "<CMD>Oil --float<CR>", desc = "Open parent directory" },

        -- Laravel
        ["<leader>lv"] = { ":Laravel artisan<cr>", desc = "Run Laravel artisan commands" },

        -- Grugfar
        ["<leader>rf"] = {
          function() require("grug-far").grug_far { prefills = { paths = vim.fn.expand "%" } } end,
          desc = "Search and replace in current file",
        },
        ["<leader>rg"] = {
          function() require("grug-far").grug_far { prefills = { paths = vim.fn.expand "%:p:h" } } end,
          desc = "Search and replace in all files in the current directory",
        },
        ["<leader>rt"] = {
          function() require("grug-far").grug_far { transient = true } end,
          desc = "Launch GrugFar in a transient buffer",
        },
        ["<leader>rw"] = {
          function() require("grug-far").grug_far { prefills = { search = vim.fn.expand "<cword>" } } end,
          desc = "Launch GrugFar with the current word under the cursor",
        },

        -- Override telescope find files
        -- ["<Leader>ff"] = {
        --   function()
        --     require("telescope.builtin").find_files {
        --       hidden = true,
        --       no_ignore = true,
        --       file_ignore_patterns = { ".git/", "node_modules/" },
        --     }
        --   end,
        --   desc = "Find all files",
        -- },

        -- Dadbod
        -- ["<leader>dd"] = { "<cmd>DBUIToggle<cr>", desc = "Toggle dadbod UI" },
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },
      i = {
        -- These have been replaced by just tab in the community plugin
        -- ["<M-tab>"] = { 'copilot#Accept("<CR>")', noremap = true, silent = true, expr = true, replace_keycodes = false },
        -- ["<C-\\>"] = { 'copilot#Accept("<CR>")', noremap = true, silent = true, expr = true, replace_keycodes = false },
      },
      x = {
        -- move line(s)
        ["J"] = { ":move '>+1<cr>gv-gv", desc = "Move line(s) down" },
        ["K"] = { ":move '<-2<cr>gv-gv", desc = "Move line(s) up" },

        -- Search in Grugfar
        ["<leader>rg"] = {
          function() require("grug-far").with_visual_selection {} end,
          desc = "Launch GrugFar with the current visual selection",
        },

        -- better increment/decrement
        ["+"] = { "g<C-a>", desc = "Increment number" },
        ["-"] = { "g<C-x>", desc = "Decrement number" },
        -- line text-objects
        ["il"] = { "g_o^", desc = "Inside line text object" },
        ["al"] = { "$o^", desc = "Around line text object" },
        -- Easy-Align
        ga = { "<Plug>(EasyAlign)", desc = "Easy Align" },
        -- vim-sandwich
        ["s"] = "<Nop>",
        -- refactoring
        ["<leader>r"] = { "<cmd>Refactor<cr>", desc = "Refactor" }, -- this is to set the prefix properly in which-key
        ["<leader>rr"] = {
          function() require("refactoring").select_refactor { show_success_message = true } end,
          desc = "Show refactoring options",
        },
        ["<leader>re"] = { "<cmd>Refactor extract <cr>", desc = "Extract function" },
        ["<leader>rf"] = { "<cmd>Refactor extract_to_file <cr>", desc = "Extract function to file" },
        ["<leader>rv"] = { "<cmd>Refactor extract_var <cr>", desc = "Extract variable" },
        ["<leader>ri"] = { "<cmd>Refactor inline_var<cr>", desc = "Inline variable" },
      },
    },
  },
}
