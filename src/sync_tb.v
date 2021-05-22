`include "sync.v"
`timescale 1ns/1ns
`define STRINGIFY(x) `"x`"

module sync_tb;

  integer i;

  reg  clk = 0;
  reg  color = 0;
  wire hsync, vsync;
  wire [2:0] red, green, blue;

  sync uut(
    .i_clock(clk),
    .i_color(),
    .o_hsync(hsync),
    .o_vsync(vsync),
    .o_red(red),
    .o_green(green),
    .o_blue(blue)
  );

  initial begin
    $dumpfile(`STRINGIFY(`DUMPFILE_PATH));
    $dumpvars(1, sync_tb);

    for (i = 0; i < 850000; i = i + 1) begin
      #20 clk = ~clk;
    end
  end

endmodule
