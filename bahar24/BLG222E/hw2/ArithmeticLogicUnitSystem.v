`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ITU Computer Engineering Department
// Selin Yilmaz - 150210100
// Hilal Kartal - 150210087
// Project Name: BLG222E Project 1
//////////////////////////////////////////////////////////////////////////////////

module ArithmeticLogicUnitSystem(RF_OutASel, RF_OutBSel, RF_FunSel, RF_RegSel, RF_ScrSel, 
        ALU_FunSel, ALU_WF, ARF_OutCSel, ARF_OutDSel,ARF_FunSel, ARF_RegSel, 
        IR_LH, IR_Write, Mem_WR, Mem_CS, MuxASel, MuxBSel, MuxCSel, Clock); 
   
    //RegisterFile    
    input wire[2:0] RF_OutASel, RF_OutBSel, RF_FunSel;
    input wire[3:0] RF_RegSel, RF_ScrSel;
   
    //ALU 
    input wire[4:0] ALU_FunSel;
    input wire ALU_WF;
   
    
    //ARF 
    input wire[1:0] ARF_OutCSel, ARF_OutDSel;
    input wire[2:0] ARF_FunSel, ARF_RegSel;
    
    //IR
    input wire IR_LH, IR_Write;
    
    //Memory
    input wire Mem_WR, Mem_CS;
    
    //MUXs
    input wire[1:0] MuxASel, MuxBSel;
    input wire MuxCSel;
    input Clock;
    
    //internal
    wire[15:0] OutA, OutB, OutC, Address;  //
    wire[15:0] IROut;
    reg[15:0] MuxAOut, MuxBOut; 
    reg[7:0] MuxCOut;
    wire[15:0] ALUOut;
    wire[3:0] Flags;
    wire[7:0] MemOut;
    
    ArithmeticLogicUnit ALU(.A(OutA), .B(OutB), .FunSel(ALU_FunSel), .WF(ALU_WF), .Clock(Clock), .ALUOut(ALUOut), .FlagsOut(Flags));
    InstructionRegister IR(.I(MemOut), .LH(IR_LH), .Write(IR_Write), .IROut(IROut), .Clock(Clock));
    RegisterFile RF(.I(MuxAOut), .OutASel(RF_OutASel), .OutBSel(RF_OutBSel), .FunSel(RF_FunSel), .RegSel(RF_RegSel), .ScrSel(RF_ScrSel), .Clock(Clock), .OutA(OutA), .OutB(OutB));
    AddressRegisterFile ARF(.I(MuxBOut), .OutCSel(ARF_OutCSel), .OutDSel(ARF_OutDSel), .FunSel(ARF_FunSel), .RegSel(ARF_RegSel), .Clock(Clock), .OutC(OutC), .OutD(Address));
    Memory MEM(.Address(Address), .Data(MuxCOut), .WR(Mem_WR), .CS(Mem_CS), .Clock(Clock), .MemOut(MemOut));

    always @(*)
        begin
         case(MuxASel)
               2'b00 :  MuxAOut <= ALUOut;
               2'b01 : MuxAOut <= OutC; //comes from ARF
               2'b10 : MuxAOut <= {8'd0, MemOut};
               2'b11 : MuxAOut <= {8'd0, IROut[7:0]};        
               
          default: MuxAOut <= 16'd0;
           endcase
           case(MuxBSel)
              2'b00 : MuxBOut <= ALUOut;
              2'b01 : MuxBOut <= OutC; //comes from ARF
              2'b10 : MuxBOut <= {8'd0, MemOut};
              2'b11 : MuxBOut <= {8'd0, IROut[7:0]}; 
              
            default: MuxBOut <= 16'd0;           
          endcase
           case(MuxCSel)
               0: MuxCOut <= ALUOut[7:0];
               1: MuxCOut <= ALUOut[15:8];
               
               default: MuxCOut <= 16'd0;
           endcase
        
        end
        
endmodule