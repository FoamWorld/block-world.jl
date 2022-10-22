module FoamWorld

# 提供基本类型
include("blocks.jl")

using StaticArrays
include("chunk.jl")
include("mapgenerator.jl")
include("world.jl")

# 辅助功能
include("random.jl")

# 总体流程控制
using Gtk
include("background.jl")
include("initialize.jl")

function julia_main()
	game = initialize()
end

end # module
