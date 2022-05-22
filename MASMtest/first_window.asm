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
hInstance       dd  ?	; 模块句柄
hWinMain        dd  ?	; 窗口句柄
hSubMenu        dd  ?

.const
; 字符串注意不要遗漏最后的0
szClassName     db  'MyClass', 0
szCaptionMain   db  'Calendar', 0
szText          db  'Win32 Assembly, Simple and powerful', 0
szButton        db  'button', 0
szButtonText    db  '&OK', 0

.code
; 窗口过程
; 交给Windows的回调函数需要保证ebx edi esi在调用前后保持不变
_ProcWinMain    proc    uses ebx edi esi, hWnd, uMsg, wParam, lParam	;消息的四个参数
				local   @stPs: PAINTSTRUCT	; 窗口客户区的“设备环境”句柄
				local   @stRect: RECT
				local   @hDc
		; uMsg指出消息类型
		mov     eax, uMsg
		; 窗口客户区绘制
		.if     eax == WM_PAINT
				invoke  BeginPaint, hWnd, addr @stPs		; 获取窗口客户区的“设备环境”句柄
				mov     @hDc, eax
				invoke  GetClientRect, hWnd, addr @stRect	; 获取客户区的大小
				invoke  DrawText, @hDc, addr szText, -1, addr @stRect, DT_SINGLELINE or DT_CENTER or DT_VCENTER
				invoke  EndPaint, hWnd, addr @stPs
		; 这里创建了一个button（也是一个窗口）		
		; 窗口建立
		.elseif eax == WM_CREATE
				invoke  CreateWindowEx, NULL, \
						offset szButton, offset szButtonText, \
						WS_CHILD or WS_VISIBLE, \
						10, 10, 65, 22, \
						hWnd, 1, hInstance, NULL
;		; 窗口
;		.elseif eax == WM_INITDIALOG
;                invoke  LoadIcon, hInstance, ICO_MAIN
;                invoke  SendMessage, hWnd, WM_SETICON, ICON_BIG, eax
;        .elseif eax == WM_COMMAND
;                mov     eax, wParam
;                movzx   eax, ax
;                .if     eax == IDOK
;                        invoke  EndDialog, hWnd, NULL
;                .endif
		; 用户关闭窗口操作
		.elseif eax == WM_CLOSE
				invoke  DestroyWindow, hWinMain
				invoke  PostQuitMessage, NULL
		.else
				; 调用默认函数
				invoke  DefWindowProc, hWnd, uMsg, wParam, lParam
				ret
		.endif
		; 注意不要遗漏eax清零，告诉Windows成功完成处理
		xor     eax, eax
		ret
_ProcWinMain    endp

_WinMain        proc
				local   @stWndClass: WNDCLASSEX
				local   @stMsg: MSG

		; 取模块句柄
		invoke  GetModuleHandle, NULL
		mov     hInstance, eax
		; 结构体清零
		invoke  RtlZeroMemory, addr @stWndClass, sizeof @stWndClass

		invoke  LoadCursor, 0, IDC_ARROW
		mov     @stWndClass.hCursor, eax
		mov     eax, hInstance
		mov     @stWndClass.hInstance, eax
		mov     @stWndClass.cbSize, sizeof WNDCLASSEX
		mov     @stWndClass.style, CS_HREDRAW or CS_VREDRAW
		; 注册窗口类时指定对应的窗口过程
		mov     @stWndClass.lpfnWndProc, offset _ProcWinMain
		mov     @stWndClass.hbrBackground, COLOR_WINDOW + 1
		mov     @stWndClass.lpszClassName, offset szClassName
		; 注册窗口类
		; 注意同一窗口类的窗口都具有相同的窗口过程
		invoke  RegisterClassEx, addr @stWndClass
		; 创建窗口
		invoke  CreateWindowEx, WS_EX_CLIENTEDGE, \;dwExStyle窗口的外形和行为
				offset szClassName, \			;建立窗口使用的类名字符串指针
				offset szCaptionMain, \			;指向表示窗口名称的字符串
				WS_OVERLAPPEDWINDOW, \			;dwStyle窗口的外形和行为
				CW_USEDEFAULT, CW_USEDEFAULT, \	;指定窗口左上角位置
				600, 400, NULL,NULL, hInstance,NULL
;				600, 400, \			;窗口的宽度和高度
;				NULL, \				;hWndParent窗口所属的父窗口
;				NULL, \				;hMenu窗口上要出现的菜单的句柄
;				hInstance, \		;hInstance模块句柄
;				NULL				;lpParam——这是一个指针，指向一个欲传给窗口的参数（一般不用）
		mov     hWinMain, eax
		; 显示窗口
		invoke  ShowWindow, hWinMain, SW_SHOWNORMAL
		; 刷新窗口客户区
		invoke  UpdateWindow, hWinMain
		; 消息循环
		.while  TRUE
				invoke  GetMessage, addr @stMsg, NULL, 0, 0
				.break  .if     eax == 0; 如果消息队列是关闭窗口
				invoke  TranslateMessage, addr @stMsg
				invoke  DispatchMessage, addr @stMsg
		.endw
		ret
_WinMain        endp

start:
		; 程序开始执行位置
		call    _WinMain
		invoke  ExitProcess, NULL
		end     start