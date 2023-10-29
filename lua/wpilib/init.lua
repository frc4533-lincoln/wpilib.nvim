--[[
	wpilib.nvim
		Unofficial Neovim plugin for FRC
	
	(c) 2023 frc4533-lincoln
]]

local M = {}

local util = require('wpilib.util')
local config = require('wpilib.config')
local versions = {}

local new_project = require('wpilib.new_project')

local Menu = require('nui.menu')

local function setup()
	-- Fetch versions if we don't already have them
	if not io.open(util.storage_path .. '/versions.lua') then
		new_project.fetch_versions()
	end

	-- Require versions now
	package.path = package.path .. ';'..require('wpilib.util').storage_path..'/versions.lua'
	versions = require('wpilib.versions')

	-- Load config
	return config.load_config()
end

function M.main()
	local cfg = setup()

	local menu = Menu(
		util.menu_opts,
		{
			lines = {
				Menu.item('New Project', { id = 'new' }),
				Menu.item('Manage Vendordeps', { id = 'vdeps' }),
			},
			on_submit = function (item)
				local tbl = {
					['new'] = function ()
						new_project.new_project(cfg.version)
					end,
					['vdeps'] = function ()
						print('Not implemented')
					end,
				}
				tbl[item.id]()
			end
		}
	)

	vim.schedule(function()
		menu:mount()
	end)
end

return M
