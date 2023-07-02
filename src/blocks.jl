abstract type Block end
Base.length(::Block) = 1
Base.iterate(b::Block) = (b, nothing)
Base.iterate(::Block, ::Nothing) = nothing

struct B_Air <: Block end
function b_show(ctx, ::B_Air, pos::Pair)
    set_source_rgb(ctx, 1, 1, 1)
    rectangle(ctx, pos.first, pos.second, 1, 1)
    fill(ctx)
end

struct B_Wall <: Block end
function b_show(ctx, ::B_Wall, pos::Pair)
    set_source_rgb(ctx, 0.25, 0.5, 0.5)
    rectangle(ctx, pos.first, pos.second, 1, 1)
    fill(ctx)
end
