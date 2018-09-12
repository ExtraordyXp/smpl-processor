
module smpl_core(
    input   logic           clock,  // clock
    input   logic           reset,  // reset bit

    input   logic [15:0]    idata,  // instruction data bus
    output  logic [12:0]    iaddr,  // instruction address bus

    input   logic [15:0]    datai,  // input data bus
    output  logic [15:0]    datao,  // output data bus
    output  logic [12:0]    daddr,  // data address bus

    output  logic           renbl,  // read enable
    output  logic           wenbl   // write enable
);

/*

The SMPL-CPU has a total of 8 instructions? divided into three classes:
arithmetic-logical instructions (ADD? SUB? AND? and NOT)? data-transfer
 instructions (LDA? STA)? and control-flow instructions (JMP? JZ).

*/

// ====== internal registers
logic [12:0] program_counter;
logic [15:0] acc; // accumulator register

// ====== Separating the intruction data

// obs.: the systemverilog type LOGIC did not work for one-line continuous
// assignments. Therefore we use WIRE for simplicity
wire [2:0] opcode = idata[15:13];
wire [12:0] memaddr = idata[12:0];

// ====== Opcode decoder
/*wire addi = (opcode == 3'b000);
wire subi = (opcode == 3'b001);
wire andi = (opcode == 3'b010);
wire noti = (opcode == 3'b011);
wire ldai = (opcode == 3'b100);
wire stai = (opcode == 3'b101);
wire jmpi = (opcode == 3'b110);
wire jzi  = (opcode == 3'b111);*/

assign wenbl = reset ? 0 : opcode == 3'b101 ? 1 : 0;
assign renbl = reset ? 1 : opcode != 3'b101 ? 1 : 0;

// ====== Instruction evaluation
always_ff @(posedge clock, posedge reset) begin
    if (reset) begin

        acc <= '0;
        program_counter <= '1;

    end else begin

        acc <= '1;
        program_counter <= program_counter + 1;

        unique case (opcode)
            3'b000: acc <= acc + datai;
            3'b001: acc <= acc - datai;
            3'b010: acc <= acc & datai;
            3'b010: acc <= ~datai;
            3'b010: acc <= datai;
            3'b010: program_counter <= memaddr;
            3'b010 : program_counter <= ~acc ? memaddr : program_counter;
        endcase
    end
end

assign iaddr = program_counter;
assign datao = acc;
assign daddr = memaddr;

endmodule 