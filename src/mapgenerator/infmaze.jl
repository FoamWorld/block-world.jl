struct InfMazeGenerator <: MapGenerator
    plain::Bool
    wider::Bool
end

function _infmaze_zone(c::DChunk, world, lx, ly, rx, ry)
    if rx == lx || ry == ly
        c.blocks[lx:rx, ly:ry] .= B_Air()
        return
    end
    mx = rande!(world, lx + 1, rx - 1)
    my = rande!(world, ly + 1, ry - 1)
    c.blocks[lx:rx, my] .= B_Wall()
    c.blocks[mx, ly:ry] .= B_Wall()
    _infmaze_zone(c, world, lx, ly, mx - 1, my - 1)
    _infmaze_zone(c, world, mx + 1, ly, rx, my - 1)
    _infmaze_zone(c, world, lx, my + 1, mx - 1, ry)
    _infmaze_zone(c, world, mx + 1, my + 1, rx, ry)
    d = (rand!(world)) & 0x3
    if d == 0x0
        c[mx, rande!(world, my + 1, ry)] = B_Air()
        c[rande!(world, lx, mx - 1), my] = B_Air()
        c[rande!(world, mx + 1, rx), my] = B_Air()
    elseif d == 0x1
        c[mx, rande!(world, ly, my - 1)] = B_Air()
        c[rande!(world, lx, mx - 1), my] = B_Air()
        c[rande!(world, mx + 1, rx), my] = B_Air()
    elseif d == 0x2
        c[mx, rande!(world, ly, my - 1)] = B_Air()
        c[mx, rande!(world, my + 1, ry)] = B_Air()
        c[rande!(world, mx + 1, rx), my] = B_Air()
    else
        c[mx, rande!(world, ly, my - 1)] = B_Air()
        c[mx, rande!(world, my + 1, ry)] = B_Air()
        c[rande!(world, lx, mx - 1), my] = B_Air()
    end
end
function generate(gen::InfMazeGenerator, c::DChunk, world, id::Pair)
    c.blocks[1, :] .= B_Wall()
    c.blocks[:, 1] .= B_Wall()
    world.rng = xor(id.first + (id.second & 0xfff) << 5 + id.second >> 12, world.seed) % UInt32
    #= distance = hypot(id.first, id.second)
    delta = gen.wider ? 0 : begin
        distance < 2 ? 0 : distance < 4 ? 2 : 4
    end =#
    _infmaze_zone(c, world, 2, 2, 16, 16)
    c[1, rande!(world, 2, 16)] = B_Air()
    c[rande!(world, 2, 16), 1] = B_Air()
    #= (gen.plain || (distance > 4 && @rand(world) > 0xfff)) || return
    # !plain
    chest = B_Chest()
    put_with_rarity_table!(chest.content, [
    ], world.rng; mess=true) =#
end
