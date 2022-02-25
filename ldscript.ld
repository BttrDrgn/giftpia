ENTRY(__start)
_SDA_BASE_ = 0x804F9060;
_SDA2_BASE_ = 0x804FAE40;
PHDRS
{
    text0 PT_LOAD;
    text1 PT_LOAD;
    data0 PT_LOAD;
    data1 PT_LOAD;
    data2 PT_LOAD;
    data3 PT_LOAD;
    data4 PT_LOAD;
    data5 PT_LOAD;
    data6 PT_LOAD;
    data7 PT_LOAD;
    bss PT_LOAD;
}
SECTIONS
{
    .text0 0x80003100 : { *(.text0) } : text0
    .text1 0x80005740 : { *(.text1) } : text1
    .data0 0x80005520 : { *(.data0) } : data0
    .data1 0x80005660 : { *(.data1) } : data1
    .data2 0x80161700 : { *(.data2) } : data2
    .data3 0x80161720 : { *(.data3) } : data3
    .data4 0x80161740 : { *(.data4) } : data4
    .data5 0x80170C00 : { *(.data5) } : data5
    .data6 0x804F1060 : { *(.data6) } : data6
    .data7 0x804F2E40 : { *(.data7) } : data7
    .bss 0x801B1800 (NOLOAD) : { *(.bss) } : bss
}
