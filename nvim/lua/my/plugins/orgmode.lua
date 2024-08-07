return {
	{
		"nvim-orgmode/orgmode",
		dependencies = {
		},
		event = 'VeryLazy',
		ft = { "org" },
	},
	{
		"akinsho/org-bullets.nvim",
		config = function()
			require("org-bullets").setup {
				concealcursor = false, -- If false then when the cursor is on a line underlying characters are visible
				symbols = {
					-- list symbol
					list = "•",
					-- headlines can be a list
					headlines = { "◉", "○", "✸", "✿" },
					checkboxes = {
						half = { "", "@org.checkbox.halfchecked" },
						done = { "✓", "@org.keyword.done" },
						todo = { "˟", "@org.keyword.todo" },
					},
				}
			}
		end,
		dependencies = { "nvim-orgmode/orgmode" },
		event = "VeryLazy",
		ft = { "org" },
	},
	{
		"nvim-orgmode/telescope-orgmode.nvim",
		event = "VeryLazy",
		ft = { "org" },
		tag = "1.2.0",
		dependencies = {
			"nvim-orgmode/orgmode",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope").load_extension("orgmode")

			vim.keymap.set("n", "<leader>orh", require("telescope").extensions.orgmode.refile_heading)
			vim.keymap.set("n", "<leader>osh", require("telescope").extensions.orgmode.search_headings)
			vim.keymap.set("n", "<leader>oil", require("telescope").extensions.orgmode.insert_link)
		end,
	},
	{ 'dhruvasagar/vim-table-mode', ft = { 'markdown', 'org' } }
}
