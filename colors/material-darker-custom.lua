-- Converted from Material_Darker.icls (Rider 2026.1.4.0.0).
-- Source SHA-256: a82773dddfb57f2306792ad4ce2970f3c39272d818c4a46f36845968247043b2
-- Static highlights: no XML parser, theme engine, or external dependency at runtime.

vim.o.background = 'dark'
vim.cmd 'highlight clear'
if vim.fn.exists 'syntax_on' == 1 then
  vim.cmd 'syntax reset'
end
vim.g.colors_name = 'material-darker-custom'

local p = {
  bg = '#191A1C',
  fg = '#EEFFFF',
  gutter = '#212121',
  line = '#424242',
  line_active = '#616161',
  cursorline = '#181818',
  selection = '#353535',
  selection_fg = '#FFFBF7',
  popup = '#292929',
  border = '#424242',
  accent = '#FF9800',
  whitespace = '#616161',
  add = '#C3E88D',
  change = '#FFCB6B',
  delete = '#F07178',
}

-- Exported editor attributes, including inherited attributes present in the file.
local s = {
  ['text'] = { fg = '#EEFFFF', bg = '#191A1C' }, -- TEXT
  ['comment'] = { fg = '#616161', italic = true }, -- DEFAULT_LINE_COMMENT
  ['comment_block'] = { fg = '#616161', italic = true }, -- DEFAULT_BLOCK_COMMENT
  ['comment_doc'] = { fg = '#616161', italic = true }, -- DEFAULT_DOC_COMMENT
  ['todo'] = { fg = '#FFEB95', italic = true }, -- TODO_DEFAULT_ATTRIBUTES
  ['keyword'] = { fg = '#C792EA', italic = true }, -- DEFAULT_KEYWORD
  ['string'] = { fg = '#C3E88D' }, -- DEFAULT_STRING
  ['escape'] = { fg = '#89DDFF' }, -- DEFAULT_VALID_STRING_ESCAPE
  ['number'] = { fg = '#F78C6C' }, -- DEFAULT_NUMBER
  ['operator'] = { fg = '#89DDFF' }, -- DEFAULT_OPERATION_SIGN
  ['delimiter'] = { fg = '#89DDFF' }, -- DEFAULT_BRACES
  ['identifier'] = { fg = '#EEFFFF' }, -- DEFAULT_IDENTIFIER
  ['field'] = { fg = '#EEFFFF' }, -- DEFAULT_INSTANCE_FIELD
  ['static_field'] = { fg = '#EEFFFF', italic = true }, -- DEFAULT_STATIC_FIELD
  ['constant'] = { fg = '#F78C6C' }, -- DEFAULT_CONSTANT
  ['class'] = { fg = '#FFCB6B' }, -- DEFAULT_CLASS_NAME
  ['interface'] = { fg = '#C3E88D', italic = true }, -- DEFAULT_INTERFACE_NAME
  ['function'] = { fg = '#82AAFF' }, -- DEFAULT_FUNCTION_DECLARATION
  ['function_call'] = { fg = '#82AAFF' }, -- DEFAULT_FUNCTION_CALL
  ['static_method'] = { fg = '#82AAFF', italic = true }, -- DEFAULT_STATIC_METHOD
  ['parameter'] = { fg = '#F78C6C' }, -- DEFAULT_PARAMETER
  ['builtin'] = { fg = '#82AAFF', italic = true }, -- DEFAULT_PREDEFINED_SYMBOL
  ['attribute'] = { fg = '#FFCB6B', italic = true }, -- DEFAULT_ATTRIBUTE
  ['tag'] = { fg = '#F07178' }, -- DEFAULT_TAG
  ['entity'] = { fg = '#F78C6C' }, -- DEFAULT_ENTITY
  ['deprecated'] = { fg = '#616161', strikethrough = true, sp = '#616161' }, -- DEPRECATED_ATTRIBUTES
  ['inlay'] = { fg = '#B0BEC5', bg = '#1A1A1A' }, -- INLINE_PARAMETER_HINT
  ['matched'] = { bg = '#353535', bold = true, underline = true, sp = '#FFCC00' }, -- MATCHED_BRACE_ATTRIBUTES
  ['search'] = { bg = '#323232' }, -- SEARCH_RESULT_ATTRIBUTES
  ['search_current'] = { fg = '#212C32', bg = '#F8E71C' }, -- TEXT_SEARCH_RESULT_ATTRIBUTES
  ['reference'] = { bg = '#033E5D' }, -- IDENTIFIER_UNDER_CARET_ATTRIBUTES
  ['reference_write'] = { bg = '#4A4D50' }, -- WRITE_IDENTIFIER_UNDER_CARET_ATTRIBUTES
  ['diff_add'] = { bg = '#264B33' }, -- DIFF_INSERTED
  ['diff_change'] = { bg = '#12404B' }, -- DIFF_MODIFIED
  ['diff_delete'] = { bg = '#41454B' }, -- DIFF_DELETED
  ['error'] = { undercurl = true, sp = '#FF5370' }, -- ERRORS_ATTRIBUTES
  ['warning'] = { undercurl = true, sp = '#FFCB6B' }, -- WARNING_ATTRIBUTES
  ['info'] = { undercurl = true, sp = '#C3E88D' }, -- INFO_ATTRIBUTES
  ['hint'] = { underdotted = true, sp = '#89DDFF' }, -- ReSharper.HINT
  ['hyperlink'] = { fg = '#89DDF7', underline = true, sp = '#89DDF7' }, -- HYPERLINK_ATTRIBUTES
  ['csharp_struct'] = { fg = '#FFCB6B', underline = true, sp = '#FFCB6B' }, -- ReSharper.STRUCT_IDENTIFIER
  ['csharp_enum'] = { fg = '#F78C6C' }, -- ReSharper.ENUM_IDENTIFIER
  ['csharp_event'] = { fg = '#EEFFE3', bold = true }, -- ReSharper.EVENT_IDENTIFIER
  ['csharp_delegate'] = { fg = '#F78C6C', bold = true }, -- ReSharper.DELEGATE_IDENTIFIER
  ['csharp_static_class'] = { fg = '#FFCB6B', italic = true }, -- ReSharper.STATIC_CLASS_IDENTIFIER
  ['csharp_type_parameter'] = { fg = '#C3E88D', italic = true }, -- ReSharper.TYPE_PARAMETER_IDENTIFIER
  ['java_modifier'] = { fg = '#F78C6C', italic = true }, -- JAVA.MODIFIER
  ['java_this'] = { fg = '#FF5370', italic = true }, -- JAVA.THIS_SUPER
  ['java_type_parameter'] = { fg = '#F78C6C' }, -- TYPE_PARAMETER_NAME_ATTRIBUTES
  ['js_conditional'] = { fg = '#89DDFF', italic = true }, -- JS.IF_ELSE
  ['js_module'] = { fg = '#89DDFF', italic = true }, -- JS.MODULE_KEYWORD
  ['js_primitive'] = { fg = '#FF9CAC' }, -- JS.PRIMITIVE
  ['js_null'] = { fg = '#F78C6C', italic = true }, -- JS.NULL_UNDEFINED
  ['js_this'] = { fg = '#FF5370' }, -- JS.THIS_SUPER
  ['js_module_name'] = { fg = '#C3E88D', italic = true }, -- JS.MODULE_NAME
  ['ts_type'] = { fg = '#B2CCD6' }, -- TS.PRIM_TYPE
  ['ts_type_parameter'] = { fg = '#FFCB6B' }, -- TS.TYPE_PARAMETER
  ['json_key'] = { fg = '#C792EA' }, -- JSON.PROPERTY_KEY
  ['json_keyword'] = { fg = '#F78C6C', italic = true }, -- JSON.KEYWORD
  ['yaml_key'] = { fg = '#F07178' }, -- YAML_SCALAR_KEY
  ['yaml_value'] = { fg = '#89DDFF' }, -- YAML_SCALAR_VALUE
  ['css_class'] = { fg = '#FFCB6B', italic = true }, -- CSS.CLASS_NAME
  ['css_pseudo'] = { fg = '#C792EA', italic = true }, -- CSS.PSEUDO
  ['css_tag'] = { fg = '#F07178' }, -- CSS.TAG_NAME
  ['css_property'] = { fg = '#B2CCD6' }, -- CSS.PROPERTY_NAME
  ['css_value'] = { fg = '#F78C6C' }, -- CSS.PROPERTY_VALUE
  ['css_important'] = { fg = '#F78C6C', italic = true }, -- CSS.IMPORTANT
  ['python_conditional'] = { fg = '#89DDFF', italic = true }, -- PY.IF_ELSE
  ['python_import'] = { fg = '#89DDFF', italic = true }, -- PY.IMPORT
  ['python_self'] = { fg = '#FF5370', italic = true }, -- PY.SELF_PARAMETER
  ['python_decorator'] = { fg = '#82AAFF' }, -- PY.DECORATOR
  ['python_annotation'] = { fg = '#FFCB6B' }, -- PY.ANNOTATION
  ['bash_external'] = { fg = '#82AAFF', italic = true }, -- BASH.EXTERNAL_COMMAND
  ['markdown_code'] = { fg = '#C792EA' }, -- MARKDOWN_CODE_BLOCK
  ['markdown_bold'] = { fg = '#F07178', bold = true }, -- MARKDOWN_BOLD
  ['markdown_italic'] = { fg = '#F07178', italic = true }, -- MARKDOWN_ITALIC
  ['markdown_link'] = { fg = '#F07178' }, -- MARKDOWN_LINK_TEXT
}

