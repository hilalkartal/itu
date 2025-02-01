`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ITU Computer Engineering Department
// Selin Yilmaz - 150210100
// Hilal Kartal - 150210087
// Project Name: BLG222E Project 1
//////////////////////////////////////////////////////////////////////////////////
/*
module Sequence_Counter(Clock, Reset, T_SC);
    input wire Clock, Reset;
    
    output reg[7:0] T_SC = 8'd0;
    
    //sequence counter çal??maca
    always @(posedge Clock)
    begin
        case(Reset)
            1: T_SC <= 8'd1;   // T0
        endcase    
          
        case(T_SC)
            8'd1: T_SC <= 8'd2;    //T1
            8'd2: T_SC <= 8'd4;    //T2        
            8'd4: T_SC <= 8'd8;    //T3
            8'd8: T_SC <= 8'd16;   //T4
            8'd16: T_SC <= 8'd32;  //T5
            8'd32: T_SC <= 8'd64;  //T6
            8'd64: T_SC <= 8'd128; //T7   
        endcase
    end 
endmodule
*/

module CPUSystem (Clock, Reset, T);
    input wire Clock, Reset;
    output reg [7:0] T = 8'd0;
    
    //For RegisterFile
    reg [2:0] RF_OutASel, RF_OutBSel, RF_FunSel;
    reg [3:0] RF_RegSel, RF_ScrSel;
    
    //For ALU    
    reg [4:0] ALU_FunSel;
    reg ALU_WF;    
    
    //For AdressRF
    reg [1:0] ARF_OutCSel, ARF_OutDSel;
    reg [2:0] ARF_FunSel, ARF_RegSel;    
    
    //For InstructionRegister
    reg IR_LH, IR_Write;
    
    //For Memory
    reg Mem_WR, Mem_CS; 
    
    //For MUXs
    reg [1:0] MuxASel, MuxBSel;
    reg MuxCSel;
    
    ArithmeticLogicUnitSystem _ALUSystem (
            .RF_OutASel(RF_OutASel), 
            .RF_OutBSel(RF_OutBSel), 
            .RF_FunSel(RF_FunSel), 
            .RF_RegSel(RF_RegSel), 
            .RF_ScrSel(RF_ScrSel), 
            .ALU_FunSel(ALU_FunSel),
            .ALU_WF(ALU_WF), 
            .ARF_OutCSel(ARF_OutCSel), 
            .ARF_OutDSel(ARF_OutDSel), 
            .ARF_FunSel(ARF_FunSel), 
            .ARF_RegSel(ARF_RegSel), 
            .IR_LH(IR_LH), 
            .IR_Write(IR_Write), 
            .Mem_WR(Mem_WR), 
            .Mem_CS(Mem_CS), 
            .MuxASel(MuxASel), 
            .MuxBSel(MuxBSel), 
            .MuxCSel(MuxCSel), 
            .Clock(Clock)
        );  
     
     
     reg SC_Reset;
   // Sequence Counter begin
         
          always@(posedge Clock)   
          begin
             if(SC_Reset == 1)
                 begin
                     T <= 8'd0; //T0
                 end
             else
                 begin
                      if(T == 8 'h00)
                          T <= 8'd1;
                      else if(T == 8'd1)
                          T <= 8'd2;
                      else if(T == 8'd2)
                          T <= 8'd4;
                      else if(T == 8'd4)
                          T <= 8'd8;
                      else if(T == 8'd8)     
                          T <= 8'd16;
                      else if(T == 8'd16)
                          T <= 8'd32;
                      else if(T == 8'd32)
                          T <= 8'd64;
                      else if(T == 8'd64)
                          T <= 8'd128;
                    end

     end
     /////BUNU DÜŞÜN
     //PC clear
     initial 
     begin
        ARF_FunSel = 3'b011;
        ARF_RegSel = 3'b011;
     end
     
     

     //fetch i?lemi
     always @(T[0] || T[1])      //if T0 or T1 is 1, we need to fetch the instruction from the memory
     begin
        if(Reset == 1)
        begin
         if(T[0] == 1)     //fetch low 
             begin
                 ARF_OutDSel <= 2'b00;      //PC'den address al.
                 
                 Mem_CS <= 0;    //when CS is one memory's chip is active
                 Mem_WR <= 0;    //O is read
                 
                 IR_LH <= 0;    
                 IR_Write <= 1;
                   
             end
         
         if(T[1] == 0)     //fetch high (T1 ==1)
             begin
                 ARF_OutDSel <= 2'b00;  //PC'den address al.
                 
                 Mem_CS <= 0;    //when CS is one memory's chip is active
                 Mem_WR <= 0;
                 
                 IR_LH <= 1;
                 IR_Write <= 1;
                 
                 //PC increment
                 ARF_FunSel <= 3'b001;      //Increment
                 ARF_RegSel <= 3'b011;      //PC is enabled (FunSel will apply to PC)   
             end
        end  
     end  
    
    reg[1:0] instruction_type;
    //decide the instruction type  
    always @(*)
    begin 
        case(_ALUSystem.IR.IROut[15:10])
            //instruction type <= 0 olanlar;
            6'b000000 : instruction_type <= 2'd0;
            6'b000001 : instruction_type <= 2'd0;
            6'b000010 : instruction_type <= 2'd0;
            6'b000011 : instruction_type <= 2'd0;
            6'b000100 : instruction_type <= 2'd0;
            6'b001100 : instruction_type <= 2'd0;
            6'b001101 : instruction_type <= 2'd0;
            6'b011110 : instruction_type <= 2'd0;
            6'b100000 : instruction_type <= 2'd0;
            6'b100001 : instruction_type <= 2'd0;

            ///////////////////////////////
            //instruction type <= 1 olanlar;
            6'b00_0111 : instruction_type <= 2'd1;
            6'b00_1000 : instruction_type <= 2'd1;
            6'b00_1001 : instruction_type <= 2'd1;
            6'b00_1010 : instruction_type <= 2'd1;
            6'b00_1011 : instruction_type <= 2'd1;
            6'b00_1100 : instruction_type <= 2'd1;
            6'b00_1101 : instruction_type <= 2'd1;
            6'b00_1110 : instruction_type <= 2'd1;
            6'b00_1111 : instruction_type <= 2'd1;

            6'b01_0000 : instruction_type <= 2'd1;
            6'b01_0110 : instruction_type <= 2'd1;
            6'b01_0111 : instruction_type <= 2'd1;
            6'b01_1000 : instruction_type <= 2'd1;
            6'b01_1001 : instruction_type <= 2'd1;
            6'b01_1010 : instruction_type <= 2'd1;
            6'b01_1011 : instruction_type <= 2'd1;
            6'b01_1100 : instruction_type <= 2'd1;
            6'b01_1101 : instruction_type <= 2'd1;
            
            ///////////////////////////////
            //instruction type selin <= 2
            6'b00_0101 : instruction_type <= 2'd2;
            6'b00_0110 : instruction_type <= 2'd2;
            6'b01_0001 : instruction_type <= 2'd2;
            6'b01_0100 : instruction_type <= 2'd2;
        endcase
    end

    //T[2] || T[3] || T[4] || T[5] || T[6] || T[7]
    always @(*)
    begin
        if(instruction_type == 2'd0)
        begin
            case(_ALUSystem.IR.IROut[15:10])
     /////////////////////////////////////////////////
            6'b000000 : begin   //BRA
                if(T[2] == 1)      //Increment PC
                begin
                    ARF_FunSel <= 3'b001;      //Increment
                    ARF_RegSel <= 3'b011;      //PC is enabled (FunSel will apply to PC)   
                end
                                    
                if(T[3] == 1'b1) begin
                //Send PC to ALU
                    //Write IR to AR
                    MuxBSel = 2'b11;
                    ARF_FunSel = 3'b010;        //Load
                    ARF_RegSel = 3'b101;        //AR enabled
                    ARF_OutCSel = 2'b00;        //PC send to OutC
                    
                    MuxASel = 2'b01;
                    
                    RF_FunSel = 3'b010;         //Load
                    RF_ScrSel = 4'b0111;                 
                end
                if(T[4] == 1'b1) begin
                //Send VALUE to ALU
                    //VALUE <- M[AR]                             
                    ARF_OutDSel = 2'b10;
                    
                    //Memory part
                    Mem_CS = 1'b0;
                    Mem_WR = 1'b0;              //Read
                    
                    MuxASel = 2'b10;
                    
                    RF_FunSel = 3'b010;
                    RF_ScrSel = 4'b1011;        //S2
                    RF_OutBSel = 3'b101;
                    RF_OutASel = 3'b100;        //S1
                    
                    ALU_WF = 1'b0;
                    ALU_FunSel = 5'b10100;   
                    
                    //Put output of ALU to PC                     
                    MuxBSel = 2'b00;  
                    ARF_FunSel = 3'b010;        //Load
                    ARF_RegSel = 3'b011;           
                    
                    //SC Reset
                    SC_Reset = 1;   
                end
            end
    //////////////////////////////////////////////////////////////////////////////             
            6'b000001 : begin   //BNE
                if(_ALUSystem.ALU.FlagsOut[3] == 0) begin
                    if(T[2] == 1)      //Increment PC
                    begin
                        ARF_FunSel <= 3'b001;      //Increment
                        ARF_RegSel <= 3'b011;      //PC is enabled (FunSel will apply to PC)   
                    end
                    if(T[3] == 1'b1) begin
                    //Send PC to ALU
                        //Write IR to AR
                        MuxBSel = 2'b11;
                        ARF_FunSel = 3'b010;        //Load
                        ARF_RegSel = 3'b101;        //AR enabled
                        ARF_OutCSel = 2'b00;        //PC send to OutC
                        
                        MuxASel = 2'b01;
                        
                        RF_FunSel = 3'b010;         //Load
                        RF_ScrSel = 4'b0111;
                        
                    end
                    if(T[4] == 1'b1) begin
                    //Send VALUE to ALU
                        //VALUE <- M[AR]                             
                        ARF_OutDSel = 2'b10;
                        
                        //Memory part
                        Mem_CS = 1'b0;
                        Mem_WR = 1'b0;              //Read
                        
                        MuxASel = 2'b10;
                        
                        RF_FunSel = 3'b010;
                        RF_ScrSel = 4'b1011;        //S2
                        RF_OutBSel = 3'b101;
                        RF_OutASel = 3'b100;        //S1
                        
                        ALU_WF = 1'b0;
                        ALU_FunSel = 5'b10100;   
                        
                        //Put output of ALU to PC                     
                        MuxBSel = 2'b00;  
                        ARF_FunSel = 3'b010;        //Load
                        ARF_RegSel = 3'b011;  
                        
                        //SC Reset
                        SC_Reset = 1;              
                    end
                end                 
            end
    //////////////////////////////////////////////////////////////////////////////             
            6'b000010 : begin   //BEQ
                if(_ALUSystem.ALU.FlagsOut[3] == 1) begin
                
                    if(T[2] == 1)      //Increment PC
                    begin
                    ARF_FunSel <= 3'b001;      //Increment
                    ARF_RegSel <= 3'b011;      //PC is enabled (FunSel will apply to PC)   
                    end                 
                    if(T[3] == 1'b1) begin
                    //Send PC to ALU
                        //Write IR to AR
                        MuxBSel = 2'b11;
                        ARF_FunSel = 3'b010;        //Load
                        ARF_RegSel = 3'b101;        //AR enabled
                        
                        
                        MuxASel = 2'b01;
                        
                        RF_FunSel = 3'b010;         //Load
                        RF_ScrSel = 4'b0111;
                        
                    end
                    if(T[4] == 1'b1) begin
                    //Send VALUE to ALU
                        //VALUE <- M[AR]                             
                        ARF_OutDSel = 2'b10;
                        ARF_OutCSel = 2'b00;        //PC send to OutC
                        
                        //Memory part
                        Mem_CS = 1'b0;
                        Mem_WR = 1'b0;              //Read
                        
                        MuxASel = 2'b10;
                        
                        RF_FunSel = 3'b010;
                        RF_ScrSel = 4'b1011;        //S2
                        RF_OutBSel = 3'b101;
                        RF_OutASel = 3'b100;        //S1
                        
                        ALU_WF = 1'b0;
                        ALU_FunSel = 5'b10100;   
                        
                        //Put output of ALU to PC                     
                        MuxBSel = 2'b00;  
                        ARF_FunSel = 3'b010;        //Load
                        ARF_RegSel = 3'b011;  
                        
                        //SC Reset
                        SC_Reset = 1;              
                    end
                end             
            end
    //////////////////////////////////////////////////////////////////////             
            6'b000011 : begin   //POP
                if(T[2] == 1)
                begin
                    //SP <= SP + 1 and PC <= PC + 1 
                    ARF_RegSel <= 3'b010;
                    ARF_FunSel <= 3'b001;
                    
                    //Rx <= M[SP] RF'e LSB'i write
                    Mem_CS <= 0;
                    Mem_WR <= 0;
                    
                    ARF_OutDSel <= 2'b11;
                    
                    MuxASel <= 2'b10;
                    
                    RF_FunSel <= 3'b100;    //clear write low
                    //cases for RF_RegSel
                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00: RF_RegSel <= 0111;   //R1
                        2'b01: RF_RegSel <= 1011;   //R2
                        2'b10: RF_RegSel <= 1101;   //R3
                        2'b11: RF_RegSel <= 1110;   //R4
                    endcase 
                end

                if(T[3] == 1)
                begin   
                    //Increment SP
                    ARF_RegSel <= 3'b110;       //SP
                    ARF_FunSel <= 3'b001;
                    
                    //Rx <= M[SP] RF'e MSB'i write
                    Mem_CS <= 0;
                    Mem_WR <= 0;
                    
                    ARF_OutDSel <= 2'b11;
                    
                    MuxASel <= 2'b10;
                    
                    RF_FunSel <= 3'b110;    //only write high
                    //cases for RF_RegSel
                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00: RF_RegSel <= 0111;   //R1
                        2'b01: RF_RegSel <= 1011;   //R2
                        2'b10: RF_RegSel <= 1101;   //R3
                        2'b11: RF_RegSel <= 1110;   //R4
                    endcase 

                    //SC Reset
                    SC_Reset = 1;     
                end 
            end            
    ///////////////////////////////////////
            6'b000100 : begin   //PSH         
                if(T[2] == 1) begin         
                //PC <= PC + 1
                    ARF_RegSel <= 3'b010;
                    ARF_FunSel <= 3'b001;                    
                    
                    //M[SP] <= Rx LSB write
                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00: RF_RegSel <= 0111;   //R1
                        2'b01: RF_RegSel <= 1011;   //R2
                        2'b10: RF_RegSel <= 1101;   //R3
                        2'b11: RF_RegSel <= 1110;   //R4
                    endcase    
                    
                    ALU_FunSel <= 5'b10000;         //A
                    
                    MuxCSel <= 1'b0;   //önce LSB write
                    
                    Mem_WR <= 1'b1;    //write
                    Mem_CS <= 1'b0;
                    
                    ARF_OutDSel <= 2'b11;      //SP                 
                end
                if(T[3] == 1) begin
                //SP'deki bilgiyi AR'ye yolla 
                    ARF_OutCSel <= 2'b11;
                    MuxBSel <= 2'b01;
                    
                    ARF_FunSel <= 3'b010;
                    ARF_RegSel <= 3'b101;   //AR
                end
                if(T[4] == 1) begin
                    // AR increment ve momory write
                    ARF_RegSel <= 3'b101;   //AR only
                    ARF_FunSel <= 3'b001;   //increment
                    
                    //memmory write
                    //M[SP] <= Rx MSB write
                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00: RF_RegSel <= 0111;   //R1
                        2'b01: RF_RegSel <= 1011;   //R2
                        2'b10: RF_RegSel <= 1101;   //R3
                        2'b11: RF_RegSel <= 1110;   //R4
                    endcase    
                    
                    ALU_FunSel <= 5'b10000;         //A
                    
                    MuxCSel <= 1'b1;   //MSB write
                    
                    Mem_WR <= 1'b1;    //write
                    Mem_CS <= 1'b0;
                    
                    ARF_OutDSel <= 2'b10;      //AR
                end
                
                if(T[5] == 1) begin    
                    //SP decrement
                    ARF_RegSel <= 3'b110;
                    ARF_FunSel <= 3'b000;
                    //SC Reset
                    SC_Reset = 1; 
                end
            end 
    ////////////////////////////////////////////
            6'b001100 : begin   //LDR
                if(T[2] == 1) begin
                    //PC <= PC + 1 
                    ARF_RegSel <= 3'b011;       //only PC
                    ARF_FunSel <= 3'b001;       //increment
                    
                    //Rx <= M[AR] LSB read yap? RF'e write
                    Mem_CS <= 0;
                    Mem_WR <= 0;
                    
                    ARF_OutDSel <= 2'b10;       //AR
                    
                    MuxASel <= 2'b10;       //Memory
                    
                    RF_FunSel <= 3'b100;    //Clear write low       
                    //cases for RF_RegSel
                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00: RF_RegSel <= 0111;   //R1
                        2'b01: RF_RegSel <= 1011;   //R2
                        2'b10: RF_RegSel <= 1101;   //R3
                        2'b11: RF_RegSel <= 1110;   //R4
                    endcase 
                    
                end
                if(T[3] == 1)
                begin
                    //AR increment ve Memory read
                    ARF_RegSel <= 3'b101;       //only AR
                    ARF_FunSel <= 3'b001;       //increment
                    
                    //Memory read
                    Mem_CS <= 0;
                    Mem_WR <= 0;
                    
                    ARF_OutDSel <= 2'b10;       //AR
                    
                    MuxASel <= 2'b10;       //Memory
                    
                    //RF'ye MSB write
                    
                    RF_FunSel <= 3'b110;    //only write high       
                    //cases for RF_RegSel
                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00: RF_RegSel <= 0111;   //R1
                        2'b01: RF_RegSel <= 1011;   //R2
                        2'b10: RF_RegSel <= 1101;   //R3
                        2'b11: RF_RegSel <= 1110;   //R4
                    endcase 
                    
                    //SC Reset
                    SC_Reset = 1;    
                end 
            end
    ///////////////////////////////////////////
            6'b001101 : begin    //STR
                if(T[2] == 1) begin    
                    //PC <= PC + 1
                    ARF_RegSel <= 3'b010;
                    ARF_FunSel <= 3'b001;
                    
                    //Rx'i memorye yolla
                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00: RF_RegSel <= 0111;   //R1
                        2'b01: RF_RegSel <= 1011;   //R2
                        2'b10: RF_RegSel <= 1101;   //R3
                        2'b11: RF_RegSel <= 1110;   //R4
                    endcase
                    
                    ALU_FunSel <= 5'b10000;         //A
                    
                    //Write to mem LSB
                    MuxCSel <= 1'b0;    //LSB seç
                    Mem_WR <= 1'b1;
                    Mem_CS <= 1'b0;
                    ARF_OutDSel <= 2'b10;           //AR   
                end
                if(T[3] == 1) begin
                    //write the MSB
                    
                    //increment AR
                    ARF_RegSel <= 3'b101;   //AR only
                    ARF_FunSel <= 3'b001;   //increment
                    
                    //Rx'i memorye yolla
                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00: RF_RegSel <= 0111;   //R1
                        2'b01: RF_RegSel <= 1011;   //R2
                        2'b10: RF_RegSel <= 1101;   //R3
                        2'b11: RF_RegSel <= 1110;   //R4
                    endcase
                    
                    ALU_FunSel <= 5'b10000;         //A
                    
                    //Write to mem LSB
                    MuxCSel <= 1'b1;    //MSB seç
                    Mem_WR <= 1'b1;
                    Mem_CS <= 1'b0;
                    ARF_OutDSel <= 2'b10;           //AR   
                    
                    //SC Reset
                    SC_Reset = 1;    
                end             
            end   
    ///////////////////////////////////////////
            6'b011110 : begin    //BX
                if(T[2] == 1) begin 
                    //PC <= PC + 1 
                    ARF_RegSel <= 3'b011;       //only PC
                    ARF_FunSel <= 3'b001;       //increment
            
                    //PC'yi MuxC'ye getir
                    ARF_OutCSel <= 2'b00;   //PC
                    MuxASel <= 2'b01;   //ARF
                
                    RF_FunSel <= 3'b010;    //load
                    RF_ScrSel <= 4'b0111;   //Scr1 
                
                    RF_OutASel <= 3'b100;   //Scr1
                
                    ALU_FunSel <=  5'b10000; // A
                    MuxCSel <= 0;   //LSB
                
                    //SP memory address yap ve memory write yap
                    ARF_OutDSel <= 2'b11;
                
                    Mem_CS <= 0;
                    Mem_WR <= 1;
                end
            
                if(T[3] == 1) begin
                    //SP increment and write MSB
                    ARF_RegSel <= 3'b110;       //only SP
                    ARF_FunSel <= 3'b001;       //increment
                
                    //PC'yi MuxC'ye getir
                    ARF_OutCSel <= 2'b00;   //PC
                    MuxASel <= 2'b01;   //ARF
                
                    RF_FunSel <= 3'b010;    //load
                    RF_ScrSel <= 4'b1011;   //Scr2 
                
                    RF_OutASel <= 3'b101;   //Scr2
                
                    ALU_FunSel <=  5'b10000; // A
                    MuxCSel <= 1;   //MSB
                    
                    //SP memory address yap ve memory write yap
                    ARF_OutDSel <= 2'b11;
                
                    Mem_CS <= 0;
                    Mem_WR <= 1;
                end
                if(T[4] == 1) begin
                    ARF_OutCSel <= 2'b00;   //PC
                    MuxASel <= 2'b01;
                
                    RF_FunSel <= 3'b010;    //load
                
                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00: RF_RegSel <= 0111;   //R1
                        2'b01: RF_RegSel <= 1011;   //R2
                        2'b10: RF_RegSel <= 1101;   //R3
                        2'b11: RF_RegSel <= 1110;   //R4
                    endcase 
                
                    //SC Reset
                    SC_Reset = 1; 
                end
            end

    /////////////////////////////////////////////
            6'b011111:  //BL
            begin 
                if(T[2] == 1)
                begin
                    //PC increment
                    ARF_RegSel <= 3'b011;       //only PC
                    ARF_FunSel <= 3'b001;       //increment
                    
                    //Memory read
                    Mem_CS <= 0;
                    Mem_WR <= 0;
                    ARF_OutDSel <= 2'b11;       //SP
                    
                    //SCR1'e LSB write
                    RF_FunSel <= 3'b100;    //Clear write low  
                    RF_ScrSel <= 4'b0111;    //S1
                end
                
                if(T[3] == 1)
                begin
                     //SP increment
                     ARF_RegSel <= 3'b110;       //only AR
                     ARF_FunSel <= 3'b001;       //increment
                     
                     //Memory read
                     Mem_CS <= 0;
                     Mem_WR <= 0;
                     ARF_OutDSel <= 2'b11;       //SP
                     
                     //SCR1'e MSB write
                     RF_FunSel <= 3'b110;    //only write high  
                     RF_ScrSel <= 4'b0111;    //S1
                end
                
                if(T[4] == 1)
                begin
                    RF_OutASel <= 3'b100;
                    ALU_FunSel  <= 5'b10000;         //A
                    
                    MuxBSel <= 2'b00;   //ALUOut
                    ARF_FunSel <= 3'b010;   //load
                    ARF_RegSel <= 3'b011;   //PC
                    
                    SC_Reset = 1; 
                end
            end 
    /////////////////////////////////////////////            
            6'b100000 : begin    //LDRIM
                if(T[2] == 1) begin
                    //PC <= PC + 1 
                    ARF_RegSel <= 3'b011;       //only PC
                    ARF_FunSel <= 3'b001;       //increment     
                end
                if(T[3] == 1) begin
                    //AR <- IR
                    MuxBSel <= 2'b11;        
                    ARF_FunSel <= 3'b010;       //Load
                    ARF_RegSel <= 3'b101;       //AR enabled
                    
                    //Memory read
                    Mem_CS <= 1'b0;
                    Mem_WR <= 1'b0;             //Read
                    ARF_OutDSel <= 2'b10;       //AR sent
                    
                    MuxASel <= 2'b10;           //MemOut sent
                    
                    //Write VALUE to selected Rx
                    RF_FunSel <= 3'b010;        //Load
                    
                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00: RF_RegSel <= 4'b0111;   //R1
                        2'b01: RF_RegSel <= 4'b1011;   //R2
                        2'b10: RF_RegSel <= 4'b1101;   //R3
                        2'b11: RF_RegSel <= 4'b1110;   //R4
                    endcase
                    
                    //SC Reset
                    SC_Reset = 1;                    
                end
            end             
    ///////////////////////////////////////////////////////////////////////////
            6'b100001 : begin    //STRIM
                if(T[2] == 1) begin
                    //PC <= PC + 1 
                    ARF_RegSel <= 3'b011;       //only PC
                    ARF_FunSel <= 3'b001;       //increment 
                
                end
                if(T[3] == 1) begin
                    //Scr1 <- AR
                    ARF_RegSel <= 3'b101;   //AR enabled
                    ARF_OutCSel <= 2'b10;   //AR
                    MuxASel <= 2'b01;       //ARFOut
                    
                    //Write to S2
                    RF_FunSel <= 3'b010;    //Load
                    RF_ScrSel <= 4'b1011;   //S2 enabled
                                  
                end
                if(T[4] == 1) begin
                    IR_Write <= 0;
                    MuxBSel <= 2'b11;
                    ARF_OutDSel <= 2'b10;
                    ARF_FunSel <= 3'b010;
                    ARF_RegSel <= 3'b101;
                    Mem_CS <= 0;
                    Mem_WR <= 0;
                    MuxASel <= 2'b10;

                    RF_ScrSel <= 4'b0111;
                    RF_FunSel<= 3'b010;
                    RF_OutASel <= 3'b100;
                    RF_OutBSel <= 3'b101;
                    ALU_FunSel <=  5'b10000;
                                      
                end
                if(T[5] == 1) begin
                    
                    MuxBSel <= 2'b00;
                    ARF_FunSel <= 3'b010;
                    ARF_RegSel <= 3'b101;
                    ARF_OutDSel <= 2'b10;

                    //send Rx to mem
                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00: RF_OutASel <= 3'b000;   //R1
                        2'b01: RF_OutASel <= 3'b001;  //R2
                        2'b10: RF_OutASel <= 3'b010;   //R3
                        2'b11: RF_OutASel <= 3'b011;   //R4
                    endcase

                    ALU_FunSel <= 5'b10000;
                    MuxCSel <= 0;                     
                end
                if(T[6] == 1) begin
                    
                    ARF_FunSel <= 3'b001;
                    ARF_RegSel <= 3'b101;
                    ARF_OutDSel <= 2'b10;

                    //send Rx to mem
                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00: RF_OutASel <= 3'b000;   //R1
                        2'b01: RF_OutASel <= 3'b001;  //R2
                        2'b10: RF_OutASel <= 3'b010;   //R3
                        2'b11: RF_OutASel <= 3'b011;   //R4
                    endcase

                    ALU_FunSel <= 5'b10000;
                    MuxCSel <= 1; 

                    SC_Reset <= 1;

                end
            end
    //////////////////////////////////////////////////////////////////////////
            endcase
        end

        if(instruction_type == 2'd1)
        begin
          ///////////////////////DTREGLER
          if(T[2] == 1)
          begin
                //PC <= PC + 1 
                ARF_RegSel <= 3'b011;       //only PC
                ARF_FunSel <= 3'b001;       //increment 

                //AR Scr1'e gitsin
                ARF_OutCSel <= 2'b10;   //AR
                MuxASel <= 2'b01;

                RF_FunSel <= 3'b010;    //load
                RF_ScrSel <= 4'b0111;
          end
          if(T[3] == 1)
          begin
                //PC Scr2'e gitsin
                ARF_OutCSel <= 2'b00;   //PC
                MuxASel <= 2'b01;

                RF_FunSel <= 3'b010;    //load
                RF_ScrSel <= 4'b1011;
          end
          if(T[4] == 1)
          begin
                //SP Scr3'e gitsin
                ARF_OutCSel <= 2'b11;   //SP
                MuxASel <= 2'b01;

                RF_FunSel <= 3'b010;    //load
                RF_ScrSel <= 4'b1101;
                
                
                case(_ALUSystem.IR.IROut[9])
                        1'b1:ALU_WF <= 1;
                        1'b0:ALU_WF <= 0;
                endcase
                    
                //cases for SREG1
                case(_ALUSystem.IR.IROut[5:3])
                    3'b000 : RF_OutASel <= 3'b101;  //PC
                    3'b001 : RF_OutASel <= 3'b101;  //PC
                    3'b010 : RF_OutASel <= 3'b110;  //SP
                    3'b011 : RF_OutASel <= 3'b100;  //AR

                    3'b100 : RF_OutASel <= 3'b000;  //R1
                    3'b101 : RF_OutASel <= 3'b001;  //R2
                    3'b110 : RF_OutASel <= 3'b010;  //R3
                    3'b111 : RF_OutASel <= 3'b011;  //R4
                endcase
                //cases for SREG2
                case(_ALUSystem.IR.IROut[2:0])
                    3'b000 : RF_OutBSel <= 3'b101;  //PC
                    3'b001 : RF_OutBSel <= 3'b101;  //PC
                    3'b010 : RF_OutBSel <= 3'b110;  //SP
                    3'b011 : RF_OutBSel <= 3'b100;  //AR

                    3'b100 : RF_OutBSel <= 3'b000;  //R1
                    3'b101 : RF_OutBSel <= 3'b001;  //R2
                    3'b110 : RF_OutBSel <= 3'b010;  //R3
                    3'b111 : RF_OutBSel <= 3'b011;  //R4
                endcase

                //cases for opcode: to choose the ALUFunsel
                case(_ALUSystem.IR.IROut[15:10])
                    6'b00_0111 : ALU_FunSel <= 5'b11011;
                    6'b00_1000 : ALU_FunSel <= 5'b11100;
                    6'b00_1001 : ALU_FunSel <= 5'b11101;
                    6'b00_1010 : ALU_FunSel <= 5'b11110;
                    6'b00_1011 : ALU_FunSel <= 5'b11111;
                    6'b00_1100 : ALU_FunSel <= 5'b10111;
                    6'b00_1101 : ALU_FunSel <= 5'b11000;
                    6'b00_1110 : ALU_FunSel <= 5'b10010;
                    6'b00_1111 : ALU_FunSel <= 5'b11001;
                    6'b01_0000 : ALU_FunSel <= 5'b11010;
                    
                    6'b01_0101 : ALU_FunSel <= 5'b10100;
                    6'b01_0110 : ALU_FunSel <= 5'b10101;
                    6'b01_0111 : ALU_FunSel <= 5'b10110;
                    6'b01_1000 : ALU_FunSel <= 5'b10000;
                    6'b01_1001 : ALU_FunSel <= 5'b10100;
                    6'b01_1010 : ALU_FunSel <= 5'b10110;
                    6'b01_1011 : ALU_FunSel <= 5'b10111;
                    6'b01_1100 : ALU_FunSel <= 5'b11000;
                    6'b01_1101 : ALU_FunSel <= 5'b11001;
                endcase   
          end
          if(T[5] == 1)
          begin
            //DSTREG LOAD
            case(_ALUSystem.IR.IROut[8:6])
                //ARF LOAD
                3'b000:
                begin
                    MuxBSel <= 2'b00;
                    ARF_FunSel <= 3'b010;
                    ARF_RegSel <= 3'b011; 
                end
                3'b001:
                begin
                    MuxBSel <= 2'b00;
                    ARF_FunSel <= 3'b010;
                    ARF_RegSel <= 3'b011; 
                end
                3'b010:    //SP
                begin
                    MuxBSel <= 2'b00;
                    ARF_FunSel <= 3'b010;
                    ARF_RegSel <= 3'b110; 
                end
                3'b011:     //AR
                begin
                    MuxBSel <= 2'b00;
                    ARF_FunSel <= 3'b010;
                    ARF_RegSel <= 3'b101; 
                end

                //RF LOAD
                3'b100:     //R1
                begin
                    MuxASel <= 2'b00;
                    RF_FunSel <= 3'b010;
                    RF_RegSel <= 4'b0111; 
                end
                3'b000:     //R2
                begin
                    MuxASel <= 2'b00;
                    RF_FunSel <= 3'b010;
                    RF_RegSel <= 4'b1011; 
                end
                3'b000:     //R3
                begin
                    MuxASel <= 2'b00;
                    RF_FunSel <= 3'b010;
                    RF_RegSel <= 4'b1101; 
                end
                3'b000:     //R4
                begin
                    MuxASel <= 2'b00;
                    RF_FunSel <= 3'b010;
                    RF_RegSel <= 4'b1110; 
                end
            endcase

            //SC reset
            SC_Reset = 1; 
          end
        end

        if(instruction_type == 2'd2)
        begin
            case(_ALUSystem.IR.IROut[15:10])
            ////////////////////////////////////////////
            6'b000101 : begin   //INC
                //DSTREG <= SREG1 + 1
                if(_ALUSystem.IR.IROut[8] == 0 && _ALUSystem.IR.IROut[5] == 0) begin
                    //ARF <- ARF            
                    if(T[2] == 1) begin
                        //PC <= PC + 1 
                        ARF_RegSel <= 3'b011;       //only PC
                        ARF_FunSel <= 3'b001;       //increment                
                    end
                    if(T[3] == 1) begin
                        ARF_FunSel <= 3'b001;   //increment

                        //find: select and send the SREG1
                        case (_ALUSystem.IR.IROut[4:3])
                            00 : begin  //PC
                                ARF_RegSel <= 3'b011;
                                ARF_OutCSel <= 2'b00;
                            end
                            01 : begin  //PC
                                ARF_RegSel <= 3'b011;
                                ARF_OutCSel <= 2'b00;
                            end
                            10 : begin  //SP
                                ARF_RegSel <= 3'b110;
                                ARF_OutCSel <= 2'b11;
                            end
                            00 : begin  //AR
                                ARF_RegSel <= 3'b101;
                                ARF_OutCSel <= 2'b10;
                            end 
                        endcase

                        MuxBSel <= 2'b01;   //ARFOut
                    end
                    if(T[4] == 1) begin
                        ARF_FunSel <= 3'b010;   //Load

                        //Find: select dstreg
                        case (_ALUSystem.IR.IROut[7:6])
                            00 : ARF_RegSel <= 3'b011;  //PC
                            01 : ARF_RegSel <= 3'b011;
                            10 : ARF_RegSel <= 3'b110;  //SP
                            11 : ARF_RegSel <= 3'b101;  //AR
                        endcase

                        //SC Reset
                        SC_Reset = 1;   
                    end
                end
                if(_ALUSystem.IR.IROut[8] == 0 && _ALUSystem.IR.IROut[5] == 1) begin
                    //ARF <- RF + 1
                    if(T[2] == 1) begin
                        //PC <= PC + 1 
                        ARF_RegSel <= 3'b011;       //only PC
                        ARF_FunSel <= 3'b001;       //increment 

                        RF_FunSel <= 3'b001;        //increment
                        case (_ALUSystem.IR.IROut[4:3])
                            00 : begin
                                RF_RegSel <= 4'b0111;   //R1
                                RF_OutASel <= 3'b000;   //send R1 to ALU
                            end
                            01 : begin
                                RF_RegSel <= 4'b1011;   //R2
                                RF_OutASel <= 3'b001;   //send R2 to ALU
                            end
                            10 : begin
                                RF_RegSel <= 4'b1101;   //R3
                                RF_OutASel <= 3'b010;   //send R3 to ALU
                            end
                            11 : begin
                                RF_RegSel <= 4'b1110;   //R4
                                RF_OutASel <= 3'b011;   //send R4 to ALU
                            end                                                                        
                        endcase

                        //şu anda aluda sreg1
                        //onu arf ye yollayacağız
                        ALU_FunSel <= 5'b10000;     //A
                        //WF <- S
                        ALU_WF <= _ALUSystem.IR.IROut[9];

                        MuxBSel <= 2'b00;   //ALUOut
                    end
                    if(T[3] == 1) begin
                        //DSTREG e yaz I'yı
                        ARF_FunSel <= 3'b010;   //Load

                        //Find: select dstreg
                        case (_ALUSystem.IR.IROut[7:6])
                            00 : ARF_RegSel <= 3'b011;  //PC
                            01 : ARF_RegSel <= 3'b011;
                            10 : ARF_RegSel <= 3'b110;  //SP
                            11 : ARF_RegSel <= 3'b101;  //AR
                        endcase

                        //SC Reset
                        SC_Reset = 1;   

                    end 
                end
                if(_ALUSystem.IR.IROut[8] == 1 && _ALUSystem.IR.IROut[5] == 0) begin
                    //RF <- ARF
                    if(T[2] == 1) begin
                        //PC <= PC + 1 
                        ARF_RegSel <= 3'b011;       //only PC
                        ARF_FunSel <= 3'b001;       //increment                
                    end
                    if(T[3] == 1) begin
                        ARF_FunSel <= 3'b001;   //increment

                        //find: select and send the SREG1
                        case (_ALUSystem.IR.IROut[4:3])
                            00 : begin  //PC
                                ARF_RegSel <= 3'b011;
                                ARF_OutCSel <= 2'b00;
                            end
                            01 : begin  //PC
                                ARF_RegSel <= 3'b011;
                                ARF_OutCSel <= 2'b00;
                            end
                            10 : begin  //SP
                                ARF_RegSel <= 3'b110;
                                ARF_OutCSel <= 2'b11;
                            end
                            00 : begin  //AR
                                ARF_RegSel <= 3'b101;
                                ARF_OutCSel <= 2'b10;
                            end 
                        endcase

                        //send it to RF
                        MuxASel <= 2'b01;   //ARFOut

                        RF_FunSel <= 3'b010; //Load
                        //Find: select DSTREG
                        case (_ALUSystem.IR.IROut[7:6])
                            00 : RF_RegSel <= 4'b0111;  //R1
                            01 : RF_RegSel <= 4'b1011;  //R2   
                            10 : RF_RegSel <= 4'b1101;  //R3
                            11 : RF_RegSel <= 4'b1110;  //R4
                        endcase 

                        //SC Reset
                        SC_Reset = 1;                      
                    end                
                end
                if(_ALUSystem.IR.IROut[8] == 1 && _ALUSystem.IR.IROut[5] == 1) begin
                    //RF <- RF
                    if(T[2] == 1) begin
                        //PC <= PC + 1 
                        ARF_RegSel <= 3'b011;       //only PC
                        ARF_FunSel <= 3'b001;       //increment

                        RF_FunSel <= 3'b001;        //increment
                        //Find: select and send sreg1
                        case (_ALUSystem.IR.IROut[4:3])
                            00 : begin
                                RF_RegSel <= 4'b0111;   //R1
                                RF_OutASel <= 3'b000;   //send R1 to ALU
                            end
                            01 : begin
                                RF_RegSel <= 4'b1011;   //R2
                                RF_OutASel <= 3'b001;   //send R2 to ALU
                            end
                            10 : begin
                                RF_RegSel <= 4'b1101;   //R3
                                RF_OutASel <= 3'b010;   //send R3 to ALU
                            end
                            11 : begin
                                RF_RegSel <= 4'b1110;   //R4
                                RF_OutASel <= 3'b011;   //send R4 to ALU
                            end                                                                        
                        endcase

                        //şu anda aluda sreg1
                        //onu rf ye yollayacağız
                        ALU_FunSel <= 5'b10000;     //A
                        //WF <- S
                        ALU_WF <= _ALUSystem.IR.IROut[9];

                        MuxASel <= 2'b00;   //ALUOut
                    end
                    if(T[3] == 1) begin
                        //They are in I of RF
                        //find and put them in their places
                        RF_FunSel <= 3'b010;    //Load

                        case (_ALUSystem.IR.IROut[4:3])
                            00 : RF_RegSel <= 4'b0111;   //R1
                            01 : RF_RegSel <= 4'b1011;   //R2
                            10 : RF_RegSel <= 4'b1101;   //R3
                            11 : RF_RegSel <= 4'b1110;   //R4
                        endcase
                        
                        //SC Reset
                        SC_Reset = 1;                     
                    end
                end
            end   
    ////////////////////////////////////////////
            6'b000110 : begin   //DEC
                //DSTREG <= SREG1 - 1
                if(_ALUSystem.IR.IROut[8] == 0 && _ALUSystem.IR.IROut[5] == 0) begin
                    //ARF <- ARF            
                    if(T[2] == 1) begin
                        //PC <= PC + 1 
                        ARF_RegSel <= 3'b011;       //only PC
                        ARF_FunSel <= 3'b001;       //increment                
                    end
                    if(T[3] == 1) begin
                        ARF_FunSel <= 3'b000;   //decrement

                        //find: select and send the SREG1
                        case (_ALUSystem.IR.IROut[4:3])
                            00 : begin  //PC
                                ARF_RegSel <= 3'b011;
                                ARF_OutCSel <= 2'b00;
                            end
                            01 : begin  //PC
                                ARF_RegSel <= 3'b011;
                                ARF_OutCSel <= 2'b00;
                            end
                            10 : begin  //SP
                                ARF_RegSel <= 3'b110;
                                ARF_OutCSel <= 2'b11;
                            end
                            00 : begin  //AR
                                ARF_RegSel <= 3'b101;
                                ARF_OutCSel <= 2'b10;
                            end 
                        endcase

                        MuxBSel <= 2'b01;   //ARFOut
                    end
                    if(T[4] == 1) begin
                        ARF_FunSel <= 3'b010;   //Load

                        //Find: select dstreg
                        case (_ALUSystem.IR.IROut[7:6])
                            00 : ARF_RegSel <= 3'b011;  //PC
                            01 : ARF_RegSel <= 3'b011;
                            10 : ARF_RegSel <= 3'b110;  //SP
                            11 : ARF_RegSel <= 3'b101;  //AR
                        endcase

                        //SC Reset
                        SC_Reset = 1;   
                    end
                end
                if(_ALUSystem.IR.IROut[8] == 0 && _ALUSystem.IR.IROut[5] == 1) begin
                    //ARF <- RF - 1
                    if(T[2] == 1) begin
                        //PC <= PC + 1 
                        ARF_RegSel <= 3'b011;       //only PC
                        ARF_FunSel <= 3'b001;       //increment 

                        RF_FunSel <= 3'b000;        //decrement
                        case (_ALUSystem.IR.IROut[4:3])
                            00 : begin
                                RF_RegSel <= 4'b0111;   //R1
                                RF_OutASel <= 3'b000;   //send R1 to ALU
                            end
                            01 : begin
                                RF_RegSel <= 4'b1011;   //R2
                                RF_OutASel <= 3'b001;   //send R2 to ALU
                            end
                            10 : begin
                                RF_RegSel <= 4'b1101;   //R3
                                RF_OutASel <= 3'b010;   //send R3 to ALU
                            end
                            11 : begin
                                RF_RegSel <= 4'b1110;   //R4
                                RF_OutASel <= 3'b011;   //send R4 to ALU
                            end                                                                        
                        endcase

                        //şu anda aluda sreg1
                        //onu arf ye yollayacağız
                        ALU_FunSel <= 5'b10000;     //A
                        //WF <- S
                        ALU_WF <= _ALUSystem.IR.IROut[9];

                        MuxBSel <= 2'b00;   //ALUOut
                    end
                    if(T[3] == 1) begin
                        //DSTREG e yaz I'yı
                        ARF_FunSel <= 3'b010;   //Load

                        //Find: select dstreg
                        case (_ALUSystem.IR.IROut[7:6])
                            00 : ARF_RegSel <= 3'b011;  //PC
                            01 : ARF_RegSel <= 3'b011;
                            10 : ARF_RegSel <= 3'b110;  //SP
                            11 : ARF_RegSel <= 3'b101;  //AR
                        endcase

                        //SC Reset
                        SC_Reset = 1;   

                    end 
                end
                if(_ALUSystem.IR.IROut[8] == 1 && _ALUSystem.IR.IROut[5] == 0) begin
                    //RF <- ARF
                    if(T[2] == 1) begin
                        //PC <= PC + 1 
                        ARF_RegSel <= 3'b011;       //only PC
                        ARF_FunSel <= 3'b001;       //increment                
                    end
                    if(T[3] == 1) begin
                        ARF_FunSel <= 3'b000;   //decrement

                        //find: select and send the SREG1
                        case (_ALUSystem.IR.IROut[4:3])
                            00 : begin  //PC
                                ARF_RegSel <= 3'b011;
                                ARF_OutCSel <= 2'b00;
                            end
                            01 : begin  //PC
                                ARF_RegSel <= 3'b011;
                                ARF_OutCSel <= 2'b00;
                            end
                            10 : begin  //SP
                                ARF_RegSel <= 3'b110;
                                ARF_OutCSel <= 2'b11;
                            end
                            00 : begin  //AR
                                ARF_RegSel <= 3'b101;
                                ARF_OutCSel <= 2'b10;
                            end 
                        endcase

                        //send it to RF
                        MuxASel <= 2'b01;   //ARFOut

                        RF_FunSel <= 3'b010; //Load
                        //Find: select DSTREG
                        case (_ALUSystem.IR.IROut[7:6])
                            00 : RF_RegSel <= 4'b0111;  //R1
                            01 : RF_RegSel <= 4'b1011;  //R2   
                            10 : RF_RegSel <= 4'b1101;  //R3
                            11 : RF_RegSel <= 4'b1110;  //R4
                        endcase 

                        //SC Reset
                        SC_Reset = 1;                      
                    end                
                end
                if(_ALUSystem.IR.IROut[8] == 1 && _ALUSystem.IR.IROut[5] == 1) begin
                    //RF <- RF
                    if(T[2] == 1) begin
                        //PC <= PC + 1 
                        ARF_RegSel <= 3'b011;       //only PC
                        ARF_FunSel <= 3'b001;       //increment

                        RF_FunSel <= 3'b000;        //decrement
                        //Find: select and send sreg1
                        case (_ALUSystem.IR.IROut[4:3])
                            00 : begin
                                RF_RegSel <= 4'b0111;   //R1
                                RF_OutASel <= 3'b000;   //send R1 to ALU
                            end
                            01 : begin
                                RF_RegSel <= 4'b1011;   //R2
                                RF_OutASel <= 3'b001;   //send R2 to ALU
                            end
                            10 : begin
                                RF_RegSel <= 4'b1101;   //R3
                                RF_OutASel <= 3'b010;   //send R3 to ALU
                            end
                            11 : begin
                                RF_RegSel <= 4'b1110;   //R4
                                RF_OutASel <= 3'b011;   //send R4 to ALU
                            end                                                                        
                        endcase

                        //şu anda aluda sreg1
                        //onu rf ye yollayacağız
                        ALU_FunSel <= 5'b10000;     //A
                        //WF <- S
                        ALU_WF <= _ALUSystem.IR.IROut[9];

                        MuxASel <= 2'b00;   //ALUOut
                    end
                    if(T[3] == 1) begin
                        //They are in I of RF
                        //find and put them in their places
                        RF_FunSel <= 3'b010;    //Load

                        case (_ALUSystem.IR.IROut[4:3])
                            00 : RF_RegSel <= 4'b0111;   //R1
                            01 : RF_RegSel <= 4'b1011;   //R2
                            10 : RF_RegSel <= 4'b1101;   //R3
                            11 : RF_RegSel <= 4'b1110;   //R4
                        endcase
                        
                        //SC Reset
                        SC_Reset = 1;                     
                    end
                end
            end      
    ////////////////////////////////////////////
            6'b010001 : begin       //MOVH
                //Write to RF
                //Clear first, then write HIGH

                if(T[2] == 1) begin
                    //Increment PC, CLEAR RF, Find: select DSTREG

                    //PC <= PC + 1 
                    ARF_RegSel <= 3'b011;       //only PC
                    ARF_FunSel <= 3'b001;       //increment  

                    RF_FunSel <= 3'b011;    //clear

                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00 : RF_RegSel <= 4'b0111;   //R1
                        2'b01 : RF_RegSel <= 4'b1011;   //R2
                        2'b10 : RF_RegSel <= 4'b1101;   //R3
                        2'b11 : RF_RegSel <= 4'b1110;   //R4
                    endcase
                end
                if(T[3] == 1) begin
                    //send IR, write HIGH, Find: select DSTREG, sc reset
                    MuxASel <= 2'b11;   //IROut

                    RF_FunSel <= 3'b110;    //Write HIGH ONLY

                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00 : RF_RegSel <= 4'b0111;   //R1
                        2'b01 : RF_RegSel <= 4'b1011;   //R2
                        2'b10 : RF_RegSel <= 4'b1101;   //R3
                        2'b11 : RF_RegSel <= 4'b1110;   //R4
                    endcase

                    //SC Reset
                    SC_Reset = 1;
                end
            end
    /////////////////////////////////////////////////
            6'b010100 : begin       //MOVL
                //DSTREG(low) <- IMMEDIATE
                //use clear and write low
                //FunSel <- 3'b100

                //Write to RF
                if(T[2] == 1) begin
                    //Increment PC, send IR, clear and write low RF, Find: select DSTREG

                    //PC <= PC + 1 
                    ARF_RegSel <= 3'b011;       //only PC
                    ARF_FunSel <= 3'b001;       //increment 

                    MuxASel <= 2'b11;           //IROut 

                    RF_FunSel <= 3'b100;    //clear and low

                    case(_ALUSystem.IR.IROut[9:8])
                        2'b00 : RF_RegSel <= 4'b0111;   //R1
                        2'b01 : RF_RegSel <= 4'b1011;   //R2
                        2'b10 : RF_RegSel <= 4'b1101;   //R3
                        2'b11 : RF_RegSel <= 4'b1110;   //R4
                    endcase
                    //SC Reset
                    SC_Reset = 1;

                end
                
            end

            endcase
        end
    end
         
         
endmodule


