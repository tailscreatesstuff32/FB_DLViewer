#include "misaka_.bi"
#include "msk_base.bi"
#include "msk_console.bi"
#include "msk_ui.bi"


sub MSK_AddCommand(Cmd as zstring ptr, Help  as zstring ptr,Func as any ptr) export
 
	if (_Console.CommandCount < 512)  then 
		_Console._Command(_Console.CommandCount)._Command = Cmd
		_Console._Command(_Console.CommandCount).Helptext = Help
		_Console._Command(_Console.CommandCount)._Function = Func
		
		'print *_Console._Command(_Console.CommandCount)._Command
                'print *_Console._Command(_Console.CommandCount).Helptext
                'if   _Console._Command(_Console.CommandCount)._Function <> 0 then print "not a valid function address"; " "; hex(_Console._Command(_Console.CommandCount)._Function,8)
                 
		_Console.CommandCount+=1
	end if
	
	
 
	
	
end sub


sub MSK_RequestExit()



	_Console.ExitHandle = MSK_MessageBox("Exit", "Do you really want to exit?", MSK_UI_MSGBOX_YESNO)
	
end sub
 
sub MSK_ShowHelp()
	MSK_ConsolePrint(MSK_COLORTYPE_OKAY, !"\nAvailable commands:\n")
	dim as integer i = 0
	dim as integer CmdCount = ArraySize(_Console._Command)
	do while((i < CmdCount) andalso (_Console._Command(i)._Function <> NULL)) 
		MSK_ConsolePrint(MSK_COLORTYPE_INFO, !"- %s: %s\n", _Console._Command(i)._Command, _Console._Command(i).Helptext)
		i+=1
	loop
end sub

sub MSK_ConsolePrint cdecl (_Color as integer, _Format as zstring ptr, ...)

	_Console.CurrentConsoleLine = _Console.TotalConsoleLine

	dim text(256) as byte
	dim as cva_list argp

	if(_Format = NULL) then return

	cva_start(argp, _Format)
	vsprintf(@Text(0), _Format, argp)
	cva_end(argp)

	dim as zstring ptr _ptr
	_Ptr = strstr(@Text(0), !"\n")
	if(_Ptr = &H0) then
		strcat(@Text(0), !"\n")
			_Console.TotalConsoleLine+=1
			_Console.CurrentConsoleLine+=1
	 else  
		do while(_Ptr <> NULL)  
			_Ptr = strstr(_Ptr+1, !"\n")
			_Console.TotalConsoleLine+=1
			_Console.CurrentConsoleLine+=1
		loop
	end if

	wattron(_Console.WindowPad, COLOR_PAIR(_Color))
	wprintw(_Console.WindowPad, "%s", @Text(0))
	wattroff(_Console.WindowPad, COLOR_PAIR(_Color))
	wrefresh(_Console.WindowPad)

	if((_Console._Log <> NULL) andalso (_Console.IsLogging)) then
		fprintf(_Console._Log, "%s", @Text(0))
		fflush(_Console._Log)
	end if

	MSK_Refresh(_Console.TotalConsoleLine - 1)
end sub



sub MSK_InitLogging(Path as zstring ptr)  export
	_Console.IsLogging = TRUE
	_Console._Log = fopen(Path, "w")
end sub

sub MSK_SetLogging(Toggle as integer)  export

_Console.IsLogging = Toggle

end sub

function MSK_ScaleRange(_in as double ,oldMin as double,oldMax as double , newMin as double ,newMax as double) as single
return (_in / ((oldMax - oldMin) / (newMax - newMin))) + newMin
end function

 sub MSK_Refresh(_Line as integer)
	'// refresh the log, show it from line n
	refresh()
	dim as integer PadStart = (_Line - PAD_ROWS) + 1
	if(PadStart < 0) then PadStart = 0

	prefresh(_Console.WindowPad, PadStart, 0, 1, 0, PAD_ROWS, PAD_COLS)

	'// draw scrollbar
	dim as integer TempNow = _Console.CurrentConsoleLine - (LINES - 2)
	if(TempNow < 0) then TempNow = 0
	dim as integer TempMax = _Console.TotalConsoleLine - (LINES - 2)
	if(TempMax < 0) then TempMax = 0

	dim as single _Pos = MSK_ScaleRange(cast(single,TempNow), 0.0f, cast(single,TempMax), 1.0f, cast(single,LINES - 2))
	if isnan(_Pos) then _Pos = cast(single,LINES - 2) 

	mvwvline(_Console.WindowMain, 1, COLS - 1, ACS_VLINE, LINES - 2)
	mvwvline(_Console.WindowMain, cast(integer,_Pos), COLS - 1, ACS_BLOCK, 1)
 
