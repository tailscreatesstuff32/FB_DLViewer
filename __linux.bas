

#include "globals.bi"



#ifndef FB_WIN32
static shared as GLint  snglBuf(0 to ...) => {GLX_RGBA, GLX_DEPTH_SIZE, 16, None}
static shared as GLint  dblBuf(0 to ...)  =>  { GLX_RGBA, GLX_DEPTH_SIZE, 16, GLX_DOUBLEBUFFER, None }

dim shared as Display ptr dpy 
dim shared as Window win

dim shared as XVisualInfo ptr vi

dim shared as Colormap cmap
dim shared as XSetWindowAttributes swa
dim shared as GLXContext cx 
dim shared as XEvent event 

dim shared as integer dummy 

static shared scr as integer
static shared root as display ptr



dim shared  as GLint                   att(0 to ...) => { GLX_RGBA, GLX_DEPTH_SIZE, 16, GLX_DOUBLEBUFFER, None }




function XInit2(WndTitle as zstring ptr, _width as integer,_height as integer) as integer
	dpy = XOpenDisplay(NULL)



	if dpy = null then
	
	dbgprintf(0, MSK_COLORTYPE_ERROR, !"- Error: Could not open display\n")
 
	 return EXIT_FAILURE
	end if


	 if( glXQueryExtension(dpy, @dummy, @dummy) = 0 ) then
		dbgprintf(0, MSK_COLORTYPE_ERROR, !"- Error: X server has no OpenGL GLX extension\n")
		return EXIT_FAILURE 
	end if

	  vi = glXChooseVisual(dpy, DefaultScreen(dpy), @dblBuf(0))
	 if (vi = NULL)  then
		vi = glXChooseVisual(dpy, DefaultScreen(dpy), @snglBuf(0))
		if (vi = NULL) then
			dbgprintf(0, MSK_COLORTYPE_ERROR, !"- Error: No RGB visual with depth buffer\n") 
			return EXIT_FAILURE 
		end if
	 end if
	 if(vi->class <> TrueColor) then
		dbgprintf(0, MSK_COLORTYPE_ERROR, !"- Error: TrueColor visual required for this program\n")
		return EXIT_FAILURE
	end if

	cx = glXCreateContext(dpy, vi, None, GL_TRUE)
	if (cx = NULL)  then
		dbgprintf(0, MSK_COLORTYPE_ERROR, !"- Error: Could not create rendering context\n")
		return EXIT_FAILURE
	end if 

	 cmap = XCreateColormap(dpy, RootWindow(dpy, vi->screen), vi->visual, AllocNone)
         swa.colormap = cmap
         swa.border_pixel = 0
         swa.event_mask = KeyPressMask or ExposureMask or ButtonPressMask or StructureNotifyMask
         win = XCreateWindow(dpy, RootWindow(dpy, vi->screen), 0, 0, _Width, _Height, 0, vi->depth, InputOutput, vi->visual, CWBorderPixel or CWColormap or CWEventMask, @swa)
         XSetStandardProperties(dpy, win, WndTitle, WndTitle, None, NULL, 0, NULL)
      
         glXMakeCurrent(dpy, win, cx)
      
         XMapWindow(dpy, win)

         XSelectInput(dpy, win, ExposureMask or KeyPressMask or KeyReleaseMask or ButtonPressMask or Button1MotionMask or StructureNotifyMask)
        
	 return EXIT_SUCCESS



                      '   scr = DefaultScreen(dpy)
	'root = RootWindow(dpy, scr)
        
        
       ' win = XCreateSimpleWindow(dpy, root,500,500,_Width, _Height,15,BlackPixel(dpy,scr),WhitePixel(dpy,scr) )
	
    '  glXMakeCurrent(dpy, win, cx)

       '  XMapWindow(dpy,win)

end function






function XInit(WndTitle as zstring ptr, _width as integer,_height as integer) as integer
 


 dpy = XOpenDisplay(NULL)    
 root = DefaultRootWindow(dpy)
  vi = glXChooseVisual(dpy,0, @dblbuf(0))
 cmap = XCreateColormap(dpy, root, vi->visual, AllocNone)
 swa.colormap = cmap
 swa.event_mask = ExposureMask or KeyPressMask
 'win = XCreateWindow(dpy, root, 0, 0, 600, 600, 0, vi->depth, InputOutput, vi->visual, CWColormap or CWEventMask, @swa)
 
 win = XCreateWindow(dpy, root, 0, 0, _width, _height, 0, vi->depth, InputOutput, vi->visual, CWColormap or CWEventMask, @swa)
 
 
 
 XMapWindow(dpy, win)
 
cx = glXCreateContext(dpy, vi, NULL, GL_TRUE)
 glXMakeCurrent(dpy, win, cx)
 
	 return EXIT_SUCCESS
end function

