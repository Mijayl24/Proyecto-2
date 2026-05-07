#!/usr/bin/env python3
"""
============================================================
  AOC2 MIPS Assembler — Universidad de Zaragoza, 2026
============================================================
Codifica instrucciones del MIPS segmentado del Proyecto 1.

FORMATO DE INSTRUCCIONES
─────────────────────────────────────────────────────────────
Bits 31-26 : opcode  (6 bits)
Bits 25-21 : Rs      (5 bits)
Bits 20-16 : Rt      (5 bits)
Bits 15-11 : Rd      (5 bits)   ← solo en tipo-R (ARIT)
Bits 15-0  : imm     (16 bits)  ← solo en tipo-I (LW/SW/BEQ/JAL/RET)
Bits  2-0  : funct   (3 bits)   ← solo en tipo-R

TABLA DE OPCODES
─────────────────────────────────────────────────────────────
NOP     000000   RTE     001000
ARIT    000001   JAL     000101  ⚠ ver nota abajo
LW      000010   RET     000110
SW      000011   MAC     001010  (MAC se codifica como ARIT con funct)
BEQ     000100

FUNCIONES ALU (bits 2-0 dentro de ARIT)
─────────────────────────────────────────────────────────────
ADD=000  SUB=001  AND=010  OR=011  MAC=100  MAC_INI=101

SINTAXIS DEL ENSAMBLADOR
─────────────────────────────────────────────────────────────
NOP
ADD   Rd, Rs, Rt           -- Rd = Rs + Rt
SUB   Rd, Rs, Rt
AND   Rd, Rs, Rt
OR    Rd, Rs, Rt
MAC   Rd, Rs, Rt           -- Rd = ACC + suma_productos(Rs,Rt)
MAC_INI Rd, Rs, Rt         -- igual pero resetea ACC antes

LW    Rt, imm(Rs)          -- Rt = MEM[Rs + imm]
SW    Rt, imm(Rs)          -- MEM[Rs + imm] = Rt

BEQ   Rs, Rt, label_o_num -- salta si Rs==Rt  (offset PC-relativo en palabras)

JAL   Rd, label_o_num     -- ⚠ ASUNCIÓN: Rd en campo Rt (bits 20-16), Rs=00000
                           --   Rd = PC+4 ; PC = PC+4 + offset*4
                           --   Ajusta si tu UC usa otro campo para Rd

RET   Rs                  -- PC = Rs  (dirección de retorno almacenada en Rs)
RTE                        -- Retorno de excepción (salta a Exception_LR)

ETIQUETAS
─────────────────────────────────────────────────────────────
  etiqueta:  instrucción     ← la etiqueta se coloca antes de la instrucción
  BEQ R0, R0, loop          ← referencia hacia atrás
  BEQ R0, R0, fin           ← referencia hacia delante (2 pasadas)

COMENTARIOS
─────────────────────────────────────────────────────────────
  -- comentario al estilo VHDL
  # comentario al estilo Python
  // comentario al estilo C

USO
─────────────────────────────────────────────────────────────
  python3 aoc2_assembler.py programa.asm
  python3 aoc2_assembler.py -           ← lee de stdin
  python3 aoc2_assembler.py programa.asm --vhdl-ram  ← salida lista para pegar en VHDL
  python3 aoc2_assembler.py programa.asm --word N     ← word de inicio en la RAM (por defecto 4)

VERIFICACIÓN CRUZADA (instrucciones conocidas)
─────────────────────────────────────────────────────────────
  LW  R1, 0(R0)     → 0x08010000  ✓
  SW  R3, 0(R0)     → 0x0C030000  ✓
  ADD R3, R1, R2    → 0x04221800  ✓
  BEQ R1, R1, 3     → 0x10210003  ✓
  BEQ R0, R0, -1    → 0x1000FFFF  ✓
  MAC_INI R10,R1,R5 → 0x04255005  ✓
  MAC R10, R2, R6   → 0x04465004  ✓
  RTE               → 0x20000000  ✓
"""

import sys
import re
import argparse

