# TUMuch
Simple implementation of 32 bit processor with RV32I Instruction Set. 

## Gruppenmitglieder
Severin Hanf,
Max Biricz,
Jeongjoo Lim,
Josip Pepić

## Functional Model:
### Memory Initialisation with Assembly Code:

- Mnemonics must ALWAYS be at least 5 characters long including whitespace. (Invalid: `ADD`, Valid: `ADD  `)

- Registers must always start with 'x' or 'X' followed by one or two digits (e.g. X7, X01, X15 etc). However, in case of using a single digit (e.g. X1, X2 etc) a whitespace must always follow the digit. I.e., always leave a whitespace after the last digit of a single-digit register, e.g. `X1 `.

- Immediates must always start with '#'. There are four operations that require a 20-bit immediate (LUI, AUIPC, JAL, VAL); all other operations use 12-bit immediates if applicable. (Examples: `ADDI X01 X02 #ABC`, `LUI X3 #ABCDE`)

- To specify a memory address to save certain instructions/data, start with @ followed by 0x and the address in hexadecimal format. The address must be divisible by 4 (Example: `@0xF000`). If not specified, the instructions/data are stored beginning with `0x0000`.

- To store data, use the mnemonic VAL followed by a 32-bit immediate represented as 8 hexadecimal digits (Example: `VAL #12345678`).

- Important: Do not use empty lines in the assembly code. Otherwise, the parser may select random characters and interpret them as mnemonics, resulting in an Assertion Error.

- For supported mnemonics, refer to `RISCV_mnemonic_pack.vhd`.

- To terminate the program, always use `STOP  ` (IMPORTANT: two trailing whitespaces after `STOP`).

- The instruction `NOP   ` must be written exactly as shown, with three trailing whitespaces.

- Sample testbenches are available at `./TUMuch.rsc/`

### Memory Initialisation with Bits

- uncomment `mem := init_memory_bin(BinFile);` in `RISCV.vhd`
- binary Inputs in bin_input.txt (fill each line with 32 Bits without following whitespaces)
- comment `mem := init_memory_asm(AsmFile);`

## RTL Model (Controller Based): 
- Top Down Partitioning of Contoller und Datapath
- Memory initialisation with bits
- Rough architecture diagram:

![structure](https://github.com/user-attachments/assets/552d26e2-ef37-41f1-a980-cc91ed0603c4)
<img width="437" height="470" alt="image" src="https://github.com/user-attachments/assets/dd2175ae-4ba3-4ab4-84bc-01a625347d7e" />
