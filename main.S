.syntax unified
.cpu cortex-m4
.thumb
@ symbolic names of GPIO registers
.equ GPIOA_BASE, (0x48000000) @ base addr, can add to it to get the reg
.equ RCC_BASE, (0x40021000) @ off the data sheet again

.equ RCC_AHB1ENR, (RCC_BASE + 0x48)
.equ RCC_AHB2ENR, (RCC_BASE + 0x4C) @ This register holds the data for gpi

.equ GPIOA_EN, (1 << 0) @ bit 0 is now 1, used to enable clock on gpio
.equ MODER5_OUT, (1 << 10) @ bit 10 must be 1 to output, DDR
.equ MODER3_OUT, (1 << 6)
.equ MODER6_OUT, (1 << 12)
.equ MODER4_OUT, (1 << 8)

.equ ODR_OFFSET, (0x14) @ Output data register for a GPIO
.equ GPIOA_ODR, (GPIOA_BASE + ODR_OFFSET) @ Register to set vals to out
.equ PIN_5_OUT, (1 << 5)
.equ PIN_3_OUT, (1 << 3)
.equ PIN_6_OUT, (1 << 6)
.equ PIN_4_OUT, (1 << 4)

@base address for port mode register is the base addr for GPIOx
.equ GPIO_MODER_OFFSET, 0x00
.equ GPIOA_MODER, GPIOA_BASE + GPIO_MODER_OFFSET

@ reset values are the default config

@ modes refer to the specific pin number on the chip i.e. mode0 is pin 0 of the port

@ port modes: 00 = input, 01 = output, 10 = alt func, 11 = analog
@ alt func is like pwm etc
@ bit number 0 on AHB2 is GPIOAEN

@ here lies the test program

.thumb_func

@ lets cook jesse
_start:

    @ begin by putting addr into general purpose reg 0
    LDR r0, =(RCC_AHB2ENR)
    @ Load value at that address (r0) into r1
    LDR r1, [r0] @ [x] takes the values from x
    @ perform a bitwise OR to ensure only the bit we need set turns only
    ORR r1,#GPIOA_EN @ or the register values with the enable def
    @store the content in r1 at the address stored in r0
    STR r1, [r0]

    @ Time to turn on the mode
    LDR r0, =(GPIOA_MODER)
    LDR r1,[r0]
    ORR r1,#MODER4_OUT
    STR r1,[r0] @ Placing the right bits to make pin 5 an output

    @LDR r0, =(GPIOA_ODR)
    @LDR r1, =(PIN_4_OUT)
    @STR r1,[r0]

    BX LR @return from subroutine

loop:
    LDR r0, =(GPIOA_ODR)
    LDR r1, =(PIN_4_OUT)
    STR r1, [r0]
b loop

