local status1, lsp = pcall(require, "lsp-zero")
if not status1 then
  print("lsp-zero not installed")
  return
end

lsp.preset("recommended")
lsp.ensure_installed({
  "tsserver",
  "sumneko_lua",
  "marksman",
})

local status2, cmp = pcall(require, "cmp")
if not status2 then
  print("cmp not installed")
  return
end

local status3, lspsaga = pcall(require, "lspsaga")
if not status3 then
  print("lspsaga not installed")
  return
end

local has_flutter_tools = pcall(require, "flutter-tools")
if not has_flutter_tools then
  print("flutter-tools not installed")
  return
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
    end
  end, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<CR>"] = cmp.mapping.confirm({ select = true }),
  ["<C-e>"] = cmp.mapping.abort(),
  ["<C-u>"] = cmp.mapping.scroll_docs(-4),
  ["<C-d>"] = cmp.mapping.scroll_docs(4),
  ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
})

-- Flutter
require("flutter-tools").setup({
  closing_tags = {
    enabled = true,
    prefix = ">",
  },
  lsp = {
    color = {
      enabled = true,
      background = false,
      foreground = false,
      virtual_text = true,
      virtual_text_str = "■",
    },
    settings = {
      showTodos = false,
    },
  },
})

lspsaga.setup({
  lightbulb = {
    enable = false,
  },
})

lsp.setup()
