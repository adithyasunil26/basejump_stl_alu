`define WIDTH_P 8

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
  logic r_r;

  logic [width_p-1:0]     rd_out;
  logic [width_p:0]       addr_in;
  logic                   we_in;
  logic [width_p-1:0]     wd_in;
  logic [width_p-1:0]     w_mask_in;
  logic                   clk;
  logic                   ce_in;

  initial begin
  	sel_i = 2'b00;
		a_i = `WIDTH_P'd1;
		b_i = `WIDTH_P'd3;
    ce_in = 0;
    w_mask_in = `WIDTH_P'b1111;
    addr_in = 'd0;
    we_in = 0;
    wd_in = `WIDTH_P'd0;
    r_r=0;
	end
	
  always_ff @(posedge clk)
  begin
    if(reset)
      begin
        a_i <= `WIDTH_P'(1'b0);
        b_i <= `WIDTH_P'(1'b0);
        finish_r   <= 1'b0;
        we_in <= 0;
        ce_in <= 0;
        wd_in <= `WIDTH_P'd0;
      end
    else
      begin 
        if(r_r) 
          begin
            r_r=0;
            addr_in <= addr_in;
          end
        else
          begin
            sel_i <= sel_i+1;
            addr_in <= addr_in+1;
            we_in <= 1;
            wd_in <= res_o;
            ce_in <= 1;
            r_r=1;
          end
      end
    
    $display("sel_i:%b a_i: %b, b_i: %b, res_o: %b\nrd_out:%b addr_in: %b, we_in: %b, wd_in: %b w_mask_in: %b \n", sel_i, a_i, b_i, res_o, rd_out, addr_in, we_in, wd_in, w_mask_in);
     
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

  sram_8x512_1rw ram(
    .clk(clk),
    .rd_out(rd_out),
    .addr_in(addr_in),
    .we_in(we_in),
    .wd_in(wd_in),
    .w_mask_in(w_mask_in),
    .ce_in(ce_in)
  );

endmodule
