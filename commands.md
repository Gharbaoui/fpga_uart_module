## Synthesis

### interactively 
read_verilog verilog_file.v
synth_gowin -top top_module
#### to see statisitcs what commpents are going to be used
stat

### analysis
1. we get intermediate representation *.il file
you can see it using write_ilang new_file_name.il
```
write_ilang my_design_proc.il
```


visualize
```
proc; opt; show
```


### Key Points
- netlist: describe logical gates and their interconnections