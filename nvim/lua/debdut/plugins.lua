-- XXX: Note to self --
-- Lazy honestly feels bloated at this point.
-- Might not be the worst of ideas to strip those parts out
-- I like the idea of "lazy" loading plugins, but i don't want things like a floating terminal, or watching
-- config files to auto reload, or auto updating plugins (definitely not this, do I want to break my install every other day?).
-- Hm. Might not be the worst idea to go back to packer either.

local uselesspath = vim.fn.stdpath("data") .. "/useless/useless.nvim"
if not vim.loop.fs_stat(uselesspath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/debdutdeb/useless.nvim.git",
		"--branch=main", -- latest stable release
		uselesspath,
	})
end
vim.opt.rtp:prepend(uselesspath)

local ok, lazy = pcall(require, "lazy")
if not ok then
	return
end

lazy.setup({
	"nvim-lua/plenary.nvim", -- Useful lua functions used by lots of plugins

	{
		"ms-jpq/coq_nvim",
		branch = "coq",
		cmd = { "LspStartWithAutocomplete" },
	},
	{
		-- TODO: add ensure_installed
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			require("debdut.null-ls")
			require("mason-null-ls").setup({ automatic_installation = false })
		end,
	},

	-- "lspcontainers/lspcontainers.nvim",

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		ft = { "c", "cpp", "lua", "go", "typescript", "typescriptreact", "javascript", "javascriptreact", "rust", "markdown", "hcl", "terraform" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/playground",
			"nvim-treesitter/nvim-treesitter-refactor",
			"treesitter_context",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			Require("nvim-treesitter.configs").setup(require("debdut.treesitter"))
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		name = "treesitter_context",
		opts = require("debdut.treesitter_context"),
	},

	-- thanks primeagen (what is your real name??,
	{
		"ThePrimeagen/harpoon",
		keys = { "<leader>a", "<leader>h" },
	},

	-- remote containers?
	-- { "chipsenkbeil/distant.nvim", branch = "v0.2" },

	"towolf/vim-helm", -- TODO replace

	-- debug access protocol
	{
		"mfussenegger/nvim-dap", -- TODO
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui", -- requires nim-dap
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			require("debdut.dap")
		end,
	},

	"JoosepAlviste/nvim-ts-context-commentstring",

	{
		"numToStr/Comment.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		opts = require("debdut.comments"),
		keys = {
			{ "gcc", mode = "n" },
			{ "gc",  mode = "v" },
			{ "gb",  mode = "v" },
		}, -- default keymaps
	},

	{
		"wthollingsworth/pomodoro.nvim",
		cmd = { "PomodoroStart", "PomodoroStatus" },
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			time_work = 30,
			time_break_short = 5,
			time_break_long = 20,
			timers_to_long_break = 4,
		},
	},
	{
		"kylechui/nvim-surround",
		version = "v2.1.1",
		event = "VeryLazy",
		opts = {},
	},
	{
		"aserowy/tmux.nvim",
		event = "VeryLazy",
		opts = {
			copy_sync = {
				-- enables copy sync. by default, all registers are synchronized.
				-- to control which registers are synced, see the `sync_*` options.
				enable = true,

				-- ignore specific tmux buffers e.g. buffer0 = true to ignore the
				-- first buffer or named_buffer_name = true to ignore a named tmux
				-- buffer with name named_buffer_name :)
				ignore_buffers = { empty = false },

				-- TMUX >= 3.2: all yanks (and deletes) will get redirected to system
				-- clipboard by tmux
				redirect_to_clipboard = false,

				-- offset controls where register sync starts
				-- e.g. offset 2 lets registers 0 and 1 untouched
				register_offset = 0,

				-- overwrites vim.g.clipboard to redirect * and + to the system
				-- clipboard using tmux. If you sync your system clipboard without tmux,
				-- disable this option!
				sync_clipboard = true,

				-- synchronizes registers *, +, unnamed, and 0 till 9 with tmux buffers.
				sync_registers = true,

				-- syncs deletes with tmux clipboard as well, it is adviced to
				-- do so. Nvim does not allow syncing registers 0 and 1 without
				-- overwriting the unnamed register. Thus, ddp would not be possible.
				sync_deletes = true,

				-- syncs the unnamed register with the first buffer entry from tmux.
				sync_unnamed = true,
			},
			navigation = {
				-- cycles to opposite pane while navigating into the border
				cycle_navigation = true,

				-- enables default keybindings (C-hjkl) for normal mode
				enable_default_keybindings = true,

				-- prevents unzoom tmux when navigating beyond vim border
				persist_zoom = false,
			},
			resize = {
				-- enables default keybindings (A-hjkl) for normal mode
				enable_default_keybindings = true,

				-- sets resize steps for x axis
				resize_step_x = 1,

				-- sets resize steps for y axis
				resize_step_y = 1,
			},
		},
	},

	{
		"debdutdeb/nvim-fzf",
		lazy = false,
	},
	{
		"windwp/nvim-ts-autotag",
		ft = { "typescriptreact", "javascriptreact", "html" },
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "debdutdeb/chaos.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
		--[[ config = function()
			local telescope = require("telescope")
			telescope.setup(require("debdut.telescope"))
			telescope.load_extension("fzf")
		end, ]]
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build =
		"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},
	{
		"debdutdeb/chaos.nvim",
		lazy = false,
		dir = "/Users/debdut/Documents/Repos/chaos.nvim",
		config = function()
			-- something is going on here, with telescope's action merge. idk what. some type of race condition because
			-- of lazy my guess is.
			-- for now ignoring the error is ok. and that
			-- is what i will be doing
			-- local config = require("debdut.lsp.configs")
			-- require("chaos.lsp").setup_autocommands(config.configured_servers, config.get_config)
			local telescope = Require("telescope")
			telescope.setup(Require("debdut.telescope"))
			telescope.load_extension("fzf")
		end,
	},
	{ "tpope/vim-abolish", lazy = false },
	{
		"folke/persistence.nvim",
		opts = {
			dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
			options = { "buffers", "curdir", "tabpages", "winsize" },
			pre_save = nil,
			save_empty = false,
		},
		lazy = false,
	},
}, {
	root = vim.fn.stdpath("data") .. "/lazy", -- directory where plugins will be installed
	defaults = {
		lazy = true,                       -- should plugins be lazy-loaded?
		version = nil,
		-- default `cond` you can use to globally disable a lot of plugins
		-- when running inside vscode for example
		cond = nil, ---@type boolean|fun(self:LazyPlugin):boolean|nil
		-- version = "*", -- enable this to try installing the latest stable versions of plugins
	},
	-- leave nil when passing the spec as the first argument to setup()
	spec = nil, ---@type LazySpec
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
	-- concurrency = jit.os:find("Windows") and (vim.loop.available_parallelism() * 2) or nil, ---@type number limit the maximum amount of concurrent tasks
	git = {
		-- defaults for the `Lazy log` command
		-- log = { "-10" }, -- show the last 10 commits
		log = { "-8" }, -- show commits from the last 3 days
		timeout = 120, -- kill processes that take more than 2 minutes
		url_format = "https://github.com/%s.git",
		-- lazy.nvim requires git >=2.19.0. If you really want to use lazy with an older version,
		-- then set the below to false. This should work, but is NOT supported and will
		-- increase downloads a lot.
		filter = true,
	},
	--[[ dev = {
		-- directory where you store your local plugin projects
		path = "~/projects",
		---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
		patterns = {}, -- For example {"folke"}
		fallback = false, -- Fallback to git when local plugin doesn't exist
	}, ]]
	install = {
		-- install missing plugins on startup. This doesn't increase startup time.
		missing = true,
		-- try to load one of these colorschemes when starting an installation during startup
		-- colorscheme = { "carbonfox" },
	},
	ui = {
		-- a number <1 is a percentage., >1 is a fixed size
		size = { width = 0.8, height = 0.8 },
		wrap = true, -- wrap the lines in the ui
		-- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
		border = "none",
		title = nil, ---@type string only works when border is not "none"
		title_pos = "right", ---@type "center" | "left" | "right"
		icons = {
			cmd = "cmd:",
			config = "cfg:",
			event = "event:",
			ft = "ft:",
			init = "init:",
			import = "import:",
			keys = "keys:",
			lazy = "lazy:",
			loaded = "loaded:",
			not_loaded = "not_loaded:",
			plugin = "plugin:",
			runtime = "runtime:",
			source = "source:",
			start = "start:",
			task = "task:",
			list = {
				"ball",
				"here",
				"star",
				"line",
			},
		},
		-- leave nil, to automatically select a browser depending on your OS.
		-- If you want to use a specific browser, you can define it here
		browser = nil, ---@type string?
		throttle = 20, -- how frequently should the ui process render events
		custom_keys = {
			-- you can define custom key maps here.
			-- To disable one of the defaults, set it to false

			-- open lazygit log
			["<localleader>l"] = function(plugin)
				Require("lazy.util").float_term({ "lazygit", "log" }, {
					cwd = plugin.dir,
				})
			end,

			-- open a terminal for the plugin dir
			["<localleader>t"] = function(plugin)
				Require("lazy.util").float_term(nil, {
					cwd = plugin.dir,
				})
			end,
		},
	},
	diff = {
		-- diff command <d> can be one of:
		-- * browser: opens the github compare view. Note that this is always mapped to <K> as well,
		--   so you can have a different command for diff <d>
		-- * git: will run git diff and open a buffer with filetype git
		-- * terminal_git: will open a pseudo terminal with git diff
		-- * diffview.nvim: will open Diffview to show the diff
		cmd = "git",
	},
	checker = {
		-- automatically check for plugin updates
		enabled = false,
		concurrency = nil, ---@type number? set to 1 to check for updates very slowly
		notify = true, -- get a notification when new updates are found
		frequency = 3600, -- check for updates every hour
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = false,
		notify = true, -- get a notification when changes are found
	},
	performance = {
		cache = {
			enabled = true,
		},
		reset_packpath = true, -- reset the package path to improve startup time
		rtp = {
			reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
			---@type string[]
			paths = {},  -- add any custom paths here that you want to includes in the rtp
			---@type string[] list any plugins you want to disable here
			disabled_plugins = {
				-- "gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				-- "tarPlugin",
				-- "tohtml",
				-- "tutor",
				-- "zipPlugin",
			},
		},
	},
	-- lazy can generate helptags from the headings in markdown readme files,
	-- so :help works even for plugins that don't have vim docs.
	-- when the readme opens with :help it will be correctly displayed as markdown
	readme = {
		enabled = true,
		root = vim.fn.stdpath("state") .. "/lazy/readme",
		files = { "README.md", "lua/**/README.md" },
		-- only generate markdown helptags for plugins that dont have docs
		skip_if_doc_exists = true,
	},
	state = vim.fn.stdpath("state") .. "/lazy/state.json", -- state info for checker and other things
	build = {
		-- Plugins can provide a `build.lua` file that will be executed when the plugin is installed
		-- or updated. When the plugin spec also has a `build` command, the plugin's `build.lua` not be
		-- executed. In this case, a warning message will be shown.
		warn_on_override = true,
	},
})

vim.opt.rtp:prepend("/Users/debdut/Documents/Repos/chaos.nvim")
