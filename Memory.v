module Memory(
    output [ 7 : 0 ] data ,//dataOut
    input clock ,
    input writeEnable ,
    input [ 7 : 0 ] address ,//����memory address
    input [ 7 : 0 ] writeData
) ;
    reg [ 7 : 0 ] memory [ 255 : 0 ] ;//�洢��256λ
    initial $readmemb ( "FibonacciNrs.mem" , memory) ;
    always @ (posedge clock ) begin
        if ( writeEnable ) memory[ address ] <= writeData ;//memory �洢���еĴ洢����ַд������___����RFD1����
    end
    assign data = memory[address] ;//����RD��Ϊ�洢����ַ��
endmodule