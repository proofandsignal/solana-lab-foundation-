#!/usr/bin/env python3
"""Fail CI if a deploy artifact is not an SBF v2 ELF shared object."""
import struct
import sys
from pathlib import Path

def main() -> None:
    if len(sys.argv) < 2:
        raise SystemExit("Usage: validate_sbf_elf.py <program.so> [program.so ...]")
    for filename in sys.argv[1:]:
        data = Path(filename).read_bytes()
        if len(data) < 64 or data[:4] != b"\x7fELF":
            raise SystemExit(f"{filename}: invalid ELF magic/header")
        if data[4] != 2 or data[5] != 1:
            raise SystemExit(f"{filename}: expected 64-bit little-endian ELF")
        machine = struct.unpack_from("<H", data, 18)[0]
        flags = struct.unpack_from("<I", data, 48)[0]
        if machine not in (247, 263):
            raise SystemExit(f"{filename}: unexpected ELF machine {machine:#x}")
        if flags != 2:
            raise SystemExit(f"{filename}: expected SBF v2 flag 0x2, got {flags:#x}")
        print(f"{filename}: valid SBF v2 (machine={machine:#x}, flags={flags:#x})")

if __name__ == "__main__":
    main()
