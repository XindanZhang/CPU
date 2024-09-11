module RegisterFile(
    output [ 7 : 0 ] register1 ,//8λ�Ĵ���
    output [ 7 : 0 ] register2 ,
    output [ 7 : 0 ] register3 ,
    output [ 7 : 0 ] data1 ,
    output [ 7 : 0 ] data2 ,
    input clock ,
    input writeEnable ,
    input [ 3 : 0 ] address1 ,
    input [ 3 : 0 ] address2 ,
    input [ 3 : 0 ] address3 ,//����Ϊaddress3
    input [ 7 : 0 ] writeData
) ;
    reg [ 7 : 0 ] registerFile [ 15 : 0 ] ;//define register files as reg;
    reg [ 4 : 0 ] i ;
    initial begin
        for ( i = 0 ; i < 16 ; i = i + 1'b1 )
            registerFile[i] = 8'b0000_0000;//8λ�Ĵ���������
    end
    always @ (posedge clock) begin//���A3��ֵ��RF�Ĵ�����дʹ��Ϊ1����address3�ĵ�ַдΪWDд����
        if ( address3 )
            if ( writeEnable ) registerFile [ address3] <= writeData ;
    end
    assign data1 = registerFile[ address1 ] ;//data1��Ϊ��ַ1
    assign data2 = registerFile[ address2 ] ;//data2 as A2;
    assign register1 = registerFile[ 1 ] ;
    assign register2 = registerFile[ 2 ] ;
    assign register3 = registerFile[ 3 ] ;
endmodule