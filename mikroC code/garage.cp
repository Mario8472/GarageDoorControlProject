#line 1 "C:/Users/Mario/Documents/0 uC/uC programi/moje_programi/GarageDoorControl/5 GarageDoorControl/garage.c"
#line 36 "C:/Users/Mario/Documents/0 uC/uC programi/moje_programi/GarageDoorControl/5 GarageDoorControl/garage.c"
unsigned short mode;
unsigned short cnt;
bit start_state, start_state2;
bit door_down, door_up, slow_opening, slow_closing;
bit zoneA, zoneB, zoneC;
sbit BRIDGE1_ENABLE at LATB.B5;
sbit BRIDGE2_ENABLE at LATD.B1;
sbit DIRECTION1 at LATC.B2;
sbit DIRECTION2 at LATC.B1;
sbit BULB at LATA.B3;
sbit LED_LIGHT1 at LATA.B1;
sbit LED_LIGHT2 at LATA.B2;


void Sleep_Start()
{
 OSCCON.IDLEN = 0;
 asm sleep;
}


void interrupt()
{

 if(INTCON.TMR0IF)
 {
 cnt++;

 TMR0L = 0x00;
 TMR0H = 0x00;

 if(cnt >= 1)
 {

 T0CON.TMR0ON = 0;


 BULB = 0;
 LED_LIGHT1 = 0;
 LED_LIGHT2 = 0;

 Sleep_Start();

 cnt = 0;
 }
 INTCON.TMR0IF = 0;
 }


 if(INTCON3.INT1IF)
 {
 INTCON3.INT1IF = 0;
 }


 if(INTCON3.INT2IF)
 {
 INTCON3.INT2IF = 0;
 }
}


void MCU_Init()
{
 ANSELA=0x00;
 ANSELB=0x00;
 ANSELC=0x00;
 ANSELD=0x00;
 ANSELE=0x00;
 TRISA=0x00;
 TRISB=0b00011111;
 TRISC=0x00;
 TRISD=0x00;
 TRISE=0b00000011;
 LATA=0x00;
 LATB=0x00;
 LATC=0x00;
 LATD=0x00;
 LATE=0x00;

 PWM1_Init(5000);
 PWM2_Init(5000);

 Delay_ms(150);
}


void Flags_Init()
{
 start_state = 0;
 start_state2 = 0;
 mode = 0;
 door_down = 0;
 door_up = 0;
 slow_opening = 0;
 slow_closing = 0;
 zoneA = 1;
 zoneB = 0;
 zoneC = 0;
}


void Door_Stop()
{
 PWM1_Stop();
 PWM2_Stop();

 BRIDGE1_ENABLE = 0;
 BRIDGE2_ENABLE = 0;
 DIRECTION1 = 0;
 DIRECTION2 = 0;
}


void Door_Open()
{
 BRIDGE1_ENABLE = 1;
 BRIDGE2_ENABLE = 1;

 PWM1_Set_Duty(90);
 PWM1_Start();
}


void Door_Open_Slow()
{
 BRIDGE1_ENABLE = 1;
 BRIDGE2_ENABLE = 1;

 PWM1_Set_Duty(80);
 PWM1_Start();
}


void Door_Close()
{
 BRIDGE1_ENABLE = 1;
 BRIDGE2_ENABLE = 1;

 PWM2_Set_Duty(90);
 PWM2_Start();
}


void Door_Close_Slow()
{
 BRIDGE1_ENABLE = 1;
 BRIDGE2_ENABLE = 1;

 PWM2_Set_Duty(80);
 PWM2_Start();
}


void Interrupt_Init()
{

 INTCON.GIE = 1;


 INTCON.PEIE = 1;


 INTCON.TMR0IF = 0;
 INTCON.TMR0IE = 1;


 INTCON3.INT1IF = 0;
 INTCON2.INTEDG1 = 1;
 INTCON3.INT1IE = 1;


 INTCON3.INT2IF = 0;
 INTCON2.INTEDG2 = 1;
 INTCON3.INT2IE = 1;
}


void Timer_Start()
{

 T0CON = 0b00000111;
 TMR0L = 0x00;
 TMR0H = 0x00;
 INTCON.TMR0IE = 1;
 T0CON.TMR0ON = 1;
}


void Lights_On()
{
 BULB = 1;
 LED_LIGHT1 = 1;
 LED_LIGHT2 = 1;


 Timer_Start();
}


void main() {

 cnt = 0;

 MCU_Init();
 Flags_Init();
 Interrupt_Init();

 Sleep_Start();

 while(1)
 {
#line 267 "C:/Users/Mario/Documents/0 uC/uC programi/moje_programi/GarageDoorControl/5 GarageDoorControl/garage.c"
 if (Button(&PORTB, 1, 1, 1))
 {
 start_state = 1;
 }
 if (start_state && Button(&PORTB, 1, 1, 0))
 {
 if(mode >= 0 && mode < 3)
 {
 mode ++;
 }
 else if(mode == 3)
 {
 mode = 0;
 }
 else
 {
 mode = 0;
 }
 Lights_On();
 start_state = 0;
 }


 if (Button(&PORTB, 2, 1, 1))
 {
 start_state2 = 1;
 }
 if (start_state2 && Button(&PORTB, 2, 1, 0))
 {
 if(mode >= 0 && mode < 3)
 {
 mode ++;
 }
 else if(mode == 3)
 {
 mode = 0;
 }
 else
 {
 mode = 0;
 }
 Lights_On();
 start_state2 = 0;
 }


 if(Button(&PORTB, 4, 1, 1))
 {
 door_down = 1;
 }
 if(door_down && Button(&PORTB, 4, 1, 0))
 {
 door_down = 0;
 }

 if(Button(&PORTB, 3, 1, 1))
 {
 door_up = 1;
 }
 if(door_up && Button(&PORTB, 3, 1, 0))
 {
 door_up = 0;
 }


 if(Button(&PORTE, 0, 1, 1))
 {
 slow_closing = 1;

 if(mode == 3)
 {
 zoneA = 1;
 zoneB = 0;
 }
 }

 if(slow_closing && Button(&PORTE, 0, 1, 0))
 {

 if(mode == 1)
 {
 zoneA = 0;
 zoneB = 1;
 }
 slow_closing = 0;
 }


 if(Button(&PORTE, 1, 1, 1))
 {

 if(mode == 1)
 {
 zoneB = 0;
 zoneC = 1;
 }
 slow_opening = 1;
 }

 if(slow_opening && Button(&PORTE, 1, 1, 0))
 {

 if(mode == 3)
 {
 zoneB = 1;
 zoneC = 0;
 }
 slow_opening = 0;
 }




 if(mode == 0)
 {
 Door_Stop();
 }

 if(mode == 1)
 {

 if(!zoneC && !door_up)
 {
 Door_Open();
 }

 if(zoneC && !door_up)
 {
 Door_Open_Slow();
 }
 if(door_up)
 {
 mode = 2;
 }
 }

 if(mode == 2)
 {
 Door_Stop();
 }

 if(mode == 3)
 {

 if(!zoneA && !door_down)
 {
 Door_Close();
 }

 if(zoneA && !door_down)
 {
 Door_Close_Slow();
 }
 if(door_down)
 {
 mode = 0;
 }
 }

 }

}
