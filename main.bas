 

'#inclib "png"
#inclib "badRDP"

'#inclib "GLEW"




#include "globals.bi"
 






dim shared as __zProgram zProgram
dim shared as __zOptions zOptions
dim shared as __zCamera zCamera
'dim shared as __zHUD zHUD

dim shared as __RAM RAM(MAX_SEGMENTS) 
dim shared as __RDRAM RDRAM 


#ifndef FILESEP
#define FILESEP !"/"
#endif

declare sub die(code as integer)


sub GetFileName(FullPath As zstring ptr, Target As zstring ptr)
 
		dim as zstring ptr _ptr
		
		
		_Ptr = strrchr(FullPath, asc(!"/"))
		
	if(_Ptr) then
		strcpy(Target,_Ptr+1)
	 else   
		strcpy(Target, FullPath)
	end if
end sub


sub GetFilePath(FullPath As zstring ptr, Target As zstring ptr)
	dim as zstring * MAX_PATH temp 
	strcpy(Temp, FullPath)
	dim as zstring ptr _ptr
	
	
 
	
	
	 _Ptr = strrchr(Temp, asc(!"/"))
 	if ( _Ptr ) then
	
  
		 _Ptr+=1
		 *_Ptr = !"\0"
		 
		
		strcpy(Target, Temp)
		return
 
	end if
	 
	 
	 
	 

	 _Ptr = strrchr(Temp, asc(!"\\"))
	if ( _Ptr ) then
	
 
		 
		 _Ptr+=1
		 *_Ptr = !"\0"
	 
		
		strcpy(Target, Temp)
		return
		
	end if
	
	sprintf(Target, ".%c", FILESEP)
	
	
end sub

'inline macro maybe?
sub dbgprintf cdecl (Level as integer , _Type as integer,  _Format as zstring ptr, ...)
 
	  if(zOptions.DebugLevel >= Level) then
	 	dim as byte Text(256)
		dim as cva_list argp

		 if _format =NULL then
		 return
		 end if

		cva_start(argp, _Format) 
		vsprintf(@Text(0),_Format, argp) 
		cva_end(argp)

	 	MSK_ConsolePrint(_Type, @Text(0)) 
	 
	end if
end sub
function  DoMainKbdInput() as integer
	 if(RDRAM.IsSet = false) then

		if(zProgram._Key(KEY_CAMERA_UP)) then ca_Movement(false, zCamera.CamSpeed)
		if(zProgram._Key(KEY_CAMERA_DOWN)) then ca_Movement(false, -zCamera.CamSpeed)
		if(zProgram._Key(KEY_CAMERA_LEFT)) then ca_Movement(true, -zCamera.CamSpeed)
		if(zProgram._Key(KEY_CAMERA_RIGHT)) then ca_Movement(true, zCamera.CamSpeed)
		
		
		
	end if

	if(zProgram._Key(KEY_GUI_TOGGLEHUD)) then
	'beep
	dbgprintf(0, MSK_COLORTYPE_INFO, !"%i\n",KEY_GUI_TOGGLEHUD) 
	
	
	
		zOptions.EnableHUD xor= 1 
		zProgram._Key(KEY_GUI_TOGGLEHUD) = false 
	end if

	if(zProgram._Key(KEY_GUI_TOGGLEGRID))  then
	dbgprintf(0, MSK_COLORTYPE_INFO, !"%i\n",KEY_GUI_TOGGLEGRID)
		zOptions.EnableGrid xor= 1 
		zProgram._Key(KEY_GUI_TOGGLEGRID) = false 
	end if

	if(zProgram._Key(KEY_DLIST_NEXTLIST) andalso zProgram.DListCount >= 0) then
		if((zProgram.DListSel < zProgram.DListCount) andalso (zProgram.DListCount <> 0)) then
			zProgram.DListSel+=1
		end if
		zProgram._Key(KEY_DLIST_NEXTLIST) = false 
	end if

	if(zProgram._Key(KEY_DLIST_PREVLIST) andalso zProgram.DListCount >= 0)  then
		if((zProgram.DListSel >= 0) andalso (zProgram.DListCount <> 0)) then
			zProgram.DListSel-=1
		end if
		zProgram._Key(KEY_DLIST_PREVLIST) = false 
	end if

 
return EXIT_SUCCESS

end function



'///////////////////////////////////////////////////////////////////////////////////


#include "GL/glu.bi"

