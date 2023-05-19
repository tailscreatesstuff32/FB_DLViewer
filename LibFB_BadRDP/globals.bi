 


#include "crt/stdio.bi"
#include "crt/stdlib.bi"
#include "crt/string.bi"
#include "crt/math.bi"
#include "crt/stdarg.bi"
#include "crt/time.bi"
#include "GL/gl.bi"
#include "GL/glx.bi"
#include "GL/glext.bi"



#ifdef WIN32
#include "windows.bi"
#else
#include "GL/glx.bi"
#include "X11/X.bi"
#include "crt/limits.bi"
#define MAX_PATH	PATH_MAX
#endif

#include "png.bi"


#include "badrdp.bi"

#include "opengl.bi"
#include "dlparse.bi"
