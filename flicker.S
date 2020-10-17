.syntax unified
.thumb

@ Register addresses from STM32F0 reference manual
.equ PERIPH_BASE,           (0x40000000)
.equ AHBPERIPH_BASE,        (PERIPH_BASE + 0x00020000)
.equ AHB2PERIPH_BASE,		(0x48000000)

.equ RCC_BASE ,             (0x40021000)
.equ GPIOA_BASE, 			(0x48000000)

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
    LDR r0, =(RCC_BASE + 0x4C)
    LDR r1, =[r0]
    ORR r1,#(1 << 0)
    STR r1, [r0]     @Store R0 value to r1
   
    @ Enable GPIOC pin 9 as output
    LDR r0, =(GPIOA_BASE + 0x00)
    LDR r1, [r0]
    ORR r1, #(1 << (4*2))	@ Every bin has 2 bit settings, hence *2
    STR r1, [r0]     @Store R0 value to r1
   

loop:

    @ Write high to pin PC9
    LDR r0, =(GPIOA_BASE + 0x14)
    LDR r1, =(1 << 4)
    STR r1, [r0]     @Store R1 value to address pointed by R0
   
    @ Dummy counter to slow down my loop
    LDR r0, =0
    LDR r1, =200000
    loop0:
    ADD r0, r0, #1
    cmp r0, r1
    bne loop0
   
    @ Write low to PC9
    LDR r0, =(GPIOA_BASE + 0x14)
    LDR r1, =(0)
    STR r1, [r0]     @Store R1 value to address pointed by R0

    @ Dummy counter to slow down my loop
    LDR r0, =0
    LDR r1, =200000
    loop1:
    ADD r0, r0, #1
    cmp r0, r1
    bne loop1

   
b loop
   
