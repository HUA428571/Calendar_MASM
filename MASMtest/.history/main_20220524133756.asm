.386
.model flat, stdcall
option casemap: none

include         windows.inc
include         user32.inc
include         kernel32.inc
include         comctl32.inc
include			gdi32.inc
includelib		msvcrt.lib
includelib      user32.lib		;通用控件
includelib      kernel32.lib	;通用控件
includelib      comctl32.lib
includelib		gdi32.lib

ICO_MAIN        equ     1000h   ;图标
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

XY_CalStartX	equ		100
XY_CalStartY	equ		100
XY_CalWidth		equ		60
XY_CalHeight	equ		40

ID_EditYear		equ		101		;
ID_EditMonth	equ		102		;
ID_EditDay		equ		103		;
ID_BtnGo		equ		201		;
ID_BtnPast		equ		202		;
ID_BtnNext		equ		203		;

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

.data
dwinit			dw	1	;第一次创建窗口

.data?
hInstance       dd  ?	; 模块句柄
hWinMain        dd  ?	; 窗口句柄
hMenu           dd  ?	; 菜单句柄
hSubMenu        dd  ?	; 小菜单句柄
hWinStatus      dd  ?	; 状态栏句柄
hEditYear		dd	?
hEditMonth		dd	?
hEditDay		dd	?

lpsz1           dd  ?	; 状态栏-时间
lpsz2           dd  ?	; 状态栏-版权
hWinEdit        dd  ?	; 编辑区
dwNowPrintYear	dd	?	; 目前正在显示的年份
dwNowPrintMonth	dd	?	; 目前正在显示的月份
dwNowPrintDay	dd	?	; 目前正在显示的日期

.const
; 字符串注意不要遗漏最后的0
szClass                 db  'EDIT', 0
szClassName				db  'MyClass', 0
szCaptionMain			db  'Calendar', 0	;标题

szText					db  'Win32 Assembly, Simple and powerful', 0

szText21				db  '一', 0
szText22				db  '二', 0
szText23				db  '三', 0
szText24				db  '四', 0
szText25				db  '五', 0
szText26				db  '六', 0
szText27				db  '日', 0

szText31				db  '年', 0
szText32				db  '月', 0
szText33				db  '日', 0

szMenuHelp				db  '帮助主题(&H)', 0
szMenuAbout				db  '关于本程序(&A)...', 0
szCaption				db  '菜单选择Window', 0

szCaptionError			db  '日期输入错误！', 0
szErrorBoxEmpty			db	'输入不能为空！',0
szErrorBoxYear			db	'输入年不在支持的范围内',0
szErrorBoxMonth			db	'输入月错误！',0
szErrorBoxDay			db	'输入日错误！',0

szFormat				db  '星期%02d', 0

szFormat0				db  '%04d年%d月%d日 ', 0
szFormatStatusBar1		db  '星期%s', 0
szFormat1				db  '%02d:%02d:%02d', 0
szFormat2				db  'CopyRight 2022 HuaCL', 0
szFormatDay				db	'%d' , 0
szFormatMonth			db	'%d年%d月' , 0
dwStatusWidth			dd  100, 150, 210, -1 ;状态栏分栏

szEdit					db  'Edit', 0
szButton				db  'Button', 0
szButtonTextGO			db  '跳转', 0
szButtonTextPast		db  '上一月', 0
szButtonTextNext		db  '下一月', 0

FontName				db	"黑体",0

.code
atoi	proto C strptr:dword

