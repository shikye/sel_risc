`timescale 1ns / 1ps

module tb();

    reg clk;
    reg rst;
    integer r;

    wire x3 = tb.rv_soc_ins.rv_core_ins.regs_ins.regs[3];
    wire x26 = tb.rv_soc_ins.rv_core_ins.regs_ins.regs[26];
    wire x27 = tb.rv_soc_ins.rv_core_ins.regs_ins.regs[27];

    always#10 clk = ~clk;

    initial begin
        rst = 0;
        clk = 1;
        #30
        rst = 1;
    end

    initial begin
        $readmemh("inst.data",tb.rv_soc_ins.rom_ins.rom_mem);
    end

    initial begin
        wait(x26);
        if(x27 == 32'b1) begin
            $display("#################PASS#################");
        end
        else begin
            $display("#################FAIL#################");
            for(r=0;r<32;r=r+1)begin
                $display("%2d reg value is %d",r,tb.rv_soc_ins.rv_core_ins.regs_ins.regs[r]);
            end

        end
    end

    initial begin
        $dumpfile("gtk");
        $dumpvars(0,tb);
    end

    



    rv_soc rv_soc_ins(
        .clk(clk),
        .rst(rst)
    );





endmodule
