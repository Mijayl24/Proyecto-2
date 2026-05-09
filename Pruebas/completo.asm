-- Llenamos y ensuciamos la Vía 0 (Conjuntos 0 al 3)
LW R1, 0(R0)    -- Read Miss Clean. Carga Dir 0 en Conjunto 0, Vía 0.
SW R1, 4(R0)    -- Write Hit. Marca Conjunto 0, Vía 0 Dirty.

LW R1, 16(R0)   -- Read Miss Clean. Carga Dir 16 en Conjunto 1, Vía 0.
SW R1, 20(R0)   -- Write Hit. Marca Conjunto 1, Vía 0 Dirty.

LW R1, 32(R0)   -- Read Miss Clean. Carga Dir 32 en Conjunto 2, Vía 0.
SW R1, 36(R0)   -- Write Hit. Marca Conjunto 2, Vía 0 Dirty.

LW R1, 48(R0)   -- Read Miss Clean. Carga Dir 48 en Conjunto 3, Vía 0.
SW R1, 52(R0)   -- Write Hit. Marca Conjunto 3, Vía 0 Dirty.



SW R1, 64(R0)   -- Write Miss. Escribe en MP.



LW R2, 64(R0)   -- Read Miss Clean. Carga Dir 64 en Conjunto 0, Vía 1. (@ X"10000000")
SW R1, 68(R0)   -- Write Hit. Marca Conjunto 0, Vía 1 Dirty.

LW R3, 80(R0)   -- Read Miss Clean. Carga Dir 80 en Conjunto 1, Vía 1. (X"00000055")
SW R1, 84(R0)   -- Write Hit. Marca Conjunto 1, Vía 1 Dirty.


LW R1, 96(R0)   -- Read Miss Clean. Carga Dir 96 en Conjunto 2, Vía 1.
SW R1, 100(R0)  -- Write Hit. Marca Conjunto 2, Vía 1 Dirty.

LW R1, 112(R0)  -- Read Miss Clean. Carga Dir 112 en Conjunto 3, Vía 1.
SW R1, 116(R0)  -- Write Hit. Marca Conjunto 3, Vía 1 Dirty.



SW R3, 0(R2)     -- Escribe X"55" en la palabra 0 de la Scratch (@ X"10000000") Este dato sera modificado si o si porque IO_Master escribe ZZZs en la primera direccion de la Scratch
SW R3, 4(R2)     -- Escribe X"55" en la palabra 1 de la Scratch (@ X"10000004")


LW R1, 0(R2)     -- Lee de Scratch. R1 -> Seguramente leerá ZZZs
LW R1, 4(R2)     -- Lee de Scratch. R1 -> X"000000AA"


LW R3, 128(R0)  -- Read Miss Dirty (Set 0). Expulsa Vía 0 (Dir 0). Copy-Back R3 = X"01000000" 
LW R2, 144(R0)  -- Read Miss Dirty (Set 1). Expulsa Vía 0 (Dir 16). Copy-Back R2 = X"00000012"
LW R1, 160(R0)  -- Read Miss Dirty (Set 2). Expulsa Vía 0 (Dir 32). Copy-Back
LW R1, 176(R0)  -- Read Miss Dirty (Set 3). Expulsa Vía 0 (Dir 48). Copy-Back


SW R2, 0(R3)    -- Intento de escritura en registro interno. Activa Mem_ERROR
LW R1, 0(R3)    -- Acierto de lectura de registro interno. Desactiva Mem_ERROR


LW R1, 1(R0)     -- Unaligned