-- Asumimos que R0 = 0.
-- ------------------------------------------------------------------
-- 1. PRUEBA EN LA VÍA 1 (Internamente Vía 0 de la caché)
-- ------------------------------------------------------------------
-- FALLO (Miss). La caché está vacía. Se trae el Bloque A entero 
-- (palabras 0 a 3) y se aloja en la Vía 0 del Conjunto 0. 
-- Valor esperado en R1: X"00000001" (1 en decimal)
LW R1, 0(R0)

-- ACIERTO (Hit). Leemos la siguiente palabra del mismo Bloque A.
-- Valor esperado en R2: X"00000002" (2 en decimal)
LW R2, 4(R0)

-- ACIERTO (Hit). Leemos la tercera palabra del Bloque A.
-- Valor esperado en R3: X"00000003" (3 en decimal)
LW R3, 8(R0)


-- ------------------------------------------------------------------
-- 2. PRUEBA EN LA VÍA 2 (Internamente Vía 1 de la caché)
-- ------------------------------------------------------------------
-- FALLO (Miss). La dir 64 es la palabra 16. Mapea al Conjunto 0.
-- Como la Vía 0 está ocupada por el Bloque A, la caché aloja el Bloque B en la Vía 1.
-- Valor esperado en R4: X"00000011" (17 en decimal)
LW R4, 64(R0)

-- ACIERTO (Hit). Leemos la siguiente palabra del Bloque B en la Vía 1.
-- Valor esperado en R5: X"00000012" (18 en decimal)
LW R5, 68(R0)


-- ------------------------------------------------------------------
-- 3. PRUEBA EN LA VÍA 1 OTRA VEZ (Forzando reemplazo FIFO)
-- ------------------------------------------------------------------
-- FALLO (Miss). La dir 128 es la palabra 32. Mapea al Conjunto 0.
-- El Conjunto 0 está lleno (Vía 0: Bloq A, Vía 1: Bloq B). 
-- Por política FIFO, se expulsa el más antiguo (Vía 0, Bloq A) 
-- y se carga el Bloque C en la Vía 0.
-- Valor esperado en R6: X"00000021" (33 en decimal)
LW R6, 128(R0)

-- ACIERTO (Hit). Leemos del nuevo Bloque C alojado en la Vía 0.
-- Valor esperado en R7: X"00000022" (34 en decimal)
LW R7, 132(R0)