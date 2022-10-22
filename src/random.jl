"""
将 seed 设置为 world 的随机种子
"""
function wsrand(world::World, seed)
	world.rng = seed
end
"""
快速根据世界随机种子生成 0-32767 间的整数
"""
function wrand_q(world::World)
end
