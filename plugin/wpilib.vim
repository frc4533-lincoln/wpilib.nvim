" Title: wpilib.nvim
" Description: An UNOFFICIAL WPILib plugin for Neovim
" Maintainer: frc4533-lincoln <https://github.com/frc4533-lincoln>

if exists('g:wpilib_loaded')
	finish
endif
let g:wpilib_loaded = 1

let s:lua_rocks_deps_loc =  expand("<sfile>:h:r") . "/../lua/wpilib/deps"
exe "lua package.path = package.path .. ';" . s:lua_rocks_deps_loc . "/lua-?/init.lua'"

command! -nargs=0 Wpilib lua require('wpilib').main()
