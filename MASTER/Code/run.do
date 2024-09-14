vlib work 
vlog -f sourcefile.txt
vsim -voptargs=+accs work.MasterAHB_tb
add wave *
run -all