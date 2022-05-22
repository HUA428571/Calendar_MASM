.386
.model flat, stdcall
option casemap: none

include         windows.inc
include         gdi32.inc
include         user32.inc
include         kernel32.inc
includelib      gdi32.lib
includelib      user32.lib
includelib      kernel32.lib

.data?
hInstance       dd  ?	; ģ����
hWinMain        dd  ?	; ���ھ��
hSubMenu        dd  ?

.const
; �ַ���ע�ⲻҪ��©����0
szClassName     db  'MyClass', 0
szCaptionMain   db  'Calendar', 0
szText          db  'Win32 Assembly, Simple and powerful', 0
szButton        db  'button', 0
szButtonText    db  '&OK', 0

.code
; ���ڹ���
; ����Windows�Ļص�������Ҫ��֤ebx edi esi�ڵ���ǰ�󱣳ֲ���
_ProcWinMain    proc    uses ebx edi esi, hWnd, uMsg, wParam, lParam	;��Ϣ���ĸ�����
				local   @stPs: PAINTSTRUCT	; ���ڿͻ����ġ��豸���������
				local   @stRect: RECT
				local   @hDc
		; uMsgָ����Ϣ����
		mov     eax, uMsg
		; ���ڿͻ�������
		.if     eax == WM_PAINT
				invoke  BeginPaint, hWnd, addr @stPs		; ��ȡ���ڿͻ����ġ��豸���������
				mov     @hDc, eax
				invoke  GetClientRect, hWnd, addr @stRect	; ��ȡ�ͻ����Ĵ�С
				invoke  DrawText, @hDc, addr szText, -1, addr @stRect, DT_SINGLELINE or DT_CENTER or DT_VCENTER
				invoke  EndPaint, hWnd, addr @stPs
		; ���ﴴ����һ��button��Ҳ��һ�����ڣ�		
		; ���ڽ���
		.elseif eax == WM_CREATE
				invoke  CreateWindowEx, NULL, \
						offset szButton, offset szButtonText, \
						WS_CHILD or WS_VISIBLE, \
						10, 10, 65, 22, \
						hWnd, 1, hInstance, NULL
;		; ����
;		.elseif eax == WM_INITDIALOG
;                invoke  LoadIcon, hInstance, ICO_MAIN
;                invoke  SendMessage, hWnd, WM_SETICON, ICON_BIG, eax
;        .elseif eax == WM_COMMAND
;                mov     eax, wParam
;                movzx   eax, ax
;                .if     eax == IDOK
;                        invoke  EndDialog, hWnd, NULL
;                .endif
		; �û��رմ��ڲ���
		.elseif eax == WM_CLOSE
				invoke  DestroyWindow, hWinMain
				invoke  PostQuitMessage, NULL
		.else
				; ����Ĭ�Ϻ���
				invoke  DefWindowProc, hWnd, uMsg, wParam, lParam
				ret
		.endif
		; ע�ⲻҪ��©eax���㣬����Windows�ɹ���ɴ���
		xor     eax, eax
		ret
_ProcWinMain    endp

_WinMain        proc
				local   @stWndClass: WNDCLASSEX
				local   @stMsg: MSG

		; ȡģ����
		invoke  GetModuleHandle, NULL
		mov     hInstance, eax
		; �ṹ������
		invoke  RtlZeroMemory, addr @stWndClass, sizeof @stWndClass

		invoke  LoadCursor, 0, IDC_ARROW
		mov     @stWndClass.hCursor, eax
		mov     eax, hInstance
		mov     @stWndClass.hInstance, eax
		mov     @stWndClass.cbSize, sizeof WNDCLASSEX
		mov     @stWndClass.style, CS_HREDRAW or CS_VREDRAW
		; ע�ᴰ����ʱָ����Ӧ�Ĵ��ڹ���
		mov     @stWndClass.lpfnWndProc, offset _ProcWinMain
		mov     @stWndClass.hbrBackground, COLOR_WINDOW + 1
		mov     @stWndClass.lpszClassName, offset szClassName
		; ע�ᴰ����
		; ע��ͬһ������Ĵ��ڶ�������ͬ�Ĵ��ڹ���
		invoke  RegisterClassEx, addr @stWndClass
		; ��������
		invoke  CreateWindowEx, WS_EX_CLIENTEDGE, \;dwExStyle���ڵ����κ���Ϊ
				offset szClassName, \			;��������ʹ�õ������ַ���ָ��
				offset szCaptionMain, \			;ָ���ʾ�������Ƶ��ַ���
				WS_OVERLAPPEDWINDOW, \			;dwStyle���ڵ����κ���Ϊ
				CW_USEDEFAULT, CW_USEDEFAULT, \	;ָ���������Ͻ�λ��
				600, 400, NULL,NULL, hInstance,NULL
;				600, 400, \			;���ڵĿ�Ⱥ͸߶�
;				NULL, \				;hWndParent���������ĸ�����
;				NULL, \				;hMenu������Ҫ���ֵĲ˵��ľ��
;				hInstance, \		;hInstanceģ����
;				NULL				;lpParam��������һ��ָ�룬ָ��һ�����������ڵĲ�����һ�㲻�ã�
		mov     hWinMain, eax
		; ��ʾ����
		invoke  ShowWindow, hWinMain, SW_SHOWNORMAL
		; ˢ�´��ڿͻ���
		invoke  UpdateWindow, hWinMain
		; ��Ϣѭ��
		.while  TRUE
				invoke  GetMessage, addr @stMsg, NULL, 0, 0
				.break  .if     eax == 0; �����Ϣ�����ǹرմ���
				invoke  TranslateMessage, addr @stMsg
				invoke  DispatchMessage, addr @stMsg
		.endw
		ret
_WinMain        endp

start:
		; ����ʼִ��λ��
		call    _WinMain
		invoke  ExitProcess, NULL
		end     start