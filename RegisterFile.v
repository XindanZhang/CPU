module RegisterFile(
    output [ 7 : 0 ] register1 ,//8位寄存器
    output [ 7 : 0 ] register2 ,
    output [ 7 : 0 ] register3 ,
    output [ 7 : 0 ] data1 ,
    output [ 7 : 0 ] data2 ,
    input clock ,
    input writeEnable ,
    input [ 3 : 0 ] address1 ,
    input [ 3 : 0 ] address2 ,
    input [ 3 : 0 ] address3 ,//输入为address3
    input [ 7 : 0 ] writeData
) ;
    reg [ 7 : 0 ] registerFile [ 15 : 0 ] ;//define register files as reg;
    reg [ 4 : 0 ] i ;
    initial begin
        for ( i = 0 ; i < 16 ; i = i + 1'b1 )
            registerFile[i] = 8'b0000_0000;//8位寄存器组清零
    end
    always @ (posedge clock) begin//如果A3有值，RF寄存器的写使能为1，则将address3的地址写为WD写数据
        if ( address3 )
            if ( writeEnable ) registerFile [ address3] <= writeData ;
    end
    assign data1 = registerFile[ address1 ] ;//data1作为地址1
    assign data2 = registerFile[ address2 ] ;//data2 as A2;
    assign register1 = registerFile[ 1 ] ;
    assign register2 = registerFile[ 2 ] ;
    assign register3 = registerFile[ 3 ] ;
endmodule