@ REGISTER breadboard
	.EQU	LED_PIN, 1
	.EQU	PUSHBUTTON1, 1
	.EQU	PUSHBUTTON2, 2
	.EQU	GPIO_INPUT, 0
	.EQU	GPIO_OUTPUT, 1
	

@ Set up addresses for hardware registers
	.EQU	GPIO0_CTRL,   0x40014004		@ Control register for GPIO-pin 0
	
	.EQU	GPIO_OE_SET, 0xD0000024		@ Register to set pin to OUTPUT
	.EQU	GPIO_OE_CLR, 0xD0000028		@ Register to set pin to INTPUT

	.EQU	GPIO_OUT_SET, 0xD0000014	@ Set pin HIGH (1)
	.EQU	GPIO_OUT_CLR, 0xD0000018	@ Set pin LOW (0)

	.EQU	GPIO_IN, 0xD0000004			@ GPIO input register


.thumb_func	@ Necessary because sdk uses BLX
.global main    @ Provide program starting address

main:
	MOV R0, #LED_PIN
	MOV R1, #GPIO_OUTPUT
	BL initialize

loop: 
	MOV R0, #LED_PIN
	bl pin_on
	
	B loop

initialize:
CMP R1, #0
BEQ set_input

set_output:
    LDR R0, =GPIO_OE_SET
    B write_oe

set_input:
    LDR R0, =GPIO_OE_CLR

write_oe:
    MOV R1, #1
    LSL R1, R3
    STR R1, [R0]
    BX LR

pin_on:
    LDR R2, =GPIO_OUT_SET
    MOV R1, #1
    LSL R1, R0
    STR R1, [R2]
    BX LR

pin_off:
    LDR R2, =GPIO_OUT_CLR
    MOV R1, #1
    LSL R1, R0
    STR R1, [R2]
    BX LR

pin_read:
	@Code for checking if input on pin is HIGH or LOW
	BX LR