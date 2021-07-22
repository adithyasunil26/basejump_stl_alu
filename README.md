## ALU core for testing BaseJump STL integration with FuseSoC


### Adding core library to FuseSoC
```bash
fusesoc library add alu https://github.com/adithyasunil26/basejump_stl_alu
```

Note: BaseJumpSTL core library must be present in order to run this core. Use following command to add BaseJump cores.
```bash
fusesoc library add basejump https://github.com/adithyasunil26/basejump_stl_cores
```

### Running the core
For linting
```bash
fusesoc run --target lint alu
```

For verilator testbench
```bash
fusesoc run --target verilator_tb alu
```
