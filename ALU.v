module ALU(
    output [7:0] result1 ,
    output [ 7 : 0 ] result2 ,
    output zeroFlag,
    output overflowFlag,
    input clock ,
    input ALUControl ,
    input ALUEnable ,
    input [ 7 : 0 ] operand1 ,
    input [ 7 : 0 ] operand2
) ;
    reg [ 8 : 0 ] internalResult ;
    reg [ 8 : 0 ] ALUResult ;
    always @ (*) begin
        internalResult = ALUControl ? operand1 + operand2 : operand1 - operand2;
    end
    always @ (posedge clock ) begin
        if ( ALUEnable )
            ALUResult = internalResult ;
    end
    assign zeroFlag= ! ALUResult ;
    assign overflowFlag = ALUResult [ 8 ] ;
    assign result1 = internalResult [ 7 : 0 ] ;
    assign result2 = ALUResult [ 7 : 0 ] ;
endmodule