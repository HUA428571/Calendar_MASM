.386
.model flat, stdcall
option casemap: none

include         windows.inc
include         user32.inc
include         kernel32.inc
include         comctl32.inc
include			gdi32.inc
;include			msvcrt.inc
includelib		msvcrt.lib
includelib      user32.lib		;ͨ�ÿؼ�
includelib      kernel32.lib	;ͨ�ÿؼ�
includelib      comctl32.lib
includelib		gdi32.lib


ICO_MAIN        equ     1000h   ;ͼ��
IDM_MAIN        equ     2000h
IDA_MAIN        equ     2000h
IDM_OPEN        equ     4101h
IDM_OPTION      equ     4102h
IDM_EXIT        equ     4103h
IDM_SETFONT     equ     4201h
IDM_SETCOLOR    equ     4202h
IDM_INACT       equ     4203h
IDM_GRAY        equ     4204h
IDM_BIG         equ     4205h
IDM_SMALL       equ     4206h
IDM_LIST        equ     4207h
IDM_DETAIL      equ     4208h
IDM_TOOLBAR     equ     4209h
IDM_TOOLBARTEXT equ     4210h
IDM_INPUTBAR    equ     4211h
IDM_STATUSBAR   equ     4212h
IDM_HELP        equ     4301h
IDM_ABOUT       equ     4301h

ID_STATUSBAR    equ     1
ID_EDIT         equ     2

;DLG_MAIN        equ     1
;IDB_1           equ     1
;IDB_2           equ     2
;IDC_ONTOP       equ     101
;IDC_SHOWBMP     equ     102
;IDC_ALLOW       equ     103
;IDC_MODALFRAME  equ     104
;IDC_THICKFRAME  equ     105
;IDC_TITLETEXT   equ     106
;IDC_CUSTOMTEXT  equ     107
;IDC_BMP         equ     108
;IDC_SCROLL      equ     109
;IDC_VALUE       equ     110

XY_CalStartX	equ		100
XY_CalStartY	equ		100
XY_CalWidth		equ		60
XY_CalHeight	equ		40


ID_EditYear		equ		101		;
ID_EditMonth	equ		102		;
ID_EditDay		equ		103		;
ID_BtnGo		equ		201		;

ID_Btn11		equ		211		;
ID_Btn12		equ		212		;
ID_Btn13		equ		213		;
ID_Btn14		equ		214		;
ID_Btn15		equ		215		;
ID_Btn16		equ		216		;
ID_Btn17		equ		217		;

ID_Btn21		equ		221		;
ID_Btn22		equ		222		;
ID_Btn23		equ		223		;
ID_Btn24		equ		224		;
ID_Btn25		equ		225		;
ID_Btn26		equ		226		;
ID_Btn27		equ		227		;

ID_Btn31		equ		231		;
ID_Btn32		equ		232		;
ID_Btn33		equ		233		;
ID_Btn34		equ		234		;
ID_Btn35		equ		235		;
ID_Btn36		equ		236		;
ID_Btn37		equ		237		;

ID_Btn41		equ		241		;
ID_Btn42		equ		242		;
ID_Btn43		equ		243		;
ID_Btn44		equ		244		;
ID_Btn45		equ		245		;
ID_Btn46		equ		246		;
ID_Btn47		equ		247		;

ID_Btn51		equ		251		;
ID_Btn52		equ		252		;
ID_Btn53		equ		253		;
ID_Btn54		equ		254		;
ID_Btn55		equ		255		;
ID_Btn56		equ		256		;
ID_Btn57		equ		257		;

ID_Btn61		equ		261		;
ID_Btn62		equ		262		;
ID_Btn63		equ		263		;
ID_Btn64		equ		264		;
ID_Btn65		equ		265		;
ID_Btn66		equ		266		;
ID_Btn67		equ		267		;

