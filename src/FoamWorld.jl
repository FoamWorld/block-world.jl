module FoamWorld

# 界面框架
using Gtk4 # https://docs.juliahub.com/Gtk4/rFcBQ/0.4.1/
using Graphics
abstract type AbstractWorld end
mutable struct Game_hl
    points::Vector{AbstractWorld}
    config::Dict
end

global application::GtkApplication
global window::GtkApplicationWindow
global topbox::GtkBox
global canvas::GtkCanvas
global game_hl::Game_hl

include("game.jl")
include("background.jl")

function julia_main()
    global application
    initialize()
    if isinteractive()
        Gtk4.GLib.stop_main_loop()
        schedule(Task(function ()
            Gtk4.run(application)
        end))
    else
        Gtk4.run(application)
    end
end

include("crumb/gtk.jl")
include("crumb/random.jl")
include("blocks.jl")
include("items.jl")

using UUIDs
abstract type Entity end
mutable struct E_Player <: Entity
	pos::Pair{Float64, Float64}
	uuid::UUID
end
include("world/dchunk.jl")

abstract type MapGenerator end
include("world/dworld.jl")
include("mapgenerators.jl")

include("entities.jl")

include("control.jl")

end # module
