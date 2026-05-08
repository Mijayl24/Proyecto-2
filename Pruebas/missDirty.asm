-- ------------------------------------------------------------------
-- FASE 1: Llenar la caché entera y marcar TODOS los bloques como SUCIOS
-- ------------------------------------------------------------------
-- Llenamos y ensuciamos la Vía 0 (Conjuntos 0 al 3)
LW R1, 0(R0)     -- Fallo. Carga Dir 0 en Conjunto 0, Vía 0.
SW R1, 4(R0)     -- Acierto de escritura. Marca Conjunto 0, Vía 0 como SUCIO.

LW R1, 16(R0)    -- Fallo. Carga Dir 16 en Conjunto 1, Vía 0.
SW R1, 20(R0)    -- Acierto de escritura. Marca Conjunto 1, Vía 0 como SUCIO.

LW R1, 32(R0)    -- Fallo. Carga Dir 32 en Conjunto 2, Vía 0.
SW R1, 36(R0)    -- Acierto de escritura. Marca Conjunto 2, Vía 0 como SUCIO.

LW R1, 48(R0)    -- Fallo. Carga Dir 48 en Conjunto 3, Vía 0.
SW R1, 52(R0)    -- Acierto de escritura. Marca Conjunto 3, Vía 0 como SUCIO.

-- Llenamos y ensuciamos la Vía 1 (Conjuntos 0 al 3)
LW R1, 64(R0)    -- Fallo. Carga Dir 64 en Conjunto 0, Vía 1.
SW R1, 68(R0)    -- Acierto de escritura. Marca Conjunto 0, Vía 1 como SUCIO.

LW R1, 80(R0)    -- Fallo. Carga Dir 80 en Conjunto 1, Vía 1.
SW R1, 84(R0)    -- Acierto de escritura. Marca Conjunto 1, Vía 1 como SUCIO.

LW R1, 96(R0)    -- Fallo. Carga Dir 96 en Conjunto 2, Vía 1.
SW R1, 100(R0)    -- Acierto de escritura. Marca Conjunto 2, Vía 1 como SUCIO.

LW R1, 112(R0)   -- Fallo. Carga Dir 112 en Conjunto 3, Vía 1.
SW R1, 116(R0)   -- Acierto de escritura. Marca Conjunto 3, Vía 1 como SUCIO.


-- ------------------------------------------------------------------
-- FASE 2: Forzar "Read Miss Dirty" en la Vía 0 de todos los conjuntos
-- ------------------------------------------------------------------
-- La caché está llena. Por la política FIFO, los bloques de la Vía 0
-- son los más antiguos. Al traer nuevas direcciones, se expulsarán estos
-- bloques de la Vía 0. Al estar sucios, forzarán una operación Copy-Back.

LW R2, 128(R0)   -- Read Miss Dirty (Set 0). Expulsa Vía 0 (Dir 0). ¡Copy-Back!
LW R2, 144(R0)   -- Read Miss Dirty (Set 1). Expulsa Vía 0 (Dir 16). ¡Copy-Back!
LW R2, 160(R0)   -- Read Miss Dirty (Set 2). Expulsa Vía 0 (Dir 32). ¡Copy-Back!
LW R2, 176(R0)   -- Read Miss Dirty (Set 3). Expulsa Vía 0 (Dir 48). ¡Copy-Back!


-- ------------------------------------------------------------------
-- FASE 3: Forzar "Read Miss Dirty" en la Vía 1 de todos los conjuntos
-- ------------------------------------------------------------------
-- Los bloques de la Vía 0 ahora son nuevos y están "limpios".
-- Los bloques más antiguos ahora mismo son los de la Vía 1 (cargados
-- en la Fase 1). Traemos 4 nuevas direcciones para expulsarlos.

LW R3, 192(R0)   -- Read Miss Dirty (Set 0). Expulsa Vía 1 (Dir 64). ¡Copy-Back!
LW R3, 208(R0)   -- Read Miss Dirty (Set 1). Expulsa Vía 1 (Dir 80). ¡Copy-Back!
LW R3, 224(R0)   -- Read Miss Dirty (Set 2). Expulsa Vía 1 (Dir 96). ¡Copy-Back!
LW R3, 240(R0)   -- Read Miss Dirty (Set 3). Expulsa Vía 1 (Dir 112). ¡Copy-Back!