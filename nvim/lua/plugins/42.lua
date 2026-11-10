return {
  {
    "tigran-sargsyan-w/42-header.nvim",
    cmd = { "Stdheader" },
    keys = { "<F1>" },
    opts = {
      default_map = true,
      auto_update = true,
      user = "raaribou",
      mail = "raaribou@student.1337.ma",
    },
    config = function(_, opts)
      require("42header").setup(opts)
    end,
  },

  {
    "Diogo-ss/42-C-Formatter.nvim",
    ft = { "c", "cpp" },
    cmd = { "CFormat42" },
    config = function()
      require("42-formatter").setup({
        formatter = "/home/raaribou/.local/share/venvs/c-formatter-42/bin/c_formatter_42",
        filetypes = {
          c = true,
          h = false,
          cpp = true,
          hpp = false,
        },
      })
    end,
    keys = {
      {
        "<F2>",
        function()
          -- Skip header files, even if Neovim detects them as c/cpp
          local ext = vim.fn.expand("%:e")
          if ext == "h" or ext == "hpp" then
            vim.notify("CFormat42 skipped for header files", vim.log.levels.INFO)
            return
          end
          vim.cmd("CFormat42")
        end,
        desc = "Format according to 42 Norm (not .h)",
        ft = { "c", "cpp" },
      },
    },
  },
}
