return {
   {
      "folke/snacks.nvim",
      opts = function(_, opts)
         -- Define custom commands
         local commands = {
            { key = "p", action = "print('Hello World')", desc = "Print Hello World" },
            { key = "n", action = "vim.notify('This is a notification')", desc = "Show notification" },
            { key = "t", action = "vim.notify('Current time: ' .. os.date())", desc = "Show current time" },
            { key = "b", action = "print(vim.inspect(vim.api.nvim_list_bufs()))", desc = "List buffers" },
         }

         -- Create the command palette function
         _G.open_command_palette = function()
            local lines = {}
            for i, cmd in ipairs(commands) do
               table.insert(lines, string.format(" %d  %s  %s", i, cmd.key, cmd.desc))
            end

            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.bo[buf].modifiable = false
            vim.bo[buf].buftype = "nofile"

            -- Set up syntax highlighting for keys (orange)
            vim.api.nvim_buf_call(buf, function()
               vim.cmd([[syntax match CommandPaletteKey /\v\s+\d+\s+\zs\S+\ze\s+/ ]])
               vim.api.nvim_set_hl(0, "CommandPaletteKey", { fg = "orange", bold = true })
            end)

            local win = Snacks.win({
               buf = buf,
               title = " Command Palette ",
               border = "rounded",
               position = "float",
               width = 50,
               height = #lines,
            })

            -- Set up keymaps for direct key access
            for _, cmd in ipairs(commands) do
               vim.keymap.set("n", cmd.key, function()
                  win:close()
                  loadstring(cmd.action)()
               end, { buffer = buf })
            end

            -- Set up keymaps for number-based access
            for i, cmd in ipairs(commands) do
               vim.keymap.set("n", tostring(i), function()
                  win:close()
                  loadstring(cmd.action)()
               end, { buffer = buf })
            end

            -- Close on q or Esc
            vim.keymap.set("n", "q", function()
               win:close()
            end, { buffer = buf })
            vim.keymap.set("n", "<Esc>", function()
               win:close()
            end, { buffer = buf })

            -- Execute on Enter (based on cursor line)
            vim.keymap.set("n", "<CR>", function()
               local line = vim.fn.line(".")
               if commands[line] then
                  win:close()
                  loadstring(commands[line].action)()
               end
            end, { buffer = buf })
         end

         return opts
      end,
      keys = {
         {
            "<leader>z",
            function()
               _G.open_command_palette()
            end,
            desc = "Open command palette",
         },
      },
   },
}
