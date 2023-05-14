#include "crt/stdio.bi"
#include "crt/stdlib.bi"
#include "crt/string.bi"
#include "crt/math.bi"
#include "crt/stdarg.bi"
#include "crt/time.bi"

'#include "dirent.bi"
#include "crt/unistd.bi"



#ifdef FB_WIN32
#include "windows.bi"
#include "conio.bi"
#ifdef MOUSE_MOVED
#undef MOUSE_MOVED
#endif
#else
#include "X11/X.bi"
#include "X11/keysym.bi"
#endif

#include "curses.bi"

#define MSK_TITLE		"MISAKA System"
#define MSK_VER			"0.1"

#define ESCAPE_KEY		&H1b
#ifndef CTL_PGUP
#define CTL_PGUP		&H1bd
#endif
#ifndef CTL_PGDN
#define CTL_PGDN		&H1be
#endif
#ifndef PADENTER
#define PADENTER		&H1cb
#endif
#define PAD_ROWS		(LINES - 2)
#define PAD_COLS		COLS

#define ArraySize(x)	ubound(x)
'(sizeof((x)) / sizeof((x)[0]))
'// ----------------------------------------


'extern "C"


type __MSK_Console_Cmd

	_Command as zstring ptr
	 Helptext  as zstring ptr

	as sub(params as any ptr) _function
end type


type __MSK_Console
	as integer Handle
	as integer ExitHandle 

	as boolean IsRunning 
	as boolean IsLogging 
	as FILE ptr _Log 

	as sub() Funcstack(256)
	as integer FunctionNo

	as __MSK_Console_Cmd _Command(512)
	as integer CommandCount

	as zstring ptr Title

	as WINDOW_ ptr WindowMain 
	as WINDOW_ ptr WindowCommand 
	as WINDOW_ ptr WindowPad 

	as byte CommandHist(512 , 512)
	as integer CommandHistCount
	as integer CommandHistCurrent

	as integer InCmdPosition

	as integer TotalConsoleLine
	as integer  CurrentConsoleLine

	as zstring ptr ValidCharacters

	as boolean UpdateHist
end type





declare sub MSK_SetMainFunction(_function as any ptr) 
declare sub MSK_RestoreMainFunction() 

#ifndef FB_WIN32
declare function kbhit() as integer
#endif

extern as  __MSK_Console _Console

'end etxern





