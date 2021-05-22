// VGA timing (https://projectf.io/posts/video-timings-vga-720p-1080p/)
// DATW=data width, FRNP=front porch, PULW=pulse width, BCKP=back porch

`define HSYN_DATW 640
`define HSYN_FRNP  16
`define HSYN_PULW  96
`define HSYN_BCKP  48

`define VSYN_DATW 480
`define VSYN_FRNP  10
`define VSYN_PULW   2
`define VSYN_BCKP  33

module sync(i_clock, i_color, o_hsync, o_vsync, o_red, o_green, o_blue);

  input i_clock;

  // Selected color (0=black, 1=red, 2=green, 3=blue)
  input [1:0] i_color;

  output o_hsync;
  output o_vsync;

  // 3 bit RGB channels
  output [2:0] o_red;
  output [2:0] o_green;
  output [2:0] o_blue;

  // 10 bit counters: one for the columns (800) and one for the rows (525)
  reg [9:0] r_col_counter = 0;
  reg [9:0] r_row_counter = 0;

  // At which pixels the hsync/vsync pulse starts (PULS) and ends (PULE)
  localparam HSYN_PULS = `HSYN_DATW + `HSYN_FRNP;
  localparam HSYN_PULE =  HSYN_PULS + `HSYN_PULW;
  localparam VSYN_PULS = `VSYN_DATW + `VSYN_BCKP;
  localparam VSYN_PULE =  VSYN_PULS + `VSYN_PULW;

  // Running the counters
  always @(posedge i_clock) begin
    if (r_col_counter == HSYN_PULE + `HSYN_BCKP) begin
      r_col_counter <= 1;

      if (r_row_counter == VSYN_PULE + `VSYN_BCKP)
        r_row_counter <= 1;
      else
        r_row_counter <= r_row_counter + 1;
    end else
      r_col_counter <= r_col_counter + 1;
  end

  // Generate the sync pulses
  assign o_hsync = r_col_counter > HSYN_PULS & r_col_counter <= HSYN_PULE ? 0 : 1;
  assign o_vsync = r_row_counter > VSYN_PULS & r_row_counter <= VSYN_PULE ? 0 : 1;

  assign o_red   = r_col_counter <= `HSYN_DATW && r_row_counter <= `VSYN_DATW && i_color == 1 ? 3'b111 : 3'b000;
  assign o_green = r_col_counter <= `HSYN_DATW && r_row_counter <= `VSYN_DATW && i_color == 2 ? 3'b111 : 3'b000;
  assign o_blue  = r_col_counter <= `HSYN_DATW && r_row_counter <= `VSYN_DATW && i_color == 3 ? 3'b111 : 3'b000;

endmodule
