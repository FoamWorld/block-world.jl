pos(ent::Entity) = ent.pos
motion(ent::Entity) = ent.motion
rotation(ent::Entity) = ent.rotation

move(ent::Entity, w::DWorld, mv::Pair) = moveto(ent, w, Pair(pos(ent).first + mv.first, pos(ent).second + mv.second))

include("entity/player.jl")
