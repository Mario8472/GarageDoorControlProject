# GarageDoorControlProject
Hardware and Software for Garage door control (retrofit) 

   Project:    Garage Door Control Unit
   MCU:        PIC18F45K22
   Hardware:   Garage Door Control PCB Card
   Software:   mikroC PRO for PIC18
   Author:     Mario Oletić
   
   Project description:
   -----------------------------------------------------------------------------
   This project is developed (both hardware and software) for replacing/retrofit
   the old garage door PCB. PCB has six input signals (24VDC level). Two of 
   them are used for starting the door movements (opening or closing). Doors can
   be started with radio switch (Input1) with 24VDC signal output or some other 
   common switch (Input2). Other four inputs are used for external capacitive or
   inductive sensors to determine door position - two for UP and DOWN positions 
   and two to determine a position of doors while approaching CLOSE or OPEN 
   positions. The last two positions are used for slowing the doors down. 
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
   MCU wakes up. 
