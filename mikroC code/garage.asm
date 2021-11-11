
_Sleep_Start:

;garage.c,50 :: 		void Sleep_Start()
;garage.c,52 :: 		OSCCON.IDLEN = 0;
	BCF         OSCCON+0, 7 
;garage.c,53 :: 		asm sleep;
	SLEEP
;garage.c,54 :: 		}
L_end_Sleep_Start:
	RETURN      0
; end of _Sleep_Start

_interrupt:

;garage.c,57 :: 		void interrupt()
;garage.c,60 :: 		if(INTCON.TMR0IF)
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt0
;garage.c,62 :: 		cnt++;
	INCF        _cnt+0, 1 
;garage.c,64 :: 		TMR0L = 0x00;
	CLRF        TMR0L+0 
;garage.c,65 :: 		TMR0H = 0x00;
	CLRF        TMR0H+0 
;garage.c,67 :: 		if(cnt >= 1)
	MOVLW       1
	SUBWF       _cnt+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt1
;garage.c,70 :: 		T0CON.TMR0ON = 0;
	BCF         T0CON+0, 7 
;garage.c,73 :: 		BULB = 0;
	BCF         LATA+0, 3 
;garage.c,74 :: 		LED_LIGHT1 = 0;
	BCF         LATA+0, 1 
;garage.c,75 :: 		LED_LIGHT2 = 0;
	BCF         LATA+0, 2 
;garage.c,77 :: 		Sleep_Start();
	CALL        _Sleep_Start+0, 0
;garage.c,79 :: 		cnt = 0;
	CLRF        _cnt+0 
;garage.c,80 :: 		}
L_interrupt1:
;garage.c,81 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;garage.c,82 :: 		}
L_interrupt0:
;garage.c,85 :: 		if(INTCON3.INT1IF)
	BTFSS       INTCON3+0, 0 
	GOTO        L_interrupt2
;garage.c,87 :: 		INTCON3.INT1IF = 0;
	BCF         INTCON3+0, 0 
;garage.c,88 :: 		}
L_interrupt2:
;garage.c,91 :: 		if(INTCON3.INT2IF)
	BTFSS       INTCON3+0, 1 
	GOTO        L_interrupt3
;garage.c,93 :: 		INTCON3.INT2IF = 0;
	BCF         INTCON3+0, 1 
;garage.c,94 :: 		}
L_interrupt3:
;garage.c,95 :: 		}
L_end_interrupt:
L__interrupt79:
	RETFIE      1
; end of _interrupt

_MCU_Init:

;garage.c,98 :: 		void MCU_Init()
;garage.c,100 :: 		ANSELA=0x00;
	CLRF        ANSELA+0 
;garage.c,101 :: 		ANSELB=0x00;
	CLRF        ANSELB+0 
;garage.c,102 :: 		ANSELC=0x00;
	CLRF        ANSELC+0 
;garage.c,103 :: 		ANSELD=0x00;
	CLRF        ANSELD+0 
;garage.c,104 :: 		ANSELE=0x00;
	CLRF        ANSELE+0 
;garage.c,105 :: 		TRISA=0x00;
	CLRF        TRISA+0 
;garage.c,106 :: 		TRISB=0b00011111;
	MOVLW       31
	MOVWF       TRISB+0 
;garage.c,107 :: 		TRISC=0x00;
	CLRF        TRISC+0 
;garage.c,108 :: 		TRISD=0x00;
	CLRF        TRISD+0 
;garage.c,109 :: 		TRISE=0b00000011;
	MOVLW       3
	MOVWF       TRISE+0 
;garage.c,110 :: 		LATA=0x00;
	CLRF        LATA+0 
;garage.c,111 :: 		LATB=0x00;
	CLRF        LATB+0 
;garage.c,112 :: 		LATC=0x00;
	CLRF        LATC+0 
;garage.c,113 :: 		LATD=0x00;
	CLRF        LATD+0 
;garage.c,114 :: 		LATE=0x00;
	CLRF        LATE+0 
;garage.c,116 :: 		PWM1_Init(5000);
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;garage.c,117 :: 		PWM2_Init(5000);
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM2_Init+0, 0
;garage.c,119 :: 		Delay_ms(150);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       134
	MOVWF       R12, 0
	MOVLW       153
	MOVWF       R13, 0
L_MCU_Init4:
	DECFSZ      R13, 1, 1
	BRA         L_MCU_Init4
	DECFSZ      R12, 1, 1
	BRA         L_MCU_Init4
	DECFSZ      R11, 1, 1
	BRA         L_MCU_Init4
