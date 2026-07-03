return {
  {
    "tiagovla/tokyodark.nvim",
    lazy = false, -- Load immediately
    priority = 1000, -- Load before other plugins
    config = function()
      require("tokyodark").setup({
        transparent_background = false,
        gamma = 1.00,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          identifiers = { italic = true },
          functions = {},
          variables = {},
        },
        custom_highlights = {},
      })
      vim.cmd("colorscheme tokyodark")
    end,
  },
}
