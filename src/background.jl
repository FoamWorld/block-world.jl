using Gtk
abstract type GUISet end
struct GtkGUISet<:GUISet
	window::GtkWindow
	topbox
	# register
end

function init_mainmenu_gtk(game::Game)
	window = GtkWindow("FoamWorld", 576, 512;resizable=false)
	set = GtkGUISet(
		window,
		nothing,
		# nothing
	)
	background_mainmenu!(set, game)
	set
end

function background_mainmenu!(gui::GtkGUISet, game::Game)
	if gui.topbox !== nothing
		destroy(gui.topbox)
	end
	box = gui.topbox = GtkBox(:v)
	text_view = GtkTextView("FoamWorld")
	but_create = GtkButton("创建新世界")
	push!(box, text_view)
	push!(box, but_create)
	push!(gtk.window, grids)
	signal_connect(but_create, "clicked") do
		background_creategame!(gui, game)
	end
end

function background_creategame!(gui::GtkGUISet, game::Game)
	destroy(gui.topbox)
	box = gui.topbox = GtkBox(:v)
	but = GtkButton("创建")
	push!(box, but)
	signal_connect(but, "clicked") do
		background_playgame!(gui, game)
	end
end

function background_playgame!(gui::GtkGUISet, game::Game)
	destroy(gui.topbox)
	cvs = gui.topbox = GtkCanvas(576, 512)
	draw(cvs) do widget _
		ctx = getgc(widget)
		draw(ctx, game)
	end
end
