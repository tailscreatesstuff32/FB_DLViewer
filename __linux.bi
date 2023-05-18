


#include "crt/sys/stat.bi"
'#include <GL/glx.h>
#include "X11/X.bi"
#include "X11/Xlib.bi"
#include "X11/Xutil.bi"
#include "X11/keysym.bi"
#include "crt/limits.bi"


#define MAX_PATH	PATH_MAX

#define FILESEP asc(!"/")


#define KEY_CAMERA_UP				XK_w_
#define KEY_CAMERA_DOWN				XK_s_
#define KEY_CAMERA_LEFT				XK_a_
#define KEY_CAMERA_RIGHT			XK_d_
#define KEY_GUI_TOGGLEGRID			XK_g_ and &HFF
'XK_F11 and &HFF
#define KEY_GUI_TOGGLEHUD			XK_h_ and &HFF
'XK_F12 and &HFF
#define KEY_DLIST_NEXTLIST			XK_KP_Add and &HFF
#define KEY_DLIST_PREVLIST			XK_KP_Subtract and &HFF


 #inclib "X11"




declare function XInit(WndTitle as zstring ptr, w as integer, h as integer) as integer
declare function XInit2(WndTitle as zstring ptr, w as integer, h as integer) as integer
 
declare function XMain() as integer
declare function XExit() as integer 
declare function XSetWindowTitle(WndTitle as zstring ptr)  as integer

extern  dpy as Display ptr
extern win as Window 

extern vi as XVisualInfo ptr 
extern cmap  as Colormap 
extern swa as XSetWindowAttributes 
'extern GLXContext cx;
extern event as  XEvent 
