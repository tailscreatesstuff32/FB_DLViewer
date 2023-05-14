extern "c"


declare sub MSK_RequestExit()
declare sub MSK_ShowHelp()
declare sub MSK_Refresh(_Line as integer)
declare sub MSK_CurrentTime(Timebuf as zstring ptr)
declare sub MSK_DoEvents_Console()
declare sub MSK_DoEvents_Console_Command( _Command as zstring ptr)
 end extern

