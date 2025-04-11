return {
   {
      -- TODO: add filetype to the buvvers window
      -- TODO: add ability to jump directly to buvvers window
      "aidancz/buvvers.nvim",
      config = function()
         local buvvers = require("buvvers")

         buvvers.setup({
            -- `config` param of vim.api.nvim_open_win
            -- buvvers_win = {
            --    width = math.max(
            --       math.ceil(vim.o.columns / 8),
            --       10
            --    )
            -- }
         })

         vim.keymap.set("n", "<leader>bl", buvvers.toggle, { desc = "[b]uffers [l]ist (buvvers)" })

         local add_buffer_keybindings = function()
            print("add_buffer_keybindings")
            -- vim.keymap.set("n", "d", function()
            --    local cursor_buf_handle = require("buvvers").buvvers_buf_get_buf(vim.fn.line("."))
            --    MiniBufremove.delete(cursor_buf_handle, false)
            -- end, {
            --    buffer = require("buvvers").buvvers_get_buf(),
            --    nowait = true,
            -- })

            -- Open buffer under cursor
            vim.keymap.set("n", "<cr>", function()
               local cursor_buf_handle = buvvers.buvvers_buf_get_buf(vim.fn.line("."))
               local previous_win_handle = vim.fn.win_getid(vim.fn.winnr("#"))
               -- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/1b44040ec7b8472dfc504bbcec735419347797ad/lua/neo-tree/utils/init.lua#L643
               vim.api.nvim_win_set_buf(previous_win_handle, cursor_buf_handle)
               vim.api.nvim_set_current_win(previous_win_handle)
            end, {
               buffer = buvvers.buvvers_get_buf(),
               nowait = true,
            })
         end

         vim.api.nvim_create_augroup("buvvers_config", {clear = true})
         vim.api.nvim_create_autocmd("User", {
            group = "buvvers_config",
            pattern = "BuvversBufEnabled",
            callback = add_buffer_keybindings,
         })

         -- Open buvvers by default
         -- TODO: close when the last buffer is closed or when quitall is used, or whenever nvim is exit
         -- FIXME?: this seems to ignore the config
         -- vim.api.nvim_create_autocmd("BufRead", {
         --    callback = function()
         --       buvvers.open()
         --    end,
         -- })
      end,
   },
}
