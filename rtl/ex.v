`include "defines.v"
module ex(
    //from id_ex
    input   wire    [31:0]  op1_i,          
    input   wire    [31:0]  op2_i,
    input   wire    [31:0]  inst_i,
    input   wire    [31:0]  inst_addr_i,
    input   wire            reg_wen_i,
    input   wire    [4:0]   rd_addr_i,
    //to regs
    output   reg    [31:0]  rd_data_o,
    output   reg            reg_wen_o,
    output   reg    [4:0]   rd_addr_o,
    //to ctrl
    output  reg     [31:0]  jump_addr_o,
    output  reg             jump_en_o,
    output  reg             hold_flag_o
);


    //TYPE_I_R_M
    wire[6:0]   opcode;
    wire[4:0]   rd;
    wire[2:0]   funct3;
    wire[4:0]   rs1;
    wire[11:0]  imm;
    wire[4:0]   rs2;
    wire[6:0]   funct7;


    assign  opcode = inst_i[6:0];
    assign  rd     = inst_i[11:7];
    assign  funct3 = inst_i[14:12];
    assign  rs1    = inst_i[19:15];
    assign  imm    = inst_i[31:20];
    assign  rs2    = inst_i[24:20];
    assign  funct7 = inst_i[31:25];


    //TYPE_J
    wire[31:0]  jump_imm;
    wire        op1_i_equal_op2_i;
    wire        uns_op1_i_lt_op2_i;
    wire        s_op1_i_lt_op2_i;

    assign      jump_imm          = {{19{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
    assign      op1_i_equal_op2_i = (op1_i == op2_i) ? 1'b1 : 1'b0;
    assign      uns_op1_i_lt_op2_i = (op1_i < op2_i) ? 1'b1 : 1'b0;
    assign      s_op1_i_lt_op2_i  = ($signed(op1_i) < $signed(op2_i)) ? 1'b1:1'b0;

    always@(*) begin
        
        case(opcode)
            `INST_TYPE_I:begin
                jump_addr_o = 32'b0;
                jump_en_o   = 1'b0;
                hold_flag_o = 1'b0;
                case(funct3)
                    `INST_ADDI:begin
                        rd_data_o = op1_i + op2_i;
                        rd_addr_o = rd;
                        reg_wen_o = reg_wen_i;
                    end


                    default:begin
                        rd_data_o = 32'b0;
                        rd_addr_o = 5'b0;
                        reg_wen_o = 1'b0;
                    end
                endcase
            end

            `INST_TYPE_R_M:begin
                jump_addr_o = 32'b0;
                jump_en_o   = 1'b0;
                hold_flag_o = 1'b0;
                case(funct3)
                    `INST_ADD_SUB:begin
                        if(funct7 == 7'b0000000) begin //add
                            rd_data_o = op1_i + op2_i;
                            rd_addr_o = rd;
                            reg_wen_o = reg_wen_i;
                        end 
                        else begin
                            rd_data_o = op1_i - op2_i;
                            rd_addr_o = rd;
                            reg_wen_o = reg_wen_i;
                        end
                    end


                    default:begin
                        rd_data_o = 32'b0;
                        rd_addr_o = 5'b0;
                        reg_wen_o = 1'b0;
                    end
                endcase
            end

            `INST_TYPE_B:begin
                rd_data_o = 32'b0;
                rd_addr_o = 5'b0;
                reg_wen_o = 1'b0;
                case(funct3)
                    `INST_BNE:begin
                            jump_addr_o = jump_imm + inst_addr_i;
                            jump_en_o   = ~op1_i_equal_op2_i;
                            hold_flag_o = 1'b0;
                    end
                    `INST_BEQ:begin
                            jump_addr_o = jump_imm + inst_addr_i;
                            jump_en_o   = op1_i_equal_op2_i;
                            hold_flag_o = 1'b0;
                    end
                    `INST_BLT:begin
                            jump_addr_o = jump_imm + inst_addr_i;
                            jump_en_o   = s_op1_i_lt_op2_i;
                            hold_flag_o = 1'b0;
                    end
                    `INST_BGE:begin
                            jump_addr_o = jump_imm + inst_addr_i;
                            jump_en_o   = ~s_op1_i_lt_op2_i;
                            hold_flag_o = 1'b0;
                    end
                    `INST_BLTU:begin
                            jump_addr_o = jump_imm + inst_addr_i;
                            jump_en_o   = uns_op1_i_lt_op2_i;
                            hold_flag_o = 1'b0;
                    end
                    `INST_BGEU:begin
                            jump_addr_o = jump_imm + inst_addr_i;
                            jump_en_o   = ~uns_op1_i_lt_op2_i;
                            hold_flag_o = 1'b0;
                    end
                    


                    default:begin
                        jump_addr_o = 32'b0;
                        jump_en_o   = 1'b0;
                        hold_flag_o = 1'b0;
                    end
                endcase
            end


            `INST_JALR:begin
                jump_addr_o = {{20{inst_i[31]}},inst_i[31:20]} + op1_i;
                jump_en_o   = 1'b1;
                hold_flag_o = 1'b0;
                rd_data_o = inst_addr_i + 32'd4;
                rd_addr_o = rd;
                reg_wen_o = 1'b1;
            end

            `INST_JAL:begin
                jump_addr_o = {{12{inst_i[31]}},inst_i[19:12],inst_i[20],inst_i[30:21],1'b0} + inst_addr_i;
                jump_en_o   = 1'b1;
                hold_flag_o = 1'b0;
                rd_data_o = inst_addr_i + 32'd4;
                rd_addr_o = rd;
                reg_wen_o = 1'b1;
            end



            `INST_LUI:begin
                jump_addr_o = 32'b0;
                jump_en_o   = 1'b0;
                hold_flag_o = 1'b0;
                rd_data_o = {inst_i[31:12],12'b0};
                rd_addr_o = rd;
                reg_wen_o = 1'b1;
            end


            `INST_AUIPC:begin
                jump_addr_o = 32'b0;
                jump_en_o   = 1'b0;
                hold_flag_o = 1'b0;
                rd_data_o = {inst_i[31:12],12'b0} + inst_addr_i;
                rd_addr_o = rd;
                reg_wen_o = 1'b1;
            end


            default:begin
                        jump_addr_o = 32'b0;
                        jump_en_o   = 1'b0;
                        hold_flag_o = 1'b0;
                        rd_data_o = 32'b0;
                        rd_addr_o = 5'b0;
                        reg_wen_o = 1'b0;
                    end
        endcase
    end















endmodule
