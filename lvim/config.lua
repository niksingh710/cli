-- Variables{{{
local which_key = lvim.builtin.which_key
local rwhich_key = require("which-key")
local mappings = which_key.mappings
local treesitter = lvim.builtin.treesitter
local cmp = lvim.builtin.cmp
local rcmp = require("cmp")
local alpha = lvim.builtin.alpha
local dashboard = alpha.dashboard
-- }}}

-- Options{{{
-- line numbers
vim.opt.relativenumber = true
vim.opt.number = true
-- tabs & indent
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
-- line wrapping
-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
-- cursorline
vim.opt.cursorline = true

vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
-- split
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.foldmethod = "marker"

vim.opt.list = true
vim.opt.listchars:append("space:·")
-- }}}

-- Autocommands{{{
vim.api.nvim_create_autocmd("FileType", {
	pattern = "zsh",
	callback = function()
		-- let treesitter use bash highlight for zsh files as well
		require("nvim-treesitter.highlight").attach(0, "bash")
	end,
})

-- vim.cmd([[
--   augroup remember_folds
--     autocmd!
--     autocmd BufWinLeave *.* mkview
--     autocmd BufWinEnter *.* silent! loadview
--   augroup END
-- ]])
-- }}}

-- Keymaps{{{
lvim.leader = "space"
vim.leader = "space"

local normal = {
	["dd"] = '"_dd',
	["c"] = '"_c',
	["x"] = '"_x',
	["<c-s>"] = ":w!<cr>",
	["<s-L>"] = ":BufferLineCycleNext<CR>",
	["<s-h>"] = ":BufferLineCyclePrev<CR>",
	-- ["<C-A-k>"] = "<C-u>",
	-- ["<C-A-j>"] = "<C-d>",

	["<c-m-j>"] = ":resize -2<cr>",
	["<c-m-k>"] = ":resize +2<cr>",
	["<c-m-l>"] = ":vertical resize -2<cr>",
	["<c-m-h>"] = ":vertical resize +2<cr>",
}

local insert = {
	["jk"] = "<esc>",
	["<c-s>"] = "<Esc>:w!<cr>",
	["<c-m-j>"] = ":resize -2<cr>",
	["<c-m-k>"] = ":resize +2<cr>",
	["<c-m-l>"] = ":vertical resize -2<cr>",
	["<c-m-h>"] = ":vertical resize +2<cr>",
}

local visual = {
	["<c-s>"] = "<Esc>:w!<cr>",
	["<c-c>"] = "<esc>",
	["x"] = '"_x',
}

lvim.keys.normal_mode = normal
lvim.keys.insert_mode = insert
lvim.keys.visual_mode = visual
-- }}}

-- Telescope{{{
local telescope = lvim.builtin.telescope
local status, actions = pcall(require, "telescope.actions")
if not status then
	return
end

telescope.defaults.mappings = {
	i = {
		["<c-k>"] = actions.move_selection_previous, -- move to prev result
		["<c-j>"] = actions.move_selection_next, -- move to next result
		["<c-m-k>"] = actions.preview_scrolling_up, -- move to prev result
		["<c-m-j>"] = actions.preview_scrolling_down, -- move to next result
		["<c-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
	},
	n = {
		["<s-j>"] = actions.preview_scrolling_down,
		["<s-k>"] = actions.preview_scrolling_up,
		["<c-k>"] = actions.move_selection_previous, -- move to prev result
		["<c-j>"] = actions.move_selection_next, -- move to next result
		["<c-m-k>"] = actions.preview_scrolling_up, -- move to prev result
		["<c-m-j>"] = actions.preview_scrolling_down, -- move to next result
		["<c-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
	},
}
telescope.theme = "center"
-- }}}

-- Plugins{{{
-- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
lvim.plugins = {
	"christoomey/vim-tmux-navigator",
	"stevearc/dressing.nvim",
	"mg979/vim-visual-multi",
	-- Noice{{{
	{
		"folke/noice.nvim",
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
					},
					progress = {
						enabled = false,
					},
					hover = {
						enabled = false,
					},
					signature = {
						enabled = false,
					},
				},
				cmdline = {
					format = {
						help = { pattern = "^:%s*tab he?l?p?%s+", icon = "" },
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
				},
			})
			-- require("notify").setup({
			-- 	background_colour = "#00000000",
			-- })
		end,
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- "rcarriga/nvim-notify",
		},
	},
	-- }}}
	-- Github Copilot{{{
	-- {
	-- 	"zbirenbaum/copilot-cmp",
	-- 	event = "InsertEnter",
	-- 	dependencies = { "zbirenbaum/copilot.lua" },
	-- 	config = function()
	-- 		---@diagnostic disable-next-line: param-type-mismatch
	-- 		vim.defer_fn(function()
	-- 			require("copilot").setup() -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
	-- 			require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
	-- 			---@diagnostic disable-next-line: param-type-mismatch
	-- 		end, 100)
	-- 	end,
	-- },
	-- Make sure to run :Lazy load copilot-cmp followed by :Copilot auth once the plugin is installed to start the authentication process.
	-- }}}
	-- Cmp Tabnine{{{
	{
		"tzachar/cmp-tabnine",
		build = "./install.sh",
		dependencies = "hrsh7th/nvim-cmp",
		event = "InsertEnter",
	},
	-- }}}
	-- Lsp-Signature{{{
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function()
			require("lsp_signature").on_attach()
		end,
	},
	-- }}}
	-- Lastplace{{{
	{
		"ethanholz/nvim-lastplace",
		event = "BufRead",
		config = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = {
					"gitcommit",
					"gitrebase",
					"svn",
					"hgcommit",
				},
				lastplace_open_folds = true,
			})
		end,
	},
	-- }}}
	-- Rainbow{{{
	{
		"mrjones2014/nvim-ts-rainbow",
		config = function()
			treesitter.rainbow.enable = true
		end,
	},
	-- }}}
	-- Scroll{{{
	{
		"karb94/neoscroll.nvim",
		event = "WinScrolled",
		config = function()
			require("neoscroll").setup({
				-- All these keys will be mapped to their corresponding default scrolling animation
				mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
				hide_cursor = true, -- Hide cursor while scrolling
				stop_eof = true, -- Stop at <EOF> when scrolling downwards
				use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
				respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
				cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
				easing_function = nil, -- Default easing function
				pre_hook = nil, -- Function to run before the scrolling animation starts
				post_hook = nil, -- Function to run after the scrolling animation ends
			})
			require("neoscroll.config").set_mappings({
				["<c-d>"] = { "scroll", { "-vim.wo.scroll", "true", "250" } },
				["<c-f>"] = { "scroll", { "vim.wo.scroll", "true", "250" } },
			})
		end,
	},
	-- }}}
	-- Leap{{{
	{
		"ggandor/leap.nvim",
		name = "leap",
		dependencies = {

			"ggandor/flit.nvim",
		},
		config = function()
			require("flit").setup()
			require("leap").add_default_mappings()
		end,
	},
	-- }}}
	-- Numb{{{
	{
		"nacro90/numb.nvim",
		event = "BufRead",
		config = function()
			require("numb").setup({
				show_numbers = true, -- Enable 'number' for the window while peeking
				show_cursorline = true, -- Enable 'cursorline' for the window while peeking
			})
		end,
	},
	-- }}}
	-- Colorizer{{{
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "*" }, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			})
		end,
	},
	-- }}}
	-- Goto Preview{{{
	{
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({
				width = 120, -- Width of the floating window
				height = 25, -- Height of the floating window
				default_mappings = false, -- Bind default mappings
				debug = false, -- Print debug information
				opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
				post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
			})
			local opts = {
				mode = "n", -- NORMAL mode
				buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
				silent = true, -- use `silent` when creating keymaps
				noremap = true, -- use `noremap` when creating keymaps
				nowait = true, -- use `nowait` when creating keymaps
			}
			local mapping = {
				["gp"] = {
					p = { "<cmd>lua require('goto-preview').close_all_win()<CR>", "Close Preview Window" },
					d = { "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", "Definations" },
					i = { "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", "Definations" },
					r = { "<cmd>lua require('goto-preview').goto_preview_references()<CR>", "References" },
					t = { "<cmd>lua require('goto-preview').goto_preview_type_definations()<CR>", "Type Definations" },
				},
			}
			rwhich_key.register(mapping, opts)
		end,
	},
	-- }}}
	-- Markdown{{{
	-- Glow{{{
	{
		"npxbr/glow.nvim",
		ft = { "*.md", "markdown" },
		-- build = "yay -S glow"
		config = true,
	},
	-- }}}
	-- Browser{{{
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		ft = "markdown",
		config = function()
			vim.g.mkdp_auto_start = 1
		end,
	},
	-- }}}
	-- }}}
	-- Persistance{{{
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		lazy = true,
		config = function()
			require("persistence").setup({
				dir = vim.fn.expand(vim.fn.stdpath("config") .. "/session/"),
				options = { "buffers", "curdir", "tabpages", "winsize" },
			})
		end,
	},
	-- }}}
	-- Todo-comment{{{
	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		config = function()
			require("todo-comments").setup()
		end,
	},
	-- }}}
	-- Pywal-lushwal{{{
	"uZer/pywal.nvim",
	-- }}}
}
-- }}}

-- Whichkey{{{
which_key.setup.popup_mappings = {
	scroll_down = "<c-j>", -- binding to scroll down inside the popup
	scroll_up = "<c-k>", -- binding to scroll up inside the popup
}
-- which_key.setup.layout.align = "center"
which_key.setup.layout = {
	height = { min = 1, max = 25 }, -- min and max height of the columns
	width = { min = 20, max = 50 }, -- min and max width of the columns
	spacing = 3, -- spacing between columns
	align = "center",
}
which_key.setup.plugins.presets = {
	windows = true,
	z = true,
	g = true,
	motions = true,
	nav = true,
}

mappings["a"] = { "gg0vG$", "Select All" }
mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
mappings["t"] = {
	name = "Tabs",
	j = { "<cmd>tabn<cr>", "Next Tab" },
	k = { "<cmd>tabp<cr>", "Previous Tab" },
	q = { "<cmd>tabclose<cr>", "Close Tab" },
	n = { "<cmd>tabnew<cr>", "New Tab" },
}
mappings["m"] = {
	name = "Markdown",
	g = { "<cmd>Glow<CR>", "Glow" },
	b = { "<cmd>MarkdownPreview<CR>", "Browser Preview" },
}

mappings["s"]["T"] = { "<cmd>TodoTelescope<cr>", "Search Todo" }
mappings["S"] = {
	name = "Session",
	d = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
	["."] = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
	Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}
-- }}}

-- Formatters & Linters{{{
-- -- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "stylua" },
	{ command = "shfmt" },
	{
		command = "prettier",
		extra_args = { "--print-width", "100" },
		filetypes = { "typescript", "typescriptreact" },
	},
	{
		command = "black",
	},
})
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "flake8", filetypes = { "python" } },
	{
		command = "shellcheck",
		args = { "--severity", "warning" },
	},
})
-- function ReadFile(file)
-- 	local f = io.open(file, "rb")
-- 	if f == nil then
-- 		return ""
-- 	end
-- 	local content = f:read("*all")
-- 	f:close()
-- 	return content
-- end

-- require("lspconfig").sourcery.setup({
-- 	init_options = {
-- 		token = "user_4JvP024xP9eaQ979oVLBQFF9cu8gTTRFNFkQQKXb6M8vvxGhagtuApvqGCY",
-- 		extension_version = "vim.lsp",
-- 		editor_version = "nvim",
-- 	},
-- })
-- -- Language specific settings
-- local lspmanager = require("lvim.lsp.manager")
-- local opts = {
-- 	init_options = {
-- 		-- token = ReadFile(os.getenv("HOME") .. "~/.config/sourcery.token"),
-- 		token = "user_4JvP024xP9eaQ979oVLBQFF9cu8gTTRFNFkQQKXb6M8vvxGhagtuApvqGCY",
-- 		extension_version = "vim.lsp",
-- 		editor_version = "vim",
-- 	},
-- }
-- lspmanager.setup("sourcery", opts)
-- }}}

-- General{{{
lvim.log.level = "info"
lvim.format_on_save = {
	enabled = true,
	pattern = "*",
	timeout = 1000,
}
-- }}}

