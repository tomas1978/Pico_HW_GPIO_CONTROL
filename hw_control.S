@ REGISTER breadboard
	.EQU	LED_PIN, 0
	.EQU	PUSHBUTTON1, 1
	.EQU	PUSHBUTTON2, 2


@ Set up addresses for hardware registers
	.EQU	GPIO0_CTRL,   0x40014004		@ Control register for GPIO-pin 0
	
	.EQU	GPIO_OE_SET, 0xD0000024		@ Register to set pin to INPUT
	.EQU	GPIO_OE_CLR, 0xD0000028		@ Register to set pin to INPUT

	.EQU	GPIO_OUT_SET, 0xD0000014	@ Set pin HIGH (1)
	.EQU	GPIO_OUT_CLR, 0xD0000018	@ Set pin LOW (0)

	.EQU	GPIO_IN, 0xD0000004			@ GPIO input register


.thumb_func	@ Necessary because sdk uses BLX
.global main    @ Provide program starting address

main:

	@ Initialize pin for SIO function
	LDR R0, =GPIO0_CTRL
	MOV R1, #5		@ 5 is the SIO function
	STR R1, [R0]

	LDR R0, =GPIO_OE_SET 	@ LED = OUTPUT
	MOV R1, #1  	@ Set pin ..0001 <-> GPIO-pin 0
	STR R1, [R0]

	
	

loop: 
	MOV R0, #1
	bl pin_on
	
	B loop



pin_on:	
	@ Set GPIO-pin in R0 to HIGH
	LDR R0, =GPIO_OUT_SET
	MOV R1, #1
	STR R1, [R0]

	BX LR


pin_off:
	@ Set GPIO-pin in R0 to LOW
	LDR R0, =GPIO_OUT_CLR
	MOV R1, #1
	STR R1, [R0]

	BX LR
