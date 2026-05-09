LW R5, 0(R0)     -- R5 = X"10000000" (Read Miss Clean)
LW R2, 4(R0)     -- R2 = X"00000055" (Read Hit)
LW R3, 8(R0)     -- R3 = X"000000AA" (Read Hit)
LW R4, 12(R0)    -- R4 = X"000000FF" (Read Hit)


SW R2, 0(R5)     -- Escribe X"55" en la palabra 0 de la Scratch (@ X"10000000") Este dato sera modificado si o si porque IO_Master escribe ZZZs en la primera direccion de la Scratch
SW R3, 4(R5)     -- Escribe X"AA" en la palabra 1 de la Scratch (@ X"10000004")
SW R4, 8(R5)     -- Escribe X"FF" en la palabra 2 de la Scratch (@ X"10000008")


LW R1, 0(R5)     -- Lee de Scratch. R1 -> Seguramente ZZZs
LW R1, 4(R5)     -- Lee de Scratch. R1 -> X"000000AA"
LW R1, 8(R5)     -- Lee de Scratch. R1 -> X"000000FF"