/*
Code sections:
	.text0:	0x00000100	0x80003100	0x80005520
	.text1:	0x00002520	0x80005740	0x80161700
Data sections:
	.data0:	0x0015E4E0	0x80005520	0x80005660
	.data1:	0x0015E620	0x80005660	0x80005740
	.data2:	0x0015E700	0x80161700	0x80161720
	.data3:	0x0015E720	0x80161720	0x80161740
	.data4:	0x0015E740	0x80161740	0x80170C00
	.data5:	0x0016DC00	0x80170C00	0x801B16E0
	.data6:	0x001AE6E0	0x804F1060	0x804F22E0
	.data7:	0x001AF960	0x804F2E40	0x804F6940
BSS section:
	.bss:	0x00000000	0x801B1800	0x804F6958
Entry Point: 0x800051FC
*/
# PowerPC Register Constants
.set r0, 0
.set r1, 1
.set r2, 2
.set r3, 3
.set r4, 4
.set r5, 5
.set r6, 6
.set r7, 7
.set r8, 8
.set r9, 9
.set r10, 10
.set r11, 11
.set r12, 12
.set r13, 13
.set r14, 14
.set r15, 15
.set r16, 16
.set r17, 17
.set r18, 18
.set r19, 19
.set r20, 20
.set r21, 21
.set r22, 22
.set r23, 23
.set r24, 24
.set r25, 25
.set r26, 26
.set r27, 27
.set r28, 28
.set r29, 29
.set r30, 30
.set r31, 31
.set f0, 0
.set f1, 1
.set f2, 2
.set f3, 3
.set f4, 4
.set f5, 5
.set f6, 6
.set f7, 7
.set f8, 8
.set f9, 9
.set f10, 10
.set f11, 11
.set f12, 12
.set f13, 13
.set f14, 14
.set f15, 15
.set f16, 16
.set f17, 17
.set f18, 18
.set f19, 19
.set f20, 20
.set f21, 21
.set f22, 22
.set f23, 23
.set f24, 24
.set f25, 25
.set f26, 26
.set f27, 27
.set f28, 28
.set f29, 29
.set f30, 30
.set f31, 31
.set qr0, 0
.set qr1, 1
.set qr2, 2
.set qr3, 3
.set qr4, 4
.set qr5, 5
.set qr6, 6
.set qr7, 7
# Small Data Area (read/write) Base
.set _SDA_BASE_, 0x804F9060
# Small Data Area (read only) Base
.set _SDA2_BASE_, 0x804FAE40

.set NULL, 0
