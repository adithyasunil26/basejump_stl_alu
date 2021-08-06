`define WIDTH_P 4

module test
#(
  parameter width_p = `WIDTH_P,
  parameter harden_p = 0,
  parameter cycle_time_p = 10,
  parameter reset_cycles_lo_p=-1,
  parameter reset_cycles_hi_p=-1
  );

  wire clk;
  wire reset;

  bsg_nonsynth_clock_gen #(  .cycle_time_p(cycle_time_p)
                          )  clock_gen
                          (  .o(clk)
                          );

  bsg_nonsynth_reset_gen #(  .num_clocks_p     (1)
                           , .reset_cycles_lo_p(reset_cycles_lo_p)
                           , .reset_cycles_hi_p(reset_cycles_hi_p)
                          )  reset_gen
                          (  .clk_i        (clk) 
                           , .async_reset_o(reset)
                          );

  logic [1:0] sel_i;
  logic [width_p-1:0] a_i;
  logic [width_p-1:0] b_i;
  logic [width_p-1:0] res_o;

  logic finish_r;

  initial begin
  	sel_i = 2'b00;
		a_i=`WIDTH_P'd1;
		b_i=`WIDTH_P'd3;
	end
	
  always_ff @(posedge clk)
  begin
    if(reset)
      begin
        a_i <= width_p'(1'b0);
        b_i <= width_p'(1'b0);
        finish_r   <= 1'b0;
      end
    else
      begin  
        sel_i <= sel_i+1;
      end
    
    $display("sel_i:%b a_i: %b, b_i: %b, res_o: %b\n", sel_i, a_i, b_i, res_o); 
     
    if(&sel_i)
      finish_r <= 1'b1;
    if(finish_r)
      begin
        $display("===========================================================\n");
        $finish;
      end
  end

  alu #(
    .width_p(width_p)
  ) dut (
    .sel_i(sel_i),
    .a_i(a_i),
    .b_i(b_i),
    .res_o(res_o)
  );

endmodule