.data?
hInstance       dd  ?	; ģ����
hWinMain        dd  ?	; ���ھ��
hMenu           dd  ?	; �˵����
hSubMenu        dd  ?	; С�˵����
hWinStatus      dd  ?	; ״̬�����
hEditYear		dd	?
hEditMonth		dd	?
hEditDay		dd	?

lpsz1           dd  ?	; ״̬��-ʱ��
lpsz2           dd  ?	; ״̬��-��Ȩ
hWinEdit        dd  ?	; �༭��

.const
; �ַ���ע�ⲻҪ��©����0
szClass                 db      'EDIT', 0
szClassName     db  'MyClass', 0
szCaptionMain   db  'Calendar', 0	;����

szText          db  'Win32 Assembly, Simple and powerful', 0

szText21		db  'һ', 0
szText22		db  '��', 0
szText23		db  '��', 0
szText24		db  '��', 0
szText25		db  '��', 0
szText26		db  '��', 0
szText27		db  '��', 0

szText11		db  'һ', 0

szMenuHelp      db  '��������(&H)', 0
szMenuAbout     db  '���ڱ�����(&A)...', 0
szCaption       db  '�˵�ѡ��Window', 0

szCaptionError	db  '�����������', 0
szErrorBoxEmpty	db	'���벻��Ϊ�գ�',0
szErrorBoxYear	db	'�����겻��֧�ֵķ�Χ��',0
szErrorBoxMonth	db	'�����´���',0
szErrorBoxDay	db	'�����մ���',0

szFormat        db  '����%02d', 0

szFormat0       db  '%04d��%d��%d�� ', 0
szFormat1       db  '%02d:%02d:%02d', 0
szFormat2       db  'CopyRight 2022 HuaCL', 0
dwStatusWidth   dd  100, 160, 220, -1 ;״̬������

szEdit			db  'Edit', 0
szButton        db  'Button', 0
szButtonText    db  '&OK', 0

FontName		db	"����",0

.code
;atoi PROTO C strptr��DWORD
atoi	proto C strptr:dword

_PrintCal	proc uses eax ecx,_hWnd,_hDc,_w,_Month,_DayCount,_FlagLeapYear
			local   @stPs: PAINTSTRUCT	; ���ڿͻ����ġ��豸���������

			local	@szBuffer[256]: byte

			local	@hbr:HBRUSH
			local	@hfont:HFONT
			local	@rect1:RECT

			local	@hDc

				local	@i
				local	@j
				local	@x1
				local	@y1
				local	@x2
				local	@y2
				
			invoke  GetDC, _hWnd		;��ʼ��ͼ��
			mov     @hDc, eax

				;�߶ȣ���ȣ�ƫ��x��ƫ��y�����أ�б�壬�»��ߣ�ɾ���ߣ��ַ���
				invoke CreateFont,24,12,0,0,400,0,0,0,DEFAULT_CHARSET,\
							;������ȣ��ü�����
                            OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,\
							;��������������壬������
                            DEFAULT_QUALITY,DEFAULT_PITCH or FF_SCRIPT,\
                            ADDR FontName
				invoke	SelectObject,@hDc,eax
				mov		@hfont,eax

				mov	@x1,XY_CalStartX
				mov	@y1,XY_CalStartY + 5
				mov	@x2,XY_CalStartX + XY_CalWidth
				mov	@y2,XY_CalStartY + XY_CalHeight









				invoke	SetTextColor,@hDc,00000000H
				invoke	SetRect, addr @rect1,100,100,400,400
				invoke  DrawText, @hDc,addr szText21,-1,addr @rect1,DT_SINGLELINE or DT_CENTER		;��һ


				;invoke	InvertRect, @hDc, addr @rect1
			
			invoke  ReleaseDC, _hWnd,@hDc
			ret
_PrintCal	endp

