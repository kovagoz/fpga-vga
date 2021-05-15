`include "sync.v"
`timescale 1ns/1ns
`define STRINGIFY(x) `"x`"

module sync_tb;

  integer i;

  reg  clk = 0;
  wire out;

  sync uut(clk, out);

  initial begin
    $dumpfile(`STRINGIFY(`DUMPFILE_PATH));
    $dumpvars(1, sync_tb);

    // 5k state changes == 2500 full cycles
    for (i = 0; i < 3500; i = i + 1) begin
      #20 clk = ~clk;
    end
  end

endmodule
