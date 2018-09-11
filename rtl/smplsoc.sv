module smpl_soc(
    input logic clock,
    input logic reset
);

logic [15:0] ROM [0:128]; // instruction memory
logic [15:0] RAM [0:128]; // data memory

initial begin
    for(int i = 0; i != 128; i = i + 1) begin
        ROM[i] = 16'dz;
    end
    $readmemb("instmem.hex",ROM);

    for(int i = 0; i != 128; i = i + 1) begin
        RAM[i] = 16'dz;
    end    
    $readmemb("datamem.hex",RAM);

end

logic read_en, write_en;

logic[12:0] instruction_addr, data_addr;
logic[15:0] instruction_data, input_data, output_data;

smpl_core core(
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

always_ff @(posedge clock, posedge reset) begin
    if (read_en) begin
        input_data <= RAM[data_addr[7:0]];
    end else if (write_en) begin
        RAM[data_addr[7:0]] <= output_data;
    end else begin
        input_data <= input_data;
        RAM[data_addr[7:0]] <= RAM[data_addr[7:0]];
    end
end

assign instruction_data = ROM[instruction_addr[7:0]];

endmodule