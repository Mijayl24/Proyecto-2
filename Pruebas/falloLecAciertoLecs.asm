-- Asumimos que R0 = 0.
-- Vamos a usar únicamente R1 para toda la traza.

-- ==================================================================
-- FASE 1: Llenado de la VÍA 0 en TODOS LOS CONJUNTOS (Sets 0 al 3)
-- ==================================================================
-- Set 0
LW R1, 0(R0)    -- Fallo (Carga Vía 0).  GTKWave R1 -> X"00000001"
LW R1, 4(R0)    -- Acierto.              GTKWave R1 -> X"00000002"

-- Set 1
LW R1, 16(R0)   -- Fallo (Carga Vía 0).  GTKWave R1 -> X"00000005"
LW R1, 20(R0)   -- Acierto.              GTKWave R1 -> X"00000006"

-- Set 2
LW R1, 32(R0)   -- Fallo (Carga Vía 0).  GTKWave R1 -> X"00000009"
LW R1, 36(R0)   -- Acierto.              GTKWave R1 -> X"0000000A"

-- Set 3
LW R1, 48(R0)   -- Fallo (Carga Vía 0).  GTKWave R1 -> X"0000000D"
LW R1, 52(R0)   -- Acierto.              GTKWave R1 -> X"0000000E"


-- ==================================================================
-- FASE 2: Llenado de la VÍA 1 en TODOS LOS CONJUNTOS (Sets 0 al 3)
-- ==================================================================
-- Set 0
LW R1, 64(R0)   -- Fallo (Carga Vía 1).  GTKWave R1 -> X"00000011"
LW R1, 68(R0)   -- Acierto.              GTKWave R1 -> X"00000012"

-- Set 1
LW R1, 80(R0)   -- Fallo (Carga Vía 1).  GTKWave R1 -> X"00000015"
LW R1, 84(R0)   -- Acierto.              GTKWave R1 -> X"00000016"

-- Set 2
LW R1, 96(R0)   -- Fallo (Carga Vía 1).  GTKWave R1 -> X"00000019"
LW R1, 100(R0)  -- Acierto.              GTKWave R1 -> X"0000001A"

-- Set 3
LW R1, 112(R0)  -- Fallo (Carga Vía 1).  GTKWave R1 -> X"0000001D"
LW R1, 116(R0)  -- Acierto.              GTKWave R1 -> X"0000001E"


-- ==================================================================
-- FASE 3: Reemplazo FIFO de la VÍA 0 en TODOS LOS CONJUNTOS
-- ==================================================================
-- La caché está llena. Entran nuevos bloques limpios que expulsan
-- a los más antiguos (los cargados en la Fase 1 en la Vía 0).

-- Set 0
LW R1, 128(R0)  -- Fallo (Reemplazo).    GTKWave R1 -> X"00000021"
LW R1, 132(R0)  -- Acierto.              GTKWave R1 -> X"00000022"

-- Set 1
LW R1, 144(R0)  -- Fallo (Reemplazo).    GTKWave R1 -> X"00000025"
LW R1, 148(R0)  -- Acierto.              GTKWave R1 -> X"00000026"

-- Set 2
LW R1, 160(R0)  -- Fallo (Reemplazo).    GTKWave R1 -> X"00000029"
LW R1, 164(R0)  -- Acierto.              GTKWave R1 -> X"0000002A"

-- Set 3
LW R1, 176(R0)  -- Fallo (Reemplazo).    GTKWave R1 -> X"0000002D"
LW R1, 180(R0)  -- Acierto.              GTKWave R1 -> X"0000002E"