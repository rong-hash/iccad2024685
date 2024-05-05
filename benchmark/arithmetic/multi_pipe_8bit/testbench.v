`timescale 1ns/1ns
`define clk_period 20
module tb_multi_pipe();
 
     reg [7:0] mul_a;
     reg [7:0] mul_b;
     reg mul_en_in;
 
     reg clk;
     reg rst_n;
 
     wire mul_en_out;
     wire [15:0] mul_out;

     integer i; // Declare the loop variable here
     integer fail_count; // Declare a variable to count the 
     reg [15:0] expected_product;
 
 verified_multi_pipe_8bit u1(
          .clk(clk),      
          .rst_n(rst_n),       
          .mul_a(mul_a),       
          .mul_b(mul_b),
          .mul_en_in(mul_en_in),       
           
          .mul_en_out(mul_en_out),
          .mul_out(mul_out)    
);
 
 
 
initial clk = 1;
always # 10 clk = ~clk; 
integer error = 0; 
 
initial begin
     rst_n = 0;
     mul_a = 0;
     mul_b = 0;
     mul_en_in = 0;
 
     #(`clk_period*200+1);
 
     rst_n = 1;
     
     #(`clk_period*10);
 
     mul_a = 'd35;
     mul_b = 'd20;
     mul_en_in = 'd1;
     repeat (100) begin
          #(`clk_period);
          mul_a = mul_a + 'd1;
          mul_b = mul_b + 'd2;
          // mul_en_in = mul_en_in + 'd1;
          expected_product = mul_a * mul_b;
          
          //========it can be changed depending on your pipelining processing latency
          #(`clk_period*4);
          //========it can be changed depending on your pipelining processing latency
          
          error = (mul_out != expected_product) ? error+1 : error;
          // $display("mul_a = %d, mul_b = %d, mul_out = %d, expected = %d", mul_a, mul_b, mul_out, expected_product);
     end

     if (error == 0) begin
            $display("===========Your Design Passed===========");
     end
     else begin
     $display("===========Test completed with %d /100 failures===========", error);
     $display("Our testbench provides the delay for the 4-stage pipeline multiplier,\nand different pipeline stages may result in your answer testing as an error.\nYou can modify it at the corresponding location in testbench.v");
     end
    
     $finish; 
   
end
 
endmodule 