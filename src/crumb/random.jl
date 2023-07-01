"""
`rng, res = wrand_q(rng)`

生成 `[0, 32768)` 间整数
"""
function wrand_q(rng)
    rng = rng * 0x41c64e6d + 0x00003039
    (rng, (rng >> 16) & 32767)
end

function rand!(world)
    world.rng, res = wrand_q(world.rng)
    res
end

"""
生成 `[l, r]` 间，与 `l`、`r` 同奇偶的整数
"""
function wrand_even_q(rng, l, r)
    rng, res = wrand_q(rng)
    (rng, l + (res % (r - l + 2)) >> 1 << 1)
end

function rande!(world, l, r)
    world.rng, res = wrand_even_q(world.rng, l, r)
    res
end
