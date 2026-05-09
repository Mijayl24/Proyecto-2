LW R3, 4(R0)    -- R3 = X"01000000" (Read Miss Clean)
LW R2, 8(R0)    -- R2 = X"00000002" (Read Hit)

SW R2, 0(R3)    -- Intento de escritura en registro interno. Activa Mem_ERROR