;--------------------------------------------------------------------------------------------
;		判断周几
;--------------------------------------------------------------------------------------------
_JudgeW		proc uses eax ecx,_Year,_Month,_Day
				local	@YearFirst2		;年份的前两位
				local	@YearLast2		;年份的后两位
				local	@w				;蔡勒公式转换结果

			.if _Month==1 || _Month==2
					add _Month,12
					dec _Year
			.endif
			
			;众所周知，2000年是20世纪，2001年才是21世纪
			mov edx,0
			mov eax,_Year
			mov ecx,1000
			idiv ecx
			.if edx == 0
				inc _Year
			.endif
			mov edx,0
			mov eax,_Year
			mov ecx,100
			idiv ecx
			mov @YearFirst2,eax
			mov @YearLast2,edx
			mov @w,edx
			add @w,139		;防止出现负数（公式里需要减1，在这里直接减掉）
			
			mov edx,0
			mov eax,_Year
			mov ecx,100
			idiv ecx
			mov @YearFirst2,eax
			mov @YearLast2,edx
			mov @w,edx
			add @w,139		;防止出现负数（公式里需要减1，在这里直接减掉）
			;+day-1
			mov eax,_Day
			add	@w,eax
			;y/4
			mov edx,0
			mov eax,@YearLast2
			mov ecx,4
			idiv ecx
			add @w,eax
			;c/4
			mov edx,0
			mov eax,@YearFirst2
			mov ecx,4
			idiv ecx
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
			add @w,eax
			;-2c
			mov edx,0
			mov eax,@YearFirst2
			mov ecx,2
			imul ecx
			sub @w,eax
			;mod7
			mov edx,0
			mov	eax,@w
			mov ecx,7
			idiv ecx
			mov @w,edx
			ret
_JudgeW	endp

;--------------------------------------------------------------------------------------------
;		判断日期
;--------------------------------------------------------------------------------------------
_JudgeDay	proc uses ecx edx,_Year,_Month,_Day
				local	@FlagLeapYear		;是否是闰年
				local	@DayCount			;本月天数

			mov @FlagLeapYear,0
			mov @DayCount,0

			;判断闰年
			mov edx,0
			mov eax,_Year
			mov ecx,4
			idiv ecx
			.if edx==0
					mov @FlagLeapYear,1
					mov edx,0
					mov eax,_Year
					mov ecx,100
					idiv ecx
					.if edx==0
							mov @FlagLeapYear,0
							mov edx,0
							mov eax,_Year
							mov ecx,400
							idiv ecx
							.if edx==0
									mov @FlagLeapYear,1
							.endif
					.endif
			.endif
			;判断大小月
			.if _Month==1 ||_Month==3 ||_Month==5 ||_Month==7 ||_Month==8 ||_Month==10 ||_Month==12
					.if _Day<0||_Day>31
							mov @DayCount,32
					.else
							mov @DayCount,31
					.endif
			.elseif _Month!=2
					.if _Day<0||_Day>30
							mov @DayCount,32
					.else
							mov @DayCount,30
					.endif
			.else
			;该死的二月
					.if @FlagLeapYear==0
							.if _Day<0||_Day>28
									mov @DayCount,32
							.else
									mov @DayCount,28
							.endif
					.else
							.if _Day<0||_Day>29
									mov @DayCount,32
							.else
									mov @DayCount,29
							.endif
					.endif
			.endif

			mov eax,@DayCount
			ret
_JudgeDay	endp

