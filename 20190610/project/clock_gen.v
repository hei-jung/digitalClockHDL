/*clock_gen.v*/
/*Clock Generator 모듈*/
module clock_gen(Clock_5K, Reset, Clock_1Sec, Clock_1MSec);

input Clock_5K, Reset;
output reg Clock_1MSec;
output reg Clock_1Sec;
reg[11:0] count; // Clock_1Sec 신호를 생성하기 위한 추가변수

always @(posedge Clock_5K or negedge Reset)
begin

  if(!Reset)
  begin
    /*Clock_1MSec, Clock_1Sec, count를 모두 0으로 초기화*/
    Clock_1MSec <= 0;
    Clock_1Sec <= 0;
    count <= 0;
  end
  
  else
  begin
    count <= count + 1; // count를 1 증가
    Clock_1MSec <= ~Clock_1MSec;   // Clock_1MSec를 반전
    
    if(count == 2500)
    begin
      /*매 0.5초마다 Clock_1Sec를 발생시킨다(2.5KHz)*/
      Clock_1Sec <= ~Clock_1Sec;
      count <= 0;
    end
    
    else  Clock_1Sec <= Clock_1Sec;
  end

end

endmodule
