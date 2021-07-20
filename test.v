`define WIDTH_P 4

module test_bsg
#(
  parameter width_p = `WIDTH_P,
  parameter harden_p = 0,
  parameter cycle_time_p = 10,
  parameter reset_cycles_lo_p=-1,
  parameter reset_cycles_hi_p=-1
  );

  wire clk;
  wire reset;

  `ifdef VERILATOR
    bsg_nonsynth_dpi_clock_gen
  `else
    bsg_nonsynth_clock_gen
  `endif
   #(.cycle_time_p(cycle_time_p))
   clock_gen
    (.o(clk));

  bsg_nonsynth_reset_gen #(  .num_clocks_p     (1)
                           , .reset_cycles_lo_p(reset_cycles_lo_p)
                           , .reset_cycles_hi_p(reset_cycles_hi_p)
                          )  reset_gen
                          (  .clk_i        (clk) 
                           , .async_reset_o(reset)
                          );

  logic [1:0] control;
  logic [width_p-1:0] a;
  logic [width_p-1:0] b;
  logic [width_p-1:0] res;
  logic ov;

  logic finish_r;

  initial begin
  	control = 2'b00;
		a=`WIDTH_P'd1;
		b=`WIDTH_P'd3;
	end
	
  always_ff @(posedge clk)
  begin
    if(reset)
      begin
        a <= width_p'(1'b0);
        b <= width_p'(1'b0);
        finish_r   <= 1'b0;
      end
    else
      begin  
        control <= control+1;
      end
          
    if(&control)
      finish_r <= 1'b1;
    if(finish_r)
      begin
        $display("===========================================================\n");
        $finish;
      end
    
    $display("control:%b a: %b, b: %b, res: %b, ov: %b, finish_r: %b\n", control, a, b, res, ov, finish_r); 

  end

  bsg_alu #(
    .width_p(width_p)
  ) dut (
    .control(control),
    .a(a),
    .b(b),
    .res(res)
  );

endmodule
