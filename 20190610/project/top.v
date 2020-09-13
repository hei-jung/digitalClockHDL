/*top.v*/
/*Top 모듈*/
module  TOP(Clock_5K, Reset,
            Control,
            Start_S, Stop_S, Reset_S,
            AM_PM, Hours, Mins, Secs, MSecs, Alarm, SW_State,
            LoadTime, LoadAlm, AlarmEnable, Set_AM_PM, Alarm_AM_PM_In,
            SetSecs, SetMins, AlarmMinsIn, SetHours, AlarmHoursIn);

input       Start_S, Stop_S, Reset_S;
input       Clock_5K, Reset, Control, LoadTime, LoadAlm, Set_AM_PM, Alarm_AM_PM_In, AlarmEnable;
input[5:0]  SetSecs, SetMins, AlarmMinsIn;
input[3:0]  SetHours, AlarmHoursIn;
output[3:0] Hours;
output[5:0] Mins, Secs;
output[9:0] MSecs;
output      AM_PM, Alarm;
output reg  SW_State;
wire[3:0]   Hours_C, Hours_S;
wire[5:0]   Mins_C, Mins_S, Secs_C, Secs_S;
wire[9:0]   MSecs_S;

/*모듈 불러오기(instantiation)*/
clock_gen   clkgen(
                    Clock_5K, Reset,
                    Clock_1Sec, Clock_1MSec);
alarm_clk   alarm(
                    Clock_1Sec, Reset, LoadTime, LoadAlm, AlarmEnable,
                    Set_AM_PM, Alarm_AM_PM_In,
                    SetSecs, SetMins, AlarmMinsIn, SetHours, AlarmHoursIn,
                    AM_PM, Alarm, Secs_C, Mins_C, Hours_C);
stop        stopwatch(
                    Clock_1MSec, Reset, Start_S, Stop_S, Reset_S,
                    Hours_S, Mins_S, Secs_S, MSecs_S, Control);

/*Control 신호 1이면 시계, 0이면 스톱워치*/
assign Hours = (Control==1)?Hours_C:Hours_S;
assign Mins = (Control==1)?Mins_C:Mins_S;
assign Secs = (Control==1)?Secs_C:Secs_S;
assign MSecs = (Control==1)?0:MSecs_S;

always @(posedge Clock_5K or negedge Reset) begin
  if(!Reset)    SW_State <= 0;  //SW_State 초기화
  else if(!Control) begin //스톱워치 기능일 때
    if(Start_S) SW_State <= 1;  //스톱워치 카운트 시작하면 SW_State에 1 저장
    if(Stop_S)  SW_State <= 0;  //스톱워치 카운트 끝나면 SW_State에 0 저장
  end
end
endmodule
