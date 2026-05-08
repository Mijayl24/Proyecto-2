-- Llenamos y ensuciamos la Vía 0 (Conjuntos 0 al 3)
LW R1, 0(R0)     -- Fallo. Carga Dir 0 en Conjunto 0, Vía 0.
LW R1, 16(R0)    -- Fallo. Carga Dir 16 en Conjunto 1, Vía 0.
LW R1, 32(R0)    -- Fallo. Carga Dir 32 en Conjunto 2, Vía 0.
SW R1, 48(R0)    -- Fallo. Escribe en MP
LW R1, 48(R0)    -- Fallo. Carga Dir 48 en Conjunto 3, Vía 0.
SW R1, 64(R0)    -- Acierto.