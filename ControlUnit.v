module ControlUnit (
    output PCEnable,
    output IR1Enable,
    output IR2Enable,
    output ALUOutEnable ,
    output PCSelect ,
    output AdrSelect ,
    output RegSelect ,
    output WDSelect ,
    output Operand1Select ,
    output Operand2Select ,
    output ALUControl ,
    output memEnable ,
    output regEnable ,//使能加选择MUX
    input clock ,
    input [ 3 : 0 ] opcode ,//四位操作码
    input zeroFlag ,
    input overflowFlag ) ;
    reg PCEnable , IR1Enable , IR2Enable , ALUOutEnable , PCSelect , AdrSelect ,
    RegSelect , WDSelect , Operand1Select , Operand2Select , ALUControl ,
    memEnable , regEnable ;
    parameter loadInstruction = 0 ;
    parameter  decodeInstruction = 1 ;
    parameter loadStore = 2 ;
    parameter compute = 3 ;
    parameter jump = 4 ;
    parameter halt = 5 ;
    reg [ 3 : 0 ] state = loadInstruction ;
    reg [ 3 : 0 ] nextstate ;
    always @ (posedge clock ) state = nextstate ;
    always @ ( state , opcode ) begin
        case ( state)
            loadInstruction : begin 
                PCEnable = 1;
                IR1Enable = 1;//通过opcode
                IR2Enable = 0;
                ALUOutEnable = 0;
                PCSelect = 0;
                AdrSelect = 0;
                RegSelect = 0;
                WDSelect = 0;//通过加载指令
                Operand1Select = 0;
                Operand2Select = 0;
                ALUControl = 1;
                memEnable = 0;
                regEnable = 0;
                nextstate = decodeInstruction;
            end
            decodeInstruction : begin //Load Instruction
                IR1Enable = 0;
                IR2Enable = 1;
                //Decode Instruction
                if ( opcode == 4'b1011 ) begin
                    nextstate = halt ; //halt
                end
                else if ( opcode [ 3 : 2 ] == 2'b00 ) begin
                    nextstate = loadStore ; //lw , sw
                end
                else if ( opcode [ 3 : 2 ] == 2'b01 ) begin
                    nextstate = compute ; //add , sub
                end
                else if ( opcode [ 3 : 2 ] == 2'b10 ) begin
                    nextstate = jump ; //j , jcz , jco
                end
            end
            loadStore : begin //Loadword , Storeword
                PCEnable = 0;
                IR1Enable = 0;
                IR2Enable = 0;
                AdrSelect = 1;
                RegSelect = 1;
                WDSelect = 1;
                if ( opcode [0] == 0) regEnable = 1 ;
                else memEnable = 1 ;
                nextstate = loadInstruction ;
            end
            compute : begin //Compute Sum or Difference and store in ALUOut
                PCEnable = 0; IR1Enable = 0; IR2Enable = 0; ALUOutEnable = 1; RegSelect = 0; Operand1Select = 1; Operand2Select = 1; regEnable = 1; WDSelect = 0;
                if ( opcode [0] == 0) ALUControl = 1 ;
                else  ALUControl = 0 ;
                nextstate = loadInstruction ;
            end
            jump : begin // jump
                PCEnable = 0;
                if ( opcode [ 1 : 0 ] == 2'b00 ) PCEnable = 1 ;
                else if ( opcode [ 1 : 0 ] == 2'b01 && zeroFlag == 1) PCEnable = 1 ;
                else if ( opcode [ 1 : 0 ] == 2'b10 && overflowFlag == 1) PCEnable = 1 ;
                IR1Enable = 0;
                IR2Enable = 0;
                PCSelect = 1;
                nextstate = loadInstruction;
            end
            halt : begin
                PCEnable = 0;
                IR1Enable = 0;
                IR2Enable = 0;
                ALUOutEnable = 0;
            end
        endcase
    end
endmodule