_JudgeW		proc uses eax ecx,_Year,_Month
				local	@YearFirst2		;��ݵ�ǰ��λ
				local	@YearLast2		;��ݵĺ���λ
				local	@w				;���չ�ʽת�����
									.if _Month==1 || _Month==2
											add _Month,12
									.endif
									mov edx,0
									mov eax,_Year
									mov ecx,100
									idiv ecx
									mov @YearFirst2,eax
									mov @YearLast2,edx
									mov @w,edx
									add @w,140;��ֹ���ָ���
									;y/4
									mov edx,0
									mov eax,@YearLast2
									mov ecx,4
									idiv ecx
									;mov @w2,eax
									add @w,eax
									;
									mov edx,0
									mov eax,@YearFirst2
									mov ecx,4
									idiv ecx
									;mov @w3,eax
									add @w,eax
									;
									mov edx,0
									mov eax,_Month
									inc eax
									mov ecx,13
									imul ecx
									mov edx,0
									mov ecx,5
									idiv ecx
									;mov @w5,eax
									add @w,eax
									;
									mov edx,0
									mov eax,@YearFirst2
									mov ecx,2
									imul ecx
									;mov @w4,eax
									sub @w,eax
									;
									mov edx,0
									mov	eax,@w
									mov ecx,7
									idiv ecx
									mov @w,edx
				ret
_JudgeW	endp

; ���ڹ���
; ����Windows�Ļص�������Ҫ��֤ebx edi esi�ڵ���ǰ�󱣳ֲ���
_ProcWinMain    proc    uses ebx edi esi, hWnd, uMsg, wParam, lParam	;��Ϣ���ĸ�����
				local   @stPs: PAINTSTRUCT	; ���ڿͻ����ġ��豸���������

				local	@rect1:RECT			;����õľ����޶���

				local	@hbr:HBRUSH			;��ˢ
				local	@hfont:HFONT		;����

				local	@FlagLeapYear		;�Ƿ�������
				local	@DayCount			;��������
				local	@FlagDayCorrect		;����������Ƿ���ȷ

				local	@i			;ѭ����
				local	@j			;ѭ����
				local	@x1
				local	@y1
				local	@x2
				local	@y2

				local   @hDc		;���

				local   @stDY: SYSTEMTIME		;ʱ�䣬״̬����
				local   @stST: SYSTEMTIME		;ʱ�䣬״̬����

				local   @stPos: POINT
				local   @hSysMenu		; �˵�
				local   @szBuffer[256]: byte
				local   @szBufferYear[64]: byte
				local   @szBufferMonth[64]: byte
				local   @szBufferDay[64]: byte

				local	@Year
				local	@Month
				local	@Day

				local	@YearFirst2		;��ݵ�ǰ��λ
				local	@YearLast2		;��ݵĺ���λ
				local	@w				;���չ�ʽת�����
				local	@wMonth			;���չ�ʽ�õ��·ݣ�3-13��

		; uMsgָ����Ϣ����
		mov     eax, uMsg
		;��ʱ����ʾʱ��
		.if		eax == WM_TIMER
                invoke  GetLocalTime, addr @stST
                movzx   eax, @stST.wHour
                movzx   ebx, @stST.wMinute
                movzx   ecx, @stST.wSecond                
				invoke  wsprintf, addr @szBuffer, addr szFormat1, eax, ebx, ecx
                invoke  SendMessage, hWinStatus, SB_SETTEXT, 2, addr @szBuffer		
		.elseif eax == WM_PAINT
				invoke  BeginPaint, hWnd, addr @stPs		; ��ȡ���ڿͻ����ġ��豸���������
				mov     @hDc, eax

;				;��������
;				invoke CreateFont,24,16,0,0,400,0,0,0,OEM_CHARSET,\
;                            OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,\
;                            DEFAULT_QUALITY,DEFAULT_PITCH or FF_SCRIPT,\
;                            ADDR FontName 

;				invoke SelectObject,@hDc,eax
;				mov    @hfont,eax
;				invoke SetTextColor,@hDc,000000FFH
;				invoke SetBkColor,@hDc,00FF00FFH

