# TUMuch
Entwurf digitaler Schaltungen mit VHDL und SystemC

# Gruppenmitglieder
Severin Hanf,
Max Biricz,
Jeongjoo Lim,
Josip Pepić

# Assembly Syntax für den Parser:

- Mnemonics müssen IMMER mind. 5 ZEICHEN (inkl. Whitespace) lang sein (ungültig: ADD) (gültig: ADD  )
- Register immer starten mit 'x' oder 'X' gefolgt von ZWEI Ziffern. Beispiel: X07 X15 etc. (Update: Parser unterstützt jetzt auch X1 X2 -> Allerdings: Es muss immer ein Whitespace hinter der Ziffer des einstelligen Registers sein -> Häufiger Fehler ist Vergessen von Whitespace bei Rd. Daher immer ein Whitespace nach letzter Ziffer von einstelligem Register z.B "X1 " übrig lassen) 
- Immediates immer starten mit '#'. Es gibt 4 Operationen die einen 20-Bit Immediate benötigen (LUI, AUIPC, JAL, VAL), alle anderen verwenden 12 Bit Immediates -> (1) ADDI  X01 X02 #ABC  (2) LUI X3 #ABCDE
- Zur Festlegung des Index (analog zu Folien) im Speicher immer mit @ anfangen und 0x gefolgt von der Adresse in Hex-Form angeben, welche durch 4 ohne Rest teilbar sein muss -> Bsp.: @0xF000
-Wichtig: Keine LEERE ZEILE im Assembly Code verwenden -> Sonst: Parser wählt random Zeichen und diese werden als mnemonic gedeutet -> Assertion Error
- Zum Speichern von Daten (NACH STOP): Verwende Mnemonic VAL gefolgt von 32 Bit Immediate in Form von 8 Ziffern Hex Code-> Bsp.: VAL  #12345678
- Für die Mnemonics nur RVI32 supportet -> siehe RISCV_mnemonic_pack.vhd
- Zum Beenden des Programms immer "STOP  " verwenden, WICHTIG: 2 Whitespace hiner STOP setzen

# Alternative Speicher initialisierung über Bit-Code

- coming soon...