end sub

sub MSK_CurrentTime(TimeBuf as zstring ptr)
	'// get current time and format a string
	dim RawTime as time_t
	dim as tm ptr TimeInfo
	time_(@RawTime)
	TimeInfo = localtime(@RawTime)
	strftime(TimeBuf, 128, "%H:%M:%S", TimeInfo)
end sub





sub MSK_DoEvents_Console()
MSK_Refresh(_Console.CurrentConsoleLine - 1)

	dim as byte CmdProcess(256)
	dim as boolean inputdone = false

	'// check if a key has been hit, if not return
	'// without this, the whole program would stall unless a key is actually pressed down
	if(kbhit()) then
		'// get the pressed key
		dim as integer Character = getch()
		

		'// update display
		wmove(_Console.WindowCommand, 0, 0)
		wprintw(_Console.WindowCommand, "~ ")

		'// check what key has been pressed
		select case character
		'	// page up -> go up a page in log
			case KEY_PPAGE
				if(_Console.CurrentConsoleLine > PAD_ROWS) then
					_Console.CurrentConsoleLine-=20
					if(_Console.CurrentConsoleLine <= PAD_ROWS)then  _Console.CurrentConsoleLine = PAD_ROWS
					MSK_Refresh(_Console.CurrentConsoleLine - 1)
				end if
				

			'// page down -> go down a page in log
			 case KEY_NPAGE
				_Console.CurrentConsoleLine+=20
				if(_Console.CurrentConsoleLine <= _Console.TotalConsoleLine) then
					MSK_Refresh(_Console.CurrentConsoleLine - 1)
				 else 
					_Console.CurrentConsoleLine = _Console.TotalConsoleLine
					MSK_Refresh(_Console.CurrentConsoleLine - 1)
			end if

			'// ctrl & page up -> go up a line in log
			case CTL_PGUP
				if(_Console.CurrentConsoleLine > PAD_ROWS)  then
					_Console.CurrentConsoleLine-=1
					MSK_Refresh(_Console.CurrentConsoleLine - 1)
				endif
			 

			'// ctrl & page down -> go down a line in log
			case CTL_PGDN
				_Console.CurrentConsoleLine +=1
				if(_Console.CurrentConsoleLine <= _Console.TotalConsoleLine) then
					MSK_Refresh(_Console.CurrentConsoleLine - 1)
				 else 
					_Console.CurrentConsoleLine-=1
				end if
				

			'// cursor up -> go up in command history
			case KEY_UP
				if(_Console.CommandHistCurrent > 0) then
					_Console.CommandHistCurrent -=1
					strcpy(@_Console.CommandHist(_Console.CommandHistCount,0), @_Console.CommandHist(_Console.CommandHistCurrent,0))
					_Console.InCmdPosition = strlen(@_Console.CommandHist(_Console.CommandHistCount,0))
				end if

			'// cursor down -> go down in command history
			case KEY_DOWN
				_Console.CommandHistCurrent +=1
				if(_Console.CommandHistCurrent = _Console.CommandHistCount) then
					memset(@_Console.CommandHist(_Console.CommandHistCount,0), &H00, ArraySize(_Console.CommandHist))
					_Console.InCmdPosition = 0
				elseif(_Console.CommandHistCurrent <= _Console.CommandHistCount) then
					strcpy(@_Console.CommandHist(_Console.CommandHistCount,0), @_Console.CommandHist(_Console.CommandHistCurrent,0))
					_Console.InCmdPosition = strlen(@_Console.CommandHist(_Console.CommandHistCount,0))
				 else 
					_Console.CommandHistCurrent-=1
				end if
				 
		'	// escape -> clear entered command string
			case ESCAPE_KEY
				memset(@_Console.CommandHist(_Console.CommandHistCount, 0),&H00, ArraySize(_Console.CommandHist))
				_Console.InCmdPosition = 0
			 

		'	// backspace -> delete a character backwards
			case asc(!"\b")
			if(_Console.InCmdPosition > 0) then 	_Console.InCmdPosition -=1: _Console.CommandHist(_Console.CommandHistCount,_Console.InCmdPosition) = asc(!"\0")

			
			case KEY_BACKSPACE
		 
		
			 	if(_Console.InCmdPosition > 0) then 	_Console.InCmdPosition -=1: _Console.CommandHist(_Console.CommandHistCount,_Console.InCmdPosition) = asc(!"\0")
			 

		'// return/enter -> finish command entry and go to processing
			case asc(!"\n") 
				if(strlen(@_Console.CommandHist(_Console.CommandHistCount,0)) = 0) then exit select
				strcpy(@CmdProcess(0), @_Console.CommandHist(_Console.CommandHistCount,0))
				_Console.InCmdPosition = 0 
				InputDone = TRUE 
			
			
			case PADENTER
			msk_consoleprint(0,"%i",ArraySize(_Console.CommandHist))
				if(strlen(@_Console.CommandHist(_Console.CommandHistCount,0)) = 0) then exit select
				strcpy(@CmdProcess(0), @_Console.CommandHist(_Console.CommandHistCount,0))
				_Console.InCmdPosition = 0 
				InputDone = TRUE 
			

			'// everything else -> check character validity and add to command string, if passed
			case else
			
			 	dim p as zstring ptr
			 	p = strchr(_Console.ValidCharacters, Character)
				if p = null then exit select		'// if invalid, break
				if((Character = asc(" ")) andalso (_Console.InCmdPosition = 0)) then exit select			'// if first character is space, break
				if(_Console.InCmdPosition >= 256) then exit select									'// if cmd too long, break;
			      
				_Console.CommandHist(_Console.CommandHistCount,_Console.InCmdPosition) = Character  
				  _Console.InCmdPosition+=1
				
		end select
	end if 


 

	'// update display
	wmove(_Console.WindowCommand, 0, 2)
	wclrtoeol(_Console.WindowCommand)
	wprintw(_Console.WindowCommand, @_Console.CommandHist(_Console.CommandHistCount,0))
	if(ReturnVal.Handle = _Console.Handle) then
		'//wprintw(_Console.WindowCommand, "_");
		mvwaddch(_Console.WindowCommand, 0, (2 + _Console.InCmdPosition), ACS_CKBOARD)
	end if

	'// if enter has been pressed, process the command
	if(InputDone) then
		wmove(_Console.WindowCommand, 0, 2)
		wclrtoeol(_Console.WindowCommand)
		wrefresh(_Console.WindowCommand)
		MSK_DoEvents_Console_Command(@CmdProcess(0))
		InputDone = FALSE
	end if

	'// update display
	refresh()
	wrefresh(_Console.WindowCommand)
	wrefresh(_Console.WindowMain)

