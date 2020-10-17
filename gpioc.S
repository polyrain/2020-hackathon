.syntax unified
.thumb
@ symbolic names of GPIO registers
.equ GPIOC_BASE, (0x48000800) @ base addr, can add to it to get the reg
.equ RCC_BASE, (0x40021000) @ off the data sheet again

.equ RCC_AHB1ENR, (RCC_BASE + 0x48)
.equ RCC_AHB2ENR, (RCC_BASE + 0x4C) @ This register holds the data for gpi

.equ GPIOC_EN, (1 << 2) @ bit 0 is now 1, used to enable clock on gpio
.equ MODER5_OUT, (1 << 10) @ bit 10 must be 1 to output, DDR
.equ MODER3_OUT, (1 << 6)
.equ MODER6_OUT, (1 << 12)

.equ ODR_OFFSET, (0x14) @ Output data register for a GPIO
.equ GPIOC_ODR, (GPIOC_BASE + ODR_OFFSET) @ Register to set vals to out
.equ PIN_5_OUT, (1 << 5)
.equ PIN_3_OUT, (1 << 3)
.equ PIN_6_OUT, (1 << 6)

@base address for port mode register is the base addr for GPIOx
.equ GPIO_MODER_OFFSET, 0x00
.equ GPIOC_MODER, GPIOB_BASE + GPIO_MODER_OFFSET

@ reset values are the default config

@ modes refer to the specific pin number on the chip i.e. mode0 is pin 0 of the port

@ port modes: 00 = input, 01 = output, 10 = alt func, 11 = analog
@ alt func is like pwm etc

@ Make start function global so the linker can see it later
.global _start

@ Vector table
.word               0x20001000		@ Vector #0 - Stack pointer init value (0x20000000 is RAM address and 0x1000 is 4kB size, stack grows "downwards")
.word               _start			@ Vector #1 - Reset vector - where the code begins
									@ Vector #3..#n - I don't use Systick and another interrupts right now
									@				so it is not necessary to define them and code can start here

.thumb_func				@ Force the assembler to call this function in Thumb mode, that means the least significant bit in address is set
						@ Using this bit, the ARM core knows whether is jumping to the ARM or Thumb code, Cortex supports only Thumb
						@ Also you can use ".type	_start, %function"
_start:

    @ Enable clock for GPIOC peripheral in RCC registers
    LDR r0, =(RCC_AHB2ENR)
    LDR r1, =(GPIOC_EN)
    STR r1, [r0]     @Store R0 value to r1
   
    @ Enable GPIOC pin 9 as output
    LDR r0, =(GPIOC_BASE + 0x00)
    LDR r1, =(1 << (9*2))	@ Every bin has 2 bit settings, hence *2
    STR r1, [r0]     @Store R0 value to r1
   

loop:

    @ Write high to pin PC9
    LDR r0, =(GPIOC_BASE + 0x14)
    LDR r1, =(1 << 9)
    STR r1, [r0]     @Store R1 value to address pointed by R0
   
    @ Dummy counter to slow down my loop
    LDR R0, =0
    LDR R1, =200000
    loop0:
    ADD R0, R0, #1
    cmp R0, R1
    bne loop0
   
    @ Write low to PC9
    LDR r0, =(GPIOC_BASE + 0x14)
    LDR r1, =(0)
    STR r1, [r0]     @Store R1 value to address pointed by R0

    @ Dummy counter to slow down my loop
    LDR R0, =0
    LDR R1, =200000
    loop1:
    ADD R0, R0, #1
    cmp R0, R1
    bne loop1

   
b loop
   
