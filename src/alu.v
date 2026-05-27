module alu(
    aluOp, 
    funct7, 
    funct3, 
    saida
);

    input wire [1:0] aluOp;
    input wire [6:0] funct7;
    input wire [2:0] funct3;
    output reg [3:0] saida;

    always @(*) begin
        case (aluOp)
            // lw / sw soma para calcular endereço (base + imediato)
            2'b00: saida = 4'b0010; //add

            // bne → subtração para comparar registradores
            2'b01: saida = 4'b0110; //add

            // (add, xor, sll) → decodifica f3 e f7
            2'b10: begin
                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0000000)
                            saida = 4'b0010; //add
                        else
                            saida = 4'b1111; //default
                    end
                    3'b100: saida = 4'b0011; //xor
                    3'b001: saida = 4'b0101; //sll
                    default: saida = 4'b1111;
                endcase
            end

            //tipo i(addi) → f3=000, só soma (ignora f7)
            2'b11: begin
                case (funct3)
                    3'b000: saida = 4'b0010; //addi → add
                    default: saida = 4'b1111;
                endcase
            end

            default: saida = 4'b1111;
        endcase
    end
endmodule