"""
将 rng 设置为 world 的随机种子
"""
function wsrand(world::World, rng)
	world.rng = UInt32(rng)
end
"""
快速根据世界随机种子生成 0-32767 间的整数
"""
function wrand_q(world::World)
	# 类 C 算法
	world.rng = world.rng*0x41c64e6d+0x00003039
	return (world.rng>>16)&32767
end