;--------------------------------------------------------------------------------------------
;		日历的底图
;--------------------------------------------------------------------------------------------
_PrintBG	proc uses eax,_hWnd

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
			
		invoke  GetDC, _hWnd		;开始画图！
		mov     @hDc, eax

		mov	@x1,XY_CalStartX
		mov	@y1,XY_CalStartY
		mov	@x2,XY_CalStartX + XY_CalWidth
		mov	@y2,XY_CalStartY + XY_CalHeight

		;高度，宽度，偏移x，偏移y，自重，斜体，下划线，删除线，字符集
		invoke CreateFont,24,12,0,0,400,0,0,0,DEFAULT_CHARSET,\
					;输出精度，裁剪精度
                    OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,\
					;输出质量，字体族，字体名
                    DEFAULT_QUALITY,DEFAULT_PITCH or FF_SCRIPT,\
                    ADDR FontName
		invoke	SelectObject,@hDc,eax
		mov		@hfont,eax
		invoke	SetBkMode,@hDc,TRANSPARENT

		invoke	SetTextColor,@hDc,000000FFH
		invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
		invoke  DrawText, @hDc,addr szText27,-1,addr @rect1,DT_SINGLELINE or DT_CENTER or DT_VCENTER		;周日
		add	@x1,XY_CalWidth
		add	@x2,XY_CalWidth
		invoke	SetTextColor,@hDc,00000000H
		invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
		invoke  DrawText, @hDc,addr szText21,-1,addr @rect1,DT_SINGLELINE or DT_CENTER or DT_VCENTER		;周一
		add	@x1,XY_CalWidth
		add	@x2,XY_CalWidth
		invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
		invoke  DrawText, @hDc,addr szText22,-1,addr @rect1,DT_SINGLELINE or DT_CENTER or DT_VCENTER		;周二
		add	@x1,XY_CalWidth
		add	@x2,XY_CalWidth
		invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
		invoke  DrawText, @hDc,addr szText23,-1,addr @rect1,DT_SINGLELINE or DT_CENTER or DT_VCENTER		;周三
		add	@x1,XY_CalWidth
		add	@x2,XY_CalWidth
		invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
		invoke  DrawText, @hDc,addr szText24,-1,addr @rect1,DT_SINGLELINE or DT_CENTER or DT_VCENTER		;周四
		add	@x1,XY_CalWidth
		add	@x2,XY_CalWidth
		invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
		invoke  DrawText, @hDc,addr szText25,-1,addr @rect1,DT_SINGLELINE or DT_CENTER or DT_VCENTER		;周五
		add	@x1,XY_CalWidth
		add	@x2,XY_CalWidth
		invoke	SetTextColor,@hDc,000000FFH
		invoke	SetRect, addr @rect1,@x1,@y1,@x2,@y2
		invoke  DrawText, @hDc,addr szText26,-1,addr @rect1,DT_SINGLELINE or DT_CENTER or DT_VCENTER		;周六

		invoke	GetStockObject ,BLACK_BRUSH
		mov @hbr ,eax;获取黑色笔刷并保存起来
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
		invoke  ReleaseDC, _hWnd,@hDc
		ret
_PrintBG	endp

