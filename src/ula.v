module ula(
    aluControl, 
    data1, 
    data2, 
    aluResult, 
    zero, 
    clk
    );

    input clk;
    input [31:0] data1;
    input [31:0] data2;
    input [3:0] aluControl;
    output reg [31:0] aluResult;
    output reg zero;

    always @(*) begin
        case(aluControl)

            4'b0010: begin          //ADD → add, addi, lw, sw
                aluResult <= data1 + data2;
                zero <= 0;
            end

            4'b0011: begin          //XOR → xor
                aluResult <= data1 ^ data2;
                zero <= 0;
            end

            4'b0101: begin          //SLL → sll
                aluResult <= data1 << data2[4:0]; //só 5 bits de deslocamento
                zero <= 0;
            end

            4'b0110: begin          //SUB → bne (comparação)
                aluResult <= data1 - data2;
                if ((data1 - data2) == 32'b0)
                    zero <= 1;
                else
                    zero <= 0;
            end

            default: begin
                aluResult <= 32'b0;
                zero <= 0;
            end

        endcase
    end
endmodule