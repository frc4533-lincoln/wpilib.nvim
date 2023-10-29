--[[
	wpilib.nvim
		Unofficial Neovim plugin for FRC
	
	(c) 2023 frc4533-lincoln
]]

return {
	storage_path = vim.fn.stdpath('data') .. '/wpilib',
  menu_opts = {
			relative = 'editor',
			position = '50%',
			size = {
				width = 25,
				height = 5,
			},
			border = {
				style = 'rounded',
				text = {
					top = 'WPILib',
					top_align = 'center',
				},
			},
		},
}
