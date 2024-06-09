module dcache_mem #(
    parameter int unsigned mem_depth = 256,
    parameter type mem_type = logic)
(
    input   logic       clk_i,
    input   logic       rst_ni,
    input   logic       [$clog2(mem_depth):0] addr_i,
    input   logic       ceb_i,
    input   logic       ren_i,
    input   logic       wen_i,
    input   mem_type    data_i,
    output  mem_type    data_o,

);


mem_type MEM [mem_depth];
logic read;
logic write;

assign read = (ceb_i & ren_i) ? 1'b1 : 1'b0;
assign write= (ceb_i & wen_i) ? 1'b1 : 1'b0;


always_ff @(posedge clk_i) begin
  if(!rst_ni) begin
    foreach(MEM[i]) MEM[i] <= '0;
    data_o <= '0;
  end else begin
    if(write) begin
      MEM[addr_i] <= data_i;
    end

    if(read) begin
      data_o <= MEM[addr_i]
    end
  end
end

endmodule