local function set(groups, style)
  for _, group in ipairs(type(groups) == 'string' and { groups } or groups) do
    vim.api.nvim_set_hl(0, group, style)
  end
end

local function link(groups, target)
  set(groups, { link = target })
end

-- Editor colors come from TEXT and the exported gutter, selection, and popup colors.
set({ 'Normal', 'NormalNC' }, { fg = p.fg, bg = p.bg })
set({ 'NormalFloat', 'Pmenu' }, { fg = p.fg, bg = p.popup })
set({ 'FloatBorder', 'WinSeparator' }, { fg = p.border, bg = p.bg })
set({ 'FloatTitle', 'Title' }, { fg = p.accent, bold = true })
set('CursorLine', { bg = p.cursorline })
set({ 'LineNr', 'SignColumn', 'FoldColumn' }, { fg = p.line, bg = p.bg })
set('CursorLineNr', { fg = p.line_active, bg = p.bg })
set('Folded', { fg = s.comment.fg, bg = p.gutter })
set({ 'NonText', 'Whitespace', 'SpecialKey' }, { fg = p.whitespace })
set('EndOfBuffer', { fg = p.bg })
set({ 'Visual', 'PmenuSel' }, { fg = p.selection_fg, bg = p.selection })
set('PmenuSbar', { bg = p.gutter })
set('PmenuThumb', { bg = p.accent })
set('ColorColumn', { bg = p.border })
set('MatchParen', s.matched)
set('Search', s.search)
set({ 'IncSearch', 'CurSearch' }, s.search_current)
set('StatusLine', { fg = p.fg, bg = p.gutter })
set({ 'StatusLineNC', 'TabLine' }, { fg = s.comment.fg, bg = p.gutter })
set('TabLineSel', { fg = p.selection_fg, bg = p.selection, bold = true })
set('TabLineFill', { bg = p.bg })
set({ 'Directory', 'Question', 'MoreMsg' }, { fg = s['function'].fg })
set('WarningMsg', { fg = s.warning.sp })
set('ErrorMsg', { fg = s.error.sp })
set('DiffAdd', s.diff_add)
set('DiffChange', s.diff_change)
set('DiffDelete', s.diff_delete)
set('DiffText', vim.tbl_extend('force', s.diff_change, { bold = true }))

