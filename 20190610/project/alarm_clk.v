/*alarm_clk.v*/
/*Alarm 모듈*/
module alarm_clk(
                Clock_1sec, Reset, LoadTime, LoadAlm, AlarmEnable,
                Set_AM_PM, Alarm_AM_PM_In,
                SetSecs, SetMins, AlarmMinsIn, SetHours, AlarmHoursIn,
                AM_PM, Alarm, Secs_C, Mins_C, Hours_C);

input           Clock_1sec, Reset, LoadTime, LoadAlm, Set_AM_PM, Alartm_AM_PM_In, AlarmEnable
input[5:0]      SecSecs, SetMins, AlarmMinsIn;
input[3:0]      SetHours, AlarmHoursIn;
output reg      AM_PM, Alarm;
output reg[5:0] Secs_C, Mins_C;
output reg[3:0] Hours_C;

always @(posedge Clock_1sec or negedge Reset) begin
  if(!Reset) begin
    /*초기화*/
    AM_PM <= 1;
    Alarm <= 0;
    Secs_C <= 0;
    Mins_C <= 0;
    Hours_C <= 0;
  end
  else begin
    /*평상시 상태: 시간 유지, 알람 동작 유지*/
    Secs_C <= Secs_C;
    Alarm <= Alarm;
    
    if(LoadTime) begin  //시간 setting
      AM_PM <= Set_AM_PM;
      Secs_C <= SetSecs;
      Mins_C <= SetMins;
      Hours_C <= SetHours;
    end
    
    else if(!LoadTime) begin  //시계 동작
      Secs_C <= Secs_C + 1;
      if(Secs_C == 59) begin
        Mins_C <= Mins_C + 1; //59초에서 1분으로
        if(Mins_C == 59) begin
          Hours_C <= Hours_C + 1; //59분에서 1시간으로
          /*59초이고 59분인 상태에서 11시일 때(11:59:59)*/
          if(Hours_C==11) AM_PM <= ~AM_PM;  //오전/오후 바꾸기
          if(Hours_C==13) Hours_C <= 1; //12시가 넘어가면 다시 1시부터
          Mins_C <= 0;  //다시 0분부터
        end
        Secs_C <= 0;  //다시 0초부터
      end
    end
    
    /*알람이 울릴 시각은 testbench에서 setting한다.*/
    
    if(AlarmEnable) begin //알람 동작
      if(!LoadAlm) begin
        if((AM_PM==Alarm_AM_PM_In) && (Hours_C==AlarmHoursIn)) begin
          /*알람 시각이 된 0초 시점부터 알람이 울린다.(1)*/
          if((Mins_C==(AlarmMinsIn-1)) && (Secs_C==59)) begin
            Alarm <= 1;
          end
          /*알람 시각이 되고 59초 시점까지만 알람이 울린다.(1->0)*/
          if((Mins_C==AlarmMinsIn) && (Secs_C==59)) begin
            Alarm <= 0;
          end
        end
      end
    end
  end
end
endmodule
          