;--------------------------------------------------------------------------------------------
;		打印日期
;--------------------------------------------------------------------------------------------
_PrintCal	proc uses eax ebx ecx edx,_hWnd,_w,_DayCount,_Year,_Month,_Day

			local	@szBuffer[256]: byte

			local	@hbr:HBRUSH
			local	@hfont:HFONT
			local	@rect1:RECT
			local	@rectBG:RECT

			local	@hDc

			local	@x1
			local	@y1
			local	@x2
			local	@y2

			local	@PrintDay	;正在打印的日期
			local	@PrintBlock	;已经打印的格子数
			local	@PrintMonth	;正在打印的月份（0上一月，1本月，2下一月
			local	@w			;当前输出日期的星期
				
		invoke  GetDC, _hWnd		;开始画图！
		mov     @hDc, eax

		;高度，宽度，偏移x，偏移y，自重，斜体，下划线，删除线，字符集
		invoke CreateFont,24,12,0,0,400,0,0,0,DEFAULT_CHARSET,\
				;输出精度，裁剪精度
				OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,\
				;输出质量，字体族，字体名
				DEFAULT_QUALITY,DEFAULT_PITCH or FF_SCRIPT,\
				addr FontName

		invoke	SelectObject,@hDc,eax
		mov @hfont,eax

		invoke	SetBkMode,@hDc,TRANSPARENT
				
		mov @PrintDay,1		;从每个月的第一天开始
		mov @PrintBlock,1	;已经打印的格子数
		mov	@PrintMonth,1
		mov eax,_w			;这一天是周几
		mov @w,eax
		
		mov @x1,XY_CalStartX
		mov @y1,XY_CalStartY
		mov @x2,XY_CalStartX
		mov @y2,XY_CalStartY
		
		add @y1,XY_CalHeight	;第一行是标题栏
		add @y2,XY_CalHeight	;第一行是标题栏

		add @x2,XY_CalWidth
		add @y2,XY_CalHeight
		
		mov edx,0
		mov eax,@w
		mov ecx,XY_CalWidth
		imul ecx
		add @x1,eax
		add @x2,eax

		;先清空打印区域
		invoke	GetStockObject,WHITE_BRUSH
		mov @hbr ,eax	;获取白色笔刷并保存起来
		invoke	SetRect, addr @rectBG ,100,100,520,380
		invoke	FillRect, @hDc,addr @rectBG ,@hbr
		invoke	SetRect, addr @rectBG ,160,400,460,430
		invoke	FillRect, @hDc,addr @rectBG ,@hbr
		
		;打印本月和下月
		mov ebx,42		;一共有42个格子
		sub ebx,_w
		.while @PrintBlock <= ebx
			;本月份的日期打印完了
			mov	eax , _DayCount
			.if	@PrintBlock > eax
				.if	@PrintMonth == 1
					mov @PrintMonth, 2
					mov @PrintDay , 1
				.endif
				invoke	SetTextColor,@hDc,00DCDCDCH
			.else
				;周六周日打印红色
				.if @w == 0 || @w == 6
					invoke	SetTextColor,@hDc,000000FFH
				.else
					invoke	SetTextColor,@hDc,00000000H
				.endif
			.endif

			;打印当天（本月），给出特别的背景色
			mov eax,_Day
			.if @PrintDay == eax && @PrintMonth == 1
				invoke	CreateSolidBrush,001E90FFH
				mov @hbr ,eax	;获取灰色笔刷并保存起来
				invoke	SetRect, addr @rect1 ,@x1,@y1,@x2,@y2
				invoke	FillRect, @hDc,addr @rect1 ,@hbr
			.endif

			invoke	SetRect, addr @rect1 ,@x1,@y1,@x2,@y2
			invoke	wsprintf, addr @szBuffer, addr szFormatDay, @PrintDay
			invoke  DrawText, @hDc,addr @szBuffer,-1,addr @rect1,DT_SINGLELINE or DT_CENTER or DT_VCENTER

			inc		@PrintDay
			inc		@PrintBlock
			.if	@w == 6
				mov @w,0
				mov @x1,XY_CalStartX
				mov @x2,XY_CalStartX
				add @x2,XY_CalWidth
				add @y1,XY_CalHeight
				add @y2,XY_CalHeight
			.else
				inc @w
				add @x1,XY_CalWidth
				add @x2,XY_CalWidth
			.endif
		.endw

		;打印上一月
		mov @x1,XY_CalStartX
		mov @y1,XY_CalStartY
		mov @x2,XY_CalStartX
		mov @y2,XY_CalStartY
		
		add @y1,XY_CalHeight	;第一行是标题栏
		add @y2,XY_CalHeight	;第一行是标题栏

		sub @x1,XY_CalWidth
		add @y2,XY_CalHeight
		
		mov edx,0
		mov eax,_w
		mov ecx,XY_CalWidth
		imul ecx
		add @x1,eax
		add @x2,eax

		;先计算上一个月有几天
		mov ebx,_Month
		.if ebx == 1
			mov ebx , 12
			mov eax , _Year
			dec eax
		.else
			dec ebx
			mov eax , _Year
		.endif
		invoke	_JudgeDay, eax, ebx, 1
		mov @PrintDay , eax
		mov eax , _w
		mov @PrintBlock , eax	;上一个月一共要打印w天
		.while @PrintBlock > 0
			invoke	SetTextColor,@hDc,00DCDCDCH

			invoke	SetRect, addr @rect1 ,@x1,@y1,@x2,@y2
			invoke	wsprintf, addr @szBuffer, addr szFormatDay, @PrintDay
			invoke  DrawText, @hDc,addr @szBuffer,-1,addr @rect1,DT_SINGLELINE or DT_CENTER or DT_VCENTER

			dec		@PrintDay
			dec		@PrintBlock

			sub @x1,XY_CalWidth
			sub @x2,XY_CalWidth
		.endw


		;打印底部标题
		invoke	SetTextColor,@hDc,00000000H
		invoke	SetRect, addr @rect1 ,160,400,460,430
		invoke	wsprintf, addr @szBuffer, addr szFormatMonth,_Year, _Month
		invoke  DrawText, @hDc,addr @szBuffer,-1,addr @rect1,DT_SINGLELINE or DT_CENTER or DT_VCENTER

		invoke  ReleaseDC, _hWnd,@hDc
		ret
_PrintCal	endp

