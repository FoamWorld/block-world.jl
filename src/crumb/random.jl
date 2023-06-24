"""
rng, res = wrand_q(rng)

生成 [0, 32768) 间整数
"""
function wrand_q(rng)
	rng = rng*0x41c64e6d+0x00003039
	(rng, (rng>>16)&32767)
end
