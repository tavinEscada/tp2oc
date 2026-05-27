module pc(
    clock, 
    reset, 
    entrada,
    saida
);

    input wire reset, clock;
    input wire [31:0] entrada;
    output reg [31:0] saida;

    always @(posedge clock) begin
    if(reset) begin
        saida <= 32'b00000000000000000000000000000000;
    end 
    else begin 
        saida <= entrada;
    end
end
endmodule