; 窗口过程
; 交给Windows的回调函数需要保证ebx edi esi在调用前后保持不变
_ProcWinMain    proc    uses ebx edi esi, hWnd, uMsg, wParam, lParam	;消息的四个参数
				local   @stPs: PAINTSTRUCT	; 窗口客户区的“设备环境”句柄

				local	@rect1:RECT			;输出用的矩形限定框
				local	@rectBG:RECT

				local	@hbr:HBRUSH			;画刷
				local	@hfont:HFONT		;字体

				local	@FlagLeapYear		;是否是闰年
				local	@DayCount			;本月天数
				local	@FlagDayCorrect		;输入的日期是否正确

				local	@i			;循环用
				local	@j			;循环用
				local	@x1
				local	@y1
				local	@x2
				local	@y2

				local   @hDc		;句柄
				local   @hDc1		;句柄

				local   @stDY: SYSTEMTIME		;时间，状态栏用
				local   @stST: SYSTEMTIME		;时间，状态栏用

				local   @stPos: POINT
				local   @hSysMenu		; 菜单
				local   @szBuffer[256]: byte
				local   @szBufferYear[64]: byte
				local   @szBufferMonth[64]: byte
				local   @szBufferDay[64]: byte

				local	@Year
				local	@Month
				local	@Day

				local	@YearFirst2		;年份的前两位
				local	@YearLast2		;年份的后两位
				local	@w				;蔡勒公式转换结果
				local	@wMonth			;蔡勒公式用的月份（3-13）

		; uMsg指出消息类型
		mov     eax, uMsg
		;计时器显示时间
		.if		eax == WM_TIMER
                invoke  GetLocalTime, addr @stST
                movzx   eax, @stST.wHour
                movzx   ebx, @stST.wMinute
                movzx   ecx, @stST.wSecond                
				invoke  wsprintf, addr @szBuffer, addr szFormat1, eax, ebx, ecx
                invoke  SendMessage, hWinStatus, SB_SETTEXT, 2, addr @szBuffer		
		.elseif eax == WM_PAINT
				invoke  BeginPaint, hWnd, addr @stPs		; 获取窗口客户区的“设备环境”句柄
				mov     @hDc, eax

				;高度，宽度，偏移x，偏移y，自重，斜体，下划线，删除线，字符集
				invoke CreateFont,20,10,0,0,400,0,0,0,DEFAULT_CHARSET,\
							;输出精度，裁剪精度
                            OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,\
							;输出质量，字体族，字体名
                            DEFAULT_QUALITY,DEFAULT_PITCH or FF_SCRIPT,\
                            ADDR FontName

				invoke	SelectObject,@hDc,eax
				mov		@hfont,eax
				invoke	SetBkMode,@hDc,TRANSPARENT
				invoke	SetTextColor,@hDc,00000000H
				invoke	SetRect, addr @rect1,220,50,260,80
				invoke  DrawText, @hDc,addr szText31,-1,addr @rect1,DT_SINGLELINE or DT_CENTER or DT_VCENTER		;年
				invoke	SetRect, addr @rect1,300,50,340,80
				invoke  DrawText, @hDc,addr szText32,-1,addr @rect1,DT_SINGLELINE or DT_CENTER or DT_VCENTER		;月
				invoke	SetRect, addr @rect1,380,50,420,80
				invoke  DrawText, @hDc,addr szText33,-1,addr @rect1,DT_SINGLELINE or DT_CENTER or DT_VCENTER		;日

				;如果是首次启动
				.if dwinit == 1
					;打印今天的日期
					invoke  GetLocalTime, addr @stDY
	                movzx   eax, @stDY.wYear
	                movzx   ebx, @stDY.wMonth
	                movzx   ecx, @stDY.wDay 
					mov @Year,eax
					mov @Month,ebx
					mov @Day,ecx
					invoke _JudgeW,@Year,@Month,1
					mov @w,edx
					invoke _JudgeDay,@Year,@Month,@Day
					mov @DayCount,eax
					invoke	_PrintCal,hWnd,@w,@DayCount,@Year,@Month,@Day
					invoke	_PrintBG,hWnd
					mov dwinit , 0
					mov eax , @Year
					mov dwNowPrintYear , eax
					mov eax , @Month
					mov dwNowPrintMonth , eax
					mov ecx , @Day
					mov dwNowPrintDay , ecx
				.endif

				invoke  EndPaint, hWnd, addr @stPs	
		.elseif eax == WM_CREATE
				;invoke  GetSubMenu, hMenu, 1
				;mov     hSubMenu, eax
				;invoke  GetSystemMenu, hWnd, FALSE
				;mov     @hSysMenu, eax
				;菜单
				;invoke  AppendMenu, @hSysMenu, 0, IDM_HELP, offset szMenuHelp
				;invoke  AppendMenu, @hSysMenu, 0, IDM_ABOUT, offset szMenuAbout
				;状态栏
				mov     eax, hWnd
                mov     hWinMain, eax
				invoke  CreateStatusWindow, WS_CHILD or WS_VISIBLE, NULL, hWinMain, ID_STATUSBAR
                mov     hWinStatus, eax
				invoke  SendMessage, hWinStatus, SB_SETPARTS, 4, offset dwStatusWidth;划分状态栏
				invoke  GetLocalTime, addr @stDY
                movzx   eax, @stDY.wYear
                movzx   ebx, @stDY.wMonth
                movzx   ecx, @stDY.wDay 
				invoke  wsprintf, addr @szBuffer, addr szFormat0, eax, ebx, ecx
				invoke  SendMessage, hWinStatus, SB_SETTEXT, 0, addr @szBuffer		;显示日期
                movzx   ecx, @stDY.wDayOfWeek
				mov		@w,ecx
				.if ecx == 0
					invoke  wsprintf, addr @szBuffer, addr szFormatStatusBar1, addr szText27
				.elseif ecx == 1
					invoke  wsprintf, addr @szBuffer, addr szFormatStatusBar1, addr szText21
				.elseif ecx == 2
					invoke  wsprintf, addr @szBuffer, addr szFormatStatusBar1, addr szText22
				.elseif ecx == 3
					invoke  wsprintf, addr @szBuffer, addr szFormatStatusBar1, addr szText23
				.elseif ecx == 4
					invoke  wsprintf, addr @szBuffer, addr szFormatStatusBar1, addr szText24
				.elseif ecx == 5
					invoke  wsprintf, addr @szBuffer, addr szFormatStatusBar1, addr szText25
				.elseif ecx == 6
					invoke  wsprintf, addr @szBuffer, addr szFormatStatusBar1, addr szText26
				.endif

				invoke  SendMessage, hWinStatus, SB_SETTEXT, 1, addr @szBuffer		;显示星期
				invoke  SendMessage, hWinStatus, SB_SETTEXT, 3, addr szFormat2		;显示版权信息

				;---------------------------------------------------------------------------------
				;绘制输入框
				;---------------------------------------------------------------------------------
				;高度，宽度，偏移x，偏移y，自重，斜体，下划线，删除线，字符集
				invoke CreateFont,20,10,0,0,400,0,0,0,DEFAULT_CHARSET,\
						;输出精度，裁剪精度
						OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,\
						;输出质量，字体族，字体名
						DEFAULT_QUALITY,DEFAULT_PITCH or FF_SCRIPT,\
						addr FontName
				mov @hfont,eax

				;输入框 年
				invoke  CreateWindowEx, NULL, \
						offset szEdit, NULL, \
						WS_BORDER or WS_CHILD or WS_VISIBLE or ES_NUMBER or ES_CENTER, \
						160, 53, 60, 24, \
						hWnd, ID_EditYear, hInstance, NULL
				;获取句柄
				mov     hEditYear, eax
				;限制输入长度
				invoke	SendMessage,hEditYear, EM_LIMITTEXT, 4,0
				;修改输入框字体以保持一致
				invoke	SendMessage,hEditYear,WM_SETFONT,@hfont,1

				;输入框 月
				invoke  CreateWindowEx, NULL, \
						offset szEdit, NULL, \
						WS_BORDER or WS_CHILD or WS_VISIBLE or ES_NUMBER or ES_CENTER, \
						260, 53, 40, 24, \
						hWnd, ID_EditMonth, hInstance, NULL
				mov     hEditMonth, eax
				invoke	SendMessage,hEditMonth, EM_LIMITTEXT, 2,0;
				;修改输入框字体以保持一致
				invoke	SendMessage,hEditMonth,WM_SETFONT,@hfont,1

				;输入框 日
				invoke  CreateWindowEx, NULL, \
						offset szEdit, NULL, \
						WS_BORDER or WS_CHILD or WS_VISIBLE or ES_NUMBER or ES_CENTER, \
						340, 53, 40, 24, \
						hWnd, ID_EditDay, hInstance, NULL
				mov     hEditDay, eax
				invoke	SendMessage,hEditDay, EM_LIMITTEXT, 2,0;
				;修改输入框字体以保持一致
				invoke	SendMessage,hEditDay,WM_SETFONT,@hfont,1

				;按钮-跳转
				invoke  CreateWindowEx, NULL, \
						offset szButton, offset szButtonTextGO, \
						WS_CHILD or WS_VISIBLE, \
						460, 50, 60, 30, \
						hWnd, ID_BtnGo, hInstance, NULL
				invoke	SendMessage,ID_BtnGo,WM_SETFONT,@hfont,1

				;按钮-上一月
				invoke  CreateWindowEx, NULL, \
						offset szButton, offset szButtonTextPast, \
						WS_CHILD or WS_VISIBLE, \
						100, 400, 60, 30, \
						hWnd, ID_BtnPast, hInstance, NULL
				invoke	SendMessage,ID_BtnPast,WM_SETFONT,@hfont,1

				;按钮-下一月
				invoke  CreateWindowEx, NULL, \
						offset szButton, offset szButtonTextNext, \
						WS_CHILD or WS_VISIBLE, \
						460, 400, 60, 30, \
						hWnd, ID_BtnNext, hInstance, NULL
				invoke	SendMessage,ID_BtnNext,WM_SETFONT,@hfont,1

                invoke  SetTimer, hWnd, 1, 300, NULL
		.elseif eax == WM_COMMAND
				mov     eax, wParam
				movzx   eax, ax
				.if     eax == IDM_EXIT
						invoke  DestroyWindow, hWinMain
						invoke  PostQuitMessage, NULL
				;日期跳转按钮被按下
				.elseif	eax == ID_BtnPast
						mov ebx,dwNowPrintMonth
						.if ebx == 1
							mov dwNowPrintMonth , 12
							dec dwNowPrintYear
						.else
							dec dwNowPrintMonth
						.endif
						invoke _JudgeW,dwNowPrintYear,dwNowPrintMonth,1
						mov @w,edx
						invoke _JudgeDay,dwNowPrintYear,dwNowPrintMonth,1
						mov @DayCount,eax
						invoke	_PrintCal,hWnd,@w,@DayCount,dwNowPrintYear,dwNowPrintMonth,0
						invoke	_PrintBG,hWnd
				.elseif	eax == ID_BtnNext
						mov ebx,dwNowPrintMonth
						.if ebx == 12
							mov dwNowPrintMonth , 1
							inc dwNowPrintYear
						.else
							inc dwNowPrintMonth
						.endif
						invoke _JudgeW,dwNowPrintYear,dwNowPrintMonth,1
						mov @w,edx
						invoke _JudgeDay,dwNowPrintYear,dwNowPrintMonth,1
						mov @DayCount,eax
						invoke	_PrintCal,hWnd,@w,@DayCount,dwNowPrintYear,dwNowPrintMonth,0
				 		invoke	_PrintBG,hWnd
				.elseif	eax == ID_BtnGo
						;---------------------------------------------------------------------------------
						;获取输入的日期，判断合法性
						;---------------------------------------------------------------------------------
						invoke	GetDlgItemText, hWnd, 101,addr @szBufferYear,5
						invoke	GetDlgItemText, hWnd, 102,addr @szBufferMonth,3
						invoke	GetDlgItemText, hWnd, 103,addr @szBufferDay,3
						;转换数字
						invoke  atoi, addr @szBufferYear
						mov @Year,eax
						invoke  atoi, addr @szBufferMonth
						mov @Month,eax
						invoke  atoi, addr @szBufferDay
						mov @Day,eax
						;判断日期输入是否正确
						mov @FlagLeapYear,0
						;mov @FlagDayCorrect,0
						;判断输入是否为空
						.if	@Year==0 || @Month==0 ||@Day==0
							invoke  MessageBox, hWinMain, addr szErrorBoxEmpty, offset szCaptionError, MB_OK
						.elseif @Month>12 || @Month<1
							;月份不符合要求
							invoke  MessageBox, hWinMain, addr szErrorBoxMonth, offset szCaptionError, MB_OK
						.else
							;判断日的合法性并准备输出
							invoke _JudgeDay,@Year,@Month,@Day
							mov @DayCount,eax
							.if @DayCount==32
								;错误的日期
								invoke  MessageBox, hWinMain, addr szErrorBoxDay, offset szCaptionError, MB_OK
							.else
								;蔡勒公式转换(查本月一号的星期，准备输出）
								invoke _JudgeW,@Year,@Month,1
								mov @w,edx
								;打印
								invoke	_PrintCal,hWnd,@w,@DayCount,@Year,@Month,@Day
								invoke	_PrintBG,hWnd
								mov ecx , @Month
								mov dwNowPrintMonth , ecx
								mov ecx , @Year
								mov dwNowPrintYear , ecx
								mov ecx , @Day
								mov dwNowPrintDay , ecx
							.endif
						.endif
;				.elseif eax >= IDM_TOOLBAR && eax <= IDM_STATUSBAR
;						mov     ebx, eax
;						invoke  GetMenuState, hMenu, ebx, MF_BYCOMMAND
;						.if     eax == MF_CHECKED
;								mov     eax, MF_UNCHECKED
;						.else
;								mov     eax, MF_CHECKED
;						.endif
;						invoke  CheckMenuItem, hMenu, ebx, eax
;				.elseif eax >= IDM_BIG && eax <= IDM_DETAIL
;						invoke  CheckMenuRadioItem, hMenu, IDM_BIG, IDM_DETAIL, eax, MF_BYCOMMAND
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
;		;鼠标右键被单击
;		.elseif eax == WM_RBUTTONDOWN
;				invoke  GetCursorPos, addr @stPos
;				invoke  TrackPopupMenu, hSubMenu, TPM_LEFTALIGN, @stPos.x, @stPos.y, NULL, hWnd, NULL
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

			; 取模块句柄
			invoke  GetModuleHandle, NULL
			mov     hInstance, eax

			;菜单栏
			invoke  LoadMenu, hInstance, IDM_MAIN
			mov     hMenu, eax

			;加速键
			invoke  LoadAccelerators, hInstance, IDA_MAIN
			mov     @hAccelerators, eax

			; 结构体清零
			invoke  RtlZeroMemory, addr @stWndClass, sizeof @stWndClass

			;图标
			invoke  LoadIcon, hInstance, ICO_MAIN
			mov     @stWndClass.hIcon, eax
			mov     @stWndClass.hIconSm, eax
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
					WS_OVERLAPPED or WS_SYSMENU or WS_CAPTION or WS_VISIBLE, \			;dwStyle窗口的外形和行为
					CW_USEDEFAULT, CW_USEDEFAULT, \	;指定窗口左上角位置
					620, 540, NULL, hMenu , hInstance,NULL
;					600, 400, \			;窗口的宽度和高度
;					NULL, \				;hWndParent窗口所属的父窗口
;					NULL, \				;hMenu窗口上要出现的菜单的句柄
;					hInstance, \		;hInstance模块句柄
;					NULL				;lpParam——这是一个指针，指向一个欲传给窗口的参数（一般不用）
			mov     hWinMain, eax
			; 显示窗口
			invoke  ShowWindow, hWinMain, SW_SHOWNORMAL
			; 刷新窗口客户区
			invoke  UpdateWindow, hWinMain

			;消息循环
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
		invoke	FreeConsole
		call    _WinMain
		invoke  ExitProcess, NULL
		end     start