`include "src/pc.v"
`include "src/memoriaInstrucoes.v"
`include "src/bancoRegs.v"
`include "src/ula.v"
`include "src/memoriaDados.v"
`include "src/alu.v"
`include "src/mux.v"
`include "src/control.v"
`include "src/imm.v"

module cd(
    input wire clk, 
    input wire reset

    );

    //fios para ligar modulos
    wire [31:0] pcInsMem, instrucao, rd1, rd2, aluOut, wd, rd, aluSrcSaida, immSaida, writeBack, pcProx;
    wire [3:0] aluControlSaida;
    wire branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, zero;
    wire [1:0] aluOp;
    wire [31:0] nextIns;
    wire [31:0] pcImm;
    wire branchOrNot;

    //descrevendo condições para endereço do PC

    assign nextIns = pcInsMem + 32'h4;
    assign branchOrNot = branch & ~zero;
    assign pcImm = pcInsMem + immSaida;

    // Instanciando módulos

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
        .rd2(rd2)
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
        //.clk(clk),
        .controle(ALUSrc),   
        .entrada1(rd2),
        .entrada2(immSaida), 
        .saida(aluSrcSaida)     
    );

    mux MuxMemToReg(
        //.clk(clk),
        .controle(MemToReg),   
        .entrada1(aluOut),
        .entrada2(rd), 
        .saida(writeBack)      
    );

    mux MuxBranch(
        //.clk(clk),
        .controle(branchOrNot),   
        .entrada1(nextIns),
        .entrada2(pcImm), 
        .saida(pcProx)      
    );

endmodule