;				;�������
;				;https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setrect
;				invoke	SetRect, addr @stText11Rect,100,100,200,150
;				;https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-drawtext
;				invoke  DrawText, @hDc, addr szText11,\
;								-1, \				;����ı����ַ�����
;								addr @stText11Rect, \		;��ʾ����
;								DT_SINGLELINE or DT_LEFT;��ʽ���
;
;				;���ƾ��ο�
;				;https://blog.csdn.net/qq_45021180/article/details/99700901
;				;invoke	CreateSolidBrush, @hbr, 0x000000FF
;				invoke	GetStockObject ,BLACK_BRUSH
;				mov @hbr ,eax;��ȡ��ɫ��ˢ����������
;				invoke	FrameRect, @hDc, addr @stText11Rect, @hbr 
;				;invoke	InvertRect, @hDc, addr @stText11Rect

;********************************************************************************
;		��ʼ�������ĵ�ͼ
;********************************************************************************
				mov	@x1,XY_CalStartX
				mov	@y1,XY_CalStartY + 5
				mov	@x2,XY_CalStartX + XY_CalWidth
				mov	@y2,XY_CalStartY + XY_CalHeight

				;�߶ȣ���ȣ�ƫ��x��ƫ��y�����أ�б�壬�»��ߣ�ɾ���ߣ��ַ���
				invoke CreateFont,24,12,0,0,400,0,0,0,DEFAULT_CHARSET,\
							;������ȣ��ü�����
                            OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,\
							;��������������壬������
                            DEFAULT_QUALITY,DEFAULT_PITCH or FF_SCRIPT,\
                            ADDR FontName
				invoke	SelectObject,@hDc,eax
				mov		@hfont,eax
				invoke	SetTextColor,@hDc,00000000H
				invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
				invoke  DrawText, @hDc,addr szText21,-1,addr @rect1,DT_SINGLELINE or DT_CENTER		;��һ
				add	@x1,XY_CalWidth
				add	@x2,XY_CalWidth
				invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
				invoke  DrawText, @hDc,addr szText22,-1,addr @rect1,DT_SINGLELINE or DT_CENTER		;�ܶ�
				add	@x1,XY_CalWidth
				add	@x2,XY_CalWidth
				invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
				invoke  DrawText, @hDc,addr szText23,-1,addr @rect1,DT_SINGLELINE or DT_CENTER		;����
				add	@x1,XY_CalWidth
				add	@x2,XY_CalWidth
				invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
				invoke  DrawText, @hDc,addr szText24,-1,addr @rect1,DT_SINGLELINE or DT_CENTER		;����
				add	@x1,XY_CalWidth
				add	@x2,XY_CalWidth
				invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
				invoke  DrawText, @hDc,addr szText25,-1,addr @rect1,DT_SINGLELINE or DT_CENTER		;����
				add	@x1,XY_CalWidth
				add	@x2,XY_CalWidth
				invoke	SetTextColor,@hDc,000000FFH
				invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
				invoke  DrawText, @hDc,addr szText26,-1,addr @rect1,DT_SINGLELINE or DT_CENTER		;����
				add	@x1,XY_CalWidth
				add	@x2,XY_CalWidth
				invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
				invoke  DrawText, @hDc,addr szText27,-1,addr @rect1,DT_SINGLELINE or DT_CENTER		;����

				invoke	GetStockObject ,BLACK_BRUSH
				mov @hbr ,eax;��ȡ��ɫ��ˢ����������
				mov	@x1,XY_CalStartX
				mov	@y1,XY_CalStartY
				mov	@x2,XY_CalStartX
				mov	@y2,XY_CalStartY
				add	@y1,XY_CalHeight
				add	@y2,XY_CalHeight
				add	@x2,XY_CalWidth
				add	@y2,XY_CalHeight
				mov	@i,0
				mov	@j,0
				.while @i<6
						.while @j<7
								invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
								invoke	FrameRect, @hDc, addr @rect1, @hbr 
								add	@x1,XY_CalWidth
								add	@x2,XY_CalWidth
								inc	@j
						.endw
						mov	@x1,XY_CalStartX
						mov	@x2,XY_CalStartX
						add	@x2,XY_CalWidth
						add	@y1,XY_CalHeight
						add	@y2,XY_CalHeight
						inc @i
						mov @j,0
				.endw

				;invoke	SetRect, addr @rect1,20,20,40,40
				;invoke	FrameRect, @hDc, addr @rect1, @hbr 



				invoke  EndPaint, hWnd, addr @stPs

		
		.elseif eax == WM_CREATE
				invoke  GetSubMenu, hMenu, 1
				mov     hSubMenu, eax
				invoke  GetSystemMenu, hWnd, FALSE
				mov     @hSysMenu, eax
				;�˵�
				invoke  AppendMenu, @hSysMenu, 0, IDM_HELP, offset szMenuHelp
				invoke  AppendMenu, @hSysMenu, 0, IDM_ABOUT, offset szMenuAbout
				;״̬��
				mov     eax, hWnd
                mov     hWinMain, eax
				invoke  CreateStatusWindow, WS_CHILD or WS_VISIBLE, NULL, hWinMain, ID_STATUSBAR
                mov     hWinStatus, eax
				invoke  SendMessage, hWinStatus, SB_SETPARTS, 4, offset dwStatusWidth;����״̬��
				invoke  GetLocalTime, addr @stDY
                movzx   eax, @stDY.wYear
                movzx   ebx, @stDY.wMonth
                movzx   ecx, @stDY.wDay 
				invoke  wsprintf, addr @szBuffer, addr szFormat0, eax, ebx, ecx
				invoke  SendMessage, hWinStatus, SB_SETTEXT, 0, addr @szBuffer		;��ʾ����
				invoke  SendMessage, hWinStatus, SB_SETTEXT, 3, addr szFormat2		;��ʾ��Ȩ��Ϣ

