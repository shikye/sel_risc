module rv_core(
    input                   clk,
    input                   rst,
    //from rom
    input   wire    [31:0]  inst_i,
    //to rom
    output  wire    [31:0]  inst_addr_o
);



    pc_reg pc_reg_ins(
        .clk        (clk),
        .rst        (rst),
        .pc_o       (pc_reg_pc_o)
    );


    //pc to if
    wire    [31:0]  pc_reg_pc_o;  
    

    ifetch ifetch_ins(
        .pc_addr_i     (pc_reg_pc_o),
        .rom_inst_i    (inst_i),
        .if2rom_addr_o (inst_addr_o),
        .inst_addr_o   (ifetch_inst_addr_o),
        .inst_o        (ifetch_inst_o)
    );


    //if to if_id
    wire    [31:0]  ifetch_inst_o;
    wire    [31:0]  ifetch_inst_addr_o;


    if_id if_id_ins(
        .clk                (clk),                
        .rst                (rst),
        .inst_i             (ifetch_inst_o),
        .inst_addr_i        (ifetch_inst_addr_o),
        .inst_o             (if_id_inst_o),
        .inst_addr_o        (if_id_inst_addr_o)    
    );


    //if_id to id
    wire    [31:0]  if_id_inst_o;
    wire    [31:0]  if_id_inst_addr_o;


    id id_ins(
        .inst_i                     (if_id_inst_o),
        .inst_addr_i                (if_id_inst_addr_o),
        .rs1_data_i                 (regs_reg1_rdata_o),
        .rs2_data_i                 (regs_reg2_rdata_o),
        .rs1_addr_o                 (id_rs1_addr_o),
        .rs2_addr_o                 (id_rs2_addr_o),
        .op1_o                      (id_op1_o),
        .op2_o                      (id_op2_o),
        .inst_o                     (id_inst_o),
        .inst_addr_o                (id_inst_addr_o),
        .rd_addr_o                  (id_rd_addr_o),  
        .reg_wen                    (id_reg_wen)    
    );


    //id to regs
    wire    [4:0]   id_rs1_addr_o;
    wire    [4:0]   id_rs2_addr_o;
    //regs to id
    wire    [31:0]  regs_reg1_rdata_o;
    wire    [31:0]  regs_reg2_rdata_o;
    //id to id_ex
    wire    [31:0]  id_op1_o;
    wire    [31:0]  id_op2_o;
    wire    [31:0]  id_inst_o;
    wire    [31:0]  id_inst_addr_o;
    wire    [4:0]   id_rd_addr_o;
    wire            id_reg_wen;

    regs regs_ins(
        .clk                        (clk),
        .rst                        (rst),
        .reg1_raddr_i               (id_rs1_addr_o),
        .reg2_raddr_i               (id_rs2_addr_o),
        .reg1_rdata_o               (regs_reg1_rdata_o),
        .reg2_rdata_o               (regs_reg2_rdata_o),
        .rd_data_i                  (ex_rd_data_o),
        .rd_addr_i                  (ex_rd_addr_o),
        .reg_wen                    (ex_reg_wen_o)    
    );



    id_ex id_ex_ins(
        .clk                        (clk),
        .rst                        (rst),
        .op1_i                      (id_op1_o),
        .op2_i                      (id_op2_o),
        .inst_i                     (id_inst_o),
        .inst_addr_i                (id_inst_addr_o),
        .reg_wen_i                  (id_reg_wen),
        .rd_addr_i                  (id_rd_addr_o),
        .op1_o                      (id_ex_op1_o),  
        .op2_o                      (id_ex_op2_o),    
        .inst_o                     (id_ex_inst_o),      
        .inst_addr_o                (id_ex_inst_addr_o),     
        .reg_wen_o                  (id_ex_reg_wen_o),     
        .rd_addr_o                  (id_ex_rd_addr_o)    
    );

    
    //id_ex to ex
    wire    [31:0]  id_ex_op1_o;
    wire    [31:0]  id_ex_op2_o;
    wire    [31:0]  id_ex_inst_o;
    wire    [31:0]  id_ex_inst_addr_o;
    wire            id_ex_reg_wen_o;
    wire    [4:0]   id_ex_rd_addr_o;



    ex ex_ins(
        .op1_i                   (id_ex_op1_o),      
        .op2_i                   (id_ex_op2_o),
        .inst_i                  (id_ex_inst_o),
        .inst_addr_i             (id_ex_inst_addr_o),
        .reg_wen_i               (id_ex_reg_wen_o),
        .rd_addr_i               (id_ex_rd_addr_o),
        .rd_data_o               (ex_rd_data_o),
        .reg_wen_o               (ex_reg_wen_o),
        .rd_addr_o               (ex_rd_addr_o)       
    );

    //ex to regs
    wire    [31:0]  ex_rd_data_o;
    wire            ex_reg_wen_o;
    wire    [4:0]   ex_rd_addr_o;

    



endmodule