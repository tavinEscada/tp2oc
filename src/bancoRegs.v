module bancoRegs(
    input wire clk,
    input wire rw,

    input wire [4:0] r1,
    input wire [4:0] r2,
    input wire [4:0] wreg,
    input wire [31:0] wd,

    output reg [31:0] rd1,
    output reg [31:0] rd2,

    // debug (para visualizar no top module)
    input wire [4:0] debugIndex,
    output wire [31:0] debugValor
);

    reg [31:0] registradores [0:31];
    integer i;

    // leitura combinacional
    always @(*) begin
        rd1 = registradores[r1];
        rd2 = registradores[r2];
    end

    // escrita síncrona + reset
    always @(posedge clk) begin
        if (rw && (wreg != 5'd0)) begin
            registradores[wreg] <= wd;
        end

        // garante x0 sempre zero (RISC-V padrão)
        registradores[0] <= 32'd0;
    end

    // debug (somente leitura externa)
    assign debugValor = registradores[debugIndex];

endmodule