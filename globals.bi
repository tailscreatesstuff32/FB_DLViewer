 
#ifndef EXIT_FAILURE
	#define EXIT_FAILURE 1
#endif

#ifndef EXIT_SUCCESS
	#define EXIT_SUCCESS 0
#endif


' // ----------------------------------------

'enum { true = 1, false = 0 };

enum _bool
_true = 1
_false = 0 
end enum



' #define _true 1
' #define _false 0 


#define ArraySize(x)	ubound(x)


#ifndef min
#define min(a, b)			iif(a < b,a,b) 
#endif

#define GetPaddingSize(Filesize, Factor) _
	(((Filesize / Factor) + 1) * Factor) - Filesize

'// ----------------------------------------


type __Vect3D
	as short X
	as short Y
	as short Z
end type
 
 
 
  #ifdef FB_WIN32
#include "__win32.bi"
#else
#include "__linux.bi"
#endif



#include "crt/stdio.bi"
#include "crt/stdlib.bi"
#include "crt/string.bi"
#include "crt/math.bi"
#include "crt/stdarg.bi"
#include "crt/time.bi"
#include "GL/gl.bi"
#include "GL/glx.bi"
#include "GL/glext.bi"

#include "png.bi"
#include "curses/ncurses.bi"

#include "misaka.bi"

#include "oz.bi"
#include "dlist.bi"
#include "draw.bi"
#include "hud.bi"
#include "camera.bi"
#include "confunc.bi"

'////////////////////////////////////////////////////////////////
'// ----------------------------------------

/' #define Read16(Buffer, Offset) \
	(Buffer[Offset] << 8) | Buffer[(Offset) + 1]

#define Read32(Buffer, Offset) \
	(Buffer[Offset] << 24) | (Buffer[(Offset) + 1] << 16) | (Buffer[(Offset) + 2] << 8) | Buffer[(Offset) + 3]

#define Write16(Buffer, Offset, Value) \
	Buffer[Offset] = (Value & 0xFF00) >> 8; \
	Buffer[Offset + 1] = (Value & 0x00FF);

#define Write32(Buffer, Offset, Value) \
	Buffer[Offset] = (Value & 0xFF000000) >> 24; \
	Buffer[Offset + 1] = (Value & 0x00FF0000) >> 16; \
	Buffer[Offset + 2] = (Value & 0x0000FF00) >> 8; \
	Buffer[Offset + 3] = (Value & 0x000000FF);

#define Write64(Buffer, Offset, Value1, Value2) \
	Buffer[Offset] = (Value1 & 0xFF000000) >> 24; \
	Buffer[Offset + 1] = (Value1 & 0x00FF0000) >> 16; \
	Buffer[Offset + 2] = (Value1 & 0x0000FF00) >> 8; \
	Buffer[Offset + 3] = (Value1 & 0x000000FF); \
	Buffer[Offset + 4] = (Value2 & 0xFF000000) >> 24; \
	Buffer[Offset + 5] = (Value2 & 0x00FF0000) >> 16; \
	Buffer[Offset + 6] = (Value2 & 0x0000FF00) >> 8; \
	Buffer[Offset + 7] = (Value2 & 0x000000FF); '/

 
 
 
  #define _SHIFTR( v, s, w ) _
    ((cast(ulong,v) shr ((&H01 shl w) - 1))
 
 
 
 #define _SHIFTL( v, s, w ) _
    ((cast(ulong,v) and ((&H01 shl w) - 1)) shl s)
 

'// ----------------------------------------

 

'// ----------------------------------------

type  __zOptions 
	as integer DebugLevel 
	as boolean EnableHUD 
	as boolean EnableGrid 
end type 

type __zCamera 
	as double AngleX 
	as double AngleY 
	as double X
	as double Y 
	as double Z 
	as double LX 
	as double LY 
	as double LZ 
	as double CamSpeed 
end type 
'double  LastTime 
 type __zProgram
	as boolean IsRunning
	as boolean _key(256)
	
	as integer windowwidth
	as integer windowheight	
	as integer HandleAbout
	
	as single LastTime  
	as integer Frames 
	as integer LastFPS
	
	as integer LastTime2 
	as integer Frames2 
	as integer LastFPS2
	
	
	
        as integer MousePosX 
        as integer MousePosY 
	as integer MouseCenterX
	as integer MouseCenterY 
	as boolean MouseButtonLDown 
	as boolean MouseButtonRDown 
	
	
	as __Vect3D SceneCoords

         as zstring * 256 Title
        as zstring * 256 WndTitle 
	as zstring * MAX_PATH AppPath
	
	
	
	as GLuint GLAxisMarker
	as GLuint GLGrid
	
	as double  ScaleFactor
	as uinteger UCode

	as GLuint DListGL(2048)
	as uinteger DListAddr(2048)
	as integer DListCount
	as integer DListSel
 end type 

'////////////////////////////////////////////////////////////////

declare sub DrawAQuad() 

'// ----------------------------------------

extern as __zProgram zProgram
extern as __zOptions zOptions

extern as __zCamera zCamera

'// ----------------------------------------

enum UcodeIDs  
F3D, 
F3DEX, 
F3DEX2 
end enum

extern as UcodeIDs _UcodeIDs

extern as zstring ptr UCodeName(2)

declare function DoMainKbdInput() as integer
declare  function  ScaleRange( in as double , oldMin as double ,  oldMax as double, newMin  as double, newMax  as double) as double
declare sub GetFilePath( FullPath as zstring ptr, Target as zstring ptr) 
declare sub  GetFileName( FullPath as zstring ptr, Target as zstring ptr) 
 'inline macro maybe?
declare sub dbgprintf cdecl (Level as integer , _Type as integer,  _Format as zstring ptr, ...)
 

declare sub gl_DrawScene2()
declare sub gl_SetupScene3D2(W as integer,H as integer)
