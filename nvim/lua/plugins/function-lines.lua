-- ~/.config/nvim/lua/plugins/function-lines.lua
-- Lists every function in the current buffer as:  function a : #24 LINE
-- Pick one to jump to it. Optionally shows each function's length inline.
-- Works for any language that has a treesitter parser (no extra plugin needed).

local M = {}
local ns = vim.api.nvim_create_namespace("function_lines")
local enabled = true

-- Treesitter node types that represent functions/methods across languages
local FUNC_NODES = {
  function_declaration = true, -- lua, js, ts, go, php
  function_definition = true, -- python, c, cpp, bash, lua
  function_item = true, -- rust
  function_expression = true, -- js
  arrow_function = true, -- js, ts
  method_definition = true, -- js, ts
  method_declaration = true, -- go, java, php
  constructor_declaration = true, -- java, c#
  local_function = true, -- c#
  generator_function_declaration = true,
}

local function text(node, buf)
  return vim.treesitter.get_node_text(node, buf)
end

-- first identifier inside a node (used for C/C++ declarators)
local function find_ident(node, buf)
  if node:type():find("identifier") then
    return text(node, buf)
  end
  for child in node:iter_children() do
    local r = find_ident(child, buf)
    if r then
      return r
    end
  end
end

local function name_of(node, buf)
  local n = node:field("name")[1]
  if n then
    return text(n, buf)
  end
  local d = node:field("declarator")[1]
  if d then
    return find_ident(d, buf)
  end
  -- const foo = () => {}   /   { foo: function() {} }
  local p = node:parent()
  if p then
    local f = p:field("name")[1] or p:field("left")[1] or p:field("key")[1]
    if f then
      return text(f, buf)
    end
  end
end

function M.collect(buf)
  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  if not ok or not parser then
    return nil
  end
  local root = parser:parse()[1]:root()
  local items = {}
  local function walk(node)
    if FUNC_NODES[node:type()] then
      local name = name_of(node, buf)
      if name then
        local sr, _, er = node:range()
        table.insert(items, {
          name = name:match("[^\n]*"),
          line = sr + 1,
          count = er - sr + 1,
        })
      end
    end
    for child in node:iter_children() do
      walk(child)
    end
  end
  walk(root)
  return items
end

function M.pick()
  local buf = vim.api.nvim_get_current_buf()
  local items = M.collect(buf)
  if not items then
    return vim.notify("No treesitter parser for this filetype", vim.log.levels.WARN)
  end
  if #items == 0 then
    return vim.notify("No functions found", vim.log.levels.INFO)
  end
  vim.ui.select(items, {
    prompt = "Functions",
    format_item = function(it)
      return ("function %s : #%d LINE"):format(it.name, it.line)
    end,
  }, function(it)
    if it then
      vim.api.nvim_win_set_cursor(0, { it.line, 0 })
      vim.cmd("normal! zz")
    end
  end)
end

-- Inline hint at the end of each function's first line: "󰊕 18 lines"
function M.refresh(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  if not enabled then
    return
  end
  local items = M.collect(buf)
  if not items then
    return
  end
  for _, it in ipairs(items) do
    vim.api.nvim_buf_set_extmark(buf, ns, it.line - 1, 0, {
      virt_text = { { ("  󰊕 %d lines"):format(it.count), "Comment" } },
      virt_text_pos = "eol",
    })
  end
end

function M.toggle()
  enabled = not enabled
  M.refresh(vim.api.nvim_get_current_buf())
  vim.notify("Function length hints " .. (enabled and "ON" or "OFF"))
end

return {
  "nvim-treesitter/nvim-treesitter",
  keys = {
    { "<leader>cL", M.pick, desc = "Function list (#LINE)" },
    { "<leader>cV", M.toggle, desc = "Toggle function length hints" },
  },
  init = function()
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
      group = vim.api.nvim_create_augroup("function_lines", { clear = true }),
      callback = function(ev)
        if enabled then
          M.refresh(ev.buf)
        end
      end,
    })
  end,
}
