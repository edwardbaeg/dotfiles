return {
   -- AI code programming
   -- :CodeCompanion <prompt> to do an inline change (see todo below)
   -- <leader>cc to open chat
   -- ga in chat to change adapter+model
   -- TODO: change default inline diff keymaps: ga and gr; they conflict
   "olimorris/codecompanion.nvim",
   -- lazy = false, -- expose :CodeCompanion commands immediately
   cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionActions",
   },
   dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "folke/noice.nvim",
      -- "j-hui/fidget.nvim", -- for spinner
   },
   opts = {
      strategies = {
         chat = {
            adapter = "copilot", -- faster
            -- adapter = "anthropic", -- missing api key?
         },
         inline = {
            adapter = "copilot",
            -- adapter = "anthropic",
         },
      },
   },
   keys = {
      {
         -- TODO: in v mode, open an input and then pass that to :CodeCompanion <prompt>
         mode = { "n", "v" },
         "<leader>cc",
         function()
            -- require("codecompanion").chat()
            require("codecompanion").toggle()
         end,
         desc = "CodeCompanion",
      },
   },
   init = function()
      -- https://github.com/olimorris/codecompanion.nvim/discussions/813
      -- TODO: this can be moved to a separate file, eg plugins/ai/extensions/companion-notification.lua

      local Format = require("noice.text.format")
      local Message = require("noice.message")
      local Manager = require("noice.message.manager")
      local Router = require("noice.message.router")

      local ThrottleTime = 200
      local M = {}

      M.handles = {}
      function M.init()
         local group = vim.api.nvim_create_augroup("NoiceCompanionRequests", {})

         vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "CodeCompanionRequestStarted",
            group = group,
            callback = function(request)
               local handle = M.create_progress_message(request)
               M.store_progress_handle(request.data.id, handle)
               M.update(handle)
            end,
         })

         vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "CodeCompanionRequestFinished",
            group = group,
            callback = function(request)
               local message = M.pop_progress_message(request.data.id)
               if message then
                  message.opts.progress.message = M.report_exit_status(request)
                  M.finish_progress_message(message)
               end
            end,
         })
      end

      function M.store_progress_handle(id, handle)
         M.handles[id] = handle
      end

      function M.pop_progress_message(id)
         local handle = M.handles[id]
         M.handles[id] = nil
         return handle
      end

      function M.create_progress_message(request)
         local msg = Message("lsp", "progress")
         local id = request.data.id
         msg.opts.progress = {
            client_id = "client " .. id,
            client = M.llm_role_title(request.data.adapter),
            id = id,
            message = "Awaiting response: ",
         }
         return msg
      end

      function M.update(message)
         if M.handles[message.opts.progress.id] then
            Manager.add(Format.format(message, "lsp_progress"))
            vim.defer_fn(function()
               M.update(message)
            end, ThrottleTime)
         end
      end

      function M.finish_progress_message(message)
         Manager.add(Format.format(message, "lsp_progress"))
         Router.update()
         Manager.remove(message)
      end

      function M.llm_role_title(adapter)
         local parts = {}
         table.insert(parts, adapter.formatted_name)
         if adapter.model and adapter.model ~= "" then
            table.insert(parts, "(" .. adapter.model .. ")")
         end
         return table.concat(parts, " ")
      end

      function M.report_exit_status(request)
         if request.data.status == "success" then
            return "Completed"
         elseif request.data.status == "error" then
            return " Error"
         else
            return "󰜺 Cancelled"
         end
      end

      -- return M

      M:init()
   end,
}
