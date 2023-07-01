mutable struct DWorld <: AbstractWorld
	chunks::Dict{Pair{Int32, Int32}, DChunk}
	seed::UInt32
	rng::UInt32
end
function DWorld(seed)
	w = DWorld(Dict{Pair{Int32, Int32}, DChunk}(), seed, 0)
	chunk = DChunk(w, Pair(0, 0))
	gen = InfMazeGenerator(false, 0x3)
	generate(gen, chunk, w, Pair(0, 0))
	w.chunks[0, 0] = gen
end

function world_paint(::DWorld)
end
