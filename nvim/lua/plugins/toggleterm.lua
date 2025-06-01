return {
	"voldikss/vim-floaterm",
	event = "VeryLazy",
	keys = {
		-- Existing mapping to toggle (show/hide) the terminal
		{ "<leader>tt", "<cmd>FloatermToggle<cr>", desc = "Floaterm: Toggle" },

		-- New mapping to kill the current floaterm session
		{ "<leader>tk", "<cmd>FloatermKill<cr>", desc = "Floaterm: Kill Session" },

		-- New mapping to open a new floaterm session explicitly
		{ "<leader>tn", "<cmd>FloatermNew<cr>", desc = "Floaterm: New Session" },

		-- Optional: mappings to navigate if you use multiple floaterm instances
		-- { "<leader>tf", "<cmd>FloatermFirst<cr>", desc = "Floaterm: First" },
		-- { "<leader>tl", "<cmd>FloatermLast<cr>", desc = "Floaterm: Last" },
		-- { "<leader>tp", "<cmd>FloatermPrev<cr>", desc = "Floaterm: Previous" },
		-- { "<leader>tj", "<cmd>FloatermNext<cr>", desc = "Floaterm: Next" }, -- 'tj' for next often used for 'j' like movement
	},
	config = function()
		-- Your existing configuration for Esc behavior (highly recommended)
		vim.g.floaterm_auto_insert = 0 -- Ensures <Esc> can be reliably mapped in terminal mode

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "floaterm", -- This targets floaterm buffers
			callback = function(args)
				-- Map <Esc> specifically in floaterm terminal buffers to hide it
				vim.keymap.set(
					"t",
					"<Esc>",
					"<C-\\><C-n>:FloatermToggle<CR>",
					{ buffer = args.buf, noremap = true, silent = true, desc = "Floaterm: Hide" }
				)
			end,
		})

		-- You can add other floaterm default settings here if you wish, e.g.:
		-- vim.g.floaterm_width = 0.9         -- Default width (0.0 to 1.0 or integer columns)
		-- vim.g.floaterm_height = 0.9        -- Default height
		-- vim.g.floaterm_title = '($1/$2) $3' -- Example title: (1/2) zsh
		-- vim.g.floaterm_border_chars = '─│─│╭╮╯╰' -- Set border characters
	end,
}
