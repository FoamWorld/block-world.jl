mutable struct Chunk
	# blks::SMatrix{64, 64, Block, 4096}
	# ligs::SVector{UInt8, 2048}
	# tm::Int
end
function getlight(c::Chunk, x, y)::UInt8
	id=(x<<5)|(y>>1)+1
	return (y&1==0) ? c.ligs[id]>>4 : c.ligs[id]&0xf
end
function setlight!(c::Chunk, x, y, v::UInt8)::UInt8
	id=(x<<5)|(y>>1)+1
	c.ligs[id] = (y&1==0) ? c.ligs[id]&0xf|(v<<4) : c.ligs[id]&0xf0|v
end
"""
将坐标 (lx, ly) 左上角显示到画板 (px, py) 像素处
"""
function paint(ctx, c::Chunk, lx::Int, ly::Int, px::Int, py::Int, envl::UInt8)
	rx=min(lx+15-px>>5, 64)
	ry=min(ly+15-py>>5, 64)
	for i in lx:rx
		for j in ly:ry
			tl=getlight(c, i, j)
			if tl<envl
				tl=envl
			end
			x0=px+(i-lx)<<5
			y0=py+(j-ly)<<5
			if tl==0x0
				set_source_rgb(ctx, 0, 0, 0)
				rectangle(ctx, x0, y0, 32, 32)
				continue
			end
			b=c.blks[i, j]
			if b_need_background(b)
				set_source_rgb(ctx, 15/16, 15/16, 15/16)
				rectangle(ctx, x0, y0, 32, 32)
			end
			b_show(ctx, b, x0, y0)
			if tl!=0x15
				set_source_rgb(ctx, 0, 0, 0, (15-tl)/16)
				rectangle(ctx, x0, y0, 32, 32)
			end
		end
	end
end
