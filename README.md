# TUMuch
Entwurf digitaler Schaltungen mit VHDL und SystemC

# Gruppenmitglieder
Severin Hanf,
Max Biricz,
Jeongjoo Lim,
Josip Pepić

# Assembly Syntax für den Parser:

- Register immer starten mit 'x' oder 'X' gefolgt von ZWEI Ziffern. Beispiel: X17.
- Immediates immer starten mit '#' gefolgt von 5 Ziffern HexCode. Falls die Instruction nur weniger als 20 Bit Immediate unterstützt, auffüllen mit 0. Beispiel: #123ab
- Für die Mnemonics nur RVI32 supportet -> siehe RISCV_mnemonic_pack.vhd

# Alternative Speicher initialisierung über Bit-Code

- coming soon...
