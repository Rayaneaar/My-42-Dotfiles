return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        c_formatter_42 = {
          command = "/home/raaribou/.local/share/venvs/c-formatter-42/bin/c_formatter_42",
        },
      },

      formatters_by_ft = {
        c = { "c_formatter_42" },
        h = { "c_formatter_42" },
      },
    },
  },
}
