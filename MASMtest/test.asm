.386;������ѡ��αָ��
.model flat,stdcall;�ڴ�ģʽ���壬�ӳ�����÷�ʽ
;ASSUME	fs:flat, gs:flat
;.stack 4096
option casemap:none;��Сд����

include windows.inc
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib

.data	;��ʼ���˵ı�������
szCaption db 'A MessageBox !',0
szText db 'Hello, World !',0
.data?	;û�г�ʼ���ı�������

.const	;�������� 

;�����
.code
main PROC
invoke MessageBox,NULL,offset szText,offset szCaption,MB_OK
invoke ExitProcess,NULL
main ENDP

END main
