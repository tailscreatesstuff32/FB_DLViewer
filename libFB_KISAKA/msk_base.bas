#include "misaka_.bi"
#include "msk_base.bi"
#include "msk_console.bi"
#include "msk_ui.bi"

#include "crt/sys/select.bi"


#include once "curses.bi"


dim shared as __MSK_Console _Console
 
dim shared as __MSK_UI_Dialog_Data Dialog(512)
dim shared as __MSK_UI_Object_Data _Object(512)

dim shared as __MSK_UI_Dialog_Data Dialog_Active

dim shared as __MSK_Return ReturnVal
 
'sub MSK_DoEvents_Console()

'end sub

sub  MSK_SetMainFunction(_function as any ptr)
 
	if(_Console.FunctionNo < 256) then 
	_Console.FunctionNo +=1
	_Console.Funcstack(_Console.FunctionNo) = _Function
	end if

end sub


function MSK_Init(Apptitle as zstring ptr) as integer export
	srand(cast(uinteger,time_(0)))
	 
	
	 memset(@_Console, &H00, sizeof(_Console))
	 memset(@Dialog(0), -1, ArraySize(Dialog))
	 memset(@_Object(0), -1, ArraySize(_Object))
	'MSK_ConsolePrint(MSK_COLORTYPE_WARNING, !"%i\n", _Object(512))
	
	
	initscr()
	clear_()
	noecho()
	
	cbreak()
	keypad(stdscr, TRUE)
	curs_set(0)
	
	start_color()
	init_color(COLOR_RED, 1000, 0, 0)
	init_color(COLOR_YELLOW, 800, 400, 0)
	init_pair(1, COLOR_GREEN, COLOR_BLACK)
	init_pair(2, COLOR_YELLOW, COLOR_BLACK)
	init_pair(3, COLOR_RED, COLOR_BLACK)
	init_pair(4, COLOR_WHITE, COLOR_BLUE)
	init_pair(5, COLOR_BLUE, COLOR_WHITE)
	color_set(1, 0)
	
	_Console.WindowCommand = newwin(1, COLS, LINES - 1, 0)
	wbkgd(_Console.WindowCommand, COLOR_PAIR(4))
	
	'// init log
	_Console.WindowPad = newpad(16384, COLS - 1)
	wbkgd(_Console.WindowPad, COLOR_PAIR(0))
	
	'// init main window / title bar
	_Console.WindowMain = newwin(LINES - 1, COLS, 0, 0)
	wbkgd(_Console.WindowMain, COLOR_PAIR(4))
	
 
	
	
	scrollok(_Console.WindowMain, TRUE)
	idlok(_Console.WindowMain, TRUE)
	
	
	
	'	// initial command bar display
	wmove(_Console.WindowCommand, 0, 0)
	 wprintw(_Console.WindowCommand, "~ ") 
	 
	 refresh()
	 wrefresh(_Console.WindowCommand)
         wrefresh(_Console.WindowMain)
         
         memset(@_Console.CommandHist(0,0), &H00, ArraySize_Bytes(_Console.CommandHist))
   
         '// set title bar
         _Console.Title = Apptitle

        '// set main function
	_Console.FunctionNo = 0
	MSK_SetMainFunction(@MSK_DoEvents_Console)

	'// add basic commands
	 MSK_AddCommand("exit", "Exit the program", @MSK_RequestExit) 
	 MSK_AddCommand("help", "Show command help",@MSK_ShowHelp) 
         'MSK_AddCommand("test", "test command",@MSK_ShowHelp) 
	_Console.IsRunning = TRUE
	
		'	MSK_ConsolePrint(MSK_COLORTYPE_WARNING, !"%i\n", _Console.FunctionNo)
	
	'MSK_ShowHelp()
	MSK_consoleprint(0,!"\n")
 
	
	'// set and return console main handle
	_Console.Handle = rand()
	return _Console.Handle
	
	
end function
sub MSK_SetValidCharacters(Chars as zstring ptr)  Export
  
	_Console.ValidCharacters = Chars 
end sub
sub MSK_Exit()  Export
 
	delwin(_Console.WindowMain) 
	delwin(_Console.WindowCommand) 
	delwin(_Console.WindowPad) 
	endwin() 

	if(_Console.IsLogging) then fclose(_Console._Log) 
end sub
sub MSK_RestoreMainFunction()
 
		if(_Console.FunctionNo > 0) then 
	
	_Console.Funcstack(_Console.FunctionNo) = NULL
	_Console.FunctionNo -=1
	
	
	end if
end sub

function MSK_DoEvents() as integer Export
 
	ReturnVal.Handle = _Console.Handle  

	'// print title bar
	wmove(_Console.WindowMain, 0, 0)
	wprintw(_Console.WindowMain,_Console.Title)

	'// display current time
  	'dim as byte _Time(256)
  	dim as zstring * 256 _Time
  	MSK_CurrentTime(_Time) 

  	wmove(_Console.WindowMain, 0, COLS - 10) 
	wprintw(_Console.WindowMain, "| %s", _Time) 
	wrefresh(_Console.WindowMain) 

	if(_Console.FuncStack(_Console.FunctionNo) <> NULL) then _Console.FuncStack(_Console.FunctionNo)()

	return _Console.IsRunning 
end function


 


#ifndef FB_WIN32
function kbhit() as integer

	dim as timeval tv
	dim as fd_set read_fd
	tv.tv_sec = 0
	tv.tv_usec = 0
	FD_ZERO(@read_fd)
	FD_SET_(0,@read_fd)
	if(select_ (1, @read_fd,NULL, NULL, @tv) = -1) then return 0
	if(FD_ISSET(0,@read_fd)) then  return 1  
	return 0
end function
#endif






