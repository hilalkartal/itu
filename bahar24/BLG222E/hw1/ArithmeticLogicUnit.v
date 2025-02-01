`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ITU Computer Engineering Department
// Selin Yilmaz - 150210100
// Hilal Kartal - 150210087
// Project Name: BLG222E Project 1
//////////////////////////////////////////////////////////////////////////////////

module ArithmeticLogicUnit(A, B, FunSel, WF, Clock, ALUOut, FlagsOut);
    input wire [15:0]A;
    input wire [15:0]B;
    input wire [4:0]FunSel;
    input Clock;
    output reg [3:0]FlagsOut;
    
    input wire WF;
    output reg [15:0]ALUOut;
    
    //internal system
    reg [3:0] Flags;
    wire C_in;
    reg [16:0]temp;


always @(*)
    begin
        if(FunSel[4] == 1) begin    //16-bit 
            case(FunSel[3:0])
                4'b0000:begin
                     ALUOut <= A;  
                     Flags[3] = (A[15:0] == 0) ? 1 : 0;
                     Flags[1] =  A[15];
                end
                4'b0001:begin
                     ALUOut <= B; 
                     Flags[3] = (B[15:0] == 0) ? 1 : 0;
                     Flags[1] =  A[15];
                end
                4'b0010:begin
                    ALUOut <= ~A;   
                    Flags[3] = (~A[15:0] ==0) ? 1 : 0;
                    Flags[1] = ~A[15];
                end
                4'b0011:begin
                    ALUOut <= ~B; 
                    Flags[3] = (~B[15:0] ==0) ? 1 : 0;
                    Flags[1] = ~B[15]; 
                end
                
                4'b0100:begin
                    temp <= A + B;   
                    ALUOut <= temp[15:0];
                    Flags[3] = (temp[15:0] == 0) ? 1 : 0; 
                    Flags[2] = temp[16];
                    Flags[1] = temp[15];
                    Flags[0] = (A[15] == B[15] && temp[15] != A[15]) ? 1 : 0; 
                end
                4'b0101:begin
                    temp <= A + B + FlagsOut[2];   
                    ALUOut <= temp[15:0];
                    Flags[3] = (temp[15:0] == 0) ? 1 : 0; 
                    Flags[2] = temp[16];
                    Flags[1] = temp[15];
                    Flags[0] = (A[15] == B[15] && temp[15] != A[15]) ? 1 : 0; 
                end
               
                4'b0110:begin
                    temp <= A + ~B + 1;
                    ALUOut <= temp[15:0]; 
                    Flags[3] = (temp[15:0] == 0) ? 1 : 0; 
                    Flags[2] = ~temp[16];
                    Flags[1] = temp[15];
                    Flags[0] = (A[15] == B[15] && temp[15] != A[15]) ? 1 : 0;  
                end
                4'b0111:begin
                    ALUOut <= A & B;   
                    Flags[3] = (ALUOut[15:0] == 0) ? 1 : 0; 
                    Flags[1] = ALUOut[15];
                end
                4'b1000:begin
                    ALUOut <= A | B;   
                    Flags[3] = (ALUOut[15:0] == 0) ? 1 : 0; 
                    Flags[1] = ALUOut[15];
                end   
                4'b1001: begin
                    ALUOut <=  A ^ B;   
                    Flags[3] = (ALUOut[15:0] == 0) ? 1 : 0; 
                    Flags[1] = ALUOut[15];
                end    
                4'b1010:begin
                    ALUOut <=  ~(A&B);   
                    Flags[3] = (ALUOut[15:0] == 0) ? 1 : 0; 
                    Flags[1] = ALUOut[15];
                end   
                
                
                4'b1011:begin
                    Flags[2] <= A[15]; 
                    temp <= A<<<1;   
                    ALUOut <=  temp[15:0];
                    Flags[3] = (ALUOut[15:0] == 0) ? 1 : 0;
                    Flags[1] = ALUOut[15];
                end
                4'b1100:begin
                    Flags[2] <= A[0];
                    temp <= A>>>1;  
                    ALUOut <=  temp[15:0];
                    Flags[3] = (ALUOut[15:0] == 0) ? 1 : 0;
                    Flags[1] = ALUOut[15];
                end
                4'b1101:begin       //aritmetic shift right
                     Flags[2] <= A[0];
                     temp[16] <= A[15];
                     temp <= temp>>1 ;
                     ALUOut <= temp[15:0];   
                     Flags[3] = (ALUOut[15:0] == 0) ? 1 : 0; 
                end
                4'b1110: begin      // circular shift left
                     Flags[2] <=A[15];
                     temp[15:0] <= A;
                     temp <= temp<<1;
                     temp[0] <= temp[16];
                     ALUOut <= temp[15:0];
                     Flags[3] = (ALUOut[15:0] == 0) ? 1 : 0;
                     Flags[1] = ALUOut[15];                     
                end 
                4'b1111: begin      //circular shift right
                    Flags[2] <= A[0];
                    temp <= {A[0], A};
                    temp <= temp>>1;
                    ALUOut <= temp[15:0];
                    Flags[3] = (ALUOut[15:0] == 0) ? 1 : 0;
                    Flags[1] = ALUOut[15];
                end   
                
            endcase
        end
 
        else begin
         case(FunSel[3:0]) //8-bits
               4'b0000:begin
                    temp <= A;
                    ALUOut <= {8'd0, temp};
                    Flags[3] = (temp[7:0] == 0) ? 1:0;
                    Flags[1] = (temp[7] == 1) ? 1:0;
               end
               4'b0001:begin
                   temp <= B;
                   ALUOut <= {8'd0, temp[7:0]};
                   Flags[3] = (temp[7:0] == 0) ? 1:0;
                   Flags[1] = (temp[7] == 1) ? 1:0;                   
               end
               4'b0010:begin
                   temp <= ~A;
                   ALUOut <= {8'd0, temp[7:0]}; 
                   Flags[3] = (temp[7:0] == 0) ? 1:0;
                   Flags[1] = (temp[7] == 1) ? 1:0;
               end  
               4'b0011:begin
                   temp <= ~B;
                   ALUOut <= {8'd0, temp[7:0]}; 
                   Flags[3] = (temp[7:0] == 0) ? 1:0;
                   Flags[1] = (temp[7] == 1) ? 1:0;
               end 
               4'b0100:begin
                   temp <= A + B;
                   ALUOut <= {8'd0, temp[7:0]}; 
                   Flags[3] = (temp[7:0] == 0) ? 1:0;
                   Flags[2] = (temp[8] == 1) ? 1:0;
                   Flags[1] = (temp[7] == 1) ? 1:0;
                   Flags[0] = (A[7] == B[7] && A[7] != temp[7]) ? 1:0;
               end
               4'b0101:begin
                   temp <= A + B + FlagsOut[2];
                   ALUOut <= {8'd0, temp[7:0]}; 
                   Flags[3] = (temp[7:0] == 0) ? 1:0;
                   Flags[2] = (temp[8] == 1) ? 1:0;
                   Flags[1] = (temp[7] == 1) ? 1:0;
                   Flags[0] = (A[7] == B[7] && A[7] != temp[7]) ? 1:0;
               end  
               4'b0110:begin
                   temp <= A + ~B + 1;
                   ALUOut <= {8'd0, temp[7:0]}; 
                   Flags[3] = (temp[7:0] == 0) ? 1:0;
                   Flags[2] = (temp[8] == 1) ? 1:0;
                   Flags[1] = (temp[7] == 1) ? 1:0;
                   Flags[0] = (A[7] == B[7] && A[7] != temp[7]) ? 1:0;                      
               end
               4'b0111:begin
                   temp <= A & B;      //A AND B
                   ALUOut <= {8'd0, temp[7:0]};
                   Flags[3] = (temp[7:0] == 0) ? 1:0;
                   Flags[1] = (temp[7] == 1) ? 1:0;
               end   
               4'b1000:begin 
                   temp <= A | B;      //A OR B
                   ALUOut <= {8'd0, temp[7:0]};
                   Flags[3] = (temp[7:0] == 0) ? 1:0;
                   Flags[1] = (temp[7] == 1) ? 1:0; 
               end
               4'b1001:begin 
                   temp <= A ^ B;      //A XOR B
                   ALUOut <= {8'd0, temp[7:0]};
                   Flags[3] = (temp[7:0] == 0) ? 1:0;
                   Flags[1] = (temp[7] == 1) ? 1:0;   
               end                   
               4'b1010:begin
                   temp <= ~(A&B);  
                   ALUOut <= {8'd0, temp[7:0]};
                   Flags[3] = (temp[7:0] == 0) ? 1:0;
                   Flags[1] = (temp[7] == 1) ? 1:0; 
               end
               4'b1011:begin           //LSL
                   Flags[2] <= A[7];
                   temp <= A<<<1; 
                   ALUOut <= {8'd0, temp[7:0]};
                   Flags[3] = (ALUOut[15:0] == 0) ? 1:0;
                   Flags[1] = (ALUOut[7] == 1) ? 1:0;                    
               end  
               4'b1100:begin           //LSR
                   Flags[2] <= A[0]; 
                   temp <= A>>>1;
                   ALUOut <= {8'd0, temp[7:0]};
                   Flags[3] = (ALUOut[15:0] == 0) ? 1:0;
                   Flags[1] = (ALUOut[7] == 1) ? 1:0;
               end  
               4'b1101:begin           //ASR
                   Flags[2] <= A[0];
                   temp[8] <= temp[7];
                   temp <= A>>1;
                   ALUOut <= {8'd0, temp[7:0]};  
                   Flags[3] = (ALUOut[15:0] == 0) ? 1:0;
                   //Flags[1] = (ALUOut[7] == 1) ? 1:0;
               end
               4'b1110: begin      // circular shift left
                   Flags[2] <= A[7];
                   temp[7:0] <= A;
                   temp <= temp<<1;
                   temp[0] <= temp[8];
                   ALUOut <= {8'd0, temp[7:0]};
                   Flags[3] = (ALUOut[15:0] == 0) ? 1:0;
                   Flags[1] = (ALUOut[7] == 1) ? 1:0;
               end 
               4'b1111: begin
                   Flags[2] <= A[0];
                   temp <= {A[0], A};
                   temp <= temp>>1;
                   ALUOut <= {8'd0, temp[7:0]};
                   Flags[3] = (ALUOut[15:0] == 0) ? 1:0;
                   Flags[1] = (ALUOut[7] == 1) ? 1:0;
               end    
               
               default: ALUOut <= 16'd0;                        
           endcase
            
        end
        
    end
    
always @(posedge Clock)
    begin
        if(WF == 1 )begin
        case(FunSel[3:0])
            4'b0000:begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[1] <= Flags[1];
            end 
            4'b0001: begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[1] <= Flags[1];
            end 
            4'b0010: begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[1] <= Flags[1];
            end   
            4'b0011: begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[1] <= Flags[1];
            end 
                                                
                                                
            4'b0100:begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[2] <= Flags[2];
                FlagsOut[1] <= Flags[1];
                FlagsOut[0] <= Flags[0];
            end
            4'b0101:begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[2] <= Flags[2];
                FlagsOut[1] <= Flags[1];
                FlagsOut[0] <= Flags[0];
            end
            4'b0110:begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[2] <= Flags[2];
                FlagsOut[1] <= Flags[1];
                FlagsOut[0] <= Flags[0];
            end
              
            4'b0111:begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[1] <= Flags[1];
            end 
            4'b1000:begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[1] <= Flags[1];
            end  
            4'b1001: begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[1] <= Flags[1];
            end 
            4'b1010: begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[1] <= Flags[1];
            end 
            
            4'b1011: begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[2] <= Flags[2];
                FlagsOut[1] <= Flags[1];
            end
            4'b1100: begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[2] <= Flags[2];
                FlagsOut[1] <= Flags[1];
            end  
            
            4'b1101: begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[2] <= Flags[2];
            end
            4'b1110: begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[2] <= Flags[2];
                FlagsOut[1] <= Flags[1];
            end 
            4'b1111:begin
                FlagsOut[3] <= Flags[3];
                FlagsOut[2] <= Flags[2];
                FlagsOut[1] <= Flags[1];
            end 

        default:
            FlagsOut[3:0] <= 4'b0000;
        endcase
        end
    end
endmodule    