module sck_converter(input wire clk,
							output reg sck);
							
reg [15:0] counter_clk = 0;
//sck = 1.536 MHz		clk = 50MHz		dividend = 50/1.536 = 32.552083...

always @(posedge clk) begin
	if (counter_clk == 33) begin
		sck <= ~sck;
		counter_clk <= 0;
	end else begin
		counter_clk <= counter_clk + 1;
	end
end
endmodule

module audioReader (
						  input wire sclk, input wire wrdclk, input wire data,
						  output reg [15:0] audioL, output reg [15:0] audioR, output reg [15:0] audioM);

reg [15:0] sample = 0;
reg [3:0] bitCount = 0;


always @(posedge sclk) begin
	sample <= {sample[14:0], data};
	bitCount <= bitCount + 1;
	
	if (bitCount == 15)
		begin	if (wrdclk == 0)
					audioL <= sample;
				else
					audioR <= sample;
			bitCount <= 0;
		end
end
endmodule



module lvl_meter(
					  input wire clk, input wire [15:0] audioM,
					  output reg [3:0] meter);

reg [15:0] lvl = 0;

always @(posedge clk) begin
			lvl = audioM;
			case (lvl)
									  lvl<13108: meter = 4'd0;
				(lvl>13107) && (lvl<26215): meter = 4'd1;
				(lvl>26214) && (lvl<39322): meter = 4'd3;
				(lvl>26213) && (lvl<52429): meter = 4'd7;
									  lvl>52428: meter = 3'd15;			
				default : meter = 0;
			endcase
end
endmodule



module vga_display(input wire clk, output reg whatever_i_need_to_output);
//code a full red screen on vga as a test code
//scan pixel 0 to max horizontally
//vsync to move to new row
endmodule
