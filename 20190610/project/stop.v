/*stop.v*/
/*Stopwatch 모듈*/
module stop(
              Clock_1MSec, Reset, Start_S, Stop_S, Reset_S,
              Hours_S, Mins_S, Secs_S, MSecs_S, Control);

input Clock_1MSec, Reset, Start_S, Stop_S, Reset_S, Control;
output reg[3:0] Hours_S;
output reg[5:0] Mins_S, Secs_S;
output reg[9:0] MSecs_S;
reg stop_count; // 정지(stop=1) 횟수를 셀 수 있도록 설정한 추가 변수

always @(posedge Clock_1MSec or negedge Reset) begin
  
  if(!Control) begin  // 스톱워치 기능으로 설정되어 있을 때
    if(!Reset) begin
      /*모두 0으로 초기화*/
      Hours_S <= 0;
      Mins_S <= 0;
      Secs_S <= 0;
      MSecs_S <= 0;
      stop_count = 0;
    end
  
    else begin
      /*평상시(스톱워치 카운트를 시작하지 않았을 때)에는 MSecs_S의 값이 변하지 않는다.*/
      MSecs_S <= MSecs_S;

      if(Stop_S) begin
        /*
        * Stop_S=1이면 stop_count도 1로 바꿔준다.
        * 또한 아무 동작도 하지 않고, 정지 상태를 유지한다.
        */
      end

      else if((Start_S==1) && (stop_count!=1)) begin
        /*정지 상태가 아니고, Start_S=1이면 스톱워치 카운트를 시작한다.*/
        MSecs_S <= MSecs_S + 1;
        if(MSecs_S == 999) begin
          Secs_S <= Secs_S + 1;
          if(Secs_S == 59) begin
            Mins_S <= Mins_S + 1;
            if(Mins_S == 59) begin
              Hours_S <= Hours_S + 1;
              if(Hours_S == 11)   Hours_S <= 0;
              Mins_S <= 0;
            end
            Secs_S <= 0;
          end
          MSecs_S <= 0;
        end
      end

      else if((Reset_S==1) && (stop_count==1)) begin
        /*Reset_S가 1이 되면 스톱워치의 동작이 모두 초기화된다.*/
        Hours_S <= 0;
        Mins_S <= 0;
        Secs_S <= 0;
        MSecs_S <= 0;
        stop_count = 0;
      end
    end
  end
end
endmodule
