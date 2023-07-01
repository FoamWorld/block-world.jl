struct FillGenerator <: MapGenerator
    fill::Block
end

function generate(gen::FillGenerator, c::DChunk, _, _)
    c.blocks[:][:] = gen.fill
end

include("mapgenerator/infmaze.jl")
