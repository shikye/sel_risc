`timescale 1ns / 1ps

module tb();

    reg clk;
    reg rst;

    always#10 clk = ~clk;

    initial begin
        rst = 0;
        clk = 1;
        #30
        rst = 1;
        #100000
        $finish;
    end

    initial begin
        $readmemb("isa_add",tb.rv_soc_ins.rom_ins.rom_mem);
    end

    initial begin
        while(1)begin
            @(posedge clk) begin
                $display("x27 value is %d",tb.rv_soc_ins.rv_core_ins.regs_ins.regs[27]);      
                $display("x28 value is %d",tb.rv_soc_ins.rv_core_ins.regs_ins.regs[28]);      
                $display("x29 value is %d",tb.rv_soc_ins.rv_core_ins.regs_ins.regs[29]); 
                $display("-----------------------------------------------");
                $display("-----------------------------------------------");
                $display("-----------------------------------------------");
            end
        end
    end

    initial begin
        $dumpfile("gtk");
        $dumpvars(0,tb.rv_soc_ins.rv_core_ins.regs_ins.regs);
    end

    



    rv_soc rv_soc_ins(
        .clk(clk),
        .rst(rst)
    );





endmodule
