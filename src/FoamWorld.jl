module FoamWorld

# 提供基本类型
# include("blocks.jl")

# using StaticArrays
# include("chunk.jl")
# include("mapgenerator.jl")
include("world.jl")

# 辅助功能
# include("random.jl")

# 总体流程控制
using Gtk4
mutable struct Game_hl
    points::Vector{AbstractWorld}
    config::Dict
end

global window::GtkWindow
global topbox::GtkWidget
global game_hl::Game_hl

include("game.jl")
include("background.jl")

function julia_main()
    initialize()
end

end # module
