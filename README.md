## ALU core for testing BaseJump STL integration with FuseSoC


### Adding core library to FuseSoC
```bash
fusesoc library add alu https://github.com/adithyasunil26/basejump_stl_alu
```

Note: BaseJumpSTL core library must be present in order to run this core. Use following command to add BaseJump cores.
```bash
fusesoc library add basejump https://github.com/adithyasunil26/basejump_stl_cores
```

Note: bsg_fakeram core library must be present in order to use the generator. Use following command to add to add bsg_fakeram geenrator core.
```bash
fusesoc library add bsg_fakeram https://github.com/adithyasunil26/bsg_fakeram_generator
```

### Running the ALU core
For linting
```bash
fusesoc run --target lint alu
```

For verilator testbench
```bash
fusesoc run --target verilator_tb alu
```

### Running the ALU core with sram

For linting
```bash
fusesoc run --target lint alu_with_ram
```

For verilator testbench
```bash
fusesoc run --target verilator_tb alu_with_ram
```
### To use a custom config file for the fakeram
Before running the fusesoc run commands, open the core file present in your fusesoc_libraries directory which will be created on executing the `lirary add` command and edit the `path_to_cfg` value to match the path to the mentioned file in your file system.

1. Navigate to the core file using:
```bash
cd fusesoc_libraries/alu/alu_with_sram/
pwd
```
2. Copy the output.
3. Open the `alu_with_sram.core` file and change `path_to_cfg` to path of config file you wish to use
4. Return to original directory with 
```bash
cd ../../..
```
Now you can use the core with the commands mentioned above.

