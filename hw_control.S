@ REGISTER breadboard
	.EQU	LED_PIN, 2
	.EQU	PUSHBUTTON1, 1
	.EQU	PUSHBUTTON2, 2
	.EQU	GPIO_IN, 0
	.EQU	GPIO_OUT, 1
	

@ Set up addresses for hardware registers
	.EQU	GPIO0_CTRL,   0x40014004		@ Control register for GPIO-pin 0
	
	.EQU	GPIO_OE_SET, 0xD0000024		@ Register to set pin to OUTPUT
	.EQU	GPIO_OE_CLR, 0xD0000028		@ Register to set pin to INTPUT

	.EQU	GPIO_OUT_SET, 0xD0000014	@ Set pin HIGH (1)
	.EQU	GPIO_OUT_CLR, 0xD0000018	@ Set pin LOW (0)

	.EQU	GPIO_IN_REG, 0xD0000004			@ GPIO input register


.thumb_func	@ Necessary because sdk uses BLX
.global main    @ Provide program starting address

main:
	MOV R0, #LED_PIN
	MOV R1, #GPIO_OUT
	BL initialize

    MOV R0, #PUSHBUTTON1
    MOV R1, #GPIO_IN
    BL initialize

loop: 
	MOV R0, #PUSHBUTTON1
    BL pin_read
    
    CMP R0, #0
    BEQ turn_off
    
    MOV R0, #LED_PIN
	BL pin_on
	B continue

    turn_off:
    MOV R0, #LED_PIN
	BL pin_off
	
    continue:
	B loop

initialize:
    MOV R3, R0          @ Spara pinnummer

    @ Välj SIO-funktion för GPIO
    LDR R2, =GPIO0_CTRL
    LSL R0, #3          @ 8 byte mellan GPIOx_CTRL
    ADD R0, R2

    MOV R2, #5          @ Funktion 5 = SIO
    STR R2, [R0]

    @ Välj riktning
    CMP R1, #GPIO_IN
    BEQ set_input

set_output:
    LDR R0, =GPIO_OE_SET
    B write_oe

set_input:
    LDR R0, =GPIO_OE_CLR

write_oe:
    MOV R1, #1
    LSL R1, R3          @ Skapa bitmask för vald pin
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
    MOV R3, R0
    LDR R2, =GPIO_IN_REG
    LDR R0,[R2] @Read from input register
    MOV R1, #1
    LSL R1, R3  @Bitmask for masking out the pin
    AND R0, R1
    LSR R0, R3  @Shift result bit to rightmost position
	BX LR