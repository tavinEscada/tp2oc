module bancoRegs(
    clk,
    rw, 
    r1, 
    r2, 
    wreg, 
    wd, 
    rd1, 
    rd2
);

    input wire clk;
    input wire rw;
    input wire [4:0] r1;
    input wire [4:0] r2;
    input wire [4:0] wreg;
    input wire[31:0] wd;
    output reg [31:0] rd1;
    output reg[31:0] rd2;
    reg [31:0] registradores [0:31];

    initial begin
    registradores[0] = 32'd0;   // x0 = 0
    registradores[1] = 32'd5;   // x1 = 5
    registradores[2] = 32'd3;   // x2 = 3
    //
end

    always @(registradores[0]) begin
        registradores[0] <= 0;
    end

    always @(posedge clk) begin
        if(rw == 1 && wreg != 5'b00000) begin
            registradores[wreg] <= wd;
        end
    end

    always @(*) begin
        rd1 = registradores[r1];
        rd2 = registradores[r2];
    end

    /*
    always @(r1 or registradores[r1]) begin
        rd1 = registradores[r1];
    end

    always @(r2 or registradores[r2]) begin
        rd2 = registradores[r2];
    end
    */

endmodule