return {
  {
    "oribarilan/lensline.nvim",
    branch = "release/2.x",
    event = "LspAttach",
    config = function()
      require("lensline").setup({
        providers = {
          {
            name = "function_length",
            enabled = true,
            event = { "BufWritePost", "TextChanged" },
            handler = function(bufnr, func_info, _, callback)
              local utils = require("lensline.utils")
              local lines = utils.get_function_lines(bufnr, func_info)

              callback({
                line = func_info.line,
                text = string.format("%d lines", math.max(0, #lines - 1)),
              })
            end,
          },
        },
      })
    end,
  },
}
