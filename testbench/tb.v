`include "./src/cd.v"
`timescale 1ns/100ps

module testbench();
    reg clk, reset;
    integer i, ciclos;

    cd cpu_inst(
        .clk(clk),
        .reset(reset)
    );

    initial begin
        reset = 1;
        clk   = 0;
        ciclos = 0;
        #6;
        $readmemb("./memoria/memInstrucoes.mem", cpu_inst.memoriaInstrucoes.memInst);
        $readmemb("./memoria/memReg.mem", cpu_inst.bancoRegs.registradores);
        $readmemb("./memoria/memData.mem", cpu_inst.memoriaDados.memoria);
        $dumpfile("bin/saida.vcd");
        $dumpvars(3, cpu_inst);
        #10 reset = 0;
    end

    always #1 clk = ~clk;

    always @(posedge clk) begin
        ciclos <= ciclos + 1;
        if (ciclos >= 30) begin
            
            for (i = 0; i < 32; i = i + 1)
                $display("Registrador %d = %d", i, cpu_inst.bancoRegs.registradores[i]);
            $finish();
        end
    end

endmodule