end sub

sub MSK_DoEvents_Console_Command(_Command as zstring ptr)
	'// assume that the command history must be updated
	_Console.UpdateHist = TRUE

         
        ' MSK_ConsolePrint(0,_Command)
         
        ' return




	'// figure out where the command itself ends, and where params start
	dim as zstring * 256 cmdname  
	strcpy(@CmdName, _Command)
	
	
	

	
	dim as zstring ptr _Ptr
	
	
	_Ptr = strstr(@CmdName, " ")
	if((_Ptr)) then *_Ptr = &H00
	
	
	

	'// go through all existing commands to find the entered one
	dim as integer i = 0:dim as  boolean CmdNotFound = TRUE
	dim as integer CmdCount = ArraySize(_Console._Command)
	do   while((i < CmdCount) andalso (_Console._Command(i)._Function <> NULL)) 
		if(strcmp(@CmdName, _Console._Command(i)._Command) = 0)then
		
		
		'MSK_ConsolePrint(MSK_COLORTYPE_WARNING, !"i%\n", _Command)'
		
			_Console._Command(i)._Function(_Ptr) 
			CmdNotFound = FALSE
			exit do
		end if
		i+=1
	loop
         
       
       

	'// if the command couldn't be found, spit out unknown command message and disable history update
	if(CmdNotFound) then
		MSK_ConsolePrint(MSK_COLORTYPE_WARNING, !"> Unknown command: %s\n", _Command)
		_Console.UpdateHist = FALSE
	end if
 
	''// if the command and the command previously issued are the same, don't add it to the history again
	if strcmp(@_Console.CommandHist(_Console.CommandHistCount,0), @_Console.CommandHist(_Console.CommandHistCount - 1,0) ) = 0 then
		_Console.UpdateHist = FALSE
		_Console.CommandHistCurrent = _Console.CommandHistCount
	end if

	'// if the history is supposed to be update, do it, else reset the current slot
	if(_Console.UpdateHist) then
		_Console.CommandHistCount+=1
		_Console.CommandHistCurrent = _Console.CommandHistCount
	else 
		memset(@_Console.CommandHist(_Console.CommandHistCount,0), &H00, ArraySize(_Console.CommandHist))
		_Console.CommandHistCurrent = _Console.CommandHistCount
	end if

	'// update display
	wmove(_Console.WindowCommand, 0, 2)
	wclrtoeol(_Console.WindowCommand)
	printw(@_Console.WindowCommand, _Console.CommandHist(_Console.CommandHistCount,0))
	
	
	
	
end sub
