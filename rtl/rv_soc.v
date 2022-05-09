module rv_soc(
    input   clk,
    input   rst
);

    rom rom_ins(
        .inst_addr_i(rv_core_inst_addr_o),
        .inst_o(rom_inst_o)
    );

    //rom to rv_core
    wire    [31:0]  rom_inst_o;
    //rv_core to rom
    wire    [31:0]  rv_core_inst_addr_o;

    rv_core rv_core_ins(
        .clk(clk),
        .rst(rst),
        .inst_i(rom_inst_o),
        .inst_addr_o(rv_core_inst_addr_o)
    );



endmodule
