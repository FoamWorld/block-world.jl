"""
地形生成器抽象类型，对于它的实例 gen，支持
* `gen(c::Chunk, world::World, idx, idy)` ，用于在世界的指定区块创建地形
"""
abstract type MapGenerator end
struct AirFillGenerator <: MapGenerator end
function (::AirFillGenerator)(c::Chunk, _, _, _)
	@inbounds c.blks[1:64, 1:64] .= B_Air()
end

struct InfMazeGenerator <: MapGenerator
	plain::Bool
end
macro rd(l, r)
	return :(wrand_even_q(world, $l, $r))
end
function _infmaze_zone_maze(c::Chunk, world, lx, ly, rx, ry, delta)
	if rx-lx<delta || ry-ly<delta
		c.blks[lx:rx, ly:ry] .= B_Air()
		return
	end
	mx=@rd lx+1 rx-1
	my=@rd ly+1 ry-1
	c.blks[lx:rx, my] .= B_StarRock()
	c.blks[mx, ly:ry] .= B_StarRock()
	_infmaze_zone_maze(c, world, lx, ly, mx-1, my-1, delta)
	_infmaze_zone_maze(c, world, mx+1, ly, rx, my-1, delta)
	_infmaze_zone_maze(c, world, lx, my+1, mx-1, ry, delta)
	_infmaze_zone_maze(c, world, mx+1, my+1, rx, ry, delta)
	dir=wrand_q(world)&0x3
	if dir==0x0
		c.blks[mx, @rd(my+1, ry)]=B_Air()
		c.blks[@rd(lx, mx-1), my]=B_Air()
		c.blks[@rd(mx+1, rx), my]=B_Air()
	elseif dir==0x1
		c.blks[mx, @rd(ly, my-1)]=B_Air()
		c.blks[@rd(lx, mx-1), my]=B_Air()
		c.blks[@rd(mx+1, rx), my]=B_Air()
	elseif dir==0x2
		c.blks[mx, @rd(ly, my-1)]=B_Air()
		c.blks[mx, @rd(my+1, ry)]=B_Air()
		c.blks[@rd(mx+1, rx), my]=B_Air()
	else
		c.blks[mx, @rd(ly, my-1)]=B_Air()
		c.blks[mx, @rd(my+1, ry)]=B_Air()
		c.blks[@rd(lx, mx-1), my]=B_Air()
	end
end
function (gen::InfMazeGenerator)(c::Chunk, world, idx, idy)
	c.blks[1, 1:64] .= B_StarRock()
	c.blks[2:64, 1] .= B_StarRock()
	wsrand(world, xor(idx<<15+idy, world.seed))
	distance = idx^2+idy^2
	_infmaze_zone_maze(c, world, 2, 2, 64, 64,
		gen.plain || distance>25 ? 0 :
		distance<11 ? 4 : 2)
	b1 = (wrand_q(world)&0x1f)<<1
	b2 = (wrand_q(world)&0x1f)<<1
	if gen.plain || (distance>16 && wrand_q(world)>0xfff)
		c.blks[1, b1] = B_Air()
		c.blks[b2, 1] = B_Air()
	else
		chest = B_Chest()
		# pushitem_with_rarity_table
		pushitem_separately!(chest,
			(I_Block(B_Sapling(0x0)), wrand_q(world)&0x3+0x1),
			I_Bucket(0x0))
		c.blks[1, b1] = chest
		c.blks[b2, 1] = B_Glass()
	end
end
