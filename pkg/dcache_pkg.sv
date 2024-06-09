package dcache;

localparam int xLen = 64;
localparam int setNum = 256;
localparam int wayNum = 8;
localparam int lineWidth = 128;
localparam int addrWidth = 38;
localparam int mshrDepth = 16;

localparam int setIdxWidth = $clog2(setNum);
localparam int offsetWidth = $clog2(lineWidth/8);
localparam int tagWidth    = addrWidth - setIdxWidth - offsetWidth;

typedef logic  [tagWidth-1:0]           tag_t;
typedef logic  [setIdxWidth-1:0]        set_idx_t;
typedef logic  [offsetWidth-1:0]        offset_t;
typedef logic  [lineWidth-1:0]          data_t;
typedef logic  [wayNum-1:0]             refill_way_t;
typedef logic  [lineWidth-1:0]          cache_line_t;


typedef enum logic [1:0] {
  B = 2'b00, 
  H = 2'b01,  
  W = 2'b10,
  D = 2'b11   
} width_e;

typedef enum logic [2:0]{
  I,
  S,
  E,
  O,
  M
  
} meta_e;

typedef enum logic {
    NO_OPERATION,
    LOAD,
    STORE,
    AMO,
    LR,
    SC,
    FENCE
} op_e;

typedef struct packed {
  tag_t     tag;
  set_idx_t set_idx;
  offset_t  offset;
} addr_t;


typedef struct packed {
  snp_msg_e               message;
  logic [addrWidth-1:0]   addr;
}snoop_req_t;

typedef struct packed {
    logic                       valid;
    op_e                        op;
    logic [addrWidth-1:0]       addr;
    width_e                     width;
    logic [XLen-1:0]            data;
    logic [reqIdWidth-1:0]      req_id;
}core_req_t;  


typedef struct packed {
    logic                       valid;
    logic [addrWidth-1:0]       addr;
    logic [XLen-1:0]            data;
    logic [reqIdWidth-1:0]      req_id;
}core_res_t;  


endpackage
