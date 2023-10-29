--[[
	wpilib.nvim
		Unofficial Neovim plugin for FRC
	
	(c) 2023 frc4533-lincoln
]]

local M = {}

local Menu = require('nui.menu')

local function init_config()
	local f = io.open(require('wpilib.util').storage_path .. '/config.json', 'w')

	if f then
		local versions = {}
		for i, v in ipairs(require('wpilib.versions')) do
			versions[i] = Menu.item(v.tag, { unstable = not v.stable })
		end

		local cfg = {}
		local menu = Menu(require('wpilib.util').menu_opts, {
			lines = versions,
			enter = true,
			on_submit = function (item)
				f:write(vim.json.encode({ version = item.text }))
				cfg = { version = item.text }
			end
		})

		vim.schedule(function ()
			menu:mount()
		end)

		return cfg
	end
end

function M.load_config()
	local f = io.open(require('wpilib.util').storage_path .. '/config.json', 'r'):read('a')
	if vim.fn.strlen(f) > 0 then
		local cfg = vim.json.decode(f)
		if cfg then
			return cfg
		else
			vim.print('Invalid configuration file')
		end
	else
		return init_config()
	end
end

return M
