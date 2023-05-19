
#include "globals.bi"




function oz_InitProgram(WWndTitle as zstring ptr, w as integer, h as integer) as integer

	#ifdef FB_WIN32
	return WinAPIInit(WndTitle, W, H)
	#else
	return XInit(WWndTitle, W, H)
	#endif


end function


function oz_SetWindowSize( w as integer, h as integer) as integer
 
	#ifdef FB_WIN32
	return WinAPISetWindowSize(W, H)
	#else
	return oz_Unimplemented(__FUNCTION__)
	#endif
end function


function oz_ExitProgram() as integer
 
	#ifdef FB_WIN32
	WinAPIExit()
	#else
	return XExit()
	#endif

	return EXIT_SUCCESS
end function

function oz_APIMain() as integer
 
	'#ifdef FB_WIN32
	'return WinAPIMain()
	'#else
	return XMain()
	'#endif
end function


function oz_CreateFolder(_Folder as zstring ptr) as integer
 
	#ifdef WIN32
	CreateDirectory(_Folder, NULL)
	#else
	return _mkdir(_Folder,0777 ) '_S_IRWXU or _S_IRWXG or _S_IROTH or _S_IXOTH)
	#endif

	return EXIT_SUCCESS
end function

function oz_SetWindowTitle(WndTitle as zstring ptr ) as integer
 
	#ifdef FB_WIN32
	return WinAPISetWindowTitle(WndTitle)
	#else
	return XSetWindowTitle(WndTitle)
	#endif
end function


function oz_Unimplemented(_FuncName as const zstring ptr) as integer
 
	dbgprintf(0, MSK_COLORTYPE_ERROR, !"- Error: Platform-specific code for %s not implemented\n", _FuncName )
	return EXIT_FAILURE
end function






