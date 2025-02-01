`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ITU Computer Engineering Department
// Selin Yilmaz - 150210100
// Hilal Kartal - 150210087
// Project Name: BLG222E Project 1
//////////////////////////////////////////////////////////////////////////////////


module InstructionRegister(I, LH, Write, IROut, Clock);
    input wire [7:0] I;
	input wire LH;
	input wire Write; 
	input Clock;
	   
	output reg[15:0] IROut;

    always @(posedge Clock)
    begin

    if(Write == 1)
    begin
        case(LH)						
            0   :	IROut = {IROut[15:8] , I[7:0]};                    //Load to LSB
            1   :	IROut = {I[7:0], IROut[7:0]};						//Load to MSB
            default: IROut <= 16'd0;
        endcase 
	end
    /*
    else //Write == 0
    begin
        IROut = IROut;     //Retain value
    end 
	*/
	end
    
endmodule