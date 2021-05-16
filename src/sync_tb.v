`include "sync.v"
`timescale 1ns/1ns
`define STRINGIFY(x) `"x`"

module sync_tb;

  integer i;

  reg  clk = 0;
  wire hsync;
  wire vsync;

  sync uut(clk, hsync, vsync);

  initial begin
    $dumpfile(`STRINGIFY(`DUMPFILE_PATH));
    $dumpvars(1, sync_tb);

    for (i = 0; i < 850000; i = i + 1) begin
      #20 clk = ~clk;
    end
  end

endmodule