/'function XInit(WndTitle as zstring ptr, _width as integer,_height as integer) as integer
 


 dpy = XOpenDisplay(NULL)    
 root = DefaultRootWindow(dpy)
 vi = glXChooseVisual(dpy, 0, @att(0))
 cmap = XCreateColormap(dpy, root, vi->visual, AllocNone)
 swa.colormap = cmap
 swa.event_mask = ExposureMask or KeyPressMask
 'win = XCreateWindow(dpy, root, 0, 0, 600, 600, 0, vi->depth, InputOutput, vi->visual, CWColormap or CWEventMask, @swa)
 
 win = XCreateWindow(dpy, root, 0, 0, _width, _height, 0, vi->depth, InputOutput, vi->visual, CWColormap or CWEventMask, @swa)
 
 
 
 XMapWindow(dpy, win)
 XStoreName(dpy, win, "VERY SIMPLE APPLICATION")
cx = glXCreateContext(dpy, vi, NULL, GL_TRUE)
 glXMakeCurrent(dpy, win, cx)
 
	 return EXIT_SUCCESS
end function '/









function XMain() as integer
 
 
	do while(XPending(dpy) > 0) 
		XNextEvent(dpy, @event)
		select case (event.type)  
			case Expose 
				XFlush(dpy) 
			 
		       case KeyPress 
		       
		       
				dim as KeySym     keysym1
				dim as  XKeyEvent ptr kevent
				dim as byte       buffer(1)
				kevent = cast(XKeyEvent ptr, @event) 
				if((XLookupString(cast(XKeyEvent ptr,@event),@buffer(0),1,@keysym1,NULL)  = 1) andalso  keysym1  = cast(KeySym,XK_Escape)) then
				 
				zProgram.IsRunning = false
				end if
				
				 
				 
				zProgram._Key(keysym1 and &HFF) = true
		 
			  case KeyRelease 
		 
				dim as KeySym     keysym
				dim as byte       buffer(1)
				XLookupString(cast(XKeyEvent ptr,@event),@buffer(0),1,@keysym,NULL) 
				zProgram._Key(keysym and &HFF) = false
				

			 case ButtonPress 
				zProgram.MouseCenterX = event.xbutton.x 
				zProgram.MouseCenterY = event.xbutton.y 
				 

			   case MotionNotify 
				if (event.xmotion.state and Button1Mask)  then
					zProgram.MousePosX = event.xbutton.x
					zProgram.MousePosY = event.xbutton.y
					ca_MouseMove(zProgram.MousePosX, zProgram.MousePosY)
					ca_Orientation(zCamera.AngleX, zCamera.AngleY)
				end if
			 

			case ConfigureNotify 
				zProgram.WindowWidth = event.xconfigure.width
				zProgram.WindowHeight = event.xconfigure.height
				gl_SetupScene3D(zProgram.WindowWidth, zProgram.WindowHeight)
			
				 
		end select
loop

	 
	return DoMainKbdInput()
 

end function






function XMain2() as integer
 
 
	do while(XPending(dpy) > 0) 
		XNextEvent(dpy, @event)
		select case (event.type)  
			case Expose 
				XFlush(dpy) 
			 
		       case KeyPress 
		       
		       
				dim as KeySym     keysym
				dim as  XKeyEvent ptr kevent
				dim as byte       buffer(1)
				kevent = cast(XKeyEvent ptr, @event) 
				if((XLookupString(cast(XKeyEvent ptr,@event),@buffer(0),1,@keysym,NULL)  = 1) andalso  keysym  = cast(KeySym,XK_Escape)) then
				 
				zProgram.IsRunning = false
				end if
				
				
				
				zProgram._Key(keysym and &HFF) = true
		 
			  case KeyRelease 
		 
				dim as KeySym     keysym
				dim as byte       buffer(1)
				XLookupString(cast(XKeyEvent ptr,@event),@buffer(0),1,@keysym,NULL) 
				zProgram._Key(keysym and &HFF) = false
				

			 case ButtonPress 
				zProgram.MouseCenterX = event.xbutton.x 
				zProgram.MouseCenterY = event.xbutton.y 
				 

			   case MotionNotify 
				if (event.xmotion.state and Button1Mask)  then
					zProgram.MousePosX = event.xbutton.x
					zProgram.MousePosY = event.xbutton.y
					ca_MouseMove(zProgram.MousePosX, zProgram.MousePosY)
					ca_Orientation(zCamera.AngleX, zCamera.AngleY)
				end if
			 

			case ConfigureNotify 
				zProgram.WindowWidth = event.xconfigure.width
				zProgram.WindowHeight = event.xconfigure.height
				gl_SetupScene3D(zProgram.WindowWidth, zProgram.WindowHeight)
			
				 
		end select
loop

	 
	return DoMainKbdInput()
 

end function


 
	
	
	
	
function XExit() as integer
 
	glXMakeCurrent(dpy, None, NULL)
	glXDestroyContext(dpy, cx)
	XDestroyWindow(dpy, win)
	XCloseDisplay(dpy)

	return EXIT_SUCCESS
end function

function XSetWindowTitle(WndTitle as zstring ptr ) as integer
 
	XSetStandardProperties(dpy, win, WndTitle, WndTitle, None, NULL, 0, NULL)

	return EXIT_SUCCESS
end function

#endif
