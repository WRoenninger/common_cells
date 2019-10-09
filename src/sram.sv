// Copyright 2017, 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Date: 13.10.2017
// Description: SRAM Behavioral Model

module sram #(
  parameter int unsigned DATA_WIDTH = 64,
  parameter int unsigned BYTE_WIDTH = 1,
  parameter int unsigned NUM_WORDS  = 1024,
  // Dependent parameters, do not overwrite!
  parameter int unsigned BE_WIDTH   = cf_math_pkg::ceil_div(DATA_WIDTH, BYTE_WIDTH),
  parameter type         addr_t     = logic[$clog2(NUM_WORDS)-1:0],
  parameter type         data_t     = logic[DATA_WIDTH-1:0],
  parameter type         strb_t     = logic[BE_WIDTH-1:0]
) (
  input  logic  clk_i,

  input  logic  req_i,
  input  logic  we_i,
  input  addr_t addr_i,
  input  data_t wdata_i,
  input  strb_t be_i,
  output data_t rdata_o
);
  data_t ram [NUM_WORDS-1:0];
  addr_t raddr_q;

  // 1. randomize array
  // 2. randomize output when no request is active
  always_ff @(posedge clk_i) begin
    if (req_i) begin
      if (!we_i) begin
        raddr_q <= addr_i;
      end else begin
        for (int unsigned i = 0; i < BE_WIDTH; i++) begin
          if (be_i[i]) begin
            ram[addr_i][i*BYTE_WIDTH:BYTE_WIDTH] <= wdata_i[i*BYTE_WIDTH:BYTE_WIDTH];
          end
        end
      end
    end
  end

  assign rdata_o = ram[raddr_q];

  initial begin : proc_check_params
    sram_byte_width : assume (DATA_WIDTH % BYTE_WIDTH == 0) else
      $warning($sformatf("sram > `DATA_WIDTH`: %0d is not a multiple of `BYTE_WIDTH`: %0d",
          DATA_WIDTH, BYTE_WIDTH));
  end
endmodule
