transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {/home/isa/intelFPGA_lite/22.1std/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {/home/isa/intelFPGA_lite/22.1std/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {/home/isa/intelFPGA_lite/22.1std/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {/home/isa/intelFPGA_lite/22.1std/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {/home/isa/intelFPGA_lite/22.1std/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cyclonev_ver
vmap cyclonev_ver ./verilog_libs/cyclonev_ver
vlog -vlog01compat -work cyclonev_ver {/home/isa/intelFPGA_lite/22.1std/quartus/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {/home/isa/intelFPGA_lite/22.1std/quartus/eda/sim_lib/mentor/cyclonev_hmi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {/home/isa/intelFPGA_lite/22.1std/quartus/eda/sim_lib/cyclonev_atoms.v}

vlib verilog_libs/cyclonev_hssi_ver
vmap cyclonev_hssi_ver ./verilog_libs/cyclonev_hssi_ver
vlog -vlog01compat -work cyclonev_hssi_ver {/home/isa/intelFPGA_lite/22.1std/quartus/eda/sim_lib/mentor/cyclonev_hssi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_hssi_ver {/home/isa/intelFPGA_lite/22.1std/quartus/eda/sim_lib/cyclonev_hssi_atoms.v}

vlib verilog_libs/cyclonev_pcie_hip_ver
vmap cyclonev_pcie_hip_ver ./verilog_libs/cyclonev_pcie_hip_ver
vlog -vlog01compat -work cyclonev_pcie_hip_ver {/home/isa/intelFPGA_lite/22.1std/quartus/eda/sim_lib/mentor/cyclonev_pcie_hip_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_pcie_hip_ver {/home/isa/intelFPGA_lite/22.1std/quartus/eda/sim_lib/cyclonev_pcie_hip_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU/Memory {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Memory/drom.v}
vlog -vlog01compat -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU/Memory {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Memory/dram.v}
vlog -vlog01compat -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/instrROM.v}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/ALU.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/ALU_Decoder.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Control_Unit.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Data_Memory.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Decode_Cycle.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Execute_Cycle.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Fetch_Cycle.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Hazard_Unit.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Instruction_Memory.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Main_Decoder.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Memory_Cycle.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Mux.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Mux_3_by_1.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/PC_Module.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/PC_Adder.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Register_File.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Sign_Extend.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Writeback_Cycle.sv}
vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/cpu.sv}

vlog -sv -work work +incdir+/home/isa/Documents/GitHub/RIDA-architecture/CPU {/home/isa/Documents/GitHub/RIDA-architecture/CPU/Memory_Cycle_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  Memory_Cycle_tb

add wave *
view structure
view signals
run -all
