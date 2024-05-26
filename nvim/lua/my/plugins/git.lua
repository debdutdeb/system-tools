return {
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		cond = function()
			return require("chaos.git_handlers").is_git_worktree()
			--[[ return #vim.fs.find('.git',
				{ upward = true, type = 'directory', limit = 1, stop = vim.uv.os_homedir(), path = vim.fs.dirname(vim
				.api.nvim_buf_get_name(0)), }) == 1 ]]
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		cond = function()
			return require("chaos.git_handlers").is_git_worktree()
		end,
		opts = {
			signs                             = {
				add          = { text = '|' },
				change       = { text = '|' },
				delete       = { text = '-' },
				topdelete    = { text = '=' },
				changedelete = { text = '~' },
				untracked    = { text = '?' },
			},
			signcolumn                        = false, -- Toggle with `:Gitsigns toggle_signs`
			numhl                             = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl                            = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff                         = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir                      = {
				follow_files = false
			},
			auto_attach                       = false,
			attach_to_untracked               = false,
			current_line_blame                = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts           = {
				virt_text = true,
				virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
			current_line_blame_formatter      = '<author>, <author_time:%Y-%m-%d> - <summary>',
			current_line_blame_formatter_opts = {
				relative_time = false,
			},
			sign_priority                     = 6,
			update_debounce                   = 100,
			status_formatter                  = nil, -- Use default
			max_file_length                   = 40000, -- Disable if file is longer than this (in lines)
			preview_config                    = {
				-- Options passed to nvim_open_win
				border = 'shadow',
				style = 'minimal',
				relative = 'cursor',
				row = 0,
				col = 1
			},
		},
	}
}
