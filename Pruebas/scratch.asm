-- ==================================================================
-- FASE 1: CARGA DE CONSTANTES DESDE MD (Caché)
-- ==================================================================
-- Estas instrucciones SÍ pasarán por la caché (Direcciones 0 a 12).
-- Generarán 1 Fallo (Miss) al traer el bloque, seguido de 3 Aciertos (Hits).

LW R9, 0(R0)     -- R9 = X"10000000" (Base de la Scratch)
LW R2, 4(R0)     -- R2 = X"00000055" (Dato 1)
LW R3, 8(R0)     -- R3 = X"000000AA" (Dato 2)
LW R4, 12(R0)    -- R4 = X"000000FF" (Dato 3)


-- ==================================================================
-- FASE 2: ESCRITURAS EN LA SCRATCH MEMORY (No cacheables)
-- ==================================================================
-- Al usar R9 como base, las direcciones enviadas tendrán el prefijo X"100000".
-- Esto activa la señal 'addr_non_cacheable' y van directas al bus.

SW R2, 0(R9)     -- Escribe X"55" en la palabra 0 de la Scratch (@ X"10000000")--Este dato sera modificado si o si porque IO_Master escribe ZZZs en la primera direccion de la Scratch
SW R3, 4(R9)     -- Escribe X"AA" en la palabra 1 de la Scratch (@ X"10000004")
SW R4, 8(R9)     -- Escribe X"FF" en la palabra 2 de la Scratch (@ X"10000008")


-- ==================================================================
-- FASE 3: LECTURAS DESDE LA SCRATCH MEMORY (No cacheables)
-- ==================================================================
-- Reutilizamos R1 para ver los cambios secuenciales de forma limpia en GTKWave.

LW R1, 0(R9)     -- Lee de Scratch. GTKWave R1 -> X"00000055"--Aqui seguramente que lea ZZZs
LW R1, 4(R9)     -- Lee de Scratch. GTKWave R1 -> X"000000AA"
LW R1, 8(R9)     -- Lee de Scratch. GTKWave R1 -> X"000000FF"