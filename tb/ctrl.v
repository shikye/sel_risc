module ctrl(
    input   wire            rst,
    //from ex
    input   wire    [31:0]  jump_addr_i,
    input   wire            jump_en_i,
    input   wire            hold_flag_i,
    //to pc_reg
    output  reg     [31:0]  jump_addr_o,
    output  reg             jump_en_o,
    //to if_id id_ex
    output  reg             hold_flag_o  
);

    always@(*) begin
        if(rst == 1'b0) begin
            jump_addr_o = 32'b0;     
            jump_en_o   = 1'b0;
            hold_flag_o = 1'b1;
        end
        else begin
            jump_addr_o = jump_addr_i;
            jump_en_o   = jump_en_o;
            if(jump_en_i || hold_flag_i)
                hold_flag_o = 1'b1;
            else
                hold_flag_o = 1'b0;
        end
    end


endmodule
