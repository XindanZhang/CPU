module Memory(
    output [ 7 : 0 ] data ,//dataOut
    input clock ,
    input writeEnable ,
    input [ 7 : 0 ] address ,//输入memory address
    input [ 7 : 0 ] writeData
) ;
    reg [ 7 : 0 ] memory [ 255 : 0 ] ;//存储器256位
    initial $readmemb ( "FibonacciNrs.mem" , memory) ;
    always @ (posedge clock ) begin
        if ( writeEnable ) memory[ address ] <= writeData ;//memory 存储器中的存储器地址写入数据___来自RFD1；；
    end
    assign data = memory[address] ;//数据RD赋为存储器地址；
endmodule