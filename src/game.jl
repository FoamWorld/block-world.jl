function initialize()
    global game_hl = Game_hl(Vector{AbstractWorld}(), Dict{Symbol,Any}())
    init_mainmenu_gtk()
    nothing
end

function initialize_game()
    global game_hl
    game_hl.points = [DWorld(0)]
    nothing
end

function propel_game()
    global game_hl
    game_hl.points[0].rng += 1
    nothing
end

function game_draw(ctx::GdkCairoContext)
    global game_hl
    world = game_hl.points[0]
    set_source_rgb(ctx, 0, 0, (world.rng & 255) / 256)
    rectangle(ctx, 0, 0, 100, 100)
    nothing
end
