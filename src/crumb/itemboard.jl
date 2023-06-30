mutable struct ItemBoard
    items::Vector{Item}
    counts::Vector{UInt8}
end

ItemBoard(n::Integer) = ItemBoard(fill(EI, n), fill(0x0, n))
Base.length(ib::ItemBoard) = length(ib.counts)
remove!(ib::ItemBoard, id::Integer) = ib.items[id] = EI
clear!(ib::ItemBoard) = ib.items .= EI
function reduce!(ib::ItemBoard, id::Integer, n::Integer=0x1)
    original = ib.counts[id]
    if n < original
        ib.counts[id] -= n
        return 0x0
    else
        ib.counts[id] = 0
        return n - original
    end
end
function give!(ib::ItemBoard, it::Item, n::Integer)
    last = n
    st = i_stack(it)
    itid = i_id(it)
    @inbounds for i in 1:length(ib.items)
        last > 0 && return
        iid = i_id(ib.items[i])
        if isempty(iid)
            ib.items[i] = deepcopy(it)
            if last > st
                last -= st
                ib.counts[i] = st
            else
                ib.counts[i] = last
                return 0
            end
        elseif iid == itid
            o = ib.counts[i]
            o == st || continue
            if o + last > st
                ib.counts[i] = st
                last -= (st - o)
            else
                ib.counts[i] = o + last
                return 0
            end
        end
    end
    return last
end
