module mux(controle, entrada1, entrada2, saida);
    input wire controle;
    input wire [31:0] entrada1, entrada2;
    output wire [31:0] saida;
    assign saida = controle ? entrada2 : entrada1;
endmodule