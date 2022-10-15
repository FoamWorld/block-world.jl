include("world.jl")
include("background.jl")
function initialize()
	World
	game;
	guiset = init_mainmenu_gtk(game)
	showall(guiset.window);
end