-- Traditional syntax and Treesitter share the exported language defaults.
set({ 'Comment', '@comment' }, s.comment)
set('@comment.documentation', s.comment_doc)
set({ 'Todo', '@comment.todo' }, s.todo)
set({ 'Constant', '@constant' }, s.constant)
set({ 'String', '@string' }, s.string)
set({ 'Character', '@character' }, s.string)
set({ 'Number', 'Float', '@number', '@number.float' }, s.number)
set({ 'Boolean', '@boolean' }, s.keyword)
set({ 'Identifier', '@variable', '@property', '@variable.member' }, s.identifier)
set('@variable.parameter', s.parameter)
set({ 'Function', '@function', '@function.method' }, s['function'])
set({ '@function.call', '@function.method.call' }, s.function_call)
set({ 'Statement', 'Conditional', 'Repeat', 'Label', 'Keyword', 'Exception', '@keyword' }, s.keyword)
set({ 'Operator', '@operator' }, s.operator)
set({ 'Type', 'Structure', 'Typedef', '@type', '@type.definition', '@constructor' }, s.class)
set({ 'StorageClass', 'PreProc', 'Include', 'Define', 'Macro', 'PreCondit', '@keyword.directive' }, s.keyword)
set({ 'Special', 'SpecialChar', '@string.escape', '@string.special' }, s.escape)
set({ 'Delimiter', '@punctuation.delimiter', '@punctuation.bracket', '@punctuation.special' }, s.delimiter)
set({ 'SpecialComment', 'Debug', '@attribute' }, s.attribute)
set({ '@variable.builtin', '@function.builtin', '@constant.builtin' }, s.builtin)
set('@type.builtin', s.interface)
set('Underlined', s.hyperlink)
set('Error', { fg = s.error.sp })
set('Ignore', { fg = s.comment.fg })
set({ '@tag', '@tag.builtin' }, s.tag)
set('@tag.attribute', s.attribute)
set('@tag.delimiter', s.delimiter)
set('@string.special.url', s.hyperlink)
set('@markup.heading', { fg = s.keyword.fg, bold = true })
set('@markup.raw', s.markdown_code)
set('@markup.strong', s.markdown_bold)
set('@markup.italic', s.markdown_italic)
set({ '@markup.link', '@markup.link.label' }, s.markdown_link)
set('@markup.link.url', s.hyperlink)
set('@markup.list', s.delimiter)

