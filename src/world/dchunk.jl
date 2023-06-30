mutable struct DChunk
    blocks::SMatrix{64, 64, Block, 4096}
	entities::Vector{Entity}
end

"""
将坐标 (lx, ly) 左上角显示到画板 (px, py) 像素处
"""
function paint(ctx, c::DChunk, lx::Int, ly::Int, px::Int, py::Int)
    rx = min(lx + 15 - px >> 5, 64)
    ry = min(ly + 15 - py >> 5, 64)
    for i in lx:rx
        for j in ly:ry
            x0 = px + (i - lx) << 5
            y0 = py + (j - ly) << 5
            b = c.blks[i, j]
            b_show(ctx, b, x0, y0)
            if tl != 0x15
                set_source_rgba(ctx, 0, 0, 0, (15 - tl) / 16)
                rectangle(ctx, x0, y0, 32, 32)
            end
        end
    end
end