'dim shared  as Display ptr dpy
dim shared  as Window   root
dim shared  as GLint                   att(0 to ...) => { GLX_RGBA, GLX_DEPTH_SIZE, 24, GLX_DOUBLEBUFFER, None }
'dim shared  as XVisualInfo ptr         vi
'dim shared  as Colormap                cmap
'dim shared  as XSetWindowAttributes    swa
'dim shared  as Window                  win
dim shared  as GLXContext              glc
dim shared  as XWindowAttributes       gwa
dim shared  as XEvent                  xev



 


function main2(argc as integer, argv as zstring ptr ptr) as integer

 dpy = XOpenDisplay(NULL)
 
 if(dpy = NULL) then
 	printf(!"\n\tcannot connect to X server\n\n")
        end 0
end if
        
 root = DefaultRootWindow(dpy)

 vi = glXChooseVisual(dpy, 0, @att(0))

 if(vi = NULL) then
	printf(!"\n\tno appropriate visual found\n\n")
        end 0
  
 else  
	printf(!"\n\tvisual %p selected\n", cast(any ptr,vi->visualid)) ' /* %p creates hexadecimal output like in glxinfo */
end if


 cmap = XCreateColormap(dpy, root, vi->visual, AllocNone)

 swa.colormap = cmap
 swa.event_mask = ExposureMask or KeyPressMask
 
 win = XCreateWindow(dpy, root, 0, 0, 600, 600, 0, vi->depth, InputOutput, vi->visual, CWColormap or CWEventMask, @swa)

 XMapWindow(dpy, win)
 XStoreName(dpy, win, "VERY SIMPLE APPLICATION")
 
 glc = glXCreateContext(dpy, vi, NULL, GL_TRUE)
 glXMakeCurrent(dpy, win, glc)
 
 glEnable(GL_DEPTH_TEST)
 
 do while 1
 	XNextEvent(dpy, @xev)
        
        if(xev.type = Expose) then
        	XGetWindowAttributes(dpy, win, @gwa)
                glViewport(0, 0, gwa.width, gwa.height)
        	DrawAQuad()
                glXSwapBuffers(dpy, win)
    
                
	elseif (xev.type = KeyPress)  then
        	glXMakeCurrent(dpy, None, NULL)
 		glXDestroyContext(dpy, glc)
 		XDestroyWindow(dpy, win)
 		XCloseDisplay(dpy)
 		end 0
        end if
      
loop 
return 0


 end function

'//////////////////////////////////////////////////////////////////////////////





function main(argc as integer, argv as zstring ptr ptr) as integer

	dim as zstring * MAX_PATH temp 
	
	
#ifdef __FB_DEBUG__
	sprintf(zProgram.Title,APPTITLE " " _VERSION " (build " __DATE__ " "   __TIME__  ")" )
	
#else
	sprintf(zProgram.Title,APPTITLE " " _VERSION " (build " __DATE__ " "   __TIME__  ")" " / Debug" ")" )
 