;********************************************************************************
;		���������
;********************************************************************************
				;����� ��
				invoke  CreateWindowEx, NULL, \
						offset szEdit, NULL, \
						WS_BORDER or WS_CHILD or WS_VISIBLE or ES_NUMBER, \
						10, 10, 40, 22, \
						hWnd, ID_EditYear, hInstance, NULL
				;��ȡ���
				mov     hEditYear, eax
				;�������볤��
				invoke	SendMessage,hEditYear, EM_LIMITTEXT, 4,0;
				;����� ��
				invoke  CreateWindowEx, NULL, \
						offset szEdit, NULL, \
						WS_BORDER or WS_CHILD or WS_VISIBLE or ES_NUMBER, \
						100, 10, 20, 22, \
						hWnd, ID_EditMonth, hInstance, NULL
				mov     hEditMonth, eax
				invoke	SendMessage,hEditMonth, EM_LIMITTEXT, 2,0;
				;����� ��
				invoke  CreateWindowEx, NULL, \
						offset szEdit, NULL, \
						WS_BORDER or WS_CHILD or WS_VISIBLE or ES_NUMBER, \
						190, 10, 20, 22, \
						hWnd, ID_EditDay, hInstance, NULL
				mov     hEditDay, eax
				invoke	SendMessage,hEditDay, EM_LIMITTEXT, 2,0;
				;��ť
				invoke  CreateWindowEx, NULL, \
						offset szButton, offset szButtonText, \
						WS_CHILD or WS_VISIBLE, \
						290, 10, 40, 22, \
						hWnd, 201, hInstance, NULL

                invoke  SetTimer, hWnd, 1, 300, NULL
        
		.elseif eax == WM_COMMAND
				mov     eax, wParam
				movzx   eax, ax
				.if     eax == IDM_EXIT
						invoke  DestroyWindow, hWinMain
						invoke  PostQuitMessage, NULL
				;������ת��ť������
				.elseif	eax == 201
