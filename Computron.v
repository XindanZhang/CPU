`timescale 1ps /1 ps
`include "RegisterFile.v "
`include "ALU.v "
`include "Memory.v "
`include "ControlUnit.v "
module Computron ;
    reg [ 7 : 0 ] programCounter ;
    reg [ 7 : 0 ] instructionReg1 ;
    reg [ 7 : 0 ] instructionReg2;
    reg clock ;
    wire [ 7 : 0 ] memoryAdress ;
    wire [ 7 : 0 ] dataOut ;
    wire [ 3 : 0 ] RFA1 ;
    wire [ 3 : 0 ] RFA2 = instructionReg2[ 3 : 0 ] ;
    wire [ 3 : 0 ] RFA3 = instructionReg1[ 3 : 0 ] ;

    wire [ 7 : 0 ] RFD1 ;
    wire [ 7 : 0 ] RFD2 ;
    wire [ 7 : 0 ] operand1 ;
    wire [ 7 : 0 ] operand2 ;
    wire [ 7 : 0 ] result1 ;
    wire [ 7 : 0 ] result2 ;
    wire [ 7 : 0 ] RFWD;
    wire [ 7 : 0 ] nextPC ;
    wire PCEnable ;
    wire IR1Enable ;
    wire IR2Enable ;
    wire ALUOutEnable ;
    wire memEnable ;
    wire regEnable ;
    wire zeroFlag ;
    wire overflowFlag ;
    wire WDSelect ;
    wire Operand1Select ;
    wire Operand2Select ;
    wire RegSelect ;
    wire AdrSelect ;
    wire PCSelect ;
    wire ALUControl;

    Memory mem(
        . data ( dataOut ) ,
        . clock ( clock ) ,
        . writeEnable (memEnable) ,
        . address ( memoryAdress ) ,
        . writeData (RFD1)) ;

    RegisterFile rf (
        . data1 (RFD1) ,
        . data2 (RFD2) ,
        . clock ( clock ) ,
        . writeEnable ( regEnable ) ,
        . address1 (RFA1) ,
        . address2 (RFA2) ,
        . address3 (RFA3) ,
        . writeData (RFWD)) ;

    ALU alu (
        . result1 ( result1 ) ,
        . result2 ( result2 ) ,
        . zeroFlag ( zeroFlag ) ,
        . overflowFlag ( overflowFlag ) ,
        . clock ( clock ) ,
        . ALUControl ( ALUControl ) ,
        . ALUEnable (ALUOutEnable ) ,
        . operand1 ( operand1 ) ,
        . operand2 ( operand2 ) ) ;

    ControlUnit cu (
        . PCEnable ( PCEnable ) ,
        . IR1Enable ( IR1Enable ) ,
        . IR2Enable ( IR2Enable ) ,
        . ALUOutEnable (ALUOutEnable ) ,
        . PCSelect ( PCSelect ) ,
        . AdrSelect ( AdrSelect) ,
        . RegSelect ( RegSelect) ,
        . WDSelect ( WDSelect ) ,
        . Operand1Select ( Operand1Select ) ,
        . Operand2Select ( Operand2Select ) ,
        . ALUControl ( ALUControl ) ,
        . memEnable(memEnable) ,
        . regEnable ( regEnable ) ,
        . clock ( clock ) ,
        . opcode ( instructionReg1 [7:4] ) ,//½«instructionReg1 [7:4]×÷Îªopcode£»
        . zeroFlag ( zeroFlag ) ,
        . overflowFlag ( overflowFlag ) ) ;

    always @ (posedge clock ) begin
        if ( PCEnable ) programCounter <= nextPC ;
        if ( IR1Enable ) instructionReg1 <= dataOut ;
        if ( IR2Enable ) instructionReg2 <= dataOut ;
    end
    assign nextPC = PCSelect ? instructionReg2: result1 ;
    assign RFWD = WDSelect ? dataOut : result1 ;
    assign operand1 = Operand1Select ? RFD1 : programCounter ;
    assign operand2 = Operand2Select ? RFD2 : 8'b0000_0001 ;
    assign RFA1 = RegSelect ? instructionReg1 [ 3 : 0 ] : instructionReg2[ 7 : 4 ] ;
    assign memoryAdress = AdrSelect ? instructionReg2 : programCounter ;
    initial begin
        $dumpfile("Computron.vcd ") ;
        $dumpvars;
        programCounter = 0;
        clock = 0;
        #500 $finish ;
    end
    always begin
        #1 clock = ~clock ;
    end
endmodule