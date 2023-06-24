module FoamWorld

# 提供基本类型
# include("blocks.jl")

# using StaticArrays
# include("chunk.jl")
# include("mapgenerator.jl")
include("worlds.jl")

using Gtk4
mutable struct Game_hl
    points::Vector{AbstractWorld}
    config::Dict
end

global window::GtkWindow
global topbox::GtkWidget
global canvas::GtkCanvas
global game_hl::Game_hl

include("game.jl")
include("background.jl")

function julia_main()
    initialize()
end

include("crumb/gtk.jl")
include("world/dworld.jl")

end # module
