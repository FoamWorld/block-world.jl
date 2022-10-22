"""
方块，世界的填充物，在指定世界的指定坐标有且仅有一个方块
"""
abstract type Block end

struct B_Air <: Block end
