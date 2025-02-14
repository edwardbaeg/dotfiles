return {
   -- Open git links
   -- currently only used for opening external links within nvim
   -- :GitPortal open_link or :GitOpenLink
   "trevorhauter/gitportal.nvim",
   config = true,
   init = function()
      vim.api.nvim_create_user_command("GitOpenLink", function ()
         require("gitportal").open_file_in_neovim()
      end, {})
   end,
}