-- Lsp & Stuff{{{
treesitter.auto_install = true
treesitter.rainbow.enable = true
treesitter.ensure_installed = "all"
cmp.mapping["<c-k>"] = rcmp.mapping.select_prev_item() -- previous suggestion
cmp.mapping["<c-j>"] = rcmp.mapping.select_next_item() -- next suggestion
cmp.mapping["<c-m-k>"] = rcmp.mapping.scroll_docs(-4)
cmp.mapping["<c-m-j>"] = rcmp.mapping.scroll_docs(4)
cmp.mapping["<c-c>"] = rcmp.mapping.abort()
cmp.mapping["<cr>"] = rcmp.mapping.confirm({ select = true })
cmp.mapping["<c-l>"] = cmp.mapping["<Tab>"]
cmp.mapping["<c-h>"] = cmp.mapping["<S-Tab>"]
-- }}}

-- Other{{{
lvim.builtin.terminal.active = false
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.transparent_window = true
-- lvim.builtin.cmp.experimental.ghost_text = true
lvim.icons.ui.Target = ""
-- }}}

-- Default Config Commented For Reference{{{
-- -- vim options
-- vim.opt.shiftwidth = 2
-- vim.opt.tabstop = 2
-- vim.opt.relativenumber = true

-- -- general
-- lvim.log.level = "info"
-- lvim.format_on_save = {
--   enabled = true,
--   pattern = "*.lua",
--   timeout = 1000,
-- }
-- -- to disable icons and use a minimalist setup, uncomment the following
-- -- lvim.use_icons = false

-- -- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
-- lvim.leader = "space"
-- -- add your own keymapping
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- -- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- -- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- -- -- Use which-key to add extra bindings with the leader-key prefix
-- -- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
-- -- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- -- -- Change theme settings
-- -- lvim.colorscheme = "lunar"

-- lvim.builtin.alpha.active = true
-- lvim.builtin.alpha.mode = "dashboard"
-- lvim.builtin.terminal.active = true
-- lvim.builtin.nvimtree.setup.view.side = "left"
-- lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- -- Automatically install missing parsers when entering buffer
-- lvim.builtin.treesitter.auto_install = true

-- -- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- -- always installed on startup, useful for parsers without a strict filetype
-- -- lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }

-- -- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

-- -- --- disable automatic installation of servers
-- -- lvim.lsp.installer.setup.automatic_installation = false

-- -- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- -- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
-- -- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- -- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- -- require("lvim.lsp.manager").setup("pyright", opts)

-- -- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- -- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- -- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
-- --   return server ~= "emmet_ls"
-- -- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- -- you can set a custom on_attach function that will be used for all the language servers
-- -- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- -- lvim.lsp.on_attach_callback = function(client, bufnr)
-- --   local function buf_set_option(...)
-- --     vim.api.nvim_buf_set_option(bufnr, ...)
-- --   end
-- --   --Enable completion triggered by <c-x><c-o>
-- --   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- -- end

-- -- -- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
-- -- local formatters = require "lvim.lsp.null-ls.formatters"
-- -- formatters.setup {
-- --   { command = "stylua" },
-- --   {
-- --     command = "prettier",
-- --     extra_args = { "--print-width", "100" },
-- --     filetypes = { "typescript", "typescriptreact" },
-- --   },
-- -- }
-- -- local linters = require "lvim.lsp.null-ls.linters"
-- -- linters.setup {
-- --   { command = "flake8", filetypes = { "python" } },
-- --   {
-- --     command = "shellcheck",
-- --     args = { "--severity", "warning" },
-- --   },
-- -- }

-- -- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
-- -- lvim.plugins = {
-- --     {
-- --       "folke/trouble.nvim",
-- --       cmd = "TroubleToggle",
-- --     },
-- -- }

-- -- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
-- -- vim.api.nvim_create_autocmd("FileType", {
-- --   pattern = "zsh",
-- --   callback = function()
-- --     -- let treesitter use bash highlight for zsh files as well
-- --     require("nvim-treesitter.highlight").attach(0, "bash")
-- --   end,
-- -- })
--
-- }}}

