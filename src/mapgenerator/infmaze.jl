struct InfMazeGenerator <: MapGenerator
    plain::Bool
    wider::Bool
end

function _infmaze_zone(c::DChunk, world, lx, ly, rx, ry)
    if rx == lx || ry == ly
        return
    end
    mx = @rande world lx + 1 rx - 1
    my = @rande world ly + 1 ry - 1
    c[lx:rx, my] .= B_Wall()
    c[mx, ly:ry] .= B_Wall()
    _infmaze_zone(c, world, lx, ly, mx - 1, my - 1)
    _infmaze_zone(c, world, mx + 1, ly, rx, my - 1)
    _infmaze_zone(c, world, lx, my + 1, mx - 1, ry)
    _infmaze_zone(c, world, mx + 1, my + 1, rx, ry)
    d = (@rand(world)) & 0x3
    if d == 0x0
        c[mx, @rande(world, my + 1, ry)] = B_Wall()
        c[@rande(world, lx, mx - 1), my] = B_Wall()
        c[@rande(world, mx + 1, rx), my] = B_Wall()
    elseif d == 0x1
        c[mx, @rande(world, ly, my - 1)] = B_Wall()
        c[@rande(world, lx, mx - 1), my] = B_Wall()
        c[@rande(world, mx + 1, rx), my] = B_Wall()
    elseif d == 0x2
        c[mx, @rande(world, ly, my - 1)] = B_Wall()
        c[mx, @rande(world, my + 1, ry)] = B_Wall()
        c[@rande(world, mx + 1, rx), my] = B_Wall()
    else
        c[mx, @rande(world, ly, my - 1)] = B_Wall()
        c[mx, @rande(world, my + 1, ry)] = B_Wall()
        c[@rande(world, lx, mx - 1), my] = B_Wall()
    end
end
function generate(gen::InfMazeGenerator, c::DChunk, world, id::Pair)
    c[1, 1:64] .= B_Wall()
    c[2:64, 1] .= B_Wall()
    world.rng = xor(id.first, bitreverse(id.second) + world.seed)
    #= distance = hypot(id.first, id.second)
    delta = gen.wider ? 0 : begin
        distance < 2 ? 0 : distance < 4 ? 2 : 4
    end =#
    _infmaze_zone(c, world, 2, 2, 64, 64)
    b1 = (@rand(world) & 0x1f) << 1
    b2 = (@rand(world) & 0x1f) << 1
    c[1, b1] = B_Air()
    c[b2, 1] = B_Air()
    #= (gen.plain || (distance > 4 && @rand(world) > 0xfff)) || return
    # !plain
    chest = B_Chest()
    put_with_rarity_table!(chest.content, [
    ], world.rng; mess=true) =#
end
