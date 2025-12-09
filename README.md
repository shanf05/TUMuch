# TUMuch
Entwurf digitaler Schaltungen mit VHDL und SystemC

# Gruppenmitglieder
Severin Hanf,
Max Biricz,
Jeongjoo Lim,
Josip Pepić

# Assembly Syntax für den Parser:

- Mnemonics müssen IMMER mind. 5 ZEICHEN (inkl. Whitespace) lang sein (ungültig: "ADD") (gültig: "ADD  ")
- Register immer starten mit 'x' oder 'X' gefolgt von ZWEI Ziffern. Beispiel: X07 X15 etc. (Update: Parser unterstützt jetzt auch X1 X2 -> Allerdings: Es muss immer ein Whitespace hinter der Ziffer des einstelligen Registers sein -> Häufiger Fehler ist Vergessen von Whitespace bei Rd. Daher immer ein Whitespace nach letzter Ziffer von einstelligem Register z.B "X1 " übrig lassen) 
- Immediates immer starten mit '#'. Es gibt 4 Operationen die einen 20-Bit Immediate benötigen (LUI, AUIPC, JAL, VAL), alle anderen verwenden 12 Bit Immediates -> (1) ADDI  X01 X02 #ABC  (2) LUI X3 #ABCDE
- Zur Festlegung der Adresse (analog zu Folien) im Speicher immer mit @ anfangen und 0x gefolgt von der Adresse in Hex-Form angeben, welche durch 4 ohne Rest teilbar sein muss -> Bsp.: @0xF000
- Wichtig: Keine LEERE ZEILE im Assembly Code verwenden -> Sonst: Parser wählt random Zeichen und diese werden als mnemonic gedeutet -> Assertion Error
- Zum Speichern von Daten: Verwende Mnemonic VAL gefolgt von 32 Bit Immediate in Form von 8 Ziffern Hex Code-> Bsp.: VAL  #12345678 (DIESES KOMMANDO MUSS NACH STOP STEHEN!)
- Für die Mnemonics nur RVI32 supportet -> siehe RISCV_mnemonic_pack.vhd
- Zum Beenden des Programms immer "STOP  " verwenden, WICHTIG: hier 2 Whitespace hiner STOP setzen
- der Befehl "NOP   " muss wie geschrieben mit 3 folgenden Leerzeichen geschriebnen werden. 

# Alternative Speicher initialisierung über Bit-Code

- auskommentieren von "mem := init_memory_bin(BinFile);" in RISCV.vhd
- binary Inputs in bin_input.txt (eine Zeile mit 32 Bits füllen, kein Leerzeichen danach)
- kommentieren von "mem := init_memory_asm(AsmFile);"

# RTL Model (Controller Based): 
- Top Down Partitioning zwischen Contoller und Datapath
- grobe Skizze:
![structure](https://github.com/user-attachments/assets/351e29aa-9efa-4d3d-a382-45b173b71f5b)
<img width="402" height="305" alt="image" src="https://github.com/user-attachments/assets/6a6b152f-601e-4eda-8bd8-80c591984a4b" />
