
/*
   Project:    Garage Door Control Unit
   MCU:        PIC18F45K22
   Hardware:   Garage Door Control PCB Card
   Author:     Mario Oletiæ
   
   Project description:
   -----------------------------------------------------------------------------
   This project is developed (both hardware and software) for replacing/retrofit
   of the old garage door PCB. PCB has six input signals (24VDC level). Two of 
   them are used for starting the door movements (opening or closing). Doors can
   be started with radio switch (Input1) with 24VDC signal output or some other 
   common switch (Input2). Other four inputs are used for external capacitive or
   inductive sensors to determine door position - two for UP and DOWN positions 
   and two to determine a position of doors while approaching CLOSE or OPEN 
   positions. The last two positions are used for slowing down the doors. 
   Signals on INPUT1 and INPUT2 are switching between four working modes. MODE 0 
   and MODE2 are for stoping, MODE1 for opening and MODE3 for closing the doors.
   Outputs are used for controlling the 24V DC motor with PWM signals. Depending 
   on the door position, the motor can rotate with two different speeds (speed 
   depends on the PWM duty cycle) - one is for normal door speed and the other 
   (slower) is for approaching final positions. Also, when activating the door, 
   lights turn on. There are two outputs for 24V DC LED lights and one output 
   for 230V AC light bulb which is controlled via Triac. Triac is triggered with 
   OptoTriac IC with zero-cross detection circuit. Also, OptoTriac isolates 230V 
   AC system from the rest of the PCB low voltage systems. Lights will be turned 
   off after doors are stoped, no matter in what position, after a fixed period 
   of time passes. When doors are not moving, MCU goes into sleep mode with much 
   lower current consumption. When a new signal for activating the doors appears, 
   MCU wakes up. On the PCB there is also mikroBUS connector, for possible future 
   upgrades with BLE or WiFi technologies so the door can be controlled through 
   PC or Smartphone Apps.
*/

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

// Function sends MCU in sleep mode
void Sleep_Start()
{
   OSCCON.IDLEN = 0;
   asm sleep;
}