;********************************************************************************
;		��ȡ��������ڣ��жϺϷ���
;********************************************************************************
						invoke	GetDlgItemText, hWnd, 101,addr @szBufferYear,5
						invoke	GetDlgItemText, hWnd, 102,addr @szBufferMonth,3
						invoke	GetDlgItemText, hWnd, 103,addr @szBufferDay,3
						;ת������
						invoke  atoi, addr @szBufferYear
						mov @Year,eax
						invoke  atoi, addr @szBufferMonth
						mov @Month,eax
						invoke  atoi, addr @szBufferDay
						mov @Day,eax
						;�ж����������Ƿ���ȷ
						mov @FlagLeapYear,0
						mov @FlagDayCorrect,0
						;�ж������Ƿ�Ϊ��
						.if	@Year==0 || @Month==0 ||@Day==0
							invoke  MessageBox, hWinMain, addr szErrorBoxEmpty, offset szCaptionError, MB_OK
						.elseif @Month>12 || @Month<1
							;�·ݲ�����Ҫ��
							invoke  MessageBox, hWinMain, addr szErrorBoxMonth, offset szCaptionError, MB_OK
						.else
							;�ж�����
							mov edx,0
							mov eax,@Year
							mov ecx,4
							idiv ecx
							.if edx==0
									mov @FlagLeapYear,1
									mov edx,0
									mov eax,@Year
									mov ecx,100
									idiv ecx
									.if edx==0
											mov @FlagLeapYear,0
											mov edx,0
											mov eax,@Year
											mov ecx,400
											idiv ecx
											.if edx==0
													mov @FlagLeapYear,1
											.endif
									.endif
							.endif
							;�жϴ�С��
							.if @Month==1 ||@Month==3 ||@Month==5 ||@Month==7 ||@Month==8 ||@Month==10 ||@Month==12
									.if @Day<0||@Day>31
											invoke  MessageBox, hWinMain, addr szErrorBoxDay, offset szCaptionError, MB_OK
									.else
											mov @DayCount,31
											mov @FlagDayCorrect,1
									.endif
							.elseif @Month!=2
									.if @Day<0||@Day>30
											invoke  MessageBox, hWinMain, addr szErrorBoxDay, offset szCaptionError, MB_OK
									.else
											mov @DayCount,30
											mov @FlagDayCorrect,1
									.endif
							.else
							;�����Ķ���
									.if @FlagLeapYear==0
											.if @Day<0||@Day>28
													invoke  MessageBox, hWinMain, addr szErrorBoxDay, offset szCaptionError, MB_OK
											.else
													mov @DayCount,28
													mov @FlagDayCorrect,1
											.endif
									.else
											.if @Day<0||@Day>29
													invoke  MessageBox, hWinMain, addr szErrorBoxDay, offset szCaptionError, MB_OK
											.else
													mov @DayCount,29
													mov @FlagDayCorrect,1
											.endif
									.endif
							.endif
;********************************************************************************
;		���չ�ʽת��
;********************************************************************************
							.if @FlagDayCorrect==1

								invoke _JudgeW,@Year,@Month
									mov @w,edx
							
									invoke  wsprintf, addr @szBuffer, addr szFormat, edx
									invoke  MessageBox, hWinMain, addr @szBuffer, offset szCaption, MB_OK
									invoke	_PrintCal,hWnd,@hDc,@w,@Month,@DayCount,@FlagLeapYear
									;invoke	InvertRect, @hDc, addr @stRect

									;invoke	SetRect, addr @rect1,100,100,200,200
									;invoke  DrawText, @hDc,addr szText21,-1,addr @rect1,DT_SINGLELINE or DT_CENTER		;��һ


							.endif
						.endif

						;invoke  wsprintf, addr @szBuffer, addr szFormat, @FlagLeapYear,@DayCount
						;invoke  MessageBox, hWinMain, addr @szBuffer, offset szCaption, MB_OK


				.elseif eax >= IDM_TOOLBAR && eax <= IDM_STATUSBAR
						mov     ebx, eax
						invoke  GetMenuState, hMenu, ebx, MF_BYCOMMAND
						.if     eax == MF_CHECKED
								mov     eax, MF_UNCHECKED
						.else
								mov     eax, MF_CHECKED
						.endif
						invoke  CheckMenuItem, hMenu, ebx, eax
				.elseif eax >= IDM_BIG && eax <= IDM_DETAIL
						invoke  CheckMenuRadioItem, hMenu, IDM_BIG, IDM_DETAIL, eax, MF_BYCOMMAND
				.endif
