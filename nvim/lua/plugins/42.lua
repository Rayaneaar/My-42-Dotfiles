return {
  {
    "tigran-sargsyan-w/42-header.nvim",
    cmd = { "Stdheader" },
    keys = { "<F1>" },
    opts = {
      default_map = true,
      auto_update = true,
      user = "raaribou",
      mail = "marvin@42.fr",
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
          h = true,
          cpp = true,
          hpp = true,
        },
      })
    end,
    keys = {
      {
        "<F2>",
        "<cmd>CFormat42<CR>",
        desc = "Format according to 42 Norm",
        ft = { "c", "cpp" },
      },
    },
  },
}
