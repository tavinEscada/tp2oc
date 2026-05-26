module imm(instrucao, imediato);
    input wire [31:0] instrucao;
    output reg [31:0] imediato;

    always @(*) begin
        case(instrucao[6:0])

            7'b0000011: //lw
                imediato <= {{20{instrucao[31]}}, instrucao[31:20]};

            7'b0100011: //sw
                imediato <= {{20{instrucao[31]}}, instrucao[31:25], instrucao[11:7]};

            7'b0010011: //addi
                imediato <= {{20{instrucao[31]}}, instrucao[31:20]};

            7'b1100011: //bne
                imediato <= {{19{instrucao[31]}}, instrucao[31], instrucao[7],
                             instrucao[30:25], instrucao[11:8], 1'b0};

            default:
                imediato <= 32'b0;

        endcase
    end
endmodule