`include "sync.v"

module main(i_Clk, o_VGA_HSync);

  input  i_Clk;
  output o_VGA_HSync;

  // SPG stands for Sync Pulse Generator
  sync SPG(.i_clock(i_Clk), .o_hsync(o_VGA_HSync));

endmodule