# ── Opcodes ──────────────────────────────────────────────────
OPCODES: dict[str, int] = {
    "NOP": 0b000000,
    "ARIT": 0b000001,
    "LW": 0b000010,
    "SW": 0b000011,
    "BEQ": 0b000100,
    "JAL": 0b000101,
    "RET": 0b000110,
    "RTE": 0b001000,
}

# ── Funciones ALU (bits 2-0) ──────────────────────────────────
FUNCTS: dict[str, int] = {
    "ADD": 0b000,
    "SUB": 0b001,
    "AND": 0b010,
    "OR": 0b011,
    "MAC": 0b100,
    "MAC_INI": 0b101,
}

# Instrucciones que son simplemente ARIT con un funct concreto
ARIT_MNEMONICS = set(FUNCTS.keys())

# ── Helpers de parseo ─────────────────────────────────────────

def parse_reg(token: str) -> int:
    """R0..R31 → 0..31"""
    s = token.strip().rstrip(",").upper()
    if re.fullmatch(r"R(\d{1,2})", s):
        n = int(s[1:])
        if 0 <= n <= 31:
            return n
    raise ValueError(f"Registro inválido: '{token}'")


def parse_imm(token: str, labels: dict[str, int], pc: int,
              is_branch: bool = False) -> int:
    """Número (dec/hex) o etiqueta → entero.
    Si is_branch=True devuelve el offset en palabras relativo a PC+4."""
    s = token.strip()
    if s in labels:
        target = labels[s]
        if is_branch:
            offset = (target - (pc + 4)) // 4
            return offset
        return target
    # Soporte 0x… y decimal con signo
    return int(s, 0)


def parse_mem(token: str) -> tuple[int, int]:
    """'imm(Rs)' → (imm, reg_num)"""
    s = token.strip()
    m = re.fullmatch(r"(-?(?:0[xX][\da-fA-F]+|\d+))\(([Rr]\d{1,2})\)", s)
    if not m:
        raise ValueError(f"Operando de memoria inválido: '{token}'")
    return int(m.group(1), 0), parse_reg(m.group(2))


# ── Codificadores ─────────────────────────────────────────────

def r_type(opc: int, rs: int, rt: int, rd: int, fn: int) -> int:
    return ((opc & 0x3F) << 26 | (rs & 0x1F) << 21
            | (rt & 0x1F) << 16 | (rd & 0x1F) << 11 | (fn & 0x7))


def i_type(opc: int, rs: int, rt: int, imm: int) -> int:
    return ((opc & 0x3F) << 26 | (rs & 0x1F) << 21
            | (rt & 0x1F) << 16 | (imm & 0xFFFF))


# ── Ensamblado principal (2 pasadas) ──────────────────────────

