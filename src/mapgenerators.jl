abstract type MapGenerator end

struct FillGenerator <: MapGenerator
    fill::Block
end

function generate(gen::FillGenerator, c::DChunk, _, _)
    c.blocks[:][:] = gen.fill
end
