return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = { "lua", "java", "javascript", "go", "html", "python" },
			sync_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			auto_install = true,
		})
	end,
}
