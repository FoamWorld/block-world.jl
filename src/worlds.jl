abstract type AbstractWorld end

#= mutable struct Dimension
    cs::Dict{Pair{Int, Int}, Chunk}
end

mutable struct World
    dims::Dimension
    seed::UInt32
    rng::UInt32
    sav
end
function generate(c::Chunk, world::World, map_generator::MapGenerator, idx, idy)
    # @assert world.sav.method = :edit
    map_generator(c, idx, idy, world)
    sav = get(world.sav, Pair(x, y), nothing)
    if !isnothing(sav)
        for i in sav
            x0 = i.first >> 6
            y0 = i.first & 63
            c.blks[x0, y0] = i.second
        end
    end
end
=#
