LW R3, 4(R0)    -- R3 = X"01000000" (Read Miss Clean)
LW R2, 8(R0)    -- R2 = X"00000002" (Read Hit)

SW R2, 0(R3)    -- Intento de escritura en registro interno. Activa Mem_ERROR


LW R1, 12(R0)   -- R1 = X"00000400" (Dirección inválida, fuera de rango)
LW R3, 0(R1)    -- Intento de lectura. Se activa Mem_ERROR y ocurre un Data Abort


LW R1, 1(R0)    -- Unaligned
SW R1, 2(R0)    -- Unaligned