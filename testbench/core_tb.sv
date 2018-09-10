module smpl_tb;

logic clock, reset;
logic read_en, write_en;

logic[12:0] instruction_addr, data_addr;
logic[15:0] instruction_data, input_data, output_data;

smpl_core dut(
    .clock(clock),
    .reset(reset),
    .idata(instruction_data),
    .iaddr(instruction_addr),
    .datai(input_data),
    .datao(output_data),
    .daddr(data_addr),
    .renbl(read_en),
    .wenbl(write_en)
);

initial clock = 0;
always #1 clock = ~clock;

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, smpl_tb);

    #0 reset = 1; #1 reset = 0;

    // add instruction
    instruction_data = 16'b0000000000000001;
    input_data = 13'b0000000000001;

    #4; // subtract instruction
    instruction_data = 16'b0010000000000001;
    input_data = 13'b0000000000001;
  
  	#4; // lda instruction
  	instruction_data = 16'b1000000000000001;
    input_data = 13'b1011101010111;

    #4; // and instruction
  	instruction_data = 16'b0100000000000001;
    input_data = 13'b0000000010101;

    #10;
    
    $finish;
end

endmodule