-- Language-specific overrides also apply inside Svelte's injected TS/JS/CSS trees.
for _, language in ipairs { 'javascript', 'typescript', 'tsx' } do
  set('@keyword.conditional.' .. language, s.js_conditional)
  set('@keyword.exception.' .. language, s.js_conditional)
  set('@keyword.import.' .. language, s.js_module)
  set('@keyword.coroutine.' .. language, s.js_conditional)
  set('@variable.builtin.' .. language, s.js_this)
  set('@constant.builtin.' .. language, s.js_null)
  set('@boolean.' .. language, s.js_primitive)
  set('@type.builtin.' .. language, s.ts_type)
  set('@module.' .. language, s.js_module_name)
end
set({ '@keyword.conditional.python', '@keyword.exception.python', '@keyword.return.python', '@keyword.coroutine.python' }, s.python_conditional)
set('@keyword.import.python', s.python_import)
set('@variable.builtin.python', s.python_self)
set('@attribute.python', s.python_decorator)
set('@type.python', s.python_annotation)
set({ '@property.json', '@string.special.key.json' }, s.json_key)
set({ '@boolean.json', '@constant.builtin.json' }, s.json_keyword)
set({ '@property.yaml', '@field.yaml' }, s.yaml_key)
set('@string.special.key.yaml', s.yaml_key)
set({ '@string.yaml', '@string.special.yaml' }, s.yaml_value)
set('@type.css', s.css_class)
set('@tag.css', s.css_tag)
set('@property.css', s.css_property)
set('@attribute.css', s.css_pseudo)
set('@type.builtin.css', s.css_pseudo)
set({ '@string.css', '@number.css' }, s.css_value)
set({ '@keyword.css', '@keyword.modifier.css' }, s.css_important)
set('@function.call.bash', s.bash_external)
set('@comment.bash', s.comment)
set('@keyword.modifier.java', s.java_modifier)
set('@variable.builtin.java', s.java_this)
set({ '@type.builtin.java', '@type.builtin.c_sharp' }, s.keyword)
set('@type.builtin.python', s.builtin)