;garage.c,120 :: 		}
L_end_MCU_Init:
	RETURN      0
; end of _MCU_Init

_Flags_Init:

;garage.c,123 :: 		void Flags_Init()
;garage.c,125 :: 		start_state = 0;
	BCF         _start_state+0, BitPos(_start_state+0) 
;garage.c,126 :: 		start_state2 = 0;
	BCF         _start_state2+0, BitPos(_start_state2+0) 
;garage.c,127 :: 		mode = 0;
	CLRF        _mode+0 
;garage.c,128 :: 		door_down = 0;
	BCF         _door_down+0, BitPos(_door_down+0) 
;garage.c,129 :: 		door_up = 0;
	BCF         _door_up+0, BitPos(_door_up+0) 
;garage.c,130 :: 		slow_opening = 0;
	BCF         _slow_opening+0, BitPos(_slow_opening+0) 
;garage.c,131 :: 		slow_closing = 0;
	BCF         _slow_closing+0, BitPos(_slow_closing+0) 
;garage.c,132 :: 		zoneA = 1;
	BSF         _zoneA+0, BitPos(_zoneA+0) 
;garage.c,133 :: 		zoneB = 0;
	BCF         _zoneB+0, BitPos(_zoneB+0) 
;garage.c,134 :: 		zoneC = 0;
	BCF         _zoneC+0, BitPos(_zoneC+0) 
;garage.c,135 :: 		}
L_end_Flags_Init:
	RETURN      0
; end of _Flags_Init

_Door_Stop:

;garage.c,138 :: 		void Door_Stop()
;garage.c,140 :: 		PWM1_Stop();
	CALL        _PWM1_Stop+0, 0
;garage.c,141 :: 		PWM2_Stop();
	CALL        _PWM2_Stop+0, 0
;garage.c,143 :: 		BRIDGE1_ENABLE = 0;
	BCF         LATB+0, 5 
;garage.c,144 :: 		BRIDGE2_ENABLE = 0;
	BCF         LATD+0, 1 
;garage.c,145 :: 		DIRECTION1 = 0;
	BCF         LATC+0, 2 
;garage.c,146 :: 		DIRECTION2 = 0;
	BCF         LATC+0, 1 
;garage.c,147 :: 		}
L_end_Door_Stop:
	RETURN      0
; end of _Door_Stop

_Door_Open:

;garage.c,150 :: 		void Door_Open()
;garage.c,152 :: 		BRIDGE1_ENABLE = 1;
	BSF         LATB+0, 5 
;garage.c,153 :: 		BRIDGE2_ENABLE = 1;
	BSF         LATD+0, 1 
;garage.c,155 :: 		PWM1_Set_Duty(90);
	MOVLW       90
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;garage.c,156 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;garage.c,157 :: 		}
L_end_Door_Open:
	RETURN      0
; end of _Door_Open

_Door_Open_Slow:

;garage.c,160 :: 		void Door_Open_Slow()
;garage.c,162 :: 		BRIDGE1_ENABLE = 1;
	BSF         LATB+0, 5 
;garage.c,163 :: 		BRIDGE2_ENABLE = 1;
	BSF         LATD+0, 1 
;garage.c,165 :: 		PWM1_Set_Duty(80);
	MOVLW       80
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;garage.c,166 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;garage.c,167 :: 		}
L_end_Door_Open_Slow:
	RETURN      0
; end of _Door_Open_Slow

_Door_Close:

;garage.c,170 :: 		void Door_Close()
;garage.c,172 :: 		BRIDGE1_ENABLE = 1;
	BSF         LATB+0, 5 
;garage.c,173 :: 		BRIDGE2_ENABLE = 1;
	BSF         LATD+0, 1 
;garage.c,175 :: 		PWM2_Set_Duty(90);
	MOVLW       90
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;garage.c,176 :: 		PWM2_Start();
	CALL        _PWM2_Start+0, 0
;garage.c,177 :: 		}
L_end_Door_Close:
	RETURN      0
; end of _Door_Close

_Door_Close_Slow:

;garage.c,180 :: 		void Door_Close_Slow()
;garage.c,182 :: 		BRIDGE1_ENABLE = 1;
	BSF         LATB+0, 5 
;garage.c,183 :: 		BRIDGE2_ENABLE = 1;
	BSF         LATD+0, 1 
;garage.c,185 :: 		PWM2_Set_Duty(80);
	MOVLW       80
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;garage.c,186 :: 		PWM2_Start();
	CALL        _PWM2_Start+0, 0
