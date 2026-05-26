module memoriaDados(
    clk,
    memwrite,
    memread,
    endereco,
    wd,
    rd
    );

input wire clk;
input wire memwrite;
input wire memread;
input wire [31:0] endereco;
input wire [31:0] wd;
output reg [31:0] rd;

reg [31:0] memoria [0:63];

always @(*)begin
    if(memread == 1)begin
        //lê no byte de acordo com o endereco
        case (endereco[1:0])
            2'b00: rd <= {24'b0, memoria[endereco >> 2][31:24]};
            2'b01: rd <= {{24{memoria[endereco >> 2][23]}}, memoria[endereco >> 2][23:16]};
            2'b10: rd <= {{24{memoria[endereco >> 2][15]}}, memoria[endereco >> 2][15:8]};
            2'b11: rd <= {{24{memoria[endereco >> 2][7]}}, memoria[endereco >> 2][7:0]};
        endcase
    end
end

always @(negedge clk)begin
    if(memwrite == 1)begin
        //escreve no byte
        case (endereco[1:0])
            2'b00: memoria[endereco >> 2][31:24] <= wd[7:0];
            2'b01: memoria[endereco >> 2][23:16] <= wd[7:0];
            2'b10: memoria[endereco >> 2][15:8] <= wd[7:0];
            2'b11: memoria[endereco >> 2][7:0] <= wd[7:0];
        endcase
    end
end

endmodule