// Intrrupt function
void interrupt()
{
   // TMR0 Interrupt
   if(INTCON.TMR0IF)
   {
       cnt++;
       
       TMR0L = 0x00;
       TMR0H = 0x00;
       
       if(cnt >= 1)
       {
       // Stop Timer0
       T0CON.TMR0ON = 0;
       
       // Turn off the lights
       BULB = 0;
       LED_LIGHT1 = 0;
       LED_LIGHT2 = 0;
       
       Sleep_Start();
       
       cnt = 0;
       }
       INTCON.TMR0IF = 0;
   }
   
   // External Interrupt INT1
   if(INTCON3.INT1IF)
   {
      INTCON3.INT1IF = 0;
   }
   
   // External Interrupt INT2
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

// Setting program flags
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

// Function stops motors
void Door_Stop()
{
   PWM1_Stop();
   PWM2_Stop();

   BRIDGE1_ENABLE = 0;
   BRIDGE2_ENABLE = 0;
   DIRECTION1 = 0;
   DIRECTION2 = 0;
}

// Function for opening the door
void Door_Open()
{
   BRIDGE1_ENABLE = 1;
   BRIDGE2_ENABLE = 1;

   PWM1_Set_Duty(90);
   PWM1_Start();
}

// Function for slow opening approach
void Door_Open_Slow()
{
   BRIDGE1_ENABLE = 1;
   BRIDGE2_ENABLE = 1;

   PWM1_Set_Duty(80);
   PWM1_Start();
}

// Function for closing the door
void Door_Close()
{
   BRIDGE1_ENABLE = 1;
   BRIDGE2_ENABLE = 1;

   PWM2_Set_Duty(90);
   PWM2_Start();
}

// Function for slow closing approach
void Door_Close_Slow()
{
   BRIDGE1_ENABLE = 1;
   BRIDGE2_ENABLE = 1;

   PWM2_Set_Duty(80);
   PWM2_Start();
}

// Interrupt initialisation
void Interrupt_Init()
{
   // Global Interrupt Enable
   INTCON.GIE = 1;
   
   // Peripheral Interrupt Enable
   INTCON.PEIE = 1;
   
   // TMR0 Interrupt
   INTCON.TMR0IF = 0;
   INTCON.TMR0IE = 1;
   
   // External Interrupt INT1
   INTCON3.INT1IF = 0;
   INTCON2.INTEDG1 = 1;
   INTCON3.INT1IE = 1;
   
   // External Interrupt INT2
   INTCON3.INT2IF = 0;
   INTCON2.INTEDG2 = 1;
   INTCON3.INT2IE = 1;
}

// Seting the timer for lights
void Timer_Start()
{
   //Prescaler 1:256
   T0CON = 0b00000111;
   TMR0L = 0x00;
   TMR0H = 0x00;
   INTCON.TMR0IE = 1;
   T0CON.TMR0ON = 1;
}

// Turn on the lights
void Lights_On()
{
   BULB = 1;
   LED_LIGHT1 = 1;
   LED_LIGHT2 = 1;
   
   // Start Timer0
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
     /*************************************************************
                            STATUS BITS
     **************************************************************/
     /*
     LATD.B5 = zoneA;
     LATD.B6 = zoneB;
     LATD.B7 = zoneC;
     LATC.B4 = door_down;
     LATC.B5 = slow_opening;
     LATC.B6 = door_up;
     LATC.B7 = slow_closing;
     */
     /************************************************************/
     

     /************************************************************
                       Flags setting
     *************************************************************/
     // Signal for opening/closing appears - IN1 (RB1 pin)
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
     
     // Signal for opening/closing appears - IN2 (RB2 pin)
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
     
     // Signal for door_closed - IN4 (RB4 pin)
     if(Button(&PORTB, 4, 1, 1))
     {
        door_down = 1;
     }
     if(door_down && Button(&PORTB, 4, 1, 0))
     {
        door_down = 0;
     }
     // Signal for door_up - IN3 (RB3 pin)
     if(Button(&PORTB, 3, 1, 1))
     {
        door_up = 1;
     }
     if(door_up && Button(&PORTB, 3, 1, 0))
     {
        door_up = 0;
     }
     //Signal on IN5 (RE0) - door approaching closed position
     // low to high transition
     if(Button(&PORTE, 0, 1, 1))
     {
        slow_closing = 1;
        // While closing
        if(mode == 3)
        {
           zoneA = 1;
           zoneB = 0;
        }
     }
     // high to low transition
     if(slow_closing && Button(&PORTE, 0, 1, 0))
     {
        // while opening
        if(mode == 1)
        {
           zoneA = 0;
           zoneB = 1;
        }
        slow_closing = 0;
     }
     //Signal on IN6 (RE1) - door approaching open position
     // low to high transition
     if(Button(&PORTE, 1, 1, 1))
     {
        // While opening
        if(mode == 1)
        {
           zoneB = 0;
           zoneC = 1;
        }
        slow_opening = 1;
     }
     // high to low transition
     if(slow_opening && Button(&PORTE, 1, 1, 0))
     {
        // while closing
        if(mode == 3)
        {
           zoneB = 1;
           zoneC = 0;
        }
        slow_opening = 0;
     }
     /************************************************************/


     // Doors stop - while closing & start position at power up
     if(mode == 0)
     {
         Door_Stop();
     }
     // Doors are opening
     if(mode == 1)
     {
         // Full speed
         if(!zoneC && !door_up)
         {
            Door_Open();
         }
         // Slow speed
         if(zoneC && !door_up)
         {
            Door_Open_Slow();
         }
         if(door_up)
         {
            mode = 2;
         }
     }
     // Doors stop - while opening
     if(mode == 2)
     {
         Door_Stop();
     }
     // Doors are closing
     if(mode == 3)
     {
         // Full speed
         if(!zoneA && !door_down)
         {
            Door_Close();
         }
         // Slow speed
         if(zoneA && !door_down)
         {
            Door_Close_Slow();
         }
         if(door_down)
         {
            mode = 0;
         }
     }
     
  }//while loop
  
}// main loop