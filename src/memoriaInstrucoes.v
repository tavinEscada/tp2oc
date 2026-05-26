module memoriaInstrucoes(
    endereco,
    instrucao
    );

    input wire [31:0] endereco;
    output reg [31:0] instrucao;

    reg [31:0] memInst [0:63];

    always @(*) begin
        instrucao = memInst[endereco/4];
    end

endmodule