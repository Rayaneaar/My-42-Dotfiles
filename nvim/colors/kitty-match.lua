vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "kitty-match"

local p = {}
local f = io.open(vim.fn.expand("~/.config/kitty/solitude.conf"))
if f then
  for line in f:lines() do
    local k, v = line:match("^(%S+)%s+(#%x%x%x%x%x%x)")
    if k then p[k] = v end
  end
  f:close()
end
local d = {
  background = "#000000", foreground = "#c1c1c1",
  color1 = "#cc5555", color2 = "#55cc55", color3 = "#cccc55", color4 = "#5555cc",
  color5 = "#cc55cc", color6 = "#55cccc", color8 = "#555555",
}
for k, v in pairs(d) do p[k] = p[k] or v end
p.selection_background = p.selection_background or p.color8
p.selection_foreground = p.selection_foreground or p.foreground

local function rgb(h) return tonumber(h:sub(2, 3), 16), tonumber(h:sub(4, 5), 16), tonumber(h:sub(6, 7), 16) end
local function mix(a, b, t)
  local r1, g1, b1 = rgb(a)
  local r2, g2, b2 = rgb(b)
  local function m(x, y) return math.floor(x + (y - x) * t + 0.5) end
  return string.format("#%02x%02x%02x", m(r1, r2), m(g1, g2), m(b1, b2))
end

local bg, fg = p.background, p.foreground
local nobg = vim.g.kitty_match_transparent and "NONE" or bg
local soft, mid, dim = mix(bg, fg, 0.08), mix(bg, fg, 0.18), p.color8
local a = p.url_color or p.color4  -- accent

-- the gradient: every token type gets its own shade, all pulled toward the accent
local c = {
  var     = mix(fg, a, 0.30),
  fn      = a,
  param   = mix(p.color6, fg, 0.25),
  prop    = mix(p.color4, fg, 0.35),
  kw      = mix(p.color5, a, 0.25),
  type    = mix(p.color6, a, 0.25),
  str     = mix(p.color2, a, 0.20),
  num     = mix(p.color3, a, 0.20),
  const   = mix(p.color3, p.color1, 0.35),
  builtin = mix(p.color1, a, 0.35),
  mod     = mix(p.color6, p.color2, 0.40),
  op      = mix(fg, dim, 0.45),
}

for i = 0, 15 do vim.g["terminal_color_" .. i] = p["color" .. i] or fg end

