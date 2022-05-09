module pc_reg(
    input   wire            clk,
    input   wire            rst,
    //from ctrl
    input   wire    [31:0]  jump_addr_i,
    input   wire            jump_en_i,
    output  reg     [31:0]  pc_o
);


    always@(posedge clk) begin
        if(rst == 1'b0)
            pc_o <= 32'b0;
        else if(jump_en_i == 1'b1)
            pc_o <= jump_addr_i;
        else
            pc_o <= pc_o + 3'd4;
    end


endmodule