;		.elseif eax == WM_SYSCOMMAND
;				mov     eax, wParam
;				movzx   eax, ax
;				.if     eax == IDM_HELP || eax == IDM_ABOUT
;						invoke  wsprintf, addr @szBuffer, addr szFormat, wParam
;						invoke  MessageBox, hWinMain, addr @szBuffer, offset szCaption, MB_OK
;				.else
;						invoke  DefWindowProc, hWnd, uMsg, wParam, lParam
;						ret
;				.endif
		;����Ҽ�������
		.elseif eax == WM_RBUTTONDOWN
				invoke  GetCursorPos, addr @stPos
				invoke  TrackPopupMenu, hSubMenu, TPM_LEFTALIGN, @stPos.x, @stPos.y, NULL, hWnd, NULL
		.elseif eax == WM_CLOSE
				invoke  DestroyWindow, hWinMain
				invoke  PostQuitMessage, NULL
		.else
				invoke  DefWindowProc, hWnd, uMsg, wParam, lParam
				ret
		.endif
		xor     eax, eax
		ret
_ProcWinMain    endp

_WinMain	proc
			local   @stWndClass: WNDCLASSEX
			local   @stMsg: MSG
			local   @hAccelerators

			; ȡģ����
			invoke  GetModuleHandle, NULL
			mov     hInstance, eax

			;�˵���
			invoke  LoadMenu, hInstance, IDM_MAIN
			mov     hMenu, eax

			;���ټ�
			invoke  LoadAccelerators, hInstance, IDA_MAIN
			mov     @hAccelerators, eax

			; �ṹ������
			invoke  RtlZeroMemory, addr @stWndClass, sizeof @stWndClass

			;ͼ��
			invoke  LoadIcon, hInstance, ICO_MAIN
			mov     @stWndClass.hIcon, eax
			mov     @stWndClass.hIconSm, eax
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
					WS_OVERLAPPED or WS_SYSMENU or WS_BORDER or WS_VISIBLE, \			;dwStyle���ڵ����κ���Ϊ
					CW_USEDEFAULT, CW_USEDEFAULT, \	;ָ���������Ͻ�λ��
					620, 540, NULL, hMenu , hInstance,NULL
;					600, 400, \			;���ڵĿ�Ⱥ͸߶�
;					NULL, \				;hWndParent���������ĸ�����
;					NULL, \				;hMenu������Ҫ���ֵĲ˵��ľ��
;					hInstance, \		;hInstanceģ����
;					NULL				;lpParam��������һ��ָ�룬ָ��һ�����������ڵĲ�����һ�㲻�ã�
			mov     hWinMain, eax
			; ��ʾ����
			invoke  ShowWindow, hWinMain, SW_SHOWNORMAL
			; ˢ�´��ڿͻ���
			invoke  UpdateWindow, hWinMain

			;��Ϣѭ��
			.while  TRUE
					invoke  GetMessage, addr @stMsg, NULL, 0, 0
					.break  .if     eax == 0
					invoke  TranslateAccelerator, hWinMain, @hAccelerators, addr @stMsg
					.if     eax == 0
							invoke  TranslateMessage, addr @stMsg
							invoke  DispatchMessage, addr @stMsg
					.endif
			.endw
			ret

_WinMain    endp

start:
        invoke  InitCommonControls
		call    _WinMain
		invoke  ExitProcess, NULL
		end     start