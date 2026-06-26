module memoriaInstrucoes(
    endereco,
    instrucao
    );

    input wire [31:0] endereco;
    output reg [31:0] instrucao;

    reg [31:0] memInst [0:63];

    initial begin
        //instrucoes
        memoriaIns[0] <= 32'b00000000101000000000000010010011; //addi x1 , x0 , 10
        memoriaIns[1] <= 32'b00000001010000000000000100010011; //addi x2 , x0 , 20
        memoriaIns[2] <= 32'b00000110010000000000000110010011; //addi x3 , x0 , 100
        memoriaIns[3] <= 32'b00000000000100011010000000100011; //sw x1 , 0( x3 )
        memoriaIns[4] <= 32'b00000000000000011010000100000011; //lw x2 , 0( x3 )
        memoriaIns[5] <= 32'b00000000010100010000000100010011; //addi x2 , x2 , -5
        
        /*memInst[0] = 32'b00000000000100000000000100110011; // add x2, x0, x1
        memInst[1] = 32'b00000000001000000000001100110011; // add x6, x0, x2
        memInst[2] = 32'b01000000001000110000000110110011; // sub x3, x6, x2
        memInst[3] = 32'b00000000001100010100001000110011; // xor x4, x2, x3
        memInst[4] = 32'b00000000001000001001001010110011; // sll x5, x1, x2
        memInst[5] = 32'b00000000010100001000010000010011; // addi x8, x1, 5
        memInst[6] = 32'b00000000100000001000010010010011; // addi x9, x1, 8
        memInst[7] = 32'b00000000000100001000010010010011; // addi x9, x1, 1
        */
    end

    always @(*) begin
        instrucao = memInst[endereco/4];
    end

endmodule
