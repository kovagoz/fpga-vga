// VGA timing (https://projectf.io/posts/video-timings-vga-720p-1080p/)
`define HSYNC_VIDEO_WIDTH       640
`define HSYNC_FRONT_PORCH_WIDTH  16
`define HSYNC_PULSE_WIDTH        96
`define HSYNC_BACK_PORCH_WIDTH   48

module sync(i_clock, o_hsync);

  input  i_clock;
  output o_hsync;

  // 10 bit counter for the 800px wide screen
  reg[9:0] r_col_counter = 0;

  // Which pixels the sync pulse starts and ends at
  localparam PULSE_START_POS = `HSYNC_VIDEO_WIDTH + `HSYNC_FRONT_PORCH_WIDTH;
  localparam PULSE_END_POS   = PULSE_START_POS + `HSYNC_PULSE_WIDTH;

  always @(posedge i_clock) begin
    if (r_col_counter == PULSE_END_POS + `HSYNC_BACK_PORCH_WIDTH)
      r_col_counter <= 1;
    else
      r_col_counter <= r_col_counter + 1;
  end

  assign o_hsync = r_col_counter > PULSE_START_POS & r_col_counter <= PULSE_END_POS ? 0 : 1;

endmodule
