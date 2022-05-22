.386;处理器选择伪指令
.model flat,stdcall;内存模式定义，子程序调用方式
;ASSUME	fs:flat, gs:flat
;.stack 4096
option casemap:none;大小写敏感

include windows.inc
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib

.data	;初始化了的变量定义
szCaption db 'A MessageBox !',0
szText db 'Hello, World !',0
.data?	;没有初始化的变量定义

.const	;常量定义 

;代码段
.code
main PROC
invoke MessageBox,NULL,offset szText,offset szCaption,MB_OK
invoke ExitProcess,NULL
main ENDP

END main
