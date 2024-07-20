--[[ https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/server_configurations ]]

require("debdut.lsp.handlers")

vim.diagnostic.config({
	virtual_text = true,
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		source = "if_many",
		header = "",
		prefix = "",
	},
})

require("neodev").setup {}

local language_servers = {
	bashls = {
		autostart = false,
	},
	clangd = {
		autostart = false,
	},
	dockerls = {
		autostart = false,
	},
	html = {
		autostart = false,
	},
	jsonls = {
		autostart = false,
	},
	yamlls = {
		autostart = false,
	},
	gopls = {
		autostart = false,
	},
	tsserver = {
		autostart = false,
	},
	pyright = {
		autostart = false,
	},
	lua_ls = {
		autostart = true,
	},
}

local formatters = {
	"prettier",
	"black",
	-- "sylua",
	"shfmt",
	"clang_format",
	-- "perltidy",
}

local linters = {
	"shellcheck",
}

local debug_servers = {
	"delve",
}

local manual_installs = {
	"perltidy",
}

require("mason-null-ls").setup {}

require("mason").setup {}

local ensure_installed = {}

for _, list in ipairs({ language_servers, formatters, linters, debug_servers, vim.tbl_keys(language_servers) }) do
	vim.list_extend(ensure_installed, list)
end

require("mason-tool-installer").setup {
	ensure_installed = ensure_installed,
	auto_update = false,
	run_on_start = true,
	integrations = {
		["mason-lspconfig"] = true,
		["mason-null-ls"] = true,
		["mason-nvim-dap"] = true,
	},
	-- debounce_hours = 7 * 24,
	-- start_delay = 5,
}

local function client_on_attach(client, bufnr)
	if client.name == "tsserver" then return end

	if client.server_capabilities.inlayHintProvider ~= nil and client.server_capabilities.inlayHintProvider then
		-- :h vim.lsp.inlay_hint
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

require("mason-lspconfig").setup {}

for name, extension in pairs(language_servers) do
	local ok, config = pcall(require, "debdut.lsp.settings." .. name)
	if not ok then
		config = {}
	end

	require("lspconfig")[name].setup(vim.tbl_extend('force', config, { on_attach = client_on_attach }, extension))
end
