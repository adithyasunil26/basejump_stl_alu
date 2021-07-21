// Adithya 7/18/2021
//
// ALU
//
// This is a simple N-bit ALU with the following functionlities.
// Operation      Control signal
//    AND           00     
//    XOR           01
//    NAND          10
//    ADD           11
//

`include "bsg_defines.v"

module alu #(
    `BSG_INV_PARAM(width_p)
  )
  (
    input [1:0] sel_i,
    input [width_p-1:0] a_i,
    input [width_p-1:0] b_i,
    output logic [width_p-1:0] res_o
  );

  logic [width_p-1:0] res_add,res_and, res_xor, res_nand;
  logic [3:0][width_p-1:0] data_i;
  wire c; 

  assign data_i = {res_add, res_nand, res_xor, res_and};


  bsg_mux #(
    .width_p(width_p),
    .els_p(4)
  )
  mux_n (
    .data_i(data_i),
    .sel_i(sel_i),
    .data_o(res_o)
  );


  bsg_adder_ripple_carry #(
      .width_p(width_p)
    )
    add_n (
      .a_i(a_i),
      .b_i(b_i),
      .s_o(res_add),
      .c_o(c)  
  );

  bsg_and #(
      .width_p(width_p)
    )
    and_n (
      .a_i(a_i),
      .b_i(b_i),
      .o(res_and)
  ); 

  bsg_xor #(
      .width_p(width_p)
    )
    xor_n (
      .a_i(a_i),
      .b_i(b_i),
      .o(res_xor)
  ); 

  bsg_nand #(
      .width_p(width_p)
    )
    nand_n (
      .a_i(a_i),
      .b_i(b_i),
      .o(res_nand)
  );

endmodule
