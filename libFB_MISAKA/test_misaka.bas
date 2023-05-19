#define SHARED_SO
#define NEW_MISAKA
#include "misaka.bi"
#include once "curses.bi"
 
 
 
 #ifdef SHARED_SO
  dim shared as any ptr libhandle: libhandle = Dylibload("libFB_MISAKA.so")


If( libhandle = 0 ) Then
    Print "Failed to load the mydll dynamic library, aborting program..."
    End 1
End If

dim shared as function( _Apptitle as zstring ptr) as integer  MSK_Init: MSK_Init = Dylibsymbol(libhandle,"MSK_Init")

dim shared as sub (Chars as Zstring ptr) MSK_SetValidCharacters: MSK_SetValidCharacters = Dylibsymbol(libhandle,"MSK_SetValidCharacters")
dim shared as sub(cmd as zstring ptr,  Help  as zstring ptr,Func as any ptr) MSK_AddCommand:MSK_AddCommand = Dylibsymbol(libhandle,"MSK_AddCommand")
dim shared as sub()   MSK_Exit:MSK_Exit = Dylibsymbol(libhandle,"MSK_Exit")
dim shared as sub( _Apptitle as zstring ptr)   MSK_InitLogging:MSK_InitLogging = Dylibsymbol(libhandle,"MSK_InitLogging")
dim shared as sub(Toggle as integer) MSK_SetLogging:MSK_SetLogging = Dylibsymbol(libhandle,"MSK_SetLogging")
dim shared as sub  cdecl  (_Color as integer,frmt as zstring ptr, ...) MSK_ConsolePrint:MSK_ConsolePrint = Dylibsymbol(libhandle,"MSK_ConsolePrint")  
dim shared as function( Title as zstring ptr, Text as zstring ptr , Type as integer) as integer MSK_MessageBox:MSK_MessageBox = Dylibsymbol(libhandle,"MSK_MessageBox")  
dim shared as sub()   MSK_DoEvents:MSK_DoEvents = Dylibsymbol(libhandle,"MSK_DoEvents")
dim shared  as function(Dlg as __MSK_UI_Dialog ptr ) as integer MSK_Dialog:MSK_Dialog  = Dylibsymbol(libhandle,"MSK_Dialog") 
 
#endif

  #define APPTITLE		"FB_DLViewer"
#define VERSION			"v0.0"


dim _Title as zstring * 256
sub Quit()


end sub

sub dbgprintf cdecl (Level as integer , _Type as integer,  _Format as zstring ptr, ...)
 
	'  if(zOptions.DebugLevel >= Level) then
	 	dim as byte Text(256)
		dim as cva_list argp

		 if _format =NULL then
		 return
		 end if

		cva_start(argp, _Format) 
		vsprintf(@Text(0),_Format, argp) 
		cva_end(argp)

	 	MSK_ConsolePrint(_Type, @Text(0)) 
	 
	'end if
end sub




#ifdef __FB_DEBUG__
	'
	
#else
	'sprintf(_Title,APPTITLE " " VERSION " (build " __DATE__ " "   __TIME__  ")" " / Debug" ")" )
 
#endif
 
sprintf(_Title,APPTITLE " " VERSION " (build " __DATE__ " "   __TIME__  ")" )

 
MSK_init(_Title)

MSK_InitLogging("log.txt")
MSK_SetValidCharacters(!"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789.,:\\/\"-()[]_!")

'dbgprintf(0,0,"test")

	#ifdef WIN32
	dbgprintf(0, MSK_COLORTYPE_INFO, APPTITLE !" launched, running on 32/64-bit Windows...\n") 
	#else
	dbgprintf(0, MSK_COLORTYPE_INFO, APPTITLE !" launched, running on non-Windows OS...\n") 
	#endif
	dbgprintf(0, MSK_COLORTYPE_INFO, !"\n") 
	
dbgprintf(0, MSK_COLORTYPE_OKAY, !"Viewer initialized, using %s microcode.\n","F3DEX2")

MSK_MessageBox("Exit", "Do you really want to exit?", MSK_UI_MSGBOX_YESNO)
'dbgprintf(0, MSK_COLORTYPE_OKAY, !"\n")
'dbgprintf(0, MSK_COLORTYPE_OKAY, !"%i \n", ))


 


dim as integer i

'print arraysize(i)

MSK_DoEvents()

do while getch() = 0

loop

MSK_Exit()



#ifdef SHARED_SO
DyLibFree(libhandle)
#endif





