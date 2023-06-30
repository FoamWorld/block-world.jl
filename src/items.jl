abstract type Item end

struct I_Empty end
i_id(::I_Empty) = ""
const EI = I_Empty()
