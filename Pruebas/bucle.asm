LW R3, 0(R0)   -- Read Miss Clean. R1 ->  X"00000001"
LW R1, 4(R0)    -- Read Hit (Carga Vía 0).   R3 -> X"00000000"
LW R4, 8(R0)    -- Read Hit. R4 ->  X"00000016"
LW R2, 12(R0)   -- Read Hit. R2 ->  X"10000000"


BUCLE:  BEQ R1, R4, FIN

SW R1, 4(R2)   -- Write Scratch (@X"10000004")

LW R1, 0(R0)    -- Read Hit.   R1 -> X"00000001"
-- Set 1
LW R1, 16(R0)   -- Read Miss Clean (Carga Vía 0).   R1 -> X"00000005"
-- Set 2
LW R1, 32(R0)   -- Read Miss Clean (Carga Vía 0).   R1 -> X"00000009"
-- Set 3
LW R1, 48(R0)   -- Read Miss Clean (Carga Vía 0).   R1 -> X"0000000D"


-- Vía 1
-- Set 0
LW R1, 64(R0)   -- Read Miss Clean (Carga Vía 1).   R1 -> X"00000011"
-- Set 1
LW R1, 80(R0)   -- Read Miss Clean (Carga Vía 1).   R1 -> X"00000015"
-- Set 2
LW R1, 96(R0)   -- Read Miss Clean (Carga Vía 1).   R1 -> X"00000019"
-- Set 3
LW R1, 112(R0)  -- Read Miss Clean (Carga Vía 1).   R1 -> X"0000001D"

LW R1, 4(R2)   -- Read Scratch (@X"10000004") R1 -> Contador

ADD R1, R1, R3
BEQ R0 R0 BUCLE
FIN: BEQ R0 R0 -1
