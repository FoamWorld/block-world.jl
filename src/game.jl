function initialize()
    global game_hl = Game_hl(Vector{AbstractWorld}(), Dict{Symbol,Any}())
    global application = GtkApplication()
    signal_connect(init_window_gtk, application, :activate)
    nothing
end

function initialize_game()
    global game_hl
    game_hl.points = [DWorld(0)]
    nothing
end

function destroy_game(save::Bool=true)
end

function propel_game()
    global game_hl
    global canvas
    reveal(canvas)
    nothing
end

function game_draw(ctx::GraphicsContext)
    global game_hl
    global window
    global topbox
    world = game_hl.points[1]
    world_paint(ctx, world)
    nothing
end