local G = {
  Normal = { fg = fg, bg = nobg }, NormalNC = { fg = fg, bg = nobg },
  NormalFloat = { fg = fg, bg = nobg }, FloatBorder = { fg = dim, bg = nobg },
  FloatTitle = { fg = a, bg = nobg, bold = true },
  SignColumn = { bg = nobg }, EndOfBuffer = { fg = bg, bg = nobg },
  LineNr = { fg = dim }, CursorLineNr = { fg = a, bold = true },
  CursorLine = { bg = soft }, ColorColumn = { bg = soft },
  Visual = { fg = p.selection_foreground, bg = p.selection_background },
  Search = { fg = bg, bg = p.color3 }, IncSearch = { fg = bg, bg = p.color2 },
  CurSearch = { fg = bg, bg = p.color2 },
  MatchParen = { fg = p.color3, bold = true, underline = true },
  WinSeparator = { fg = mid }, VertSplit = { fg = mid },
  Folded = { fg = dim, bg = soft }, NonText = { fg = mid }, Whitespace = { fg = mid },
  Pmenu = { fg = fg, bg = soft }, PmenuSel = { fg = p.selection_foreground, bg = p.selection_background },
  PmenuSbar = { bg = soft }, PmenuThumb = { bg = dim },
  StatusLine = { fg = fg, bg = soft }, StatusLineNC = { fg = dim, bg = soft },
  TabLine = { fg = dim, bg = soft }, TabLineSel = { fg = a, bg = bg, bold = true }, TabLineFill = { bg = soft },
  Title = { fg = a, bold = true }, Directory = { fg = a },
  ErrorMsg = { fg = p.color1 }, WarningMsg = { fg = p.color3 }, MoreMsg = { fg = p.color2 },

  -- classic syntax groups
  Comment = { fg = dim, italic = true },
  Constant = { fg = c.const }, String = { fg = c.str }, Character = { fg = c.str },
  Number = { fg = c.num }, Boolean = { fg = c.const }, Float = { fg = c.num },
  Identifier = { fg = c.var }, Function = { fg = c.fn },
  Statement = { fg = c.kw }, Conditional = { fg = c.kw }, Repeat = { fg = c.kw },
  Keyword = { fg = c.kw }, Operator = { fg = c.op },
  PreProc = { fg = c.kw }, Include = { fg = c.kw },
  Type = { fg = c.type }, Special = { fg = c.builtin }, Delimiter = { fg = dim },
  Todo = { fg = bg, bg = p.color3, bold = true }, Underlined = { underline = true },
  Error = { fg = p.color1 },

  -- treesitter
  ["@variable"] = { fg = c.var },
  ["@variable.builtin"] = { fg = c.builtin, italic = true },
  ["@variable.parameter"] = { fg = c.param, italic = true },
  ["@variable.member"] = { fg = c.prop },
  ["@property"] = { fg = c.prop },
  ["@function"] = { fg = c.fn, bold = true },
  ["@function.call"] = { fg = mix(c.fn, fg, 0.20) },
  ["@function.method"] = { fg = c.fn },
  ["@function.method.call"] = { fg = mix(c.fn, fg, 0.20) },
  ["@function.builtin"] = { fg = c.builtin },
  ["@constructor"] = { fg = c.type },
  ["@keyword"] = { fg = c.kw },
  ["@keyword.function"] = { fg = c.kw, italic = true },
  ["@keyword.return"] = { fg = c.kw, bold = true },
  ["@type"] = { fg = c.type },
  ["@type.builtin"] = { fg = c.builtin },
  ["@string"] = { fg = c.str },
  ["@string.escape"] = { fg = c.builtin },
  ["@number"] = { fg = c.num },
  ["@boolean"] = { fg = c.const },
  ["@constant"] = { fg = c.const },
  ["@constant.builtin"] = { fg = c.builtin },
  ["@module"] = { fg = c.mod },
  ["@operator"] = { fg = c.op },
  ["@punctuation"] = { fg = dim },
  ["@punctuation.bracket"] = { fg = mix(fg, dim, 0.5) },
  ["@tag"] = { fg = c.fn },
  ["@tag.attribute"] = { fg = c.prop },
  ["@attribute"] = { fg = c.mod },
  ["@comment"] = { fg = dim, italic = true },

  -- LSP semantic tokens
  ["@lsp.type.variable"] = { link = "@variable" },
  ["@lsp.type.parameter"] = { link = "@variable.parameter" },
  ["@lsp.type.property"] = { link = "@property" },
  ["@lsp.type.function"] = { link = "@function" },
  ["@lsp.type.method"] = { link = "@function.method" },
  ["@lsp.type.class"] = { link = "@type" },
  ["@lsp.type.namespace"] = { link = "@module" },

  DiagnosticError = { fg = p.color1 }, DiagnosticWarn = { fg = p.color3 },
  DiagnosticInfo = { fg = a }, DiagnosticHint = { fg = p.color6 },
  DiagnosticUnderlineError = { undercurl = true, sp = p.color1 },
  DiagnosticUnderlineWarn = { undercurl = true, sp = p.color3 },
  DiagnosticUnderlineInfo = { undercurl = true, sp = a },
  DiagnosticUnderlineHint = { undercurl = true, sp = p.color6 },

  DiffAdd = { bg = mix(bg, p.color2, 0.2) }, DiffDelete = { bg = mix(bg, p.color1, 0.2) },
  DiffChange = { bg = mix(bg, a, 0.2) }, DiffText = { bg = mix(bg, a, 0.4) },
  GitSignsAdd = { fg = p.color2 }, GitSignsChange = { fg = a }, GitSignsDelete = { fg = p.color1 },
}
for name, opts in pairs(G) do vim.api.nvim_set_hl(0, name, opts) end
