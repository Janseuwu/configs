--
-- LSP config
--

local lspconfig = require("lspconfig")

local function on_attach()
	-- TODO: register LSP mappings here
	print("attached")
end

lspconfig.pyright.setup({ on_attach = on_attach })

--
-- Completion
--

-- Set up nvim-cmp.
local cmp = require('cmp')

vim.cmd[[set completeopt=menu,menuone,noselect]]

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'calc' },
    { name = 'buffer' },
  })
})