;garage.c,187 :: 		}
L_end_Door_Close_Slow:
	RETURN      0
; end of _Door_Close_Slow

_Interrupt_Init:

;garage.c,190 :: 		void Interrupt_Init()
;garage.c,193 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;garage.c,196 :: 		INTCON.PEIE = 1;
	BSF         INTCON+0, 6 
;garage.c,199 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;garage.c,200 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;garage.c,203 :: 		INTCON3.INT1IF = 0;
	BCF         INTCON3+0, 0 
;garage.c,204 :: 		INTCON2.INTEDG1 = 1;
	BSF         INTCON2+0, 5 
;garage.c,205 :: 		INTCON3.INT1IE = 1;
	BSF         INTCON3+0, 3 
;garage.c,208 :: 		INTCON3.INT2IF = 0;
	BCF         INTCON3+0, 1 
;garage.c,209 :: 		INTCON2.INTEDG2 = 1;
	BSF         INTCON2+0, 4 
;garage.c,210 :: 		INTCON3.INT2IE = 1;
	BSF         INTCON3+0, 4 
;garage.c,211 :: 		}
L_end_Interrupt_Init:
	RETURN      0
; end of _Interrupt_Init

_Timer_Start:

;garage.c,214 :: 		void Timer_Start()
;garage.c,217 :: 		T0CON = 0b00000111;
	MOVLW       7
	MOVWF       T0CON+0 
;garage.c,218 :: 		TMR0L = 0x00;
	CLRF        TMR0L+0 
;garage.c,219 :: 		TMR0H = 0x00;
	CLRF        TMR0H+0 
;garage.c,220 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;garage.c,221 :: 		T0CON.TMR0ON = 1;
	BSF         T0CON+0, 7 
;garage.c,222 :: 		}
L_end_Timer_Start:
	RETURN      0
; end of _Timer_Start

_Lights_On:

;garage.c,225 :: 		void Lights_On()
;garage.c,227 :: 		BULB = 1;
	BSF         LATA+0, 3 
;garage.c,228 :: 		LED_LIGHT1 = 1;
	BSF         LATA+0, 1 
;garage.c,229 :: 		LED_LIGHT2 = 1;
	BSF         LATA+0, 2 
;garage.c,232 :: 		Timer_Start();
	CALL        _Timer_Start+0, 0
;garage.c,233 :: 		}
L_end_Lights_On:
	RETURN      0
; end of _Lights_On

_main:

;garage.c,236 :: 		void main() {
;garage.c,238 :: 		cnt = 0;
	CLRF        _cnt+0 
;garage.c,240 :: 		MCU_Init();
	CALL        _MCU_Init+0, 0
;garage.c,241 :: 		Flags_Init();
	CALL        _Flags_Init+0, 0
;garage.c,242 :: 		Interrupt_Init();
	CALL        _Interrupt_Init+0, 0
;garage.c,244 :: 		Sleep_Start();
	CALL        _Sleep_Start+0, 0
;garage.c,246 :: 		while(1)
L_main5:
;garage.c,267 :: 		if (Button(&PORTB, 1, 1, 1))
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
;garage.c,269 :: 		start_state = 1;
	BSF         _start_state+0, BitPos(_start_state+0) 
;garage.c,270 :: 		}
L_main7:
;garage.c,271 :: 		if (start_state && Button(&PORTB, 1, 1, 0))
	BTFSS       _start_state+0, BitPos(_start_state+0) 
	GOTO        L_main10
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
L__main76:
;garage.c,273 :: 		if(mode >= 0 && mode < 3)
	MOVLW       0
	SUBWF       _mode+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main13
	MOVLW       3
	SUBWF       _mode+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main13
L__main75:
;garage.c,275 :: 		mode ++;
	INCF        _mode+0, 1 
;garage.c,276 :: 		}
	GOTO        L_main14
L_main13:
;garage.c,277 :: 		else if(mode == 3)
	MOVF        _mode+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main15
;garage.c,279 :: 		mode = 0;
	CLRF        _mode+0 
;garage.c,280 :: 		}
	GOTO        L_main16
L_main15:
;garage.c,283 :: 		mode = 0;
	CLRF        _mode+0 
;garage.c,284 :: 		}
L_main16:
L_main14:
;garage.c,285 :: 		Lights_On();
	CALL        _Lights_On+0, 0
;garage.c,286 :: 		start_state = 0;
	BCF         _start_state+0, BitPos(_start_state+0) 
