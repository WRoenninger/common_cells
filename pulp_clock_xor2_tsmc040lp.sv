module pulp_clock_xor2
(
   input  logic clk0_i,
   input  logic clk1_i,
   output logic clk_o
);


   XOR2_X2M_A9TL clk_xor_i 
   (
      .Y(clk_o),
      .A(clk0_i),
      .B(clk1_i) 
   );


endmodule