def assemble(source: str):
    """
    Devuelve:
      instructions : list[ (byte_addr, word, orig_line, error_str|None) ]
      labels       : dict[str, int]   (byte_addr de cada etiqueta)
    """
    raw_lines = source.splitlines()

    # ── Pasada 1: recoger etiquetas, limpiar líneas ───────────
    labels: dict[str, int] = {}
    stmts: list[tuple[int, str]] = []   # (byte_addr, texto)
    pc = 0

    for raw in raw_lines:
        # Quitar comentarios
        line = re.sub(r"(--|#|//).*", "", raw).strip()
        if not line:
            continue

        # Puede haber varias etiquetas en la misma línea: "label1: label2: instr"
        while ":" in line:
            colon = line.index(":")
            candidate = line[:colon].strip()
            if re.fullmatch(r"[A-Za-z_]\w*", candidate):
                labels[candidate] = pc
                line = line[colon + 1:].strip()
            else:
                break  # ':' es parte de un literal u otra cosa

        if not line:
            continue  # Línea solo con etiquetas

        stmts.append((pc, line))
        pc += 4

    # ── Pasada 2: codificar instrucciones ─────────────────────
    instructions = []
    for pc, line in stmts:
        # Dividir tokens (espacios, comas)
        toks = [t for t in re.split(r"[\s,]+", line) if t]
        mn = toks[0].upper()
        err = None
        word = 0

        try:
            # ── NOP ──────────────────────────────────────────
            if mn == "NOP":
                word = 0

            # ── Instrucciones tipo-R (ALU) ────────────────────
            elif mn in ARIT_MNEMONICS:
                if len(toks) < 4:
                    raise ValueError(f"Se esperan 3 registros: {mn} Rd, Rs, Rt")
                rd = parse_reg(toks[1])
                rs = parse_reg(toks[2])
                rt = parse_reg(toks[3])
                word = r_type(OPCODES["ARIT"], rs, rt, rd, FUNCTS[mn])

            # ── LW ───────────────────────────────────────────
            elif mn == "LW":
                # LW Rt, imm(Rs)
                rt = parse_reg(toks[1])
                imm, rs = parse_mem(toks[2])
                word = i_type(OPCODES["LW"], rs, rt, imm)

            # ── SW ───────────────────────────────────────────
            elif mn == "SW":
                # SW Rt, imm(Rs)
                rt = parse_reg(toks[1])
                imm, rs = parse_mem(toks[2])
                word = i_type(OPCODES["SW"], rs, rt, imm)

            # ── BEQ ──────────────────────────────────────────
            elif mn == "BEQ":
                rs = parse_reg(toks[1])
                rt = parse_reg(toks[2])
                imm = parse_imm(toks[3], labels, pc, is_branch=True)
                word = i_type(OPCODES["BEQ"], rs, rt, imm)

            # ── JAL ──────────────────────────────────────────
            # ⚠ ASUNCIÓN: Rd (link register) se codifica en el campo Rt
            # (bits 20-16), Rs = 00000. El salto usa offset PC-relativo igual
            # que BEQ. Ajusta si tu UC lee Rd del campo Rd (bits 15-11).
            elif mn == "JAL":
                rd = parse_reg(toks[1])
                imm = parse_imm(toks[2], labels, pc, is_branch=True)
                word = i_type(OPCODES["JAL"], 0, rd, imm)

            # ── RET ──────────────────────────────────────────
            # RET Rs  → PC = BusA = Rs
            elif mn == "RET":
                rs = parse_reg(toks[1])
                word = i_type(OPCODES["RET"], rs, 0, 0)

            # ── RTE ──────────────────────────────────────────
            elif mn == "RTE":
                word = OPCODES["RTE"] << 26   # = 0x20000000

            else:
                raise ValueError(f"Mnemónico desconocido: '{mn}'")

        except Exception as exc:
            err = str(exc)
            word = 0xDEADBEEF  # marcador de error visible

        instructions.append((pc, word, line, err))

    return instructions, labels


# ── Desensamblador sencillo (para verificación) ───────────────

def disassemble(word: int) -> str:
    opc = (word >> 26) & 0x3F
    rs  = (word >> 21) & 0x1F
    rt  = (word >> 16) & 0x1F
    rd  = (word >> 11) & 0x1F
    imm = word & 0xFFFF
    imm_s = imm if imm < 0x8000 else imm - 0x10000   # signo
    fn  = word & 0x7

    if opc == 0x00:
        return "NOP"
    elif opc == 0x01:  # ARIT
        fn_name = {v: k for k, v in FUNCTS.items()}.get(fn, f"fn={fn}")
        return f"{fn_name} R{rd}, R{rs}, R{rt}"
    elif opc == 0x02:
        return f"LW  R{rt}, {imm_s}(R{rs})"
    elif opc == 0x03:
        return f"SW  R{rt}, {imm_s}(R{rs})"
    elif opc == 0x04:
        return f"BEQ R{rs}, R{rt}, {imm_s}"
    elif opc == 0x05:
        return f"JAL R{rt}, {imm_s}  [PC+4+{imm_s*4}]"
    elif opc == 0x06:
        return f"RET R{rs}"
    elif opc == 0x08:
        return "RTE"
    else:
        return f"??? (opc=0b{opc:06b})"


# ── Formateo de salida ────────────────────────────────────────

