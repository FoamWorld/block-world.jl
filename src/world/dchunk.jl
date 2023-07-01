mutable struct DChunk
    blocks::SMatrix{64, 64, Block, 4096}
	entities::Vector{Entity}
end

Base.getindex(c::DChunk, x, y) = c.blocks[x, y]
Base.setindex!(c::DChunk, v, x, y) = c.blocks[x, y] = v

function DChunk(world::DWorld, pos::Pair)
    c = DChunk(SMatrix{64, 64, Block, 4096}(Array{Block}(B_Air(), 64, 64)), Vector{Entity}())
    gen = InfMazeGenerator(false, true)
    generate(gen, c, world, pos)
end

"""
将坐标 (lx, ly) 左上角显示到画板 (px, py) 像素处
"""
function chunk_paint(ctx, c::DChunk, lx::Int, ly::Int, px::Int, py::Int)
    rx = min(lx + 15 - px >> 5, 64)
    ry = min(ly + 15 - py >> 5, 64)
    for i in lx:rx
        for j in ly:ry
            x0 = px + (i - lx) << 5
            y0 = py + (j - ly) << 5
            b = c[i, j]
            b_show(ctx, b, Pair(x0, y0))
        end
    end
    fill(ctx)
end
