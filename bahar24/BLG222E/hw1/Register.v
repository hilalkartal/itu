`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ITU Computer Engineering Department
// Selin Yilmaz - 150210100
// Hilal Kartal - 150210087
// Project Name: BLG222E Project 1
//////////////////////////////////////////////////////////////////////////////////

module Register (I, E, FunSel, Clock, Q);
	input wire [15:0] I;
	input wire E;
	input wire [2:0] FunSel;
	input wire Clock;
	output reg[15:0] Q;
	
	//For rising edge
	always @(posedge Clock)

	begin

    if(E == 1)
    begin
        case(FunSel)
            3'b000 	:	Q <= Q - 1;						//Decrement
            3'b001	:	Q <= Q + 1;						//Increment
            3'b010	:	Q <= I;							//Load
            3'b011	: 	Q <= 16'd0;						//Clear
            3'b100	: 	Q <= {8'd0 , I[7:0]};			//Clear and write low
            3'b101	: 	Q <= {Q[15:8], I[7:0]};			//Only write low
            3'b110	: 	Q <= {I[15:8], Q[7:0]};			//Only write high
            3'b111	: 	begin							//Sign extend and Write low
                            if(I[7] == 1'b0)
                                Q <= {8'b0, I[7:0]};	//Sign is zero
                            else 
                                Q <= {8'b1, I[7:0]};	//Sign is 1
                        end 
            default: Q <= 16'd0;
        endcase // FunSel
		end

		else 
		begin
			Q <= Q;
		end 
		
	end


endmodule