;garage.c,287 :: 		}
L_main10:
;garage.c,290 :: 		if (Button(&PORTB, 2, 1, 1))
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main17
;garage.c,292 :: 		start_state2 = 1;
	BSF         _start_state2+0, BitPos(_start_state2+0) 
;garage.c,293 :: 		}
L_main17:
;garage.c,294 :: 		if (start_state2 && Button(&PORTB, 2, 1, 0))
	BTFSS       _start_state2+0, BitPos(_start_state2+0) 
	GOTO        L_main20
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main20
L__main74:
;garage.c,296 :: 		if(mode >= 0 && mode < 3)
	MOVLW       0
	SUBWF       _mode+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main23
	MOVLW       3
	SUBWF       _mode+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main23
L__main73:
;garage.c,298 :: 		mode ++;
	INCF        _mode+0, 1 
;garage.c,299 :: 		}
	GOTO        L_main24
L_main23:
;garage.c,300 :: 		else if(mode == 3)
	MOVF        _mode+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main25
;garage.c,302 :: 		mode = 0;
	CLRF        _mode+0 
;garage.c,303 :: 		}
	GOTO        L_main26
L_main25:
;garage.c,306 :: 		mode = 0;
	CLRF        _mode+0 
;garage.c,307 :: 		}
L_main26:
L_main24:
;garage.c,308 :: 		Lights_On();
	CALL        _Lights_On+0, 0
;garage.c,309 :: 		start_state2 = 0;
	BCF         _start_state2+0, BitPos(_start_state2+0) 
;garage.c,310 :: 		}
L_main20:
;garage.c,313 :: 		if(Button(&PORTB, 4, 1, 1))
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       4
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main27
;garage.c,315 :: 		door_down = 1;
	BSF         _door_down+0, BitPos(_door_down+0) 
;garage.c,316 :: 		}
L_main27:
;garage.c,317 :: 		if(door_down && Button(&PORTB, 4, 1, 0))
	BTFSS       _door_down+0, BitPos(_door_down+0) 
	GOTO        L_main30
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       4
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main30
L__main72:
;garage.c,319 :: 		door_down = 0;
	BCF         _door_down+0, BitPos(_door_down+0) 
;garage.c,320 :: 		}
L_main30:
;garage.c,322 :: 		if(Button(&PORTB, 3, 1, 1))
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       3
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main31
;garage.c,324 :: 		door_up = 1;
	BSF         _door_up+0, BitPos(_door_up+0) 
;garage.c,325 :: 		}
L_main31:
;garage.c,326 :: 		if(door_up && Button(&PORTB, 3, 1, 0))
	BTFSS       _door_up+0, BitPos(_door_up+0) 
	GOTO        L_main34
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       3
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main34
L__main71:
;garage.c,328 :: 		door_up = 0;
	BCF         _door_up+0, BitPos(_door_up+0) 
;garage.c,329 :: 		}
L_main34:
;garage.c,332 :: 		if(Button(&PORTE, 0, 1, 1))
	MOVLW       PORTE+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main35
;garage.c,334 :: 		slow_closing = 1;
	BSF         _slow_closing+0, BitPos(_slow_closing+0) 
;garage.c,336 :: 		if(mode == 3)
	MOVF        _mode+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main36
;garage.c,338 :: 		zoneA = 1;
	BSF         _zoneA+0, BitPos(_zoneA+0) 
;garage.c,339 :: 		zoneB = 0;
	BCF         _zoneB+0, BitPos(_zoneB+0) 
;garage.c,340 :: 		}
L_main36:
;garage.c,341 :: 		}
L_main35:
;garage.c,343 :: 		if(slow_closing && Button(&PORTE, 0, 1, 0))
	BTFSS       _slow_closing+0, BitPos(_slow_closing+0) 
	GOTO        L_main39
	MOVLW       PORTE+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main39
L__main70:
;garage.c,346 :: 		if(mode == 1)
	MOVF        _mode+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main40
;garage.c,348 :: 		zoneA = 0;
	BCF         _zoneA+0, BitPos(_zoneA+0) 
;garage.c,349 :: 		zoneB = 1;
	BSF         _zoneB+0, BitPos(_zoneB+0) 
;garage.c,350 :: 		}
L_main40:
;garage.c,351 :: 		slow_closing = 0;
	BCF         _slow_closing+0, BitPos(_slow_closing+0) 
;garage.c,352 :: 		}
L_main39:
;garage.c,355 :: 		if(Button(&PORTE, 1, 1, 1))
	MOVLW       PORTE+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main41
;garage.c,358 :: 		if(mode == 1)
	MOVF        _mode+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main42
