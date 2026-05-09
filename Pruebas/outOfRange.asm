LW R1, 4(R0)    -- R1 = X"00000400" (Dirección inválida, fuera de rango)
LW R3, 0(R1)    -- Intento de lectura. ¡Se activa Mem_ERROR y ocurre un Data Abort!