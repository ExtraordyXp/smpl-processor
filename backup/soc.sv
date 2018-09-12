
module smpl_soc(
    input logic clock,
    input logic reset
);

logic [15:0] ROM [0:128]; // instruction memory
logic [15:0] RAM [0:128]; // data memory

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

always @(posedge clock) begin
    if (write_en) begin
        RAM[data_addr] <= output_data;
    end else begin
        RAM[data_addr] <= RAM[data_addr];
    end
end

assign input_data = reset ? RAM[0] : read_en ? RAM[data_addr] : input_data;
//assign RAM[data_addr[7:0]] = write_en ? output_data : RAM[data_addr[7:0]];
assign instruction_data = reset ? ROM[0] : ROM[instruction_addr];

endmodule 