#endif
 
 
 
 	'// get working directory from executable path
	GetFilePath(argv[0], zProgram.AppPath) 

 	'// check for --help and --about options
	if(argc > 1)  then
		if(strcmp(argv[1], "--help") = 0 orelse strcmp(argv[1], "-h") = 0)  then
			dim as zstring * MAX_PATH Temp
			GetFileName(argv[0], Temp)
			printf(!"Prototype:\n %s [options]\n\nOptions:\n -a, --about\tDisplay program information\n -h, --help\tThis message\n", Temp)
			return EXIT_SUCCESS
		end if

		if( strcmp(argv[1], "--about") = 0 orelse strcmp(argv[1], "-a") = 0) then
			printf("%s", zProgram.Title)
			#ifdef __FB_DEBUG__
			printf(" (Debug build)")
			#endif
			printf(!"\n")
			return EXIT_SUCCESS
		end if
	end if
 
 MSK_Init(zProgram.Title)
 sprintf(Temp, !"%s//log.txt", zProgram.AppPath)
 
 MSK_InitLogging(Temp)
 MSK_SetValidCharacters(!"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789.,:\\/\"-()[]_!")
 cn_InitCommands()
 
	#ifdef WIN32
	dbgprintf(0, MSK_COLORTYPE_INFO, APPTITLE !" launched, running on 32/64-bit Windows...\n") 
	#else
	dbgprintf(0, MSK_COLORTYPE_INFO, APPTITLE !" launched, running on non-Windows OS...\n") 
	#endif
	dbgprintf(0, MSK_COLORTYPE_INFO, !"\n") 
	
	zProgram.WindowWidth = WINDOW_WIDTH
        zProgram.WindowHeight = WINDOW_HEIGHT
 
 	if oz_InitProgram(zProgram.Title, zProgram.WindowWidth,  zProgram.WindowHeight)  then 
 	   die(EXIT_FAILURE)
  
  

 	end if
 	 	
 
  
 	 '// init HUD system
	if(hud_Init()) then
		MSK_ConsolePrint(MSK_COLORTYPE_ERROR,!"- Error: Failed to initialize HUD system!\n")
		die(EXIT_FAILURE)
	 else  
		hudMenu_Init()
	end if
 
  
 		
 	RDP_SetupOpenGL()
	'RDP_SetRendererOptions(BRDP_TEXTURES or BRDP_COMBINER or BRDP_TEXCRC /' or BRDP_WIREFRAME'/ )	
 	dl_ViewerInit(F3DEX2)
 	
 	gl_SetupScene3D(zProgram.WindowWidth, zProgram.WindowHeight)
 	
 	gl_CreateViewerDLists()
 	
 	zProgram.ScaleFactor = 0.1f
	zProgram.DListCount = -1
	zProgram.DListSel = -1

	zOptions.EnableHUD = _true
	zOptions.EnableGrid = _true
	
	
	ca_Reset()
 	
 	'// get the program to run
 	zProgram.IsRunning = true

 	dim _start as integer 
 
 	do while zProgram.IsRunning
		'// let the API do whatever it needs to
		
	 
			 
		
		select case oz_APIMain()  
			'// API's done...
			case EXIT_SUCCESS 
			
				'// all clear, let MISAKA do her stuff
				
				'temporary fix
				if zProgram.IsRunning = false then  exit do
				
				zProgram.IsRunning = MSK_DoEvents()

				'// let OpenGL do the rendering
			 
				 gl_DrawScene()
				 
		                '// FPS calculation!
				zProgram.Frames  +=   1
				
			 
				if (clock() - zProgram.LastTime) >= 1000 then
			 
					zProgram.LastTime = clock() 
					zProgram.LastFPS = zProgram.Frames
					zProgram.Frames = 0 
 
				end if
				
			
		              if(gl_FinishScene()) then  die(EXIT_FAILURE) 

				'// calculate camera speed
				zCamera.CamSpeed = ScaleRange(zProgram.ScaleFactor, 0.0005f, 1.0f, 1.0f, 10.0f) * 7.5f
				
				
			
			
			
		
			 

			'// API's not done, so do nothing here...
			case -1  
			 

			'// ouch, something bad happened with the API, terminating now...
			case EXIT_FAILURE
			 
				 die(EXIT_FAILURE) 
		end select
	loop

 
 	
 	
 	if(oz_ExitProgram()) then die(EXIT_FAILURE)
 
	  die(EXIT_SUCCESS)
 
 

	return EXIT_FAILURE
 
 
end function





function main3(argc as integer, argv as zstring ptr ptr) as integer
 
 	
 	if oz_InitProgram(zProgram.Title, zProgram.WindowWidth, zProgram.WindowHeight)  then 
 	   die(EXIT_FAILURE)
  
  

 	end if
 	
      
  
  

 	zProgram.IsRunning = true
 	do while zProgram.IsRunning
 	gl_DrawScene2
 		   glEnable(GL_DEPTH_TEST)
		gl_FinishScene
	
	loop

 
 	
 	
 	if(oz_ExitProgram()) then die(EXIT_FAILURE)
 
	  die(EXIT_SUCCESS)
 
 

	return EXIT_FAILURE
 	
	'do while (XNextEvent(dpy, @event) = 0)
	 
	
	'loop
 
end function













function  ScaleRange( in as double , oldMin as double ,  oldMax as double, newMin  as double, newMax  as double) as double
return (in / ((oldMax - oldMin) / (newMax - newMin))) + newMin
end function



sub die(code as integer)
 
	'// clear out HUD stuff
	hud_KillFont()

	dbgprintf(0, MSK_COLORTYPE_INFO, !"\n")

	'// determine if program exited normally or not
	if(Code = EXIT_SUCCESS) then
		dbgprintf(0, MSK_COLORTYPE_INFO, !"Program terminated normally.\n")
	else
		dbgprintf(0, MSK_COLORTYPE_ERROR, !"Program terminated abnormally, error code %i.\n", Code)
	end if
	
	dbgprintf(0, MSK_COLORTYPE_INFO, !"\n")
	dbgprintf(0, MSK_COLORTYPE_INFO, !"Press any key to continue...\n")

	'// one more MISAKA update
	MSK_DoEvents()

	'// wait for keypress, then shut down MISAKA and exit
	
	do while getch() = 0 
	loop
	
	MSK_Exit()

	end code
end sub





end main(__FB_ARGC__,__FB_ARGV__)
