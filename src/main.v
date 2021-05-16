`include "sync.v"

module main(i_Clk, o_VGA_HSync, o_VGA_VSync);

  input  i_Clk;
  output o_VGA_HSync;
  output o_VGA_VSync;

  // SPG stands for Sync Pulse Generator
  sync SPG(.i_clock(i_Clk), .o_hsync(o_VGA_HSync), .o_vsync(o_VGA_VSync));

endmodule
