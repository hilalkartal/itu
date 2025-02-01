`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ITU Computer Engineering Department
// Selin Yilmaz - 150210100
// Hilal Kartal - 150210087
// Project Name: BLG222E Project 1
//////////////////////////////////////////////////////////////////////////////////

module RegisterFile(I, OutASel, OutBSel, FunSel, RegSel, ScrSel, Clock, OutA, OutB);

    input wire [15:0] I;
    input wire [2:0] OutASel;
    input wire [2:0] OutBSel;
    
    input wire [2:0] FunSel;
    input wire [3:0] RegSel;
    input wire [3:0] ScrSel;
    input wire Clock;
 
    wire [15:0]OR1, OR2, OR3, OR4, OS1, OS2, OS3, OS4;
    
    reg ER1;
    reg ER2;
    reg ER3;
    reg ER4;
    reg ES1;
    reg ES2;
    reg ES3;
    reg ES4;
    
    output reg[15:0] OutA;
    output reg[15:0] OutB;
    
    //(I, E, FunSel, Clock, Q)
Register R1(
   .I(I),
   .E(ER1),
   .FunSel(FunSel),
   .Clock(Clock),
   .Q(OR1)
);
Register R2(
    .I(I),
    .E(ER2),
    .FunSel(FunSel),
    .Clock(Clock),
    .Q(OR2)
 );
Register R3(
    .I(I),
    .E(ER3),
    .FunSel(FunSel),
    .Clock(Clock),
    .Q(OR3)
);
Register R4(
    .I(I),
    .E(ER4),
    .FunSel(FunSel),
    .Clock(Clock),
    .Q(OR4)
);
Register S1(
    .I(I),
    .E(ES1),
    .FunSel(FunSel),
    .Clock(Clock),
    .Q(OS1)
);
Register S2(
   .I(I),
   .E(ES2),
   .FunSel(FunSel),
   .Clock(Clock),
   .Q(OS2)
);
Register S3(
    .I(I),
    .E(ES3),
    .FunSel(FunSel),
    .Clock(Clock),
    .Q(OS3)
);
Register S4(
      .I(I),
      .E(ES4),
      .FunSel(FunSel),
      .Clock(Clock),
      .Q(OS4)
);
    always @(*)
       
        
        begin
            case(RegSel)
                4'b0000  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end
                4'b0001  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end
                4'b0010  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end
                4'b0011  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end   
                4'b0100  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end
                4'b0101  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end
                4'b0110  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end 
                4'b0111  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end 
                4'b1000  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end 
                4'b1001  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end
                4'b1010  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end
                4'b1011  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end
                4'b1100  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end  
                4'b1101  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end 
                4'b1110  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end 
                4'b1111  :begin 
                    ER1 <= ~RegSel[3];
                    ER2 <= ~RegSel[2];
                    ER3 <= ~RegSel[1];
                    ER4 <= ~RegSel[0];
                end                                                                                                                                                                                                                                              
            endcase
            case(ScrSel)
                4'b0000  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end
                4'b0001  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end
                4'b0010  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end
                4'b0011  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end   
                4'b0100  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end
                4'b0101  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end
                4'b0110  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end 
                4'b0111  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end 
                4'b1000  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end 
                4'b1001  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end
                4'b1010  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end
                4'b1011  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end
                4'b1100  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end  
                4'b1101  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end 
                4'b1110  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end 
                4'b1111  :begin 
                    ES1 <= ~ScrSel[3];
                    ES2 <= ~ScrSel[2];
                    ES3 <= ~ScrSel[1];
                    ES4 <= ~ScrSel[0];
                end                                                                                                                                                                                                                                              
            endcase            
            
            case(OutASel)
                3'b000  :    OutA <= OR1;                        //Decrement
                3'b001  :    OutA <= OR2;                        //Decrement
                3'b010  :    OutA <= OR3;                        //Decrement
                3'b011  :    OutA <= OR4;                        //Decrement
                3'b100  :    OutA <= OS1;                        //Decrement
                3'b101  :    OutA <= OS2;                        //Decrement
                3'b110  :    OutA <= OS3;                        //Decrement
                3'b111  :    OutA <= OS4;                        //Decrement
                default: OutA<= 16'd0;
            endcase // OutASel
            case(OutBSel)
                3'b000  :    OutB <= OR1;                        //Decrement
                3'b001  :    OutB <= OR2;                        //Decrement
                3'b010  :    OutB <= OR3;                        //Decrement
                3'b011  :    OutB <= OR4;                        //Decrement
                3'b100  :    OutB <= OS1;                        //Decrement
                3'b101  :    OutB <= OS2;                        //Decrement
                3'b110  :    OutB <= OS3;                        //Decrement
                3'b111  :    OutB <= OS4;                        //Decrement
                default: OutB<= 16'd0;
            endcase // OutBSel
            
    end
        
endmodule