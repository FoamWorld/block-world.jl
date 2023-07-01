"""
方块，世界的填充物，在指定世界的指定坐标有且仅有一个方块
"""
abstract type Block end

struct B_Air <: Block end
function b_show(ctx, ::B_Air, pos::Pair)
	set_source_rgb(ctx, 1, 1, 1)
	rectangle(ctx, pos.first, pos.second, 1, 1)
end

struct B_Wall <: Block end
