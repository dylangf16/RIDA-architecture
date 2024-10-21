transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU/Memory {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Memory/drom.v}
vlog -vlog01compat -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU/Memory {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Memory/dram.v}
vlog -vlog01compat -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/instrROM.v}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/ALU.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/ALU_Decoder.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Control_Unit.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Data_Memory.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Decode_Cycle.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Execute_Cycle.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Fetch_Cycle.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Hazard_Unit.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Instruction_Memory.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Main_Decoder.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Memory_Cycle.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Mux.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Mux_3_by_1.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/PC_Module.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/PC_Adder.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Register_File.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Sign_Extend.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/Writeback_Cycle.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/cpu.sv}

vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture/CPU {/home/ale/Documents/GitHub/RIDA-architecture/CPU/cpu_tb2.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  cpu_tb2

add wave *
view structure
view signals
run -all
