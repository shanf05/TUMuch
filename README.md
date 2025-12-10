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

![structure](https://github.com/user-attachments/assets/552d26e2-ef37-41f1-a980-cc91ed0603c4)
<img width="437" height="470" alt="image" src="https://github.com/user-attachments/assets/ff53573c-6d10-41d6-94f3-bdd71b21644c" />
