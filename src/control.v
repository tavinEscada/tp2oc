module control(
    opcode, 
    branch, 
    memread, 
    memtoreg, 
    aluop, 
    memwrite, 
    alusrc, 
    regwrite
    );

    input wire [6:0] opcode;
    output reg branch;
    output reg memread;
    output reg memtoreg;
    output reg [1:0] aluop;
    output reg memwrite;
    output reg alusrc;
    output reg regwrite;

    always @(*) begin
        case (opcode)

            7'b0000011: begin   // lw
                branch <= 0;
                memread <= 1;
                memtoreg <= 1;
                aluop <= 2'b00;
                memwrite <= 0;
                alusrc <= 1;
                regwrite <= 1;
            end

            7'b0100011: begin   //sw
                branch <= 0;
                memread <= 0;
                memtoreg <= 0;
                aluop <= 2'b00;
                memwrite <= 1;
                alusrc <= 1;
                regwrite <= 0;
            end

            7'b0110011: begin   //tipo r: add, xor, sll
                branch <= 0;
                memread <= 0;
                memtoreg <= 0;
                aluop <= 2'b10;
                memwrite <= 0;
                alusrc <= 0;
                regwrite <= 1;
            end

            7'b0010011: begin   //tipo i: addi
                branch <= 0;
                memread <= 0;
                memtoreg <= 0;
                aluop <= 2'b11;  //distingue de tipo r no alu
                memwrite <= 0;
                alusrc <= 1;
                regwrite <= 1;
            end

            7'b1100011: begin   //bne (tipo b)
                branch <= 1;
                memread <= 0;
                memtoreg <= 0;
                aluop <= 2'b01;
                memwrite <= 0;
                alusrc <= 0;
                regwrite <= 0;
            end

            default: begin
                branch <= 0;
                memread <= 0;
                memtoreg <= 0;
                aluop <= 2'b00;
                memwrite <= 0;
                alusrc <= 0;
                regwrite <= 0;
            end

        endcase
    end
endmodule