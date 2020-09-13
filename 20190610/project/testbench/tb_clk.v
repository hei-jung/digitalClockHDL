`timescale 10us/1us

module clk_tb();
  reg Clock_5K, Reset;
  wire Clock_1Sec, Clock_1MSec;
  
  clock_gen clk_g(Clock_5K, Reset, Clock_1Sec, Clock_1MSec);
  
  initial
  begin
    Clock_5K = 1; Reset = 1;
    #50 Reset = 0;
    #30 Reset = 1;
    #250000 $finish;
  end
  
  always  #10 Clock_5K = ~Clock_5K;

endmodule
