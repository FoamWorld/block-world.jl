mutable struct DWorld <: AbstractWorld
    chunks::Dict{Pair{Int32,Int32},DChunk}
    gen::MapGenerator
    viewpos::Pair
    seed::UInt32
    rng::UInt32
    flag::Bool
end

function DWorld(seed)
    vpos = Pair(0.0, 0.0)
    w = DWorld(Dict{Pair{Int32,Int32},DChunk}(), InfMazeGenerator(false, true), vpos, seed, 0, true)
    _dworld_loadchunk(w, Pair(zero(Int32), zero(Int32)))
    w
end

function _dworld_newchunk(w::DWorld, pos::Pair)
    c = DChunk(Matrix{Block}(undef, 16, 16), Vector{Entity}())
    generate(w.gen, c, w, pos)
    c
end

function _dworld_loadchunk(w::DWorld, pos::Pair{Int32,Int32})
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
        set_coordinates(ctx, BoundingBox(0, width(ctx), height(ctx), 0))
        scale(ctx, 16)
        w.flag = false
    end
	xc, xoffset = divrem(w.viewpos.first, 16)
	yc, yoffset = divrem(w.viewpos.second, 16)
	xc, yc = Int(xc), Int(yc)
	chunk_paint(ctx, w.chunks[xc, yc], 1, 1, 4.5 - xoffset, 4.5 - yoffset)
end
