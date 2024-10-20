transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture {/home/ale/Documents/GitHub/RIDA-architecture/instrROM.v}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture {/home/ale/Documents/GitHub/RIDA-architecture/Fetch.sv}
vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture {/home/ale/Documents/GitHub/RIDA-architecture/Instruction_Memory.sv}

vlog -sv -work work +incdir+/home/ale/Documents/GitHub/RIDA-architecture {/home/ale/Documents/GitHub/RIDA-architecture/Fetch_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  Fetch_tb

add wave *
view structure
view signals
run -all
