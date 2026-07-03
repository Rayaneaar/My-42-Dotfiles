return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    -- This section is where we customize blink's behavior
    opts = {
      keymap = {
        preset = "default", -- Keeps the default keymaps active

        -- Map Ctrl+j and Ctrl+k to move down and up the suggestion list
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },

        -- Keeps Enter working to accept the suggestion
        ["<CR>"] = { "accept", "fallback" },
      },
    },
  },
}