def format_plain(instructions, labels, start_word: int = 4):
    """Tabla legible: word_addr | hex | disasm | línea original"""
    # Mapa etiqueta → word_addr
    lab_by_addr = {v: k for k, v in labels.items()}

    lines = []
    lines.append("=" * 72)
    lines.append(f"  {'Word':>5}  {'Addr (hex)':>10}  {'Código hex':>10}  {'Disasm':<30}  {'Fuente'}")
    lines.append("=" * 72)
    for byte_addr, word, orig, err in instructions:
        w_idx = byte_addr // 4 + start_word
        label_str = lab_by_addr.get(byte_addr, "")
        label_pfx = f"{label_str}:" if label_str else ""
        dasm = disassemble(word) if err is None else f"ERROR: {err}"
        hex_addr = f"0x{byte_addr + start_word*4:08X}"
        lines.append(
            f"  {w_idx:>5}  {hex_addr:>10}  0x{word:08X}  {dasm:<30}  {label_pfx}{orig}"
        )
    lines.append("=" * 72)
    return "\n".join(lines)


def format_vhdl_ram(instructions, start_word: int = 4, total_words: int = 128):
    """
    Genera el bloque signal RAM : RamType := (...); 
    listo para pegar en el .vhd de memoria de instrucciones.
    Las instrucciones se colocan a partir de start_word.
    El resto se rellena con X"00000000".
    """
    # Construir array completo
    ram = [0x00000000] * total_words
    for byte_addr, word, orig, err in instructions:
        idx = start_word + byte_addr // 4
        if 0 <= idx < total_words:
            ram[idx] = word if err is None else 0xDEADBEEF
        else:
            pass  # fuera de rango, se ignora

    lines = []
    lines.append("signal RAM : RamType := (")
    for row in range(0, total_words, 8):
        chunk = ram[row:row + 8]
        hex_vals = ", ".join(f'X"{v:08X}"' for v in chunk)
        comment = f"--word {row},..."
        comma = "," if row + 8 < total_words else ""
        lines.append(f"\t{hex_vals}{comma} {comment}")
    lines.append(");")
    return "\n".join(lines)


# ── Main ──────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="AOC2 MIPS Assembler — Universidad de Zaragoza"
    )
    parser.add_argument(
        "source",
        help="Fichero .asm (o '-' para leer de stdin)",
    )
    parser.add_argument(
        "--vhdl-ram",
        action="store_true",
        help="Genera salida en formato 'signal RAM : RamType := (...);'",
    )
    parser.add_argument(
        "--word",
        type=int,
        default=4,
        metavar="N",
        help="Word de inicio en la RAM (por defecto 4, después del vector de excepciones)",
    )
    parser.add_argument(
        "--ram-size",
        type=int,
        default=128,
        metavar="N",
        help="Tamaño total de la RAM en palabras (por defecto 128)",
    )
    args = parser.parse_args()

    # Leer fuente
    if args.source == "-":
        source = sys.stdin.read()
    else:
        with open(args.source, "r", encoding="utf-8") as f:
            source = f.read()

    instructions, labels = assemble(source)

    # Mostrar tabla de ensamblado
    print(format_plain(instructions, labels, start_word=args.word))

    # Mostrar etiquetas resueltas
    if labels:
        print("\nEtiquetas:")
        for name, addr in labels.items():
            print(f"  {name:20s} → byte 0x{addr:04X}  (word {args.word + addr//4})")

    # Errores
    errors = [(pc, e, ln) for pc, _, ln, e in instructions if e]
    if errors:
        print(f"\n⚠  {len(errors)} error(es) encontrado(s):")
        for pc, e, ln in errors:
            print(f"   byte 0x{pc:04X}: {e}")
            print(f"            → '{ln}'")

    # Salida VHDL RAM
    if args.vhdl_ram:
        print("\n── VHDL RAM (pegar en memoriaRAM_I) " + "─" * 36)
        print(format_vhdl_ram(instructions, start_word=args.word,
                               total_words=args.ram_size))


if __name__ == "__main__":
    main()