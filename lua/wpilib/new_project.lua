--[[
	wpilib.nvim
		Unofficial Neovim plugin for FRC
	
	(c) 2023 frc4533-lincoln
]]

local M = {}

local util = require('wpilib.util')

local versions_url = 'https://github.com/4533-phoenix/wpilib-novsc/raw/main/versions.lua'
local storage_path = util.storage_path

local Menu = require('nui.menu')

function M.new_project(version)
	local menu_opts = util.menu_opts
	menu_opts.border.text.top = 'New Project'

	local menu = Menu(menu_opts, {
		lines = {
			Menu.item('Java'),
			Menu.item('C++'),
		},
		on_submit = function (item)
			local tbl = {
				['Java'] = function ()
					return M.dl_templates('java', 'v'..version)
				end,
				['C++'] = function ()
					return M.dl_templates('cpp', 'v'..version)
				end,
			}
			local tmpls_path = tbl[item.text]()

			local tmpls = vim.json.decode(io.open(tmpls_path..'/templates.json', 'r'):read('a'))
			if tmpls then
				for i, tmpl in ipairs(tmpls) do
					print(tmpl.name)
				end
			else
				print('invalid templates.json')
			end
		end,
	})

	vim.schedule(function ()
		menu:mount()
	end)
end

local function svn(repo, tag, path, dest)
	if vim.fn.executable('svn') then
		local j = vim.fn.jobstart({
			'svn',
			'export',
			'https://github.com/'..repo..'/tags/'..tag..'/'..path,
			storage_path..'/'..dest
		})
		vim.fn.jobwait({j})
	else
		print('svn not installed')
	end
end

function M.fetch_versions()
	if vim.fn.executable('wget') then
		vim.fn.mkdir(storage_path, 'p')
    os.execute('wget -q -O "'..storage_path..'/versions.lua" "'..versions_url..'"')
	else
		print('wget not installed')
	end
end

function M.dl_templates(lang, version)
	local dest = version..'/templates/'..lang
	local tbl = {
		['java'] = function ()
			svn(
				'wpilibsuite/allwpilib',
				version,
				'wpilibjExamples/src/main/java/edu/wpi/first/wpilibj/templates',
				dest
			)
		end,
		['cpp'] = function ()
			svn(
				'wpilibsuite/allwpilib',
				version,
				'wpilibcExamples/src/main/cpp/templates',
				dest
			)
		end,
	}

	tbl[lang]()
	return storage_path..'/'..dest
end

return M
