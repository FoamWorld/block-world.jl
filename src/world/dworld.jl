mutable struct DWorld <: AbstractWorld
	chunks::Dict{Pair{Int32, Int32}, DChunk}
	rng::UInt32
end
function DWorld(rng)
	w = DWorld(Dict{Pair{Int32, Int32}, DChunk}(), rng)
	chunk = DChunk()
	gen = InfMazeGenerator(false, 0x3)
	generate(gen, chunk, w, Pair(0, 0))
	w.chunks[0, 0] = gen
end
