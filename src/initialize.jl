function initialize()
	game = Game(nothing)
	guiset = init_mainmenu_gtk(game)
	showall(guiset.window)
	game
end
