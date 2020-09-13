`timescale 10us/1us

module stop_tb();
reg Clock_1MSec, Reset, Start_S, Stop_S, Reset_S, Control;
wire[3:0] Hours_S;
wire[5:0] Mins_S, Secs_S;
wire[9:0] MSecs_S;

stop  stop_m(Clock_1MSec, Reset, Start_S, Stop_S, Reset_S,
              Hours_S, Mins_S, Secs_S, MSecs_S, Control);

initial begin
          Clock_1MSec=0; Reset=1; Control=0; Start_S=0; Reset_S=0; Stop_S=0;
  #5      Reset=0;
  #5      Reset=1;
  #25     Start_S=1;
  #25     Start_S=0;
  #25     Start_S=1;
  #25     Stop_S=1;
  #25     Stop_S=0;
  #250000 $finish;
end

always begin
  #5      Clock_1MSec = ~Clock_1MSec;
end

endmodule
