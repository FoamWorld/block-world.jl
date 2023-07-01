mutable struct DChunk
    blocks::Matrix{Block}
    entities::Vector{Entity}
end

Base.getindex(c::DChunk, x, y) = c.blocks[x, y]
Base.setindex!(c::DChunk, v, x, y) = c.blocks[x, y] = v

"""
将地图坐标系 (lx, ly) 格左下角显示到画板坐标系 (px, py)
"""
function chunk_paint(ctx, c::DChunk, lx::Integer, ly::Integer, px, py)
    rx = min(16, lx + Int(ceil(9 - px)))
    ry = min(16, ly + Int(ceil(8 - py)))
    for i in lx:rx
        for j in ly:ry
            x0 = px + (i - lx)
            y0 = py + (j - ly)
            b = c[i, j]
            b_show(ctx, b, Pair(x0, y0))
        end
    end
    fill(ctx)
end