-- LSP tokens preserve the same palette instead of overriding it with unrelated colors.
local semantic = {
  variable = '@variable',
  parameter = '@variable.parameter',
  property = '@property',
  ['function'] = '@function',
  method = '@function.method',
  macro = '@function',
  class = '@type',
  type = '@type',
  struct = '@type',
  enum = '@type',
  interface = '@type.builtin',
  typeParameter = '@variable.parameter',
  namespace = '@module',
  enumMember = '@constant',
  event = '@property',
  keyword = '@keyword',
  modifier = '@keyword',
  comment = '@comment',
  string = '@string',
  number = '@number',
  regexp = '@string',
  operator = '@operator',
  decorator = '@attribute',
}
set('@module', s.identifier)
for token, target in pairs(semantic) do
  link('@lsp.type.' .. token, target)
end
set('@lsp.mod.deprecated', s.deprecated)
for _, token in ipairs { 'variable', 'function', 'method', 'type', 'class' } do
  local target = token == 'variable' and '@variable.builtin' or ((token == 'type' or token == 'class') and '@type.builtin' or '@function.builtin')
  link('@lsp.typemod.' .. token .. '.defaultLibrary', target)
end
set('@lsp.typemod.variable.static', s.static_field)
set('@lsp.typemod.method.static', s.static_method)
set('@lsp.typemod.property.static', s.static_field)
set('@lsp.type.struct.cs', s.csharp_struct)
set('@lsp.type.enum.cs', s.csharp_enum)
set('@lsp.type.event.cs', s.csharp_event)
set('@lsp.type.delegate.cs', s.csharp_delegate)
set('@lsp.type.typeParameter.cs', s.csharp_type_parameter)
set('@lsp.typemod.class.static.cs', s.csharp_static_class)
set('@lsp.type.typeParameter.java', s.java_type_parameter)
for _, language in ipairs { 'javascript', 'typescript', 'typescriptreact' } do
  set('@lsp.type.typeParameter.' .. language, s.ts_type_parameter)
  set('@lsp.type.namespace.' .. language, s.js_module_name)
end
set('LspInlayHint', s.inlay)
set({ 'LspReferenceText', 'LspReferenceRead' }, s.reference)
set('LspReferenceWrite', s.reference_write)

for _, diagnostic in ipairs { { 'Error', s.error }, { 'Warn', s.warning }, { 'Info', s.info }, { 'Hint', s.hint } } do
  local name, style = diagnostic[1], diagnostic[2]
  set('Diagnostic' .. name, { fg = style.sp })
  link({ 'DiagnosticSign' .. name, 'DiagnosticVirtualText' .. name, 'DiagnosticFloating' .. name }, 'Diagnostic' .. name)
  set('DiagnosticUnderline' .. name, style)
end
set('DiagnosticUnnecessary', { fg = s.comment.fg })
set('DiagnosticDeprecated', s.deprecated)
set('SpellBad', s.error)
set('SpellCap', s.warning)
set('SpellLocal', s.info)
set('SpellRare', s.hint)

