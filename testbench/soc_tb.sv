module soc_tb;

logic clock, reset;

smpl_soc dut(
    .clock(clock),
    .reset(reset)
);

initial clock = 0;
always #1 clock = ~clock;

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, soc_tb);

    #0 reset = 1; #1 reset = 0;

    #10;
        
    $finish;
end

endmodule