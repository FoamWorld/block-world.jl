function key_control(keyval::Integer)
	global game_hl
	world = game_hl.points[1]
	if keyval == 119
		move(world.player, world, Pair(0.0, -1.0))
	end
end
