.syntax unified
.cpu cortex-m4
.thumb
.equ GPIOB_BASE, 0x48000400
.equ RCC_BASE, 0x40021000

ldr r0, =(1 << 1) @ Bit 1 is the GPIOB enable
ldr r1, =(RCC_BASE + 0x4C) @ Grab the address for AHB2ENR
str r0, [r1]			

ldr r0, =(1 << 6) @ Bit 6 is needed to be 1 to set GPIOB_3 to OUTPUT
ldr r1, =(GPIOB_BASE)
str r0, [r1]			

ldr r0, =(0x04) @ Now want to write to bit 3 to set it to output 1
ldr r1, =(GPIOB_BASE + 0x14)
str r0, [r1]			
b .
