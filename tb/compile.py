import sys
import filecmp
import subprocess
import sys
import os


# 主函数
def main():

    rtl_dir = r'..';

    # iverilog程序
    iverilog_cmd = ['iverilog']
    # 顶层模块
    iverilog_cmd += ['-s', 'tb']
    # 编译生成文件
    iverilog_cmd += ['-o', r'out.vvp']
    # 头文件(defines.v)路径
    iverilog_cmd += ['-I', r'../rtl']
    # 宏定义，仿真输出文件
    #iverilog_cmd += ['-D', r'OUTPUT="signature.output"']
    # testbench文件
    iverilog_cmd.append(r'tb.v')
    # ../rtl/core
    iverilog_cmd.append(rtl_dir + r'/rtl/ctrl.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/defines.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/ex.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/id.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/id_ex.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/if_id.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/pc_reg.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/regs.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/dff_set.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/ifetch.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/rom.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/rv_soc.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/rv_core.v')
    
 
    # 编译
    process = subprocess.Popen(iverilog_cmd)
    process.wait(timeout=5)

if __name__ == '__main__':
    sys.exit(main())
