/*
`include "src/pc.v"
`include "src/memoriaInstrucoes.v"
`include "src/bancoRegs.v"
`include "src/ula.v"
`include "src/memoriaDados.v"
`include "src/alu.v"
`include "src/mux.v"
`include "src/control.v"
`include "src/imm.v"
*/

module cd(
    input wire clk, //BOTAO-0: clock
    input wire reset, //BOTAO-1: reset
    input wire btn_reg, //BOTAO-2: avança indice do registrador
    input wire sw_retro, //SW1: retrocede indicie do registrador

    output wire [6:0] HEX0, //valor do registrador [3:0]
    output wire [6:0] HEX1, //valor do registrador [7:4]
    output wire [6:0] HEX2, //valor do registrador [11:8]
    output wire [6:0] HEX3, //valor do registrador [15:12]
    output wire [6:0] HEX4, //indice do registrador [3:0]
    output wire [6:0] HEX5, //indice do registrador [7:4]
    output wire [6:0] HEX6, //pc [3:0]
    output wire [6:0] HEX7, //pc [7:4]

    output wire [7:0] LEDG //índice do registrador em binário
);

    //fios
    wire [31:0] pcInsMem, instrucao, rd1, rd2, aluOut, rd;
    wire [31:0] aluSrcSaida, immSaida, writeBack, pcProx, nextIns, pcImm;
    wire [3:0] aluControlSaida;
    wire branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, zero;
    wire [1:0] aluOp;
    wire branchOrNot;

    wire clk_int    = ~clk; // borda de subida quando botão é pressionado
    wire reset_int  = ~reset; // 1 quando pressionado
    wire btn_reg_int = ~btn_reg;

    assign nextIns = pcInsMem + 32'h4;
    assign branchOrNot = branch & ~zero;
    assign pcImm = pcInsMem + immSaida;

    pc PC(
        .reset(reset),
        .clock(clk),
        .entrada(pcProx),
        .saida(pcInsMem)
    );

    memoriaInstrucoes memoriaInstrucoes(
        .endereco(pcInsMem),
        .instrucao(instrucao)
    );

    bancoRegs bancoRegs(
        .clk(clk),
        .rw(RegWrite),
        .r1(instrucao[19:15]),
        .r2(instrucao[24:20]),
        .wreg(instrucao[11:7]),
        .wd(writeBack),
        .rd1(rd1),
        .rd2(rd2),
        .debugIndex(regIndex),
        .debugValor(regValor)

    );

    imm imm(
        .instrucao(instrucao),
        .imediato(immSaida)
    );

    ula ula(
        .clk(clk),
        .aluControl(aluControlSaida),
        .data1(rd1),
        .data2(aluSrcSaida),
        .aluResult(aluOut),
        .zero(zero)
    );

    memoriaDados memoriaDados(
        .clk(clk),
        .memwrite(MemWrite),
        .memread(MemRead),
        .endereco(aluOut),
        .wd(rd2),
        .rd(rd)
    );

    alu alu(
        .aluOp(aluOp),
        .funct7(instrucao[31:25]),
        .funct3(instrucao[14:12]),
        .saida(aluControlSaida)
    );

    control control(
        .opcode(instrucao[6:0]),
        .branch(branch),
        .memread(MemRead),
        .memtoreg(MemToReg),
        .memwrite(MemWrite),
        .alusrc(ALUSrc),
        .regwrite(RegWrite),
        .aluop(aluOp)
    );

    mux MuxALUSrc(
        .controle(ALUSrc),
        .entrada1(rd2),
        .entrada2(immSaida),
        .saida(aluSrcSaida)
    );

    mux MuxMemToReg(
        .controle(MemToReg),
        .entrada1(aluOut),
        .entrada2(rd),
        .saida(writeBack)
    );

    mux MuxBranch(
        .controle(branchOrNot),
        .entrada1(nextIns),
        .entrada2(pcImm),
        .saida(pcProx)
    );

    //controle do indice
    reg [4:0] regIndex;
    reg btn_reg_prev;
    //reg sw_retro_prev;

    always @(posedge btn_reg_int or posedge reset_int) begin
        if (reset_int) begin
            regIndex     <= 5'd0;
            btn_reg_prev <= 1'b0;
        end else begin
            //BOTAO-2: avanca indice
            if (regIndex == 5'd31)
                regIndex <= 5'd0;
            else
                regIndex <= regIndex + 5'd1;
        end
    end

    wire [4:0] regIndexFinal;
    assign regIndexFinal = (sw_retro == 1'b1) ?
                           (regIndex == 5'd0 ? 5'd31 : regIndex - 5'd1) :
                           regIndex;

    //leitura do reg
    wire [31:0] regValor;
    //assign regValor = bancoRegs.registradores[regIndexFinal];


    seg7 d0(.numero(regValor[3:0]),   .display(HEX0));
    seg7 d1(.numero(regValor[7:4]),   .display(HEX1));
    seg7 d2(.numero(regValor[11:8]),  .display(HEX2));
    seg7 d3(.numero(regValor[15:12]), .display(HEX3));

    //HEX4-5: indice do registrador (00 a 1F)
    seg7 d4(.numero({3'b0, regIndexFinal[3:0]}), .display(HEX4));
    seg7 d5(.numero({3'b0, regIndexFinal[4]}),   .display(HEX5));

    //HEX6-7: PC em hex
    seg7 d6(.numero(pcInsMem[3:0]),  .display(HEX6));
    seg7 d7(.numero(pcInsMem[7:4]),  .display(HEX7));

    //LEDG: indice do registrador em binario
    assign LEDG = {3'b0, regIndexFinal};

endmodule






    /*always @(posedge clk or posedge reset) begin
        if (reset) begin
            regIndex      <= 5'd0;
            btn_reg_prev  <= 1'b1;
            sw_retro_prev <= 1'b1;
        end else begin
            //detecta borda de descida do botão (botão pressionado = 0)
            btn_reg_prev  <= btn_reg;
            sw_retro_prev <= sw_retro;

            //BOTAO-2: avança índice
            if (btn_reg_prev == 1'b1 && btn_reg == 1'b0) begin
                if (regIndex == 5'd31)
                    regIndex <= 5'd0;
                else
                    regIndex <= regIndex + 5'd1;
            end

            //SW1: retrocede índice
            if (sw_retro_prev == 1'b1 && sw_retro == 1'b0) begin
                if (regIndex == 5'd0)
                    regIndex <= 5'd31;
                else
                    regIndex <= regIndex - 5'd1;
            end
        end
    end

    //leitura do reg
    wire [31:0] regValor;
    //assign regValor = bancoRegs.registradores[regIndex];

    // displays

    //HEX0-3: valor do registrador em hex (32 bits = 8 dígitos hex, mostra 16 bits baixos)
    seg7 d0(.numero(regValor[3:0]),   .display(HEX0));
    seg7 d1(.numero(regValor[7:4]),   .display(HEX1));
    seg7 d2(.numero(regValor[11:8]),  .display(HEX2));
    seg7 d3(.numero(regValor[15:12]), .display(HEX3));

    //HEX4-5: índice do registrador (0-31)
    seg7 d4(.numero({3'b0, regIndex[3:0]}), .display(HEX4));
    seg7 d5(.numero({3'b0, regIndex[4]}),   .display(HEX5));

    //HEX6-7: PC completo em hex (mostra byte baixo)
    seg7 d6(.numero(pcInsMem[3:0]),  .display(HEX6));
    seg7 d7(.numero(pcInsMem[7:4]),  .display(HEX7));

    //LEDG: índice do registrador em binário
    assign LEDG = {3'b0, regIndex};

endmodule*/