-- Highlight existing plugins without loading them or adding dependencies.
link({ 'TelescopeNormal', 'BlinkCmpMenu', 'BlinkCmpDoc', 'BlinkCmpSignatureHelp', 'WhichKeyNormal' }, 'NormalFloat')
link({ 'TelescopeBorder', 'BlinkCmpMenuBorder', 'BlinkCmpDocBorder', 'BlinkCmpSignatureHelpBorder', 'WhichKeyBorder', 'MiniFilesBorder' }, 'FloatBorder')
link({ 'TelescopeTitle', 'MiniFilesTitle', 'MiniFilesTitleFocused' }, 'Title')
link({ 'TelescopeSelection', 'BlinkCmpMenuSelection' }, 'PmenuSel')
set({ 'TelescopeMatching', 'BlinkCmpLabelMatch' }, { fg = p.accent, bold = true })
link({ 'TelescopePromptPrefix', 'TelescopeSelectionCaret' }, 'Title')
set({ 'BlinkCmpLabel', 'BlinkCmpLabelDetail' }, { fg = p.fg })
link({ 'BlinkCmpLabelDescription', 'BlinkCmpSource', 'BlinkCmpGhostText' }, 'Comment')
set('BlinkCmpLabelDeprecated', s.deprecated)
link('BlinkCmpKind', 'Type')
for kind, target in pairs {
  Text = 'Comment',
  Method = 'Function',
  Function = 'Function',
  Constructor = 'Type',
  Field = 'Identifier',
  Variable = 'Identifier',
  Class = 'Type',
  Interface = '@type.builtin',
  Module = '@module',
  Property = 'Identifier',
  Keyword = 'Keyword',
  Constant = 'Constant',
  Enum = 'Type',
  EnumMember = 'Constant',
  Struct = 'Type',
  TypeParameter = '@variable.parameter',
} do
  link('BlinkCmpKind' .. kind, target)
end
link('BlinkCmpSignatureHelpActiveParameter', '@variable.parameter')
link('WhichKey', 'Function')
set('WhichKeyGroup', { fg = s.keyword.fg, bold = true })
set('WhichKeyDesc', { fg = p.fg })
link({ 'WhichKeySeparator', 'WhichKeyValue' }, 'Comment')
link('MiniFilesNormal', 'NormalFloat')
link('MiniFilesDirectory', 'Directory')
set('MiniFilesFile', { fg = p.fg })
link('MiniFilesCursorLine', 'PmenuSel')
link({ 'MiniStatuslineDevinfo', 'MiniStatuslineFilename', 'MiniStatuslineFileinfo' }, 'StatusLine')
link('MiniStatuslineInactive', 'StatusLineNC')
for mode, color in pairs {
  Normal = s['function'].fg,
  Insert = s.string.fg,
  Visual = s.keyword.fg,
  Replace = s.error.sp,
  Command = p.accent,
  Other = s.operator.fg,
} do
  set('MiniStatuslineMode' .. mode, { fg = p.bg, bg = color, bold = true })
end
link('TroubleNormal', 'Normal')
link('TroubleNormalNC', 'NormalNC')
set({ 'TroubleText', 'TroubleFilename' }, { fg = p.fg })
link({ 'TroubleSource', 'TroublePos', 'TroubleIndent' }, 'Comment')
link('TroubleCount', 'Number')
link('FidgetTitle', 'Title')
link('FidgetTask', 'Comment')
set('GitSignsAdd', { fg = p.add, bg = p.bg })
set('GitSignsChange', { fg = p.change, bg = p.bg })
set({ 'GitSignsDelete', 'GitSignsTopdelete', 'GitSignsChangedelete' }, { fg = p.delete, bg = p.bg })
link('GitSignsAddLn', 'DiffAdd')
link('GitSignsChangeLn', 'DiffChange')
link('GitSignsDeleteLn', 'DiffDelete')
link('GitSignsCurrentLineBlame', 'Comment')
