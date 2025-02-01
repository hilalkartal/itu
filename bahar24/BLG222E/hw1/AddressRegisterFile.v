`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ITU Computer Engineering Department
// Selin Yilmaz - 150210100
// Hilal Kartal - 150210087
// Project Name: BLG222E Project 1
//////////////////////////////////////////////////////////////////////////////////
    
module AddressRegisterFile(I, OutCSel, OutDSel, FunSel, RegSel, Clock, OutC, OutD);
    input wire [15:0] I;
    input wire [1:0] OutCSel;
    input wire [1:0] OutDSel;
    input wire [2:0] FunSel;
    input wire [2:0] RegSel;
    input wire Clock;
    
    reg EPC;
    reg EAR;
    reg ESP;
    wire [15:0] OPC, OAR, OSP;
    
    output reg [15:0] OutC;
    output reg [15:0] OutD;
    
Register PC(
   .I(I),
   .E(EPC),
   .FunSel(FunSel),
   .Clock(Clock),
   .Q(OPC)
);
Register AR(
    .I(I),
    .E(EAR),
    .FunSel(FunSel),
    .Clock(Clock),
    .Q(OAR)
 );
Register SP(
    .I(I),
    .E(ESP),
    .FunSel(FunSel),
    .Clock(Clock),
    .Q(OSP)
);   

always @(*)

    begin
        case(OutCSel)
            2'b00  :    OutC <= OPC;                 
            2'b01  :    OutC <= OPC;                      
            2'b10  :    OutC <= OAR;                        
            2'b11  :    OutC <= OSP;  
            default: OutC <= 16'd0;                      
        endcase // OutCSel
        
        case(OutDSel)
            2'b00  :    OutD <= OPC;                 
            2'b01  :    OutD <= OPC;                      
            2'b10  :    OutD <= OAR;                        
            2'b11  :    OutD <= OSP; 
            default: OutD <= 16'd0;                        
        endcase // OutCSel
    
        case(RegSel)
            3'b000  :begin
                EPC <= ~RegSel[2];
                EAR <= ~RegSel[1];
                ESP <= ~RegSel[0];
                end
            3'b001  :begin
                EPC <= ~RegSel[2];
                EAR <= ~RegSel[1];
                ESP <= ~RegSel[0];
                end    
            3'b010  :begin
                EPC <= ~RegSel[2];
                EAR <= ~RegSel[1];
                ESP <= ~RegSel[0];
                end    
            3'b011  :begin
                EPC <= ~RegSel[2];
                EAR <= ~RegSel[1];
                ESP <= ~RegSel[0];
                end    
            3'b100  :begin
                EPC <= ~RegSel[2];
                EAR <= ~RegSel[1];
                ESP <= ~RegSel[0];
                end    
            3'b101  :begin
                EPC <= ~RegSel[2];
                EAR <= ~RegSel[1];
                ESP <= ~RegSel[0];
                end    
            3'b110  :begin
                EPC <= ~RegSel[2];
                EAR <= ~RegSel[1];
                ESP <= ~RegSel[0];
                end    
            3'b111  :begin
                EPC <= ~RegSel[2];
                EAR <= ~RegSel[1];
                ESP <= ~RegSel[0];
                end    
                        
            default: begin
                EPC <= 0;
                EAR <= 0;
                ESP <= 0;
                end  
        
          endcase

end
    
endmodule 