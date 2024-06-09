module dcache_top import dcache_pkg::*;(
    input   logic       clk_i,
    input   logic       rst_ni,

    output  logic       cache_busy_o
    input   core_req_t  core_req_i,
    output  core_res_t  core_res_o
    

);



addr_t core_req_addr;


assign core_req_addr.tag      = core_req_i.addr[addrWidth-1:addrWidth-(setIdxWidth+offsetWidth)];
assign core_req_addr.set_idx  = core_req_i.addr[setIdxWidth+offsetWidth-1:offsetWidth];
assign core_req_addr.offset   = core_req_i.addr[offsetWidth-1:0];

logic [wayNum-1:0] sram_ceb;
logic [wayNum-1:0] sram_wen;
logic [wayNum-1:0] sram_ren;

tag_t tag_readen;



data_t fill_data;
data_t data_readen;

for (genvar i = 0; i<wayNum;i++)  begin:tag_gen
  dcache_mem #(
      mem_depth = 256,
      mem_type = tag_t)
  (
      .clk_i  (clk_i),
      .rst_ni (rst_ni),
      .addr_i (core_req_addr.set_idx),
      .ceb_i  (sram_ceb[i]),
      .ren_i  (sram_ren[i]),
      .wen_i  (sram_wen[i]),
      .data_i (core_req_addr.tag),
      .data_o (tag_readen),
  );
end

for (genvar i = 0; i<wayNum;i++)  begin:data_gen
  dcache_mem #(
      mem_depth = 256,
      mem_type = data_t)
  (
      .clk_i  (clk_i),
      .rst_ni (rst_ni),
      .addr_i (core_req_addr.set_idx),
      .ceb_i  (sram_ceb[i]),
      .ren_i  (sram_ren[i]),
      .wen_i  (sram_wen[i]),
      .data_i (fill_data),
      .data_o (data_readen),
  );
end

// TODO : Coherent Implementation
for (genvar i = 0; i<wayNum;i++)  begin:meta_gen
  dcache_mem #(
      mem_depth = 256,
      mem_type = meta_e)
  (
      .clk_i  (clk_i),
      .rst_ni (rst_ni),
      .addr_i (core_req_addr.set_idx),
      .ceb_i  (sram_ceb[i]),
      .ren_i  (sram_ren[i]),
      .wen_i  (sram_wen[i]),
      .data_i (),
      .data_o (),
  );
end


endmodule