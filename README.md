# TUMuch
Entwurf digitaler Schaltungen mit VHDL und SystemC


# Gruppenmitglieder
Severin Hanf
Max Biricz

# Benennungen Dateien:

• name.vhd: VHDL-Beschreibung der Schaltung name; enthält die Entity und die
zugehörige Architecture (sinnvoll: Entity-Name := name).
(Entity und Architecture können auch in verschiedenen Dateien abgelegt
werden.)
• name_tb.vhd: VHDL-Beschreibung der Testumgebung (VHDL-Testbench) für die
Schaltung name (der Inhalt der Testbenches wird später erklärt).
• name_sim.tcl: Skript, welches eine projektspezifische Konfiguration erstellt und somit
die Simulation der Schaltung name erleichtert (wird später genauer
erläutert); keine VHDL-Beschreibung, sondern spezifisch für Vivado!
• name.xdc: Xilinx Design Constraint Datei enthält Constraints (wie die
Taktfrequenz und Pin Zuweisungen) für die Synthese; keine VHDLBeschreibung, sondern spezifisch für Vivado!