-- Alpha{{{

-- Headers{{{

function HeaderGlyph()
	math.randomseed(os.time())
	local headers = {
		{
			"                                                                             ",
			"                                                                             ",
			"    █████████               █████            █████████              █████    ",
			"   ███░░░░░███             ░░███            ███░░░░░███            ░░███     ",
			"  ███     ░░░   ██████   ███████   ██████  ░███    ░███  ████████  ███████   ",
			" ░███          ███░░███ ███░░███  ███░░███ ░███████████ ░░███░░███░░░███░    ",
			" ░███         ░███ ░███░███ ░███ ░███████  ░███░░░░░███  ░███ ░░░   ░███     ",
			" ░░███     ███░███ ░███░███ ░███ ░███░░░   ░███    ░███  ░███       ░███ ███ ",
			"  ░░█████████ ░░██████ ░░████████░░██████  █████   █████ █████      ░░█████  ",
			"   ░░░░░░░░░   ░░░░░░   ░░░░░░░░  ░░░░░░  ░░░░░   ░░░░░ ░░░░░        ░░░░░   ",
			"                                                                             ",
		},
		{
			"                                   ",
			"                                   ",
			"                                   ",
			"   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
			"    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
			"          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
			"           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
			"          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
			"   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
			"  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
			" ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
			" ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
			"      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
			"       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
			"                                   ",
		},
		{
			"",
			"",
			"",
			"",
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⡠⡄⠰⡀⡤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⢰⠂⠇⠑⠀⠈⠈⠈⠫⠈⡼⡄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⢀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡤⠒⠊⠀⠀⠀⠈⠀⢀⢀⢀⣄⡠⠂⡱⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀⣾⣿⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠲⠩⠁⡁⠠⠀⠀⠠⠂⠀⠀⣾⣿⡆⠀⠠⡋⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⠀⠀⣿⣿⣾⣿⡄⠀⠀⠀⠀⠀⣸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⣆⣠⠀⢀⣤⣀⠀⠀⠀⠈⣏⡆⠂⠀⠠⠐⠁⡨⣠⡥⢺⣿⣿⣷⠀⠀⠠⣊⡀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⢸⣿⣾⠀⠀⣤⠀⠀⣿⣿⣧⠀⠀⡇⠀⠀⠀⠀⠀⠀⣿⣿⣿⣼⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⢈⣶⣾⠀⠀⠀⠀⠀⠀⣤⣧⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⢠⣼⣄⠀⣿⣿⠀⢸⣿⡇⠀⠀⠀⢈⣿⣧⠠⠀⢀⠂⣴⣮⠺⡧⣼⣿⣿⣿⡄⠐⢖⢚⠐⠰⠆⢠⣀⣿⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⢹⣿⣿⠀⢰⣿⣶⣷⣿⣿⣿⣾⣾⣿⠀⠀⢸⡆⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠈⣿⣿⠀⠀⠀⠀⠀⠀⣿⣿⠦⠴⠦⠴⠦⠶⠴⠤⠴⠤⢾⣿⣿⠀⣿⣿⣠⣼⣿⡇⠀⠀⠀⠀⣰⣿⣶⣶⣶⣶⣿⡇⡄⢃⣿⣿⣿⣿⣷⣶⣷⣶⠀⠀⠀⠀⠈⣿⠢⡀⠀⠀⠀]],
			[[⠀⣶⡆⠀⢰⣶⢺⣿⣿⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⣹⣇⣡⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡇⠀⢰⣾⠀⣿⣿⣿⣿⣷⣶⣤⡟⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡏⣑⣿⣿⣿⣿⣿⣿⠀⢀⡀⠀⣸⣿⣿⣿⣿⣿⣿⣇⡃⢸⣿⣿⣿⣿⣿⣿⣿⣿⣤⣤⣄⣠⣄⣿⠀⠐⡂⠀⠀]],
			[[⠠⣿⣿⣿⣿⣿⣾⣿⣿⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⢀⣠⣄⡀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣼⢄⠀]],
			[[⢈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢹⣿⣿⣿⣿⣿⣿⣿⣿⠉⠛⢻⣭⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽⡄]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
		},
		{
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢾⡷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢘⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣺⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣟⣺⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠭⠭⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⢀⡂⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣬⣤⣤⣵⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⠯⠽⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣲⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⠀⠀⢿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⢠⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣿⣿⣿⣸⡀⠀⠀⠀⠄⠀⠀⡀⠀⠀⠀⠀]],
			[[⠀⠀⢀⣤⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣇⣀⣀⣸⣿⣆⠀⠀⠀⢼⣿⣿⣿⣿⣿⣿⣿⣿⡅⠀⠀⢸⣿⣿⣿⡇⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⣰⡀⠀⢸⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⢠⡄⠀⠀⠀⠀⠀⠀⠀⠀⣀⣿⣿⣿⣿⣿⣿⣷⣀⠀⠰⡷⠀⣠⣷⡀⠀⠀⠀]],
			[[⣀⡀⢸⣿⠀⠀⠀⠀⠀⢠⣾⣿⡇⣇⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⢸⣿⣿⡿⠛⠻⣿⣿⣿⡇⠀⠀⢸⣿⣿⣿⡇⠀⠀⣶⣶⣿⣿⣶⣶⠀⡇⠀⢸⣿⣿⡆⢸⠀⠀⠀⣿⣿⣇⣀⣀⣀⣠⣼⣧⣆⣀⣀⣀⡀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⡇⢠⣿⣿⣷⡀⠀⠀]],
			[[⣿⡇⢸⣿⠀⠀⣤⣦⣴⣼⣿⣿⡇⣧⣾⣿⣀⠀⠀⢠⣿⣿⠟⡏⠉⠉⢙⡻⢿⣿⣄⣆⢸⣿⣿⣇⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⡏⠙⡿⢿⣆⣷⣤⣼⣿⣿⣧⣼⣤⣄⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣀⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣀⣇⣸⣿⣿⣿⣇⣀⣀]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣴⣴⣿⣿⣷⣾⣿⣦⣶⣼⣷⣾⣻⣿⣿⣿⣿⣿⣿⣧⣤⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⡇⠀⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⣷⣶⣷⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
		},
		{
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⢀⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⢀⣀⣠⣶⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⢸⣿⣿⢀⣠⣤⣴⣶⡇⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣄⣀⣿⡀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⢰⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣴⣶⠀]],
			[[⣼⣿⣿⣾⣿⣿⣿⣿⡇⠀⠀⢀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⢀⡀⣀⣀⣀⣀⣀⣹⣿⣿⣿⣁⣀⣀⣀⡀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣤⠀⠀⠀⠀⠀⠀⣀⡀⠀⣿⡇⢸⣿⣿⣿⣿⣿⠀⣴⣦⣾⠀⠀⣀⠀⣿⣿⣿⣿⠀]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣧⢀⣶⣾⣷⣶⣶⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣀⡀⠀⠀⠀⢀⣀⣠⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣄⠀⠀⣶⣿⣿⣿⡇⠀⣿⡇⢸⣿⣿⣿⣿⣿⢀⣿⣿⣿⠀⣿⣿⣇⣿⣿⣿⣿⠀]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⣠⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⢸⠀⠀⠀⠀⠀⣿⣿⣿⣿⡇⠀⣿⣿⣿⣿⣧⡀⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⢀⣿⣿⣿⣿⣿⣿⣿⠀]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⣿⣿⣿⣿⠀⠀⢀⣀⣀⣀⠀⣿⡏⠉⢹⡯⠉⠉⣿⠉⠉⠉⠉⣿⡏⠉⢹⡏⠉⠉⣿⠀⢰⣾⣿⣿⣶⠀⠀⠀⣿⣿⣿⣿⡇⡄⣿⣿⣿⣿⣿⣧⣿⣧⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⠀]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣦⣿⣿⣿⣿⣆⡀⢸⣿⣿⣿⠀⣿⡇⠀⢸⡧⠀⠀⣿⠀⠀⠀⠀⣿⡇⠀⢸⡇⠀⠀⣿⠀⢸⣿⣿⣿⣿⠀⣤⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⡇⠀⢸⣯⠀⠀⣿⠀⠀⠀⠀⣿⡇⠀⢸⡇⠀⠀⣿⠀⢸⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⡇⠀⢸⡷⠀⠀⣿⠀⠀⠀⠀⣿⡇⠀⢸⡇⠀⠀⣿⣤⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣼⣿⣤⣤⣿⣤⣤⣤⣤⣿⣧⣤⣼⣧⣤⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
			[[⠛⠛⠛⠛⠛⠙⠋⠋⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠋⠛⠛⠛⠙⠋⠛⠛⠋⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛]],
		},
		{
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢼⡿⢿⡧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣧⣼⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⢿⣿⣿⣿⢿⣿⣿⣿⣿⡿⣿⣿⣿⡿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣾⣶⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣿⣿⣷⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⢿⣿⡿⡆⠀⠀⠀⠀⠀⠀⠀⠰⢿⣿⡿⡗⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⢻⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣶⣦⡀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢀⣴⣶⣦⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣾⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⢴⣿⣿⣿⣷⠄⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⢠⣿⢿⣿⣿⣿⣿⣿⣿⡿⠛⠛⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣯⢸⣿⡇⢸⣿⡇⣹⣿⡇⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡟⠛⢿⣿⠀⠀⠀⠀⠀⠀⠀⢸⣿⠋⢻⣿⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⢸⢻⣼⣿⡿⠿⡟⠀⢸⡇⠀⠀⣿⣿⣿⣀⣠⣤⡀⠀⠀⠀⠀⠀⢀⣀⣀⡀⣀⠀⠀⠀⣾⣿⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⡿⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⢸⣿⡿⠉⡇⠀⡇⣀⣸⣧⣶⣶⣿⣿⣿⣿⣿⣿⣷⣤⣤⣼⣿⣤⣾⣿⣿⣿⣿⡟⢻⣷⣿⣿⡏⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⢸⡇⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣷⣶⣾⣿⣤⣤⣤⣤⣤⣤⣤⣼⣿⣶⣾⣿⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⣾⢟⢀⣀⣧⣶⣿⣿⣿⣿⠿⢿⣿⡿⠋⠉⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⡿⠿⢿⣿⣿⣿⣟⣯⣿⣿⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⢹⣽⣿⣿⡿⢿⡟⠉⢻⡇⠀⢰⣿⡇⠀⠀⣿⣿⣿⡇⠀⢿⣿⠁⠀⢹⣿⣇⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣽⣿⣿⣯⣽⣿⣿⣿⣿⣯⣽⣿⣿⣯⣽⣿⣿⣽⣿⣿⣿⣭⣿⣿⣼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣏⡇⠀⢸⡙⣿⣿⣿⣿⣷⣿⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⣾⡟⡏⢸⠀⢸⡇⠀⢸⣇⣀⣸⣿⣧⣤⣴⣿⣿⣿⣷⣶⣾⣿⣤⣤⣼⣿⣿⡆⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣥⣤⣤⣤⣤⣤⣤⣤⣤⣤⣬⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⣿⣇⣇⣼⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣿⣿⡟⢻⣿⣿⡟⢻⣿⡟⢻⣿⡟⣿⣿⣿⡟⢻⣿⣿⢻⣿⣿⣿⡟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣿⣿⡇⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⡿⢿⡿⠿⣿⡿⠛⠻⣿⡟⠉⠙⢿⣿⠋⠉⠙⣿⣿⡟⠛⢻⣿⡿⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣼⣿⣿⣧⣼⣿⣧⣼⣿⣧⣿⣿⣿⣧⣾⣿⣿⣼⣿⣿⣿⣧⣿⣿⣴⢹⣿⣿⣿⡿⠿⢿⣿⣿⣿⡏⣿⣿⢻⣿⣿⣿⣿⡏⠉⢹⣿⣿⣿⣿⡟⣿⣿⡇⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⣿⡏⡇⢸⠀⢸⡇⠀⢸⡇⠀⠀⣿⡇⠀⠀⣿⣿⠀⠀⠀⣿⣿⣷⡀⢰⣿⡆⠀⠐⣿⡇⠀⢹⣿⣿⣿⣿⣿⡿⢿⣿⣿⣿⣿⣿⡿⢿⣿⣿⣿⣿⣿⡿⢿⣿⣿⣿⣿⣿⡏⠀⢸⣿⣶⣾⡿⢻⣿⠀⠀⢸⣿⠟⣿⣗⣿⣿⣾⣿⣿⣿⣿⡇⠀⢸⣿⣿⣿⣿⣷⣿⣿⡇⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⢀⣿⣇⣇⣸⣀⣸⣇⣀⣸⣇⣀⣀⣿⣇⣀⣀⣿⣿⣀⣀⣀⣿⣿⣿⣧⣸⣿⣇⣀⣀⣿⣿⣄⣸⣿⣿⣏⣿⣿⡇⠀⣿⣿⡟⢹⣿⡇⢸⣿⡟⣿⣿⣿⡇⢸⣿⣿⣹⣿⣿⡇⠀⢸⣿⣿⣿⡇⠀⣿⠀⠀⢸⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣼⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀]],
			[[⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄]],
			[[⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠁]],
		},
		{
			"",
			"",
			"",
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⣶⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⢲⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠘⢹⡯⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣶⣦⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⣶⣶⣤⣤⣄⣀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⣶⠀⠀⠀⢸⡇⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⣀⣤⣴⣶⣾⣿⣿⣿⣿⣿⣿⡗⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⣿⠀⠀⠀⢹⡏⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⣿⡆⠀⢠⣼⡇⠀⠀⠀⠀⠀⠸⣿⣿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣥⣀⡀⢀⣀⣤⣤⣶⣶⣾⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⣀⠀⢀⢤⡤⡀⠀⣀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⣿⣿⣿⣿⣿⡇⠀⢀⣠⣤⣶⣾⣿⣷⣶⣤⣀⣘⣿⢹⣿⠋⠉⠛⠛⠛⣿⢹⣿⣿⣿⡿⠛⠛⠛⠿⠿⣿⡿⠿⠿⠿⠛⠛⢿⣿⣿⣿⠃⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⢀⡦⡭⠽⠓⠊⠉⠉⠉⠉⠉⠈⠑⠒⠸⢿⣀⠀⠀⢀⠀⠀⠀⠀⠀]],
			[[⣿⣿⣿⣿⣿⣿⣀⠀⣟⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣤⣤⣽⣼⣿⣿⣭⣤⣤⣤⣤⣤⣤⣼⣤⣤⣤⣤⣤⣤⣤⣽⣿⣧⣤⣤⣽⣅⣀⡀⠘⣿⣿⣿⣿⣿⣿⣷⣦⣀⠀⠀⣠⣤⣧⢤⠀⠀⠀⣐⣢⣷⣄⣆⣉⣁⣀⣀⣄⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣄⣈⣀⣰⣪⣪⣔⣢⡄⠀]],
			[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣾⣿⣿⣿⣿⣿⣿⣶⣶⣿⣶⣶⣶⡶⡶⣿⣶⣶⣶⣶⢶⣶⣶⡶⣶⡶⣾⢿⣿⣿⡿⣿⡿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣤⣿⣿⣿⣿⡏⠉⠉⠰⠘⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣠⣮⣄⡀]],
			[[⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿]],
		},
		{
			"                                                              ",
			"    ⢀⣀⣤⣤⣤⠤⢤⣤⣤⣤⣤⣄⣀⡀           ⢀⣠⣤⣄⡀            ⣀⣀⣀⣤⣤⣤⣤⣤⣤⣤⣤⣀⡀   ",
			" ⢀⣤⠚⠩⠁⡄ ⠠⣤⠒⠒⣂ ⢈⣨⣭⣿⠛⠶⣦⣤⣄⡀   ⢠⣾⡟⠉⠉⠝⠿⠇    ⢀⣠⡤⠔⠒⣻⠟⠋⠩⠉⢁⣀⡀  ⣶  ⠙⡛⠷  ",
			" ⠸⢟⡠⠒⢊⡤  ⠋⣠ ⠈⣉⣉⣉⣉⣀⣛⣿⡒⠭⡿⢿⣷⣤⣤⣀⣽⣇⣴⠆⣴⡃⢀⣠⣤⠴⣚⣫⡥ ⠒⠛⠁⣀⣉⣉⣙⢏⡉  ⢀⣼⣤⣜⠳⡦⠂  ",
			"   ⠐⠚⠫⣤⠖⢣⣤⡕ ⠉⣩⣤⠔ ⠂⣋⣭⣥⣤⠴⠛⣛⠈⢩⣿⠿⠛⢉  ⡐⠞⠫⢍⠙⣓⠢⠴⣥⣍⣙⠛⢓⡢⢤⣬⠉⠅ ⣤⡜⢛⠻⠛⠉⠁   ",
			"      ⠘⢔⢎⣡⡔⠂⣠⡿⠁⠒⢛⡻⢛⣩⠅  ⠉  ⠚⣯⣄⢠⣿⢀⣾⠇ ⠓ ⠁⠂⠈⠍⠐⠈⡉⣿⠛⣛⠛⠉⣤⣰⣿⣿⡟⠛⠁      ",
			"        ⠙⠛⠐⠚⠋ ⠒⣲⡿⠇⣋        ⢺⡏⠈⣀ ⠉⠈        ⠙⢿⠟⢰⣖⡢ ⠂⠒⠚⠉         ",
			"             ⣴⠛⠅⢀⣾⠟⢃       ⢹⠃⠠⠁⠈⠩         ⢠⣿ ⣀⢹⣿⡷             ",
			"             ⢿⣤⢚⣫⠅         ⢸⠇ ⢚ ⢀         ⣸⡇ ⠉⣿⣿⠇             ",
			"             ⠈⠛⢻⣥⡚⠔⣠⢣⣄⡀    ⢸⡇ ⢘ ⠈ ⠠⠈    ⣀⣰⡿⣧⣄⠾⠋⠁              ",
			"                ⠈⠑⠁        ⠘⣿⡀⣈⣀    ⠈  ⠈⠙⠁                    ",
			"                            ⠘⣷⠁                               ",
			"                             ⠙⣤                               ",
			"                              ⠛⠂                              ",
			"                                                              ",
		},
		{
			"                   ██          ██                    ",
			"                 ██▒▒██      ██▒▒██                  ",
			"                 ██▒▒▓▓██████▓▓▒▒██                  ",
			"               ██▓▓▒▒▒▒▓▓▓▓▓▓▒▒▒▒▓▓██                ",
			"               ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                ",
			"             ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██              ",
			"             ██▒▒▒▒██▒▒▒▒██▒▒▒▒██▒▒▒▒██              ",
			"             ██▒▒▒▒▒▒▒▒██▒▒██▒▒▒▒▒▒▒▒██              ",
			"           ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██            ",
			"           ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██            ",
			"           ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██            ",
			"           ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██            ",
			"         ██▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓██          ",
			"         ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██          ",
			"         ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    ████  ",
			"         ██▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓██  ██▒▒▒▒██",
			"         ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██    ██▓▓██",
			"         ██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒▒▒██    ██▒▒██",
			"         ██▓▓▒▒▒▒██▒▒██▒▒▒▒▒▒██▒▒██▒▒▒▒▓▓██████▒▒▒▒██",
			"           ██▓▓▒▒██▒▒██▒▒▒▒▒▒██▒▒██▒▒▓▓██▒▒▒▒▓▓▒▒██  ",
			"             ██████▒▒██████████▒▒████████████████    ",
			"                 ██████      ██████                  ",
		},
		{
			"",
			"",
			"",
			"",
			"   ▄████▄        ▒▒▒▒▒    ▒▒▒▒▒    ▒▒▒▒▒    ▒▒▒▒▒ ",
			"  ███▄█▀        ▒ ▄▒ ▄▒  ▒ ▄▒ ▄▒  ▒ ▄▒ ▄▒  ▒ ▄▒ ▄▒",
			" ▐████  █  █    ▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒",
			"  █████▄        ▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒",
			"    ████▀       ▒ ▒ ▒ ▒  ▒ ▒ ▒ ▒  ▒ ▒ ▒ ▒  ▒ ▒ ▒ ▒",
			"",
			"",
			"",
			"",
		},
		{
			[[]],
			[[     ___                                    ___     ]],
			[[    /__/\          ___        ___          /__/\    ]],
			[[    \  \:\        /__/\      /  /\        |  |::\   ]],
			[[     \  \:\       \  \:\    /  /:/        |  |:|:\  ]],
			[[ _____\__\:\       \  \:\  /__/::\      __|__|:|\:\ ]],
			[[/__/::::::::\  ___  \__\:\ \__\/\:\__  /__/::::| \:\]],
			[[\  \:\~~\~~\/ /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/]],
			[[ \  \:\  ~~~  \  \:\|  |:|     \__\::/  \  \:\      ]],
			[[  \  \:\       \  \:\__|:|     /__/:/    \  \:\     ]],
			[[   \  \:\       \__\::::/      \__\/      \  \:\    ]],
			[[    \__\/           ~~~~                   \__\/    ]],
			[[]],
		},
		{
			[[]],
			[[]],
			[[░█████╗░██████╗░░█████╗░░█████╗░███╗░░██╗███████╗]],
			[[██╔══██╗██╔══██╗██╔══██╗██╔══██╗████╗░██║██╔════╝]],
			[[███████║██████╔╝██║░░╚═╝███████║██╔██╗██║█████╗░░]],
			[[██╔══██║██╔══██╗██║░░██╗██╔══██║██║╚████║██╔══╝░░]],
			[[██║░░██║██║░░██║╚█████╔╝██║░░██║██║░╚███║███████╗]],
			[[╚═╝░░╚═╝╚═╝░░╚═╝░╚════╝░╚═╝░░╚═╝╚═╝░░╚══╝╚══════╝]],
			[[]],
			[[]],
		},
		{
			[[      ____                                        ]],
			[[     /___/\_                                      ]],
			[[    _\   \/_/\__                     __           ]],
			[[  __\       \/_/\            .--.--.|__|.--.--.--.]],
			[[  \   __    __ \ \           |  |  ||  ||        |]],
			[[ __\  \_\   \_\ \ \   __      \___/ |__||__|__|__|]],
			[[/_/\\   __   __  \ \_/_/\                         ]],
			[[\_\/_\__\/\__\/\__\/_\_\/                         ]],
			[[   \_\/_/\       /_\_\/                           ]],
			[[      \_\/       \_\/                             ]],
		},
		{
			[[          |  \ \ | |/ /                     ]],
			[[          |  |\ `' ' /                      ]],
			[[          |  ;'aorta \      / , pulmonary   ]],
			[[          | ;    _,   |    / / ,  arteries  ]],
			[[ superior | |   (  `-.;_,-' '-' ,           ]],
			[[vena cava | `,   `-._       _,-'_           ]],
			[[          |,-`.    `.)    ,<_,-'_, pulmonary]],
			[[         ,'    `.   /   ,'  `;-' _,  veins  ]],
			[[        ;        `./   /`,    \-'           ]],
			[[        | right   /   |  ;\   |\            ]],
			[[        | atrium ;_,._|_,  `, ' \           ]],
			[[        |        \    \ `       `,          ]],
			[[        `      __ `    \   left  ;,         ]],
			[[         \   ,'  `      \,  ventricle       ]],
			[[          \_(            ;,      ;;         ]],
			[[          |  \           `;,     ;;         ]],
			[[ inferior |  |`.          `;;,   ;'         ]],
			[[vena cava |  |  `-.        ;;;;,;'          ]],
			[[          |  |    |`-.._  ,;;;;;'           ]],
			[[          |  |    |   | ``';;;'  FL         ]],
			[[                  aorta                     ]],
		},
		{
			[[            ___           _,.---,---.,_                                 ]],
			[[            |         ,;~'             '~;,                             ]],
			[[            |       ,;                     ;,                           ]],
			[[   Frontal  |      ;                         ; ,--- Supraorbital Foramen]],
			[[    Bone    |     ,'                         /'                         ]],
			[[            |    ,;                        /' ;,                        ]],
			[[            |    ; ;      .           . <-'  ; |                        ]],
			[[            |__  | ;   ______       ______   ;<----- Coronal Suture     ]],
			[[           ___   |  '/~"     ~" . "~     "~\'  |                        ]],
			[[           |     |  ~  ,-~~~^~, | ,~^~~~-,  ~  |                        ]],
			[[ Maxilla,  |      |   |        }:{        | <------ Orbit               ]],
			[[Nasal and  |      |   l       / | \       !   |                         ]],
			[[Zygomatic  |      .~  (__,.--" .^. "--.,__)  ~.                         ]],
			[[  Bones    |      |    ----;' / | \ `;-<--------- Infraorbital Foramen  ]],
			[[           |__     \__.       \/^\/       .__/                          ]],
			[[              ___   V| \                 / |V <--- Mastoid Process      ]],
			[[              |      | |T~\___!___!___/~T| |                            ]],
			[[              |      | |`IIII_I_I_I_IIII'| |                            ]],
			[[     Mandible |      |  \,III I I I III,/  |                            ]],
			[[              |       \   `~~~~~~~~~~'    /                             ]],
			[[              |         \   .       . <-x---- Mental Foramen            ]],
			[[              |__         \.    ^    ./                                 ]],
			[[                            ^~~~^~~~^                                   ]],
		},
		{
			[[    .o oOOOOOOOo                                            OOOo    ]],
			[[    Ob.OOOOOOOo  OOOo.      oOOo.                      .adOOOOOOO   ]],
			[[    OboO"""""""""""".OOo. .oOOOOOo.    OOOo.oOOOOOo.."""""""""'OO   ]],
			[[    OOP.oOOOOOOOOOOO "POOOOOOOOOOOo.   `"OOOOOOOOOP,OOOOOOOOOOOB'   ]],
			[[    `O'OOOO'     `OOOOo"OOOOOOOOOOO` .adOOOOOOOOO"oOOO'    `OOOOo   ]],
			[[    .OOOO'            `OOOOOOOOOOOOOOOOOOOOOOOOOO'            `OO   ]],
			[[    OOOOO                 '"OOOOOOOOOOOOOOOO"`                oOO   ]],
			[[   oOOOOOba.                .adOOOOOOOOOOba               .adOOOOo. ]],
			[[  oOOOOOOOOOOOOOba.    .adOOOOOOOOOO@^OOOOOOOba.     .adOOOOOOOOOOOO]],
			[[ OOOOOOOOOOOOOOOOO.OOOOOOOOOOOOOO"`  '"OOOOOOOOOOOOO.OOOOOOOOOOOOOO ]],
			[[ "OOOO"       "YOoOOOOMOIONODOO"`  .   '"OOROAOPOEOOOoOY"     "OOO" ]],
			[[                'OOOOOOOOOOOOOO: .oOOo. :OOOOOOOOOOO?'              ]],
			[[                 .oO%OOOOOOOOOOo.OOOOOO.oOOOOOOOOOOOO?              ]],
			[[                 oOOP"%OOOOOOOOoOOOOOOO?oOOOOO?OOOO"OOo             ]],
			[[                 '%o  OOOO"%OOOO%"%OOOOO"OOOOOO"OOO':               ]],
			[[                      `$"  `OOOO' `O"Y ' `OOOO'  o                  ]],
			[[                       .     OP"          : o     .                 ]],
		},
		{
			[[                         __________                         ]],
			[[                      .~#########%%;~.                      ]],
			[[                     /############%%;`\                     ]],
			[[                    /######/~\/~\%%;,;,\                    ]],
			[[                   |#######\    /;;;;.,.|                   ]],
			[[                   |#########\/%;;;;;.,.|                   ]],
			[[          XX       |##/~~\####%;;;/~~\;,|       XX          ]],
			[[        XX..X      |#|  o  \##%;/  o  |.|      X..XX        ]],
			[[      XX.....X     |##\____/##%;\____/.,|     X.....XX      ]],
			[[ XXXXX.....XX      \#########/\;;;;;;,, /      XX.....XXXXX ]],
			[[X |......XX%,.@      \######/%;\;;;;, /      @#%,XX......| X]],
			[[X |.....X  @#%,.@     |######%%;;;;,.|     @#%,.@  X.....| X]],
			[[X  \...X     @#%,.@   |# # # % ; ; ;,|   @#%,.@     X.../  X]],
			[[ X# \.X        @#%,.@                  @#%,.@        X./  # ]],
			[[  ##  X          @#%,.@              @#%,.@          X   #  ]],
			[[, "# #X            @#%,.@          @#%,.@            X ##   ]],
			[[   `###X             @#%,.@      @#%,.@             ####'   ]],
			[[  . ' ###              @#%.,@  @#%,.@              ###`"    ]],
			[[    . ";"                @#%.@#%,.@                ;"` ' .  ]],
			[[      '                    @#%,.@                   ,.      ]],
		},
		{
			[[⠀⠀⠀⠀⠀⠀⠀⢠⠣⡑⡕⡱⡸⡀⡢⡂⢨⠀⡌⠀⠀⠀⠀⠀⠀     ]],
			[[⠀⠀⠀⠀⠀⠀⠀⡕⢅⠕⢘⢜⠰⣱⢱⢱⢕⢵⠰⡱⡱⢘⡄⡎⠌⡀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠱⡸⡸⡨⢸⢸⢈⢮⡪⣣⣣⡣⡇⣫⡺⡸⡜⡎⡢⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⢱⢱⠵⢹⢸⢼⡐⡵⣝⢮⢖⢯⡪⡲⡝⠕⣝⢮⢪⢀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⢀⠂⡮⠁⠐⠀⡀⡀⠑⢝⢮⣳⣫⢳⡙⠐⠀⡠⡀⠀⠑⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⢠⠣⠐⠀ ⭕ ￼ ⠀⠀⢪⢺⣪⢣⠀⡀ ⭕     ]],
			[[⠀⠀⠀⠀⠐⡝⣕⢄⡀⠑⢙⠉⠁⡠⡣⢯⡪⣇⢇⢀⠀⠡⠁⠁⡠⡢⠡⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⢑⢕⢧⣣⢐⡄⣄⡍⡎⡮⣳⢽⡸⡸⡊⣧⣢⠀⣕⠜⡌⠌⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠌⡪⡪⠳⣝⢞⡆⡇⡣⡯⣞⢜⡜⡄⡧⡗⡇⠣⡃⡂⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠨⢊⢜⢜⣝⣪⢪⠌⢩⢪⢃⢱⣱⢹⢪⢪⠊⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠐⠡⡑⠜⢎⢗⢕⢘⢜⢜⢜⠜⠕⠡⠡⡈⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⡢⢀⠈⠨⣂⡐⢅⢕⢐⠁⠡⠡⢁⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⠢⠀⡀⡐⡍⢪⢘⠀⠀⠡⡑⡀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠨⢂⠀⠌⠘⢜⠘⠀⢌⠰⡈⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢑⢸⢌⢖⢠⢀⠪⡂          ]],
		},
		{
			[[    .                             .                                 .]],
			[[ .                o88888888888888  d88b  .  8888888b.  .             ]],
			[[          .  .    Y88<""""888"""" j8PY8i    888   )88                ]],
			[[                   Y8b.   888    ,8P  Y8,   88888888'         .      ]],
			[[____________________>88b  888    88888888   888  Y8b_________________]],
			[[::::::::::::88888888888P  888   d8P    Y8b  888   Y888888::::::::::::]],
			[[::::::::::::(                                           )::::::::::::]],
			[[::::::::::::Y8b  d88b  d8P  d88b   . 8888888b.  o88888888::::::::::::]],
			[["""""""""""""88ij8888ij88' j8PY8i    888   )88  Y88<"""""""""""""""""]],
			[[             "8888PY8888' ,8P  Y8,   88888888'   Y8b.   .            ]],
			[[    .         Y88P  Y88P  88888888   888  Y8b_____>88b              .]],
			[[  .         .  Y8'  "8P  d8P    Y8b  888   Y888888888P               ]],
			[[]],
		},
		{
			[[                                 __ 1      1 __        _.xxxxxx.]],
			[[                 [xxxxxxxxxxxxxx|##|xxxxxxxx|##|xxxxxxXXXXXXXXX|]],
			[[ ____            [XXXXXXXXXXXXXXXXXXXXX/.\||||||XXXXXXXXXXXXXXX|]],
			[[|::: `-------.-.__[=========---___/::::|::::::|::::||X O^XXXXXX|]],
			[[|::::::::::::|2|%%%%%%%%%%%%\::::::::::|::::::|::::||X /        ]],
			[[|::::,-------|_|~~~~~~~~~~~~~`---=====-------------':||  5      ]],
			[[ ~~~~                       |===|:::::|::::::::|::====:\O       ]],
			[[                            |===|:::::|:.----.:|:||::||:|       ]],
			[[                            |=3=|::4::`'::::::`':||__||:|       ]],
			[[                            |===|:::::::/  ))\:::`----':/       ]],
			[[BlasTech Industries'        `===|::::::|  // //~`######b        ]],
			[[DL-44 Heavy Blaster Pistol      `--------=====/  ######B        ]],
			[[                                                 `######b       ]],
			[[1 .......... Sight Adjustments                    #######b      ]],
			[[2 ............... Stun Setting                    #######B      ]],
			[[3 ........... Air Cooling Vent                    `#######b     ]],
			[[4 ................. Power Pack                     #######P     ]],
			[[5 ... Power Pack Release Lever             LS      `#####B      ]],
		},
		{
			[[.--------------------------------------------------------------------------.]],
			[[|                                                                          |]],
			[[|        __..,,-----l"|-.                                                  |]],
			[[|    __/"__  |----""  |  i--voo..,,__                                      |]],
			[[| .-'=|:|/\|-------o.,,,---. Y88888888o,,_                                 |]],
			[[|_+=:_|_|__|_|   ___|__|___-|  """"````"""`----------.........___          |]],
			[[/__============:' "" |==|__\===========(=>=+    |           ,_, .-"`--..._ |]],
			[[|  ;="|"|  |"| `.____|__|__/===========(=>=+----+===-|---------<---------_=-]],
			[[| | ==|:|\/| |   | o|.-'__,-|   .'  _______|o  `----'|        __\ __,.-'"  |]],
			[[|  "`--""`--"'"""`.-+------'" .'  _L___,,...-----------"""""""   "         |]],
			[[|                  `------""""""""                                     LS  |]],
			[[|                                                                          |]],
			[[`--------------------- Incom/Subpro's Z-95 Headhunter ---------------------']],
		},
		{
			[[     _O_        _____         _<>_          ___     ]],
			[[   /     \     |     |      /      \      /  _  \   ]],
			[[  |==/=\==|    |[/_\]|     |==\==/==|    |  / \  |  ]],
			[[  |  O O  |    / O O \     |   ><   |    |  |"|  |  ]],
			[[   \  V  /    /\  -  /\  ,-\   ()   /-.   \  X  /   ]],
			[[   /`---'\     /`---'\   V( `-====-' )V   /`---'\   ]],
			[[   O'_:_`O     O'M|M`O   (_____:|_____)   O'_|_`O   ]],
			[[    -- --       -- --      ----  ----      -- --    ]],
			[[   STAN         KYLE        CARTMAN        KENNY    ]],
		},
		{
			[[ _____                                 ]],
			[[/     \                                ]],
			[[vvvvvvv  /|__/|                        ]],
			[[   I   /O,O   |                        ]],
			[[   I /_____   |      /|/|              ]],
			[[  J|/^ ^ ^ \  |    /00  |    _//|      ]],
			[[   |^ ^ ^ ^ |W|   |/^^\ |   /oo |      ]],
			[[    \m___m__|_|    \m_m_|   \mm_|      ]],
			[[                                       ]],
			[[  "Totoros" (from "My Neighbor Totoro")]],
			[[      --- Duke Lee                     ]],
			[[]],
		},
		{
			[[                                   /\                                ]],
			[[                              /\  //\\                               ]],
			[[                       /\    //\\///\\\        /\                    ]],
			[[                      //\\  ///\////\\\\  /\  //\\                   ]],
			[[         /\          /  ^ \/^ ^/^  ^  ^ \/^ \/  ^ \                  ]],
			[[        / ^\    /\  / ^   /  ^/ ^ ^ ^   ^\ ^/  ^^  \                 ]],
			[[       /^   \  / ^\/ ^ ^   ^ / ^  ^    ^  \/ ^   ^  \       *        ]],
			[[      /  ^ ^ \/^  ^\ ^ ^ ^   ^  ^   ^   ____  ^   ^  \     /|\       ]],
			[[     / ^ ^  ^ \ ^  _\___________________|  |_____^ ^  \   /||o\      ]],
			[[    / ^^  ^ ^ ^\  /______________________________\ ^ ^ \ /|o|||\     ]],
			[[   /  ^  ^^ ^ ^  /________________________________\  ^  /|||||o|\    ]],
			[[  /^ ^  ^ ^^  ^    ||___|___||||||||||||___|__|||      /||o||||||\   ]],
			[[ / ^   ^   ^    ^  ||___|___||||||||||||___|__|||          | |       ]],
			[[/ ^ ^ ^  ^  ^  ^   ||||||||||||||||||||||||||||||oooooooooo| |ooooooo]],
			[[ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo]],
			[[]],
		},
		{
			[[_______________________________________________________________]],
			[[||         _.-'-``-._          |      \:::::::::'      /     ||]],
			[[||       ,'::::::''  `.        |      /::::::'         \     ||]],
			[[||      ::::::'        :       |      \:::::           /     ||]],
			[[||      |:::'          |       |      /;'`--'`--'`--'`.\     ||]],
			[[||      ;:::  .  ,     :       |      \_.`--'.  ,'- '._/     ||]],
			[[||     :-------::-------:      |      /:  o   ::  o   :\     ||]],
			[[||     `.__o__.;:.__o__.'      |      \:.____.;:.____.'/     ||]],
			[[||_____(.:::::(:_)_____.)______|______(.:::::(:_)_____.)_____||]],
			[[||          _     _            |                             ||]],
			[[||        ,':`._.':`.          |       \`.`.'`.'`.'`'(       ||]],
			[[||    ..-':::::::'   `--..     |        :::::::::''  :       ||]],
			[[||   \:::::::::          /     |        |:::::'      |       ||]],
			[[||   _`.::::::          `._    |        |::::        |       ||]],
			[[|| .':::_.`--'.  ,'--'._   `,  |       (.----.  ,----.)      ||]],
			[[||  `.:::  o   ::  o   :  ,'   |       :  o   ::  o   :      ||]],
			[[||   ,':`.____.;:.____.' `.    |       `.____.;:.____.'      ||]],
			[[||__`.:(.:::::(:_)_____.)_,'___|_______(.::::(:_)____.)___SSt||]],
			[['-------------------------------------------------------------']],
		},
		{
			[[           ||||||||||||,,       ]],
			[[           |WWWWWWWWW|W|||,     ]],
			[[           |_________|~WWW||,   ]],
			[[            ~-_      ~_  ~WW||, ]],
			[[            __-~---__/ ~_  ~WW|,]],
			[[        _-~~         ~~-_~_  ~W ]],
			[[  _--~~~~~~~~~~___       ~-~_/  ]],
			[[ -                ~~~--_   ~_   ]],
			[[|                       ~_   |  ]],
			[[|   ____-------___        -_  | ]],
			[[|-~~              ~~--_     - | ]],
			[[ ~| ~--___________     |-_   ~_ ]],
			[[   | \`~'/  \`~'_-~~  |  |~-_-  ]],
			[[  _-~_~~~    ~~~   _-~  |  |    ]],
			[[ ---.--__         ---.-~  |     ]],
			[[ | |    -~~-----~~| |    -      ]],
			[[ |_|__-~          |_|__-~       ]],
			[[]],
		},
		{
			[[ =ccccc,      ,cccc       ccccc      ,cccc,  ?$$$$$$$,  ,ccc,   -ccc        ]],
			[[:::"$$$$bc    $$$$$     ::`$$$$$c,  : $$$$$c`:"$$$$???'`."$$$$c,:`?$$c      ]],
			[[`::::"?$$$$c,z$$$$F     `:: ?$$$$$c,`:`$$$$$h`:`?$$$,` :::`$$$$$$c,"$$h,    ]],
			[[  `::::."$$$$$$$$$'    ..,,,:"$$$$$$h, ?$$$$$$c`:"$$$$$$$b':"$$$$$$$$$$$c   ]],
			[[     `::::"?$$$$$$    :"$$$$c:`$$$$$$$$d$$$P$$$b`:`?$$$c : ::`?$$c "?$$$$h, ]],
			[[       `:::.$$$$$$$c,`::`????":`?$$$E"?$$$$h ?$$$.`:?$$$h..,,,:"$$$,:."?$$$c]],
			[[         `: $$$$$$$$$c, ::``  :::"$$$b `"$$$ :"$$$b`:`?$$$$$$$c``?$F `:: "::]],
			[[          .,$$$$$"?$$$$$c,    `:::"$$$$.::"$.:: ?$$$.:.???????" `:::  ` ``` ]],
			[[          'J$$$$P'::"?$$$$h,   `:::`?$$$c`::``:: .:: : :::::''   `          ]],
			[[         :,$$$$$':::::`?$$$$$c,  ::: "::  ::  ` ::'   ``                    ]],
			[[        .'J$$$$F  `::::: .::::    ` :::'  `                                 ]],
			[[       .: ???):     `:: :::::                                               ]],
			[[       : :::::'        `                                                    ]],
			[[        ``                                                                  ]],
		},
		{
			[[                   .,ccc$$$$$$$bccc,.                                      ]],
			[[ Professor   .,c$$$$$$$$$$$$$$$$$$$$$$$$c,                                 ]],
			[[ Xavier   ,c$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$c,                              ]],
			[[       ,c$$$$CCCC$$$$$$$$$$$$$$$$$$$$$$$$$$$$$,                            ]],
			[[     ,d$$$CCCCCCCC$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$c                          ]],
			[[   ,$$$CCCCCCCCC>"$$$$$$$$$$$$$$$$$$$$$?3$$P,d$$$"                         ]],
			[[ ,d$$CCCCCCCCCC>,$$$$$$$$$$$$$$$$$$$$Ez$$$$$$$$$" -db                      ]],
			[[,$$$CCCCCCCCCC>,$$$$$$$$$$$$$$$$$$?$$$$$?$$$$$$$" z$$b                     ]],
			[[`$$$$$$$?$$$$$$$$$$$,J$$$'$$br   .   P)$$b                                 ]],
			[[ $$CCCCCCCCCCCCc`?$$$$h$$$$$$$$$$$??",$$$$$$F cd$c$$c$$$$$.                ]],
			[[ `$$CCCCCCCCCCCC>,$$$$$$$???" _,,,c$?3$$"$$$$."?$$$$$$$$$$$                ]],
			[[  `$$CCCCCCCCCCCCCC?$$$   ,c$$$P""  4,$$ 3$$$$$c`?$$$$$$$$$                ]],
			[[   ?$$CCCCCCCCCCCCC 3$P   $$$F  ,   ,$P"$$$$$$$$$c "$$$$$$$                ]],
			[[    "$$CCCCCCCCCCCCc`?L  J$$P" J3$$$$P,d$$$$$$$F3$$c,"?$$$$,               ]],
			[[     `?$CCCCCCCCCCCC>c,  $ -cc="=$$$$c$$$$$$$$$LJ$??P d$$$$hc              ]],
			[[       ```''??CCCCCCCC>"" c$$$$$$$$$$$$$$$$$F'?"  ,, d$$$$$$$L             ]],
			[[     J??????c,,CCCCCCC                                                     ]],
		},
		{
			[[         __                        ___________________________________        ]],
			[[       _( _)_                     /    I know Beethoven was great,    \       ]],
			[[      ( _) ( )            _____  |      but do you have to say it      |      ]],
			[[     (_)    (_)          @@@@@@@ |  every day on rec.music.classical?  |      ]],
			[[   __/     . |          @@@  .|_  \ __________________________________/       ]],
			[[ /    \  --\_) _________@@(    _) |/                  | |         |           ]],
			[[|   /\  \__/)-/_______(@@@@__-/                       | |        |'           ]],
			[[|--|**|\__ --|        (___)   \___ /\  ##             !_!-v----v-"            ]],
			[[|*****|__ |____________| \    |  /    \##    __--"""i i""""""""""i            ]],
			[[ \*(#####)  ||      ||    \___|____/\__##   !_______! !__________!            ]],
			[[""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""]],
			[[]],
		},
		{
			[[$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'               `$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$]],
			[[$$$$$$$$$$$$$$$$$$$$$$$$$$$$'                   `$$$$$$$$$$$$$$$$$$$$$$$$$$$$]],
			[[$$$'`$$$$$$$$$$$$$'`$$$$$$!                       !$$$$$$'`$$$$$$$$$$$$$'`$$$]],
			[[$$$$  $$$$$$$$$$$  $$$$$$$                         $$$$$$$  $$$$$$$$$$$  $$$$]],
			[[$$$$. `$' \' \$`  $$$$$$$!                         !$$$$$$$  '$/ `/ `$' .$$$$]],
			[[$$$$$. !\  i  i .$$$$$$$$                           $$$$$$$$. i  i  /! .$$$$$]],
			[[$$$$$$   `--`--.$$$$$$$$$                           $$$$$$$$$.--'--'   $$$$$$]],
			[[$$$$$$L        `$$$$$^^$$                           $$^^$$$$$'        J$$$$$$]],
			[[$$$$$$$.   .'   ""~   $$$    $.                 .$  $$$   ~""   `.   .$$$$$$$]],
			[[$$$$$$$$.  ;      .e$$$$$!    $$.             .$$  !$$$$$e,      ;  .$$$$$$$$]],
			[[$$$$$$$$$   `.$$$$$$$$$$$$     $$$.         .$$$   $$$$$$$$$$$$.'   $$$$$$$$$]],
			[[$$$$$$$$    .$$$$$$$$$$$$$!     $$`$$$$$$$$'$$    !$$$$$$$$$$$$$.    $$$$$$$$]],
			[[$JT&yd$     $$$$$$$$$$$$$$$$.    $    $$    $   .$$$$$$$$$$$$$$$$     $by&TL$]],
			[[                                 $    $$    $                                ]],
			[[                                 $.   $$   .$                                ]],
			[[                                 `$        $'                                ]],
			[[                                  `$$$$$$$$'                                 ]],
		},
		{
			[[]],
			[[         _nnnn_                      ]],
			[[        dGGGGMMb     ,"""""""""""""".]],
			[[       @p~qp~~qMb    | Linux Rules! |]],
			[[       M|@||@) M|   _;..............']],
			[[       @,----.JM| -'                 ]],
			[[      JS^\__/  qKL                   ]],
			[[     dZP        qKRb                 ]],
			[[    dZP          qKKb                ]],
			[[   fZP            SMMb               ]],
			[[   HZM            MMMM               ]],
			[[   FqM            MMMM               ]],
			[[ __| ".        |\dS"qML              ]],
			[[ |    `.       | `' \Zq              ]],
			[[_)      \.___.,|     .'              ]],
			[[\____   )MMMMMM|   .'                ]],
			[[     `-'       `--' hjm              ]],
			[[]],
		},
		{
			[[]],
			[[Kevin Woods:                                 ]],
			[[                                 ,        ,  ]],
			[[                                /(        )` ]],
			[[                                \ \___   / | ]],
			[[                                /- _  `-/  ' ]],
			[[                               (/\/ \ \   /\ ]],
			[[                               / /   | `    \]],
			[[                               O O   ) /    |]],
			[[                               `-^--'`<     ']],
			[[                   TM         (_.)  _  )   / ]],
			[[|  | |\  | ~|~ \ /             `.___/`    /  ]],
			[[|  | | \ |  |   X                `-----' /   ]],
			[[`__| |  \| _|_ / \                           ]],
			[[]],
		},
		{
			[[]],
			[[              $$ $$$$$ $$              ]],
			[[              $$ $$$$$ $$              ]],
			[[             .$$ $$$$$ $$.             ]],
			[[             :$$ $$$$$ $$:             ]],
			[[             $$$ $$$$$ $$$             ]],
			[[             $$$ $$$$$ $$$             ]],
			[[            ,$$$ $$$$$ $$$.            ]],
			[[           ,$$$$ $$$$$ $$$$.           ]],
			[[          ,$$$$; $$$$$ :$$$$.          ]],
			[[         ,$$$$$  $$$$$  $$$$$.         ]],
			[[       ,$$$$$$'  $$$$$  `$$$$$$.       ]],
			[[     ,$$$$$$$'   $$$$$   `$$$$$$$.     ]],
			[[  ,s$$$$$$$'     $$$$$     `$$$$$$$s.  ]],
			[[$$$$$$$$$'       $$$$$       `$$$$$$$$$]],
			[[$$$$$Y'          $$$$$          `Y$$$$$]],
			[[]],
		},
		{
			[[]],
			[[888888888888888888888888888888888888888888888888888888888888]],
			[[888888888888888888888888888888888888888888888888888888888888]],
			[[8888888888888888888888888P""  ""9888888888888888888888888888]],
			[[8888888888888888P"88888P          988888"9888888888888888888]],
			[[8888888888888888  "9888            888P"  888888888888888888]],
			[[888888888888888888bo "9  d8o  o8b  P" od88888888888888888888]],
			[[888888888888888888888bob 98"  "8P dod88888888888888888888888]],
			[[888888888888888888888888    db    88888888888888888888888888]],
			[[88888888888888888888888888      8888888888888888888888888888]],
			[[88888888888888888888888P"9bo  odP"98888888888888888888888888]],
			[[88888888888888888888P" od88888888bo "98888888888888888888888]],
			[[888888888888888888   d88888888888888b   88888888888888888888]],
			[[8888888888888888888oo8888888888888888oo888888888888888888888]],
			[[888888888888888888888888888888888888888888888888888888888888]],
			[[]],
		},
		{
			[[                      ,-~   _  ^^~-.,\                        ]],
			[[                    ,^        -,____ ^,         ,/\/\/\,\     ]],
			[[                   /           (____)  |      S~         ~7\  ]],
			[[                  ;  .---._    | | || _|     S   I AM THE   Z\]],
			[[                  | |      ~-.,\ | |!/ |     /_  NVIM-LAW  _\\]],
			[[                  ( |    ~<-.,_^\|_7^ ,|     _//_         _\\ ]],
			[[                  | |      ", 77>   (T/|   _//   \/\/\/\/     ]],
			[[                  |  \_      )/<,/^\)i(|\                     ]],
			[[                  (    ^~-,  |________||\                     ]],
			[[                  ^!,_    / /, ,"^~^",!!_,..---.\             ]],
			[[                   \_ "-./ /   (-~^~-))" =,__,..>-,\          ]],
			[[                     ^-,__/#w,_  "^" /~-,_/^\      )\         ]],
			[[                  /\  ( <_    ^~~--T^ ~=, \  \_,-=~^\\        ]],
			[[     .-==,    _,=^_,.-"_  ^~*.(_  /_)    \ \,=\      )\       ]],
			[[    /-~;  \,-~ .-~  _,/ \    ___[8]_      \ T_),--~^^)\       ]],
			[[      _/   \,,..==~^_,.=,\   _.-~O   ~     \_\_\_,.-=}\       ]],
			[[    ,{       _,.-<~^\  \ \\      ()  .=~^^~=. \_\_,./\        ]],
			[[   ,{ ^T^ _ /  \  \  \  \ \)    [|   \oDREDD>\       \        ]],
		},
		{
			[[                   ,d"=≥,.,qOp,    ]],
			[[                 ,7'  ''²$(  )     ]],
			[[                ,7'      '?q$7'    ]],
			[[             ..,$$,.               ]],
			[[   ,.  .,,--***²""²***--,,.  .,    ]],
			[[ ²   ,p²''              ''²q,   ²  ]],
			[[:  ,7'                      '7,  : ]],
			[[ ' $      ,db,      ,db,      $ '  ]],
			[[  '$      ²$$²      ²$$²      $'   ]],
			[[  '$                          $'   ]],
			[[   '$.     .,        ,.     .$'    ]],
			[[    'b,     '²«»«»«»²'     ,d'     ]],
			[[     '²?bn,,          ,,nd?²'      ]],
			[[       ,7$ ''²²²²²²²²'' $7,        ]],
			[[     ,² ²$              $² ²,      ]],
			[[     $  :$              $:  $      ]],
			[[     $   $              $   $      ]],
			[[     'b  q:            :p  d'      ]],
			[[      '²«?$.          .$?»²'       ]],
			[[         'b            d'          ]],
			[[       ,²²'?,.      .,?'²²,        ]],
			[[      ²==--≥²²==--==²²≤--==²       ]],
		},
		{
			[[               ==========================================                 ]],
			[[                 `.:::::::.       `:::::::.       `:::::::.               ]],
			[[                   \:::::::.        :::::::.        :::::::\              ]],
			[[                    L:::::::        ::::::::        ::::::::L             ]],
			[[                    |:::::::        ::::::::        ::::::::|     .---.   ]],
			[[                    |:::::::        ::::::::        ::::::::|    /(@  o`. ]],
			[[                    |:::::::        ::::::::        ::::::::|   |    /^^^ ]],
			[[     __             |:::::::        ::::::::        ::::::::|    \ . \vvv ]],
			[[   .'_ \            |:::::::        ::::::::        ::::::::|     \ `--'  ]],
			[[   (( ) |           |:::::::        ::::::::        ::::::::|      \ `.   ]],
			[[    `/ /            |:::::::        ::::::::        ::::::::|       L  \  ]],
			[[    / /             |:::::::        ::::::::        ::::::::|       |   \ ]],
			[[   |  L\            J:::::::        .:::::::        .:::::::J      /     F]],
			[[   J  J `.     .   F:::::::        ::::::::        ::::::::F    .'      J ]],
			[[    L  \  `.  //  /:::::::'      .::::::::'      .::::::::/   .'        F ]],
			[[    J   `.  `//_..---.   .---.   .---.   .---.   .---.   <---<         J  ]],
			[[     L    `-//_=/  _  \=/  _  \=/  _  \=/  _  \=/  _  \=/  _  \       /   ]],
			[[     J     /|  |  (_)  |  (_)  |  (_)  |  (_)  |  (_)  |  (_)  |     /    ]],
			[[      \   / |   \     //\     //\     //\     //\     //\     /    .'     ]],
			[[       \ / /     `---//  `---//  `---//  `---//  `---//  `---'   .'       ]],
			[[________/_/_________//______//______//______//______//_________.'_________]],
			[[##VK######################################################################]],
		},
		{
			[[            > <     ,     > <                 ]],
			[[       .     '             '      .      .    ]],
			[[                __.--._          > <          ]],
			[[        .     .'   L   `.--._     '           ]],
			[[       > <    `/ c '`    \   `.               ]],
			[[        '     :           ;    `.    `     ,  ]],
			[[              |           ;      \            ]],
			[[             /`.     | ' /        \     .     ]],
			[[        '   / -.\ \  ^ ;/   _      \   > <    ]],
			[[           :    \`.:/ \|     `.|    ;   '     ]],
			[[           |     :''   '       ;    |         ]],
			[[           |     |`.         _/_    ;         ]],
			[[[bug]      :     :  `-._____/   `. /          ]],
			[[            \    |         :/ ,   V\          ]],
			[[  /"\   __.--; _ :         `./ /  ; ;         ]],
			[[ :  |\_/     |  \L  _..--.   `.L.'  |`.   __  ]],
			[[ |  | ;`.    ; _ \\'      `.          /`+'.'`.]],
			[[ |  | |      | \CT_;        `-.      ' / /   |]],
			[[ |-_| |   .-'`.___.            `-.    / /    ;]],
			[[ :  ; :.-'                        `-./ /.   / ]],
			[[  \/_/         _                     \/  `./  ]],
			[[   "                                  `._.'   ]],
		},
		{
			[[           _____________________________________________        ]],
			[[         //:::::::::::::::::::::::::::::::::::::::::::::\\      ]],
			[[       //:::_______:::::::::________::::::::::_____:::::::\\    ]],
			[[     //:::_/   _-"":::_--"""        """--_::::\_  ):::::::::\\  ]],
			[[    //:::/    /:::::_"                    "-_:::\/:::::|^\:::\\ ]],
			[[   //:::/   /~::::::I__                      \:::::::::|  \:::\\]],
			[[   \\:::\   (::::::::::""""---___________     "--------"  /::://]],
			[[    \\:::\  |::::::::::::::::::::::::::::""""==____      /:::// ]],
			[[     \\:::"\/::::::::::::::::::::::::::::::::::::::\   /~::://  ]],
			[[       \\:::::::::::::::::::::::::::::::::::::::::::)/~::://    ]],
			[[         \\::::\""""""------_____::::::::::::::::::::::://      ]],
			[[           \\:::"\               """""-----_____:::::://        ]],
			[[             \\:::"\    __----__                )::://          ]],
			[[               \\:::"\/~::::::::~\_         __/~:://            ]],
			[[                 \\::::::::::::::::""----""":::://              ]],
			[[                   \\::::::::::::::::::::::::://                ]],
			[[                     \\:::\^""--._.--""^/::://                  ]],
			[[                       \\::"\         /":://                    ]],
			[[                         \\::"\     /":://                      ]],
			[[                           \\::"\_/":://                        ]],
			[[                             \\::::://                          ]],
			[[                               \\_//                            ]],
		},
		{
			[[_____________________                              _____________________ ]],
			[[`-._:  .:'   `:::  .:\           |\__/|           /::  .:'   `:::  .:.-' ]],
			[[    \      :          \          |:   |          /         :       /     ]],
			[[     \     ::    .     `-_______/ ::   \_______-'   .      ::   . /      ]],
			[[      |  :   :: ::'  :   :: ::'  :   :: ::'      :: ::'  :   :: :|       ]],
			[[      |     ;::         ;::         ;::         ;::         ;::  |       ]],
			[[      |  .:'   `:::  .:'   `:::  .:'   `:::  .:'   `:::  .:'   `:|       ]],
			[[      /     :           :           :           :           :    \       ]],
			[[     /______::_____     ::    .     ::    .     ::   _____._::____\      ]],
			[[                   `----._:: ::'  :   :: ::'  _.----'                    ]],
			[[                          `--.       ;::  .--'                           ]],
			[[                              `-. .:'  .-'                               ]],
			[[                                 \    / :F_P:                            ]],
			[[                                  \  /                                   ]],
			[[                                   \/                                    ]],
			[[]],
		},
		{
			[[                ur d$$$$$$$$$$$$$$Nu               ]],
			[[              d$$$ "$$$$$$$$$$$$$$$$$$e.           ]],
			[[          u$$c   ""   ^"^**$$$$$$$$$$$$$b.         ]],
			[[        z$$#"""           `!?$$$$$$$$$$$$$N.       ]],
			[[      .$P                   ~!R$$$$$$$$$$$$$b      ]],
			[[     x$F                 **$b. '"R).$$$$$$$$$$     ]],
			[[    J^"                           #$$$$$$$$$$$$.   ]],
			[[   z$e                      ..      "**$$$$$$$$$   ]],
			[[  :$P           .        .$$$$$b.    ..  "  #$$$$  ]],
			[[  $$            L          ^*$$$$b   "      4$$$$L ]],
			[[ 4$$            ^u    .e$$$$e."*$$$N.       @$$$$$ ]],
			[[ $$E            d$$$$$$$$$$$$$$L "$$$$$  mu $$$$$$F]],
			[[ $$&            $$$$$$$$$$$$$$$$N   "#* * ?$$$$$$$N]],
			[[ $$F            '$$$$$$$$$$$$$$$$$bec...z$ $$$$$$$$]],
			[['$$F             `$$$$$$$$$$$$$$$$$$$$$$$$ '$$$$E"$]],
			[[ $$                  ^""""""`       ^"*$$$& 9$$$$N ]],
			[[ k  u$                                  "$$. "$$P r]],
			[[ 4$$$$L                                   "$. eeeR ]],
			[[  $$$$$k                                   '$e. .@ ]],
			[[  3$$$$$b                                   '$$$$  ]],
			[[   $$$$$$                                    3$$"  ]],
			[[    $$$$$  dc                                4$F   ]],
		},
		{
			[[                                          _\/               ]],
			[[                                        .-'.'`)             ]],
			[[                                     .-' .'                 ]],
			[[               .                  .-'     `-.          __\/ ]],
			[[                \.    .  |,   _.-'       -:````)   _.-'.'``)]],
			[[                 \`.  |\ | \.-_.           `._ _.-' .'`     ]],
			[[                __) )__\ |! )/ \_.          _.-'      `.    ]],
			[[            _.-'__`-' =`:' /.' / |      _.-'      -:`````)  ]],
			[[      __.--' ( (@> ))  = \ ^ `'. |_. .-'           `.       ]],
			[[     : @       `^^^    == \ ^   `. |<                `.     ]],
			[[     VvvvvvvvVvvvv)    =  ;   ^  ;_/ :           -:``````)  ]],
			[[       (^^^^^^^^^^=  ==   |      ; \. :            `.       ]],
			[[    ((  `-----------.  == |  ^   ;_/   :             `.     ]],
			[[    /\             /==   /       : \.  :     _..--``````)   ]],
			[[  __\ \_          ; ==  /  ^     :_/   :      `.            ]],
			[[>                                                           ]],
		},
		{
			[[                            ,-.                            ]],
			[[       ___,---.__          /'|`\          __,---,___       ]],
			[[    ,-'    \`    `-.____,-'  |  `-.____,-'    //    `-.    ]],
			[[  ,'        |           ~'\     /`~           |        `.  ]],
			[[ /      ___//              `. ,'          ,  , \___      \ ]],
			[[|    ,-'   `-.__   _         |        ,    __,-'   `-.    |]],
			[[|   /          /\_  `   .    |    ,      _/\          \   |]],
			[[\  |           \ \`-.___ \   |   / ___,-'/ /           |  /]],
			[[ \  \           | `._   `\\  |  //'   _,' |           /  / ]],
			[[  `-.\         /'  _ `---'' , . ``---' _  `\         /,-'  ]],
			[[     ``       /     \    ,='/ \`=.    /     \       ''     ]],
			[[             |__   /|\_,--.,-.--,--._/|\   __|             ]],
			[[             /  `./  \\`\ |  |  | /,//' \,'  \             ]],
			[[            /   /     ||--+--|--+-/-|     \   \            ]],
			[[           |   |     /'\_\_\ | /_/_/`\     |   |           ]],
			[[            \   \__, \_     `~'     _/ .__/   /            ]],
			[[             `-._,-'   `-._______,-'   `-._,-'             ]],
			[[]],
		},
		{
			[[  ______________________________________________________________________ ]],
			[[ |.============[_F_E_D_E_R_A_L___R_E_S_E_R_V_E___N_O_T_E_]=============.|]],
			[[ ||%&%&%&%_    _        _ _ _   _ _  _ _ _     _       _    _  %&%&%&%&||]],
			[[ ||%&.-.&/||_||_ | ||\||||_| \ (_ ||\||_(_  /\|_ |\|V||_|)|/ |\ %&.-.&&||]],
			[[ ||&// |\ || ||_ \_/| ||||_|_/ ,_)|||||_,_) \/|  ||| ||_|\|\_|| &// |\%||]],
			[[ ||| | | |%               ,-----,-'____'-,-----,               %| | | |||]],
			[[ ||| | | |&% """"""""""  [    .-;"`___ `";-.    ]             &%| | | |||]],
			[[ ||&\===//                `).'' .'`_.- `. '.'.(`  A 76355942 J  \\===/&||]],
			[[ ||&%'-'%/1                // .' /`     \    \\                  \%'-'%||]],
			[[ ||%&%&%/`   d8888b       // /   \  _  _;,    \\      .-"""-.  1 `&%&%%||]],
			[[ ||&%&%&    8P |) Yb     ;; (     > a  a| \    ;;    //A`Y A\\    &%&%&||]],
			[[ ||&%&%|    8b |) d8     || (    ,\   \ |  )   ||    ||.-'-.||    |%&%&||]],
			[[ ||%&%&|     Y8888P      ||  '--'/`  -- /-'    ||    \\_/~\_//    |&%&%||]],
			[[ ||%&%&|                 ||     |\`-.__/       ||     '-...-'     |&%&%||]],
			[[ ||%%%%|                 ||    /` |._ .|-.     ||                 |%&%&||]],
			[[ ||%&%&|  A 76355942 J  /;\ _.'   \  } \  '-.  /;\                |%&%&||]],
			[[ ||&%.-;               (,  '.      \  } `\   \'  ,)   ,.,.,.,.,   ;-.%&||]],
			[[ ||%( | ) 1  """""""   _( \  ;...---------.;.; / )_ ```""""""" 1 ( | )%||]],
			[[ ||&%'-'==================\`------------------`/=================='-'%&||]],
			[[ ||%&JGS&%&%&%&%%&%&&&%&%%&)O N E  D O L L A R(%&%&%&%&%&%&%%&%&&&%&%%&||]],
			[[ '""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""`]],
		},
		{
			[[                                              ,           ^'^  _     ]],
			[[                                              )               (_) ^'^]],
			[[         _/\_                    .---------. ((        ^'^           ]],
			[[         (('>                    )`'`'`'`'`( ||                 ^'^  ]],
			[[    _    /^|                    /`'`'`'`'`'`\||           ^'^        ]],
			[[    =>--/__|m---               /`'`'`'`'`'`'`\|                      ]],
			[[         ^^           ,,,,,,, /`'`'`'`'`'`'`'`\      ,               ]],
			[[                     .-------.`|`````````````|`  .   )               ]],
			[[                    / .^. .^. \|  ,^^, ,^^,  |  / \ ((               ]],
			[[                   /  |_| |_|  \  |__| |__|  | /,-,\||               ]],
			[[        _         /_____________\ |")| |  |  |/ |_| \|               ]],
			[[       (")         |  __   __  |  '==' '=='  /_______\     _         ]],
			[[      (' ')        | /  \ /  \ |   _______   |,^, ,^,|    (")        ]],
			[[       \  \        | |--| |--| |  ((--.--))  ||_| |_||   (' ')       ]],
			[[     _  ^^^ _      | |__| |("| |  ||  |  ||  |,-, ,-,|   /  /        ]],
			[[   ,' ',  ,' ',    |           |  ||  |  ||  ||_| |_||   ^^^         ]],
			[[.,,|RIP|,.|RIP|,.,,'==========='==''=='==''=='=======',,....,,,,.,ldb]],
			[[]],
		},
		{
			[[           .-"""""""-.                            ]],
			[[         .'       __  \_                          ]],
			[[        /        /  \/  \                         ]],
			[[       |         \_0/\_0/______                   ]],
			[[       |:.          .'       oo`\                 ]],
			[[       |:.         /             \                ]],
			[[       |' ;        |             |                ]],
			[[       |:..   .     \_______     |                ]],
			[[       |::.|'     ,  \,_____\   /                 ]],
			[[       |:::.; ' | .  '|  ====)_/===;===========;()]],
			[[       |::; | | ; ; | |            # # # #::::::  ]],
			[[      /::::.|-| |_|-|, \           # # # #::::::  ]],
			[[     /'-=-'`  '-'   '--'\          # # # #::::::  ]],
			[[jgs /                    \         # # # #::::::  ]],
			[[                                   # # # # # # #  ]],
			[[           H A P P Y               # # # # # # #  ]],
			[[                                   # # # # # # #  ]],
			[[   F O U R T H  O F  J U L Y       # # # # # # #  ]],
			[[                                   # # # # # # #  ]],
			[[                                   # # # # # # #  ]],
			[[]],
		},
		{

			[[$$$$$$$$$$$$$$$$$L   .$$$$$$$$$$$$$$$u      ]],
			[[$$$$$$$$$$$$$$$$$$N.@$$$$$$$$$$$$$$$$ *     ]],
			[[$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ '>.n=L]],
			[[$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$RR$$$$ 'b"  9]],
			[[$$$$$$$$$$$$$$$$$$$$$$$$$$$R#"  .$$$$ @   .*]],
			[[$$$$$$$$$$$$$$$$$$$$$$$$`   .e$$$$$$$P   e" ]],
			[[$$$$$$$$$$$$$$$$$$$$$R#    o$$$$$$$$P   @   ]],
			[[$$$$$$$$$$$$$$$$$$$P" .e> 4$" '$$$$F  .F    ]],
			[[$$$$$$$$$$$$$$$$$R  .$$$& '$   $$$$  .#>    ]],
			[[$$$$$$$$$$$$$$$$$b.o$$$$$  $N  "$$" ."'>    ]],
			[[$$$$$$$$$$$$$$$$$$$$$$$$$  $$N  "` .$ '>    ]],
			[[$$$$$$$$$$$$$$ "$$$$$$$$R  $$$&    $$ '>    ]],
			[[$$$$$$$$$$$$$$  E"$$P`9$E  $$$$   8$$ '>    ]],
			[[$$$$$$$$$$$$$$  E  "  9$F  $$$$k .$$$ '>    ]],
			[[$$$$$$$$$$$$$$  E     9$N  $$$$$$$$$$ '>    ]],
			[[$$$$$$$$$$$$$$  E     9$$.u$$$$$$$$$$ '>    ]],
			[[$$$$$$$$$$$$$$ o"     9$$$$$$$$$$$$$$ d     ]],
			[[**************#       ***************"      ]],
		},
		{
			[[  ___  ____            _           ____      _     _  ]],
			[[ |   |/   /           | |         /    \    (_)   | | ]],
			[[ |   '   /  ___   ___ | |  ___   /   _  \    _  __| | ]],
			[[ |      <  / _ \ / _ \| | |___| /   (_)  \  | |/ _` | ]],
			[[ |   .   \| (_) | (_) | |      /   ____   \ | | (_) | ]],
			[[ |___|\___\\___/ \___/|_|     /___/    \___\|_|\__,_| ]],
			[[     _______________          ____________            ]],
			[[    ( _____________ ) ___    (            )           ]],
			[[    /    _     _    \/ _ \   (  OH YEAH!  )           ]],
			[[   /    (,)   (,)    \/ \ \ /_____________)           ]],
			[[  |         _         | | |               _______     ]],
			[[  |        (_)        | | |   _______    (  . .  )_   ]],
			[[  |     .       .     |/ /   (  . .  )_  |   o   |_)  ]],
			[[   \     '.....'     /__/    |   o   |_)  ) '-' (     ]],
			[[    \               /         ) '-' (    (_______)    ]],
			[[     )_____________(         (_______)                ]],
			[[____(_______________)_________________________________]],
			[[   ______            __    __    __                   ]],
		},
		{
			[[                    _wr""        "-q__                    ]],
			[[                 _dP                 9m_                  ]],
			[[               _#P                     9#_                ]],
			[[              d#@                       9#m               ]],
			[[             d##                         ###              ]],
			[[            J###                         ###L             ]],
			[[            {###K                       J###K             ]],
			[[            ]####K      ___aaa___      J####F             ]],
			[[        __gmM######_  w#P""   ""9#m  _d#####Mmw__         ]],
			[[     _g##############mZ_         __g##############m_      ]],
			[[   _d####M@PPPP@@M#######Mmp gm#########@@PPP9@M####m_    ]],
			[[  a###""          ,Z"#####@" '######"\g          ""M##m   ]],
			[[ J#@"             0L  "*##     ##@"  J#              *#K  ]],
			[[ #"               `#    "_gmwgm_~    dF               `#_ ]],
			[[7F                 "#_   ]#####F   _dK                 JE ]],
			[[]                    *m__ ##### __g@"                   F ]],
			[[                       "PJ#####LP"                        ]],
			[[ `                       0######_                      '  ]],
			[[                       _0########_                        ]],
			[[     .               _d#####^#####m__              ,      ]],
			[[      "*w_________am#####P"   ~9#####mw_________w*"       ]],
			[[          ""9@#####@M""           ""P@#####@M""           ]],
		},
		{
			[[=================     ===============     ===============   ========  ========]],
			[[\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //]],
			[[||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||]],
			[[|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||]],
			[[||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||]],
			[[|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||]],
			[[||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||]],
			[[|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||]],
			[[||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||]],
			[[||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||]],
			[[||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||]],
			[[||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||]],
			[[||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||]],
			[[||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||]],
			[[||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||]],
			[[||.=='    _-'                                                     `' |  /==.||]],
			[[=='    _-'                        N E O V I M                         \/   `==]],
			[[\   _-'                                                                `-_   /]],
			[[ `''                                                                      ``' ]],
		},
		{
			"          ▀████▀▄▄              ▄█ ",
			"            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ",
			"    ▄        █          ▀▀▀▀▄  ▄▀  ",
			"   ▄▀ ▀▄      ▀▄              ▀▄▀  ",
			"  ▄▀    █     █▀   ▄█▀▄      ▄█    ",
			"  ▀▄     ▀▄  █     ▀██▀     ██▄█   ",
			"   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ",
			"    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ",
			"   █   █  █      ▄▄           ▄▀   ",
		},
		{
			[[]],
			[[██████▒░                    ██████▒░]],
			[[    ████▒░                ████▒░    ]],
			[[      ████▒░            ████▒░      ]],
			[[        ██████▒░    ██████▒░        ]],
			[[            ██████████▒░            ]],
			[[        ██████▓▓▓▓▓▓██████▒░        ]],
			[[        ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▒░        ]],
			[[      ████▓▓▓▓▓▓▓▓▓▓▓▓▓▓████▒░      ]],
			[[      ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▒░      ]],
			[[      ████▓▓▓▓▓▓▓▓▓▓▓▓▓▓████▒░      ]],
			[[        ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▒░        ]],
			[[        ██████▓▓▓▓▓▓██████▒░        ]],
			[[            ██████████▒░            ]],
			[[]],
		},
		{
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣶⣾⠿⠿⠟⠛⠛⠛⠛⠿⠿⣿⣷⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⡿⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠒⠂⠉⠉⠉⠉⢩⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⢰⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠠⡀⠀⠀⢀⣾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⢀⣸⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡧⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠈⠁⠒⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣇⠀⠀⠀⠀⠀⠀⠉⠢⠤⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡟⠈⠑⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠑⠒⠤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⡇⠀⠀⢀⣣⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠒⠢⠤⠄⣀⣀⠀⠀⠀⢠⣿⡟⠀⠀⠀⣺⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⣿⠇⠀⠀⠀⠀⠀⣤⡄⠀⠀⢠⣤⡄⠀⢨⣭⣠⣤⣤⣤⡀⠀⠀⢀⣤⣤⣤⣤⡄⠀⠀⠀⣤⣄⣤⣤⣤⠀⠀⣿⣯⠉⠉⣿⡟⠀⠈⢩⣭⣤⣤⠀⠀⠀⠀⣠⣤⣤⣤⣄⣤⣤",
			"⢠⣿⠀⠀⠀⠀⠀⠀⣿⠃⠀⠀⣸⣿⠁⠀⣿⣿⠉⠀⠈⣿⡇⠀⠀⠛⠋⠀⠀⢹⣿⠀⠀⠀⣿⠏⠀⠸⠿⠃⠀⣿⣿⠀⣰⡟⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⣿⡟⢸⣿⡇⢀⣿",
			"⣸⡇⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⣿⡟⠀⢠⣿⡇⠀⠀⢰⣿⡇⠀⣰⣾⠟⠛⠛⣻⡇⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⢻⣿⢰⣿⠀⠀⠀⠀⠀⠀⣾⡇⠀⠀⠀⢸⣿⠇⢸⣿⠀⢸⡏",
			"⣿⣧⣤⣤⣤⡄⠀⠘⣿⣤⣤⡤⣿⠇⠀⢸⣿⠁⠀⠀⣼⣿⠀⠀⢿⣿⣤⣤⠔⣿⠃⠀⠀⣾⡇⠀⠀⠀⠀⠀⠀⢸⣿⣿⠋⠀⠀⠀⢠⣤⣤⣿⣥⣤⡄⠀⣼⣿⠀⣸⡏⠀⣿⠃",
			"⠉⠉⠉⠉⠉⠁⠀⠀⠈⠉⠉⠀⠉⠀⠀⠈⠉⠀⠀⠀⠉⠉⠀⠀⠀⠉⠉⠁⠈⠉⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠁⠀⠉⠁⠀⠉⠁⠀⠉⠀",
		},
		{
			[[]],
			[[                      ██████                     ]],
			[[                  ████▒▒▒▒▒▒████                 ]],
			[[                ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██               ]],
			[[              ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██             ]],
			[[            ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒               ]],
			[[            ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▓▓▓▓           ]],
			[[            ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▒▒▓▓           ]],
			[[          ██▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒    ██         ]],
			[[          ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██         ]],
			[[          ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██         ]],
			[[          ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██         ]],
			[[          ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██         ]],
			[[          ██▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒██         ]],
			[[          ████  ██▒▒██  ██▒▒▒▒██  ██▒▒██         ]],
			[[          ██      ██      ████      ████         ]],
			[[                                                 ]],
			[[]],
		},
		{
			[[]],
			[[  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⣠⣶⡾⠏⠉⠙⠳⢦⡀⠀⠀⠀⢠⠞⠉⠙⠲⡀⠀]],
			[[⠀⠀⠀⣴⠿⠏⠀⠀⠀⠀⠀⠀⢳⡀⠀ ⡏⠀⠀⠀⠀⢷ ]],
			[[⠀⠀⢠⣟⣋⡀⢀⣀⣀⡀⠀⣀⡀⣧⠀⢸⠀⠀⠀⠀⠀ ⡇]],
			[[⠀⠀⢸⣯⡭⠁⠸⣛⣟⠆⡴⣻⡲⣿⠀⣸⠀⠀OK⠀ ⡇]],
			[[⠀⠀⣟⣿⡭⠀⠀⠀⠀⠀⢱⠀⠀⣿⠀⢹⠀⠀⠀⠀⠀ ⡇]],
			[[⠀⠀⠙⢿⣯⠄⠀⠀⠀⢀⡀⠀⠀⡿⠀⠀⡇⠀⠀⠀⠀⡼ ]],
			[[⠀⠀⠀⠀⠹⣶⠆⠀⠀⠀⠀⠀⡴⠃⠀⠀⠘⠤⣄⣠⠞⠀ ]],
			[[⠀⠀⠀⠀⠀⢸⣷⡦⢤⡤⢤⣞⣁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⢀⣤⣴⣿⣏⠁⠀⠀⠸⣏⢯⣷⣖⣦⡀⠀⠀⠀⠀⠀⠀]],
			[[⢀⣾⣽⣿⣿⣿⣿⠛⢲⣶⣾⢉⡷⣿⣿⠵⣿⠀⠀⠀⠀⠀⠀]],
			[[⣼⣿⠍⠉⣿⡭⠉⠙⢺⣇⣼⡏⠀⠀⠀⣄⢸⠀⠀⠀⠀⠀⠀]],
			[[⣿⣿⣧⣀⣿………⣀⣰⣏⣘⣆⣀⠀⠀⢸     ⠀]],
			[[]],
		},
		{
			[[]],
			[[ ...      (^~^)                              ]],
			[[(°з°)  _ ┐__\|_┌________ __   __ ___ __   __ ]],
			[[|  |  | |       |       |  | |  |   |  |_|  |]],
			[[|   |_| |    ___|  ___  |  |_|  |   |       |]],
			[[|       |   |___| |▀-▀| |       |   |       |]],
			[[|  _    |    ___| |___| |       |   |       |]],
			[[| | |   |   |___|       ||     ||   | ||_|| |]],
			[[|_|  |__|_______|_______| |___| |___|_|   |_|]],
			[[]],
			[[]],
		},
		{
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⣶⣶⣶⣶⣶⣶⣶⣦⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣾⣿⠿⠛⠛⠉⠉⠉⠉⠉⠉⠉⠙⠛⠻⢿⣿⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠒⠈⠉⠉⠉⠉⠉⣹⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⠀⣰⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⢄⠀⠀⠀⠀⢰⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⢄⡀⠀⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢺⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠉⠑⠢⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡇⠀⠀⠀⠈⠑⠢⠄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠢⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠉⠐⠢⠄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⡟⠀⠈⠑⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠒⠠⠤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⠁⠀⠀⢀⣼⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠒⠂⠤⠤⠀⣀⡀⠀⠀⠀⣼⣿⠇⠀⠀⢀⣸⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⣿⡟⠀⠀⠀⠀⠀⠀⣤⡄⠀⠀⠀⣠⣤⠀⠀⢠⣭⣀⣤⣤⣤⡀⠀⠀⠀⢀⣤⣤⣤⣤⡀⠀⠀⠀⢠⣤⢀⣤⣤⣄⠀⠀⣿⣿⠀⠉⣹⣿⠏⠉⠉⢱⣶⣶⣶⡦⠀⠀⠀⢠⣶⣦⣴⣦⣠⣴⣦⡀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⢠⣿⡇⠀⠀⠀⠀⠀⢠⣿⠇⠀⠀⠀⣿⡇⠀⠀⣿⡿⠉⠀⠈⣿⣧⠀⠀⠰⠿⠋⠀⠀⢹⣿⠀⠀⠀⣿⡿⠋⠀⠹⠿⠀⠀⢻⣿⡇⢠⣿⡟⠀⠀⠀⠈⠉⢹⣿⡇⠀⠀⠀⢸⣿⡏⢹⣿⡏⢹⣿⡇⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⢰⣿⠃⠀⢠⣿⡇⠀⠀⠀⣿⡇⠀⠀⣠⣴⡶⠶⠶⣿⣿⠀⠀⢠⣿⡇⠀⠀⠀⠀⠀⠀⢸⣿⣇⣿⡿⠀⠀⠀⠀⠀⠀⣿⣿⠁⠀⠀⠀⣿⣿⠀⣾⣿⠀⣾⣿⠁⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⣿⣟⠀⠀⠀⠀⠀⠀⢻⣿⡀⠀⢀⣼⣿⠀⠀⢸⣿⠀⠀⠀⢰⣿⠇⠀⢰⣿⣇⠀⠀⣠⣿⡏⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⠁⠀⠀⠀⣀⣀⣠⣿⣿⣀⡀⠀⢠⣿⡟⢠⣿⡟⢀⣿⡿⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠛⠛⠛⠛⠛⠛⠁⠀⠈⠛⠿⠟⠋⠛⠃⠀⠀⠛⠛⠀⠀⠀⠘⠛⠀⠀⠀⠙⠿⠿⠛⠙⠛⠃⠀⠀⠚⠛⠀⠀⠀⠀⠀⠀⠀⠘⠿⠿⠃⠀⠀⠀⠀⠿⠿⠿⠿⠿⠿⠿⠀⠸⠿⠇⠸⠿⠇⠸⠿⠇⠀⠀⠀⠀⠀",
			"                                                                                ",
		},
	}
	return headers[math.random(1, #headers)]
end

-- }}}
function DashboardEntries(entry, index)
	table.insert(dashboard.section.buttons.entries, index, entry)
end

dashboard.section.header.val = HeaderGlyph()
dashboard.section.footer.val = "Welcome!!"

DashboardEntries({ ".", " Last Session", "<cmd>lua require('persistence').load({ last = true })<cr>" }, 3)
DashboardEntries({ "d", " Last Session of Dir", "<cmd>lua require('persistence').load()<cr>" }, 4)
-- }}}
