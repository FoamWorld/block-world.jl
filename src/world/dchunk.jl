mutable struct DChunk
    blocks::Matrix{Block}
    entities::Vector{Entity}
end

Base.getindex(c::DChunk, x, y) = c.blocks[x, y]
Base.setindex!(c::DChunk, v, x, y) = c.blocks[x, y] = v

function chunk_index(x)
    (x >> 4), (x & 15)
end

"""
显示区块坐标系 (xsc..., ysc...) （以 0 起始）。区块坐标 (0, 0) 对应画板坐标 (px, py)
"""
function chunk_paint(ctx, c::DChunk, xsc, ysc, px, py)
    for i in xsc
        for j in ysc
            b = c[i + 1, j + 1]
            b_show(ctx, b, Pair(px + i, py + j))
        end
    end
    fill(ctx)
end
