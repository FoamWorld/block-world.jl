mutable struct ItemStack
	item::Item
	num::UInt8
end

mutable struct ItemBoard # 物品栏管理器
	items::SVector{ItemStack}
end
Base.getindex(ib::ItemBoard, i::Integer) = ib.items[i]
Base.setindex!(ib::ItemBoard, v::ItemStack, i::Integer) = ib.items[i] = v
remove!(ib::ItemBoard, id::Integer) = ib[id].item = EI()
clear!(ib::ItemBoard) = ib.items .= EI()
function reduce!(ib::ItemBoard, id::Int, n::Integer = 0x1)
	if n < ib[id].num
		ib[id].num -= n
		return 0x0
	else
		ib[id].item = EI()
		return n - ib[id].num
	end
end
function give!(ib::ItemBoard, it::Item, n::Integer)
	last = n
	st = stack(it)
	itid = id(it)
	@inbounds for i in 1:length(ib.items)
		if last==0 return end
		iid = id(ib[i].item)
		if iid == "" # EI
			ib[i].item = deepcopy(it)
			if last > st
				last -= st
				ib[i].num = st
			else
				ib[i].num = last
				return 0
			end
		elseif iid == itid
			orin = ib[i].num
			if orin == st # 很可能出现
				continue
			elseif orin+last > st
				ib[i].num = st
				last -= (st-orin)
			else
				ib[i].num = orin+last
				return 0
			end
		end
	end
	return last
end
