---@module "snacks"
return {
   -- TODO: add keymap for scrolling the preview window
   -- NOTE: [buffer] lines picker doesn't have preview, so using fzf-lua for now
   "folke/snacks.nvim",
   lazy = false,
   priority = 1000,
   ---@type snacks.Config
   opts = {
      -- NOTE: use <c-q> to add files to quickfix (default for grep)
      picker = {
         sources = {
            explorer = {
               hidden = true, -- show hidden files
               win = {
                  list = {
                     keys = {
                        ["o"] = "explorer_add", -- default is explorer_open
                        ["O"] = "explorer_open",
                     },
                  },
               },
            },
            files = {
               hidden = true, -- show hidden files
               -- TODO: we want to ignore some files. Maybe hardcode here or create another ignore file?
               -- args = { "--no-ignore", "!assets/documents" },
               args = { "--no-ignore" },
            },
            grep = {
               hidden = true, -- show hidden files
            },
            buffers = {
               layout = {
                  preset = "dropdown",
               },
               -- on_show = function()
               --    vim.cmd.stopinsert()
               -- end,
            },
            command_history = {
               on_show = function()
                  vim.cmd.stopinsert()
               end,
            },
            recents = {
               on_show = function()
                  vim.cmd.stopinsert()
               end,
            },
            jumps = {
               on_show = function()
                  vim.cmd.stopinsert()
               end,
            },
            git_status = {
               on_show = function()
                  vim.cmd.stopinsert()
               end,
            },
            git_log_file = {
               on_show = function()
                  vim.cmd.stopinsert()
               end,
            },
            undo = {
               on_show = function()
                  vim.cmd.stopinsert()
               end,
            },
         },
      },
      win = {
         -- input window
         input = {
            keys = {
               -- close from insert mode -- this doesn't seem to work...
               ["<Esc>"] = { "close", mode = { "n", "i" } },
            },
         },

         -- result list window
         list = {
            keys = {},
         },
      },
   },
   keys = {
      -- Pickers
      {
         "<leader>f<space>",
         function()
            Snacks.picker()
         end,
         desc = "[F]uzzy Snacks...",
      },
      {
         "<leader>ff",
         function()
            Snacks.picker.files()
         end,
         desc = "[f]iles",
      },
      {
         "<c-p>",
         function()
            Snacks.picker.files()
         end,
         desc = "[f]iles",
      },
      {
         "<leader>f,",
         function()
            Snacks.picker.buffers()
         end,
         desc = "Buffers",
      },
      {
         "<leader>:",
         function()
            Snacks.picker.command_history()
         end,
         desc = "Command History",
      },
      {
         "<leader>fn",
         function()
            Snacks.picker.notifications()
         end,
         desc = "Notification History",
      },
      {
         "<leader>fe",
         function()
            Snacks.explorer()
         end,
         desc = "File Explorer",
      },
      {
         "<leader>fh",
         function()
            Snacks.picker.help()
         end,
         desc = "Help",
      },
      {
         "<leader>i",
         function()
            Snacks.picker.buffers()
         end,
         desc = "Buffers",
      },
      {
         "<leader>fr",
         function()
            Snacks.picker.recent()
         end,
         desc = "Recent",
      },
      {
         "<leader>fj",
         function()
            Snacks.picker.jumps()
         end,
         desc = "Jumps",
      },
      {
         "<leader>fu",
         function()
            Snacks.picker.undo()
         end,
         desc = "Undo History",
      },
      {
         "<leader>fgs",
         function()
            Snacks.picker.git_status()
         end,
         desc = "Git Status",
      },
      {
         "<leader>fgl",
         function()
            Snacks.picker.git_log_file()
         end,
         desc = "Git Log File",
      },
      {
         "<leader>fsp",
         function()
            Snacks.picker.spelling()
         end,
         desc = "[sp]elling",
      },
      {
         "<leader>fp",
         -- NOTE: this links to the actual configuration file, not the symlink
         function()
            Snacks.picker.lazy()
         end,
         desc = "[P]lugins",
      },

      -- doesn't support fuzzy?
      -- but can do <c-g> to fuzzy search results, including filenames
      {
         -- "<c-g>",
         "<leader>sg",
         function()
            Snacks.picker.grep()
         end,
         desc = "Grep",
      },

      {
         "<leader>fsw",
         function()
            Snacks.picker.lsp_workspace_symbols()
         end,
         desc = "workspace symbols",
      },
      {
         "<leader>fss",
         function()
            Snacks.picker.lsp_symbols()
         end,
         desc = "document symbols",
      },

      -- still using fzf-lua for the preview
      -- {
      --    "<leader>fl",
      --    function()
      --       Snacks.picker.lines({
      --          layout = {
      --             preset = "telescope",
      --          },
      --       })
      --    end,
      --    desc = "Buffer Lines",
      -- },

      -- Lazygit opens files as buffers but doesn't support hiding terminal during async functions...
      -- {
      --    "<c-\\>",
      --    function()
      --       Snacks.lazygit()
      --    end,
      --    desc = "lazygit",
      -- },
      -- {
      --    "<leader>lg",
      --    function()
      --       Snacks.lazygit()
      --    end,
      --    desc = "lazygit",
      -- },
   },
   config = function(_, opts)
      Snacks.setup(opts)

      vim.api.nvim_create_user_command("Scratch", function()
         Snacks.scratch()
      end, {})

      -- Toggle mappings
      Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>tsp")
      Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
      Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>tb")
   end,
}
