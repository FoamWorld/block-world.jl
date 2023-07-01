mutable struct DWorld <: AbstractWorld
    chunks::Dict{Pair{Int,Int},DChunk}
    gen::MapGenerator
    viewpos::Pair
    seed::UInt32
    rng::UInt32
    flag::Bool
end

Base.getindex(w::DWorld, x::Int, y::Int) = w.chunks[Pair(x, y)]

function DWorld(seed)
    vpos = Pair(0.0, 0.0)
    w = DWorld(Dict{Pair{Int,Int},DChunk}(), InfMazeGenerator(false, true), vpos, seed, 0, true)
    _dworld_loadchunk(w, Pair(0, 0))
    w
end

function _dworld_newchunk(w::DWorld, pos::Pair)
    c = DChunk(Matrix{Block}(undef, 16, 16), Vector{Entity}())
    generate(w.gen, c, w, pos)
    c
end

function _dworld_loadchunk(w::DWorld, pos::Pair{Int,Int})
    for (dx, dy) in [(0, 0), (1, 0), (0, 1), (-1, 0), (0, -1), (1, 1), (-1, 1), (-1, -1), (1, -1), (2, 0), (0, 2), (-2, 0), (0, -2)]
        x, y = pos.first + dx, pos.second + dy
        tpos = Pair(x, y)
        if !haskey(w.chunks, tpos)
            w.chunks[tpos] = _dworld_newchunk(w, tpos)
        end
    end
end

function world_paint(ctx, w::DWorld)
    if w.flag
        set_coordinates(ctx, BoundingBox(0, 9, 8, 0))
        w.flag = false
    end
    # 地图坐标 w.viewpos 对应画板坐标 (4.5, 4)
    wx, wy = Tuple(w.viewpos)
    lxchk, lxind = Int(floor(wx - 4.5)) |> chunk_index
    lychk, lyind = Int(floor(wy - 4)) |> chunk_index
	rxchk, rxind = Int(ceil(wx + 4.5)) |> chunk_index
    rychk, ryind = Int(ceil(wy + 4)) |> chunk_index
    xoffset = 4.5 - mod(wx, 16)
    yoffset = 4 - mod(wy, 16)
    if lxchk == rxchk && lychk == rychk
        chunk_paint(ctx, w[lxchk, lychk], lxind:rxind, lyind:ryind, xoffset, yoffset)
    elseif lxchk != rxchk && lychk == rychk
        chunk_paint(ctx, w[lxchk, lychk], lxind:15, lyind:ryind, xoffset, yoffset)
        chunk_paint(ctx, w[rxchk, lychk], 0:rxind, lyind:ryind, xoffset + 16, yoffset)
    elseif lxchk == rxchk && lychk != rychk
        chunk_paint(ctx, w[lxchk, lychk], lxind:rxind, lyind:15, xoffset, yoffset)
        chunk_paint(ctx, w[lxchk, rychk], lxind:rxind, 0:ryind, xoffset, yoffset + 16)
    else
        chunk_paint(ctx, w[lxchk, lychk], lxind:15, lyind:15, xoffset, yoffset)
        chunk_paint(ctx, w[rxchk, lychk], 0:rxind, lyind:15, xoffset + 16, yoffset)
        chunk_paint(ctx, w[lxchk, rychk], lxind:15, 0:ryind, xoffset, yoffset + 16)
        chunk_paint(ctx, w[rxchk, rychk], 0:rxind, 0:ryind, xoffset + 16, yoffset + 16)
    end
end
