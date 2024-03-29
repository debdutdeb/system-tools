vim.cmd([[
augroup _auto_resize
autocmd!
autocmd VimResized * tabdo wincmd =
augroup end

autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

au BufRead,BufNewFile *.bash setfiletype bash
]])

local ag = vim.api.nvim_create_augroup
local ac = vim.api.nvim_create_autocmd

local sessions = ag("sessions_management", { clear = true })

--ac("VimLeave", {
--	callback = function(_)
--		if not vim.uv.fs_stat(".vim") then
--			vim.fn.mkdir(".vim")
--		end
--		vim.cmd(":mksession! " .. vim.fn.getcwd() .. "/.vim/session")
--	end,
--	group = sessions,
--})

ac("VimEnter", {
	callback = function(_)
		-- create a scratch buffer
		local scratch_bufnr = vim.api.nvim_create_buf( --[[list this in bufferlist?]] true, --[[is this a scratch buffer?]]
			true)
		vim.api.nvim_buf_set_name(scratch_bufnr, "Scratch buffer")
		vim.bo[scratch_bufnr].filetype = "lua"
		local args = vim.api.nvim_command_output ":args"
		if args and args:match("%[.+%]") then
			return
		end
		vim.schedule(function()
			Require("persistence").load()
		end)
		--if vim.uv.fs_stat(".vim/session") then
		--	vim.cmd ":source .vim/session"
		--else
		-- open a scratch buffer
		local no_buf = vim.api.nvim_get_current_buf()
		vim.cmd([[:buffer ]] .. scratch_bufnr)
		vim.cmd([[:bdelete ]] .. no_buf)
		--end
	end,
	nested = true,
	group = sessions,
})

local folds = ag("folds", { clear = true })

--vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
--	pattern = { "*.*" },
--	desc = "save view (folds), when closing file",
--	command = "mkview",
--	group = folds,
--})
--
--vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
--	pattern = { "*.*" },
--	desc = "load view (folds), when opening file",
--	command = "silent! loadview",
--	group = folds,
--})

--[[ vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.tf",
	callback = function()
		vim.cmd "set ft=hcl"
	end
}) ]]

local qflist_group = ag("qflist_autoopen", { clear = true })

ac("QuickFixCmdPost", {
	pattern = "l*", -- locationlist
	command = "lopen",
	group = qflist_group,
})

ac("QuickFixCmdPost", {
	pattern = "[^l]*", -- quickfixlist
	command = "copen",
	group = qflist_group,
})


ac({ "TextYankPost" }, {
	callback = function()
		Require('vim.highlight').on_yank({ higroup = 'Visual', timeout = 200 })
	end,
	group = ag("yank_post_highlight", { clear = true }),
})

ac("FileType", {
	group = ag("q_to_close", { clear = true }),
	callback = function(_)
		vim.api.nvim_buf_set_keymap(0, "n", "q", ":q<cr>", { silent = true })
	end,
	pattern = { "qf", "help" },
})
