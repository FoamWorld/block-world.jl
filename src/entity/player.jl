function moveto(ent::E_Player, w::DWorld, pos::Pair)
	oldchkpos = Pair(ent.pos.first >> 4, ent.pos.second >> 4)
	ent.pos = pos
	w.viewpos = pos
	chkpos = Pair(pos.first >> 4, pos.second >> 4)
	_dworld_loadchunk(w, chkpos)
	if oldchkpos != chkpos
		oldlist = w.chunks[oldchkpos].entities
		for (i, v) in enumerate(oldlist)
			if v.uuid == ent.uuid
				deleteat!(oldlist, i)
				break
			end
		end
		push!(w.chunks[chkpos].entities, ent)
	end
end
