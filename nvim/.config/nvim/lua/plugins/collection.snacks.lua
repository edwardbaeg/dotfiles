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
      ---@class snacks.picker.Config
      picker = {
         formatters = {
            file = {
               -- truncate the file path to fit the picker window. This must also be set in each keymap to be dynamic
               truncate = (function()
                  return vim.api.nvim_win_get_width(0) * 0.8
               end)(),
            }
         },
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

            -- -- FIXME: add source for quickly finding test files
            -- test_files = {
            --    finder = "grep",
            --    cmd = "rg --files --glob '*.test.*' --glob '*.spec.*'",
            --    format = "file",
            --    live = true,
            --    supports_live = true,
            -- },
            --
            -- -- custom
            -- -- Add to snacks config
            -- -- Trigger with: `:lua require('snacks.picker').git_diff_base()`
            -- git_diff_base = {
            --    finder = function(opts, ctx)
            --       local line, h = {}, {}
            --       return require("snacks.picker.source.proc").proc({
            --          cmd = "git",
            --          args = { "diff", "--color=always", "--no-ext-diff", "master" }, -- Replace 'master' with your base
            --          transform = function(item)
            --             -- Parses diff output into hunks
            --             local text = item.text
            --             if text:find("^diff") then
            --                item.file = text:match("diff.-a/(.*) b/")
            --             elseif text:find("^@@") then
            --                table.insert(h, text)
            --             elseif text:find("^[+-]") then
            --                table.insert(line, text)
            --                if #line > 0 then
            --                   item.diff = table.concat(line, "\n")
            --                   item.hunk = table.concat(h, "\n")
            --                   return true
            --                end
            --             end
            --             return false
            --          end,
            --       }, ctx)
            --    end,
            -- },
         },
         win = {
            -- input window
            input = {
               keys = {
                  -- NOTE: use <esc> to enter normal mode; <c-c> to close
                  -- ["<Esc>"] = { "close", mode = { "n", "i" } },

                  ["K"] = { "preview_scroll_up", mode = { "n" } },
                  ["J"] = { "preview_scroll_down", mode = { "n" } },
                  -- ["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
                  -- ["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
               },
            },

            -- result list window
            list = {
               keys = {
                  ["K"] = { "preview_scroll_up", mode = { "n" } },
                  ["J"] = { "preview_scroll_down", mode = { "n" } },
                  -- ["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
                  -- ["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
               },
            },
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
            -- Snacks.picker.files()
            Snacks.picker.git_files({
               formatters = {
                  file = {
                     truncate = (function()
                        return vim.api.nvim_win_get_width(0) * 0.8
                     end)(),
                     -- truncate = 100
                  }
               }
            })
         end,
         desc = "[f]iles",
      },
      {
         "<c-p>",
         function()
            -- Snacks.picker.files()
            Snacks.picker.git_files({
               formatters = {
                  file = {
                     truncate = (function()
                        return vim.api.nvim_win_get_width(0) * 0.8
                     end)(),
                     -- truncate = 100
                  }
               }
            })
         end,
         desc = "[f]iles",
      },
      -- {
      --    "<leader>f,",
      --    function()
      --       Snacks.picker.buffers()
      --    end,
      --    desc = "Buffers",
      -- },
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

      -- this is super slow in large TS projects
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

      -- -- START Custom pickers
      -- local function pick_cmd_result(picker_opts)
      --    local git_root = Snacks.git.get_root()
      --    local function finder(opts, ctx)
      --       return require("snacks.picker.source.proc").proc({
      --          opts,
      --          {
      --             cmd = picker_opts.cmd,
      --             args = picker_opts.args,
      --             transform = function(item)
      --                item.cwd = picker_opts.cwd or git_root
      --                item.file = item.text
      --             end,
      --          },
      --       }, ctx)
      --    end
      --
      --    Snacks.picker.pick({
      --       source = picker_opts.name,
      --       finder = finder,
      --       preview = picker_opts.preview,
      --       title = picker_opts.title,
      --    })
      -- end
      --
      -- -- Custom Pickers
      -- local custom_pickers = {}
      --
      -- -- function custom_pickers.git_show()
      -- --    pick_cmd_result({
      -- --       cmd = "git",
      -- --       args = { "diff-tree", "--no-commit-id", "--name-only", "--diff-filter=d", "HEAD", "-r" },
      -- --       name = "git_show",
      -- --       title = "Git Last Commit",
      -- --       preview = "git_show",
      -- --    })
      -- -- end
      --
      -- function custom_pickers.git_diff_merge_point()
      --    pick_cmd_result({
      --       cmd = "git",
      --       -- args = { "diff-tree", "--no-commit-id", "--name-only", "--diff-filter=d", "HEAD@{u}..HEAD", "-r" },
      --       -- args = { "diff-tree", "--no-commit-id", "--name-only", "--diff-filter=d", "master...HEAD", "-r" },
      --       -- args = { "diff", "--merge-base", "master" },
      --       name = "git_diff_upstream",
      --       title = "Git Branch Changed Files",
      --       preview = "file",
      --    })
      -- end
      --
      -- -- vim.keymap.set("n", "<leader>fgh", custom_pickers.git_show)
      -- vim.keymap.set("n", "<leader>fgu", custom_pickers.git_diff_merge_point)
      -- -- END custom pickers

      -- Toggle mappings
      Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>tsp")
      Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
      Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>tb")
   end,
}
