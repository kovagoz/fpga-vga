`include "sync.v"

module main(
  input  i_Clk,

  input  i_Switch_1,
  input  i_Switch_2,
  input  i_Switch_3,
  input  i_Switch_4,

  output o_VGA_HSync,
  output o_VGA_VSync,

  output o_VGA_Red_0,
  output o_VGA_Red_1,
  output o_VGA_Red_2,

  output o_VGA_Grn_0,
  output o_VGA_Grn_1,
  output o_VGA_Grn_2,

  output o_VGA_Blu_0,
  output o_VGA_Blu_1,
  output o_VGA_Blu_2,

  output o_LED_1,
  output o_LED_2,
  output o_LED_3,
  output o_LED_4);

  wire [2:0] red, green, blue;
  reg  [1:0] color = 1;

  sync s0(
    .i_clock(i_Clk),
    .i_color(color),
    .o_hsync(o_VGA_HSync),
    .o_vsync(o_VGA_VSync),
    .o_red(red),
    .o_green(green),
    .o_blue(blue)
  );

  always @(posedge i_Clk) begin
    if (i_Switch_1)
      color <= 1;
    else if (i_Switch_2)
      color <= 2;
    else if (i_Switch_3)
      color <= 3;
    else if (i_Switch_4)
      color <= 0;
  end

  assign o_VGA_Red_0 = red[0];
  assign o_VGA_Red_1 = red[1];
  assign o_VGA_Red_2 = red[2];

  assign o_VGA_Grn_0 = green[0];
  assign o_VGA_Grn_1 = green[1];
  assign o_VGA_Grn_2 = green[2];

  assign o_VGA_Blu_0 = blue[0];
  assign o_VGA_Blu_1 = blue[1];
  assign o_VGA_Blu_2 = blue[2];

  assign o_LED_1 = color == 1;
  assign o_LED_2 = color == 2;
  assign o_LED_3 = color == 3;
  assign o_LED_4 = color == 0;

endmodule