;garage.c,360 :: 		zoneB = 0;
	BCF         _zoneB+0, BitPos(_zoneB+0) 
;garage.c,361 :: 		zoneC = 1;
	BSF         _zoneC+0, BitPos(_zoneC+0) 
;garage.c,362 :: 		}
L_main42:
;garage.c,363 :: 		slow_opening = 1;
	BSF         _slow_opening+0, BitPos(_slow_opening+0) 
;garage.c,364 :: 		}
L_main41:
;garage.c,366 :: 		if(slow_opening && Button(&PORTE, 1, 1, 0))
	BTFSS       _slow_opening+0, BitPos(_slow_opening+0) 
	GOTO        L_main45
	MOVLW       PORTE+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main45
L__main69:
;garage.c,369 :: 		if(mode == 3)
	MOVF        _mode+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main46
;garage.c,371 :: 		zoneB = 1;
	BSF         _zoneB+0, BitPos(_zoneB+0) 
;garage.c,372 :: 		zoneC = 0;
	BCF         _zoneC+0, BitPos(_zoneC+0) 
;garage.c,373 :: 		}
L_main46:
;garage.c,374 :: 		slow_opening = 0;
	BCF         _slow_opening+0, BitPos(_slow_opening+0) 
;garage.c,375 :: 		}
L_main45:
;garage.c,380 :: 		if(mode == 0)
	MOVF        _mode+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main47
;garage.c,382 :: 		Door_Stop();
	CALL        _Door_Stop+0, 0
;garage.c,383 :: 		}
L_main47:
;garage.c,385 :: 		if(mode == 1)
	MOVF        _mode+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main48
;garage.c,388 :: 		if(!zoneC && !door_up)
	BTFSC       _zoneC+0, BitPos(_zoneC+0) 
	GOTO        L_main51
	BTFSC       _door_up+0, BitPos(_door_up+0) 
	GOTO        L_main51
L__main68:
;garage.c,390 :: 		Door_Open();
	CALL        _Door_Open+0, 0
;garage.c,391 :: 		}
L_main51:
;garage.c,393 :: 		if(zoneC && !door_up)
	BTFSS       _zoneC+0, BitPos(_zoneC+0) 
	GOTO        L_main54
	BTFSC       _door_up+0, BitPos(_door_up+0) 
	GOTO        L_main54
L__main67:
;garage.c,395 :: 		Door_Open_Slow();
	CALL        _Door_Open_Slow+0, 0
;garage.c,396 :: 		}
L_main54:
;garage.c,397 :: 		if(door_up)
	BTFSS       _door_up+0, BitPos(_door_up+0) 
	GOTO        L_main55
;garage.c,399 :: 		mode = 2;
	MOVLW       2
	MOVWF       _mode+0 
;garage.c,400 :: 		}
L_main55:
;garage.c,401 :: 		}
L_main48:
;garage.c,403 :: 		if(mode == 2)
	MOVF        _mode+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main56
;garage.c,405 :: 		Door_Stop();
	CALL        _Door_Stop+0, 0
;garage.c,406 :: 		}
L_main56:
;garage.c,408 :: 		if(mode == 3)
	MOVF        _mode+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main57
;garage.c,411 :: 		if(!zoneA && !door_down)
	BTFSC       _zoneA+0, BitPos(_zoneA+0) 
	GOTO        L_main60
	BTFSC       _door_down+0, BitPos(_door_down+0) 
	GOTO        L_main60
L__main66:
;garage.c,413 :: 		Door_Close();
	CALL        _Door_Close+0, 0
;garage.c,414 :: 		}
L_main60:
;garage.c,416 :: 		if(zoneA && !door_down)
	BTFSS       _zoneA+0, BitPos(_zoneA+0) 
	GOTO        L_main63
	BTFSC       _door_down+0, BitPos(_door_down+0) 
	GOTO        L_main63
L__main65:
;garage.c,418 :: 		Door_Close_Slow();
	CALL        _Door_Close_Slow+0, 0
;garage.c,419 :: 		}
L_main63:
;garage.c,420 :: 		if(door_down)
	BTFSS       _door_down+0, BitPos(_door_down+0) 
	GOTO        L_main64
;garage.c,422 :: 		mode = 0;
	CLRF        _mode+0 
;garage.c,423 :: 		}
L_main64:
;garage.c,424 :: 		}
L_main57:
;garage.c,426 :: 		}//while loop
	GOTO        L_main5
;garage.c,428 :: 		}// main loop
L_end_main:
	GOTO        $+0
; end of _main
