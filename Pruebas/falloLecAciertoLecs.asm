-- Vía 0
-- Set 0
LW R1, 0(R0)    -- Read Miss Clean (Carga Vía 0).   R1 -> X"00000001"
LW R1, 4(R0)    -- Read Hit.                        R1 -> X"00000002"
LW R1, 8(R0)    -- Read Hit.                        R1 -> X"00000003"
LW R1, 12(R0)   -- Read Hit.                        R1 -> X"00000004"

-- Set 1
LW R1, 16(R0)   -- Read Miss Clean (Carga Vía 0).   R1 -> X"00000005"
LW R1, 20(R0)   -- Read Hit.                        R1 -> X"00000006"

-- Set 2
LW R1, 32(R0)   -- Read Miss Clean (Carga Vía 0).   R1 -> X"00000009"
LW R1, 36(R0)   -- Read Hit.                        R1 -> X"0000000A"

-- Set 3
LW R1, 48(R0)   -- Read Miss Clean (Carga Vía 0).   R1 -> X"0000000D"
LW R1, 52(R0)   -- Read Hit.                        R1 -> X"0000000E"


-- Vía 1
-- Set 0
LW R1, 64(R0)   -- Read Miss Clean (Carga Vía 1).   R1 -> X"00000011"
LW R1, 68(R0)   -- Read Hit.                        R1 -> X"00000012"

-- Set 1
LW R1, 80(R0)   -- Read Miss Clean (Carga Vía 1).   R1 -> X"00000015"
LW R1, 84(R0)   -- Read Hit.                        R1 -> X"00000016"
LW R1, 88(R0)   -- Read Hit.                        R1 -> X"00000017"
LW R1, 92(R0)   -- Read Hit.                        R1 -> X"00000018"

-- Set 2
LW R1, 96(R0)   -- Read Miss Clean (Carga Vía 1).   R1 -> X"00000019"
LW R1, 100(R0)  -- Read Hit.                        R1 -> X"0000001A"

-- Set 3
LW R1, 112(R0)  -- Read Hit Miss Clean (Carga Vía 1).   R1 -> X"0000001D"
LW R1, 116(R0)  -- Read Hit.                            R1 -> X"0000001E"


-- Reemplazo de la vía 0 en todos los conjuntos
-- Set 0
LW R1, 128(R0)  -- Read Hit Miss Clean (Reemplazo). R1 -> X"00000021"
LW R1, 132(R0)  -- Read Hit Hit.                    R1 -> X"00000022"

-- Set 1
LW R1, 144(R0)  -- Read Miss Clean (Reemplazo). R1 -> X"00000025"
LW R1, 148(R0)  -- Read Hit.                    R1 -> X"00000026"

-- Set 2
LW R1, 160(R0)  -- Read Miss Clean (Reemplazo).    R1 -> X"00000029"
LW R1, 164(R0)  -- Read Hit.                    R1 -> X"0000002A"
LW R1, 168(R0)  -- Read Hit.                    R1 -> X"0000002B"
LW R1, 172(R0)  -- Read Hit.                    R1 -> X"0000002C"

-- Set 3
LW R1, 176(R0)  -- Read Miss Clean (Reemplazo). R1 -> X"0000002D"
LW R1, 180(R0)  -- Read Hit.                    R1 -> X"0000002E"