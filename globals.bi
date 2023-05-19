
#define APPTITLE		"FB_DLViewer"
#define _VERSION		"v0.0"


#define WINDOW_WIDTH	640
#define WINDOW_HEIGHT	480
 
 
 
 
 
#ifndef EXIT_FAILURE
	#define EXIT_FAILURE 1
#endif

#ifndef EXIT_SUCCESS
	#define EXIT_SUCCESS 0
#endif


' // ----------------------------------------

'enum { true = 1, false = 0 };

enum bool
_true = 1
_false = 0 
end enum



' #define _true 1
' #define _false 0 




 

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
#include "badrdp.bi"

 
#include "oz.bi"
#include "dlist.bi"
#include "draw.bi"
#include "hud.bi"
#include "hud_menu.bi"
#include "mouse.bi"
#include "camera.bi"
#include "confunc.bi"

'////////////////////////////////////////////////////////////////
'// ----------------------------------------

  #define Read16(Buffer, Offset) _
	(Buffer[Offset] shl 8) or Buffer[(Offset) + 1]

#define Read32(Buffer, Offset) _
	(Buffer[Offset] shl 24) or (Buffer[(Offset) + 1] shl 16) or (Buffer[(Offset) + 2] shl 8) or Buffer[(Offset) + 3]

#define Write16(Buffer, Offset, Value)  _
	Buffer[Offset] = (Value and &HFF00) shr 8 _
	Buffer[Offset + 1] = (Value and &H00FF)

#define Write32(Buffer, Offset, Value)  _
	Buffer[Offset] = (Value1 and &HFF000000) shr 24 _
	Buffer[Offset + 1] = (Value1 and &H00FF0000) shr 16 _
	Buffer[Offset + 2] = (Value1 and &H0000FF00) shr 8 _
	Buffer[Offset + 3] = (Value1 and &H000000FF) _

#define Write64(Buffer, Offset, Value1, Value2) _ 
	Buffer[Offset] = (Value1 and &HFF000000) shr 24 _
	Buffer[Offset + 1] = (Value1 and &H00FF0000) shr 16 _
	Buffer[Offset + 2] = (Value1 and &H0000FF00) shr 8 _
	Buffer[Offset + 3] = (Value1 and &H000000FF) _
	Buffer[Offset + 4] = (Value2 and &HFF000000) shr 24 _
	Buffer[Offset + 5] = (Value2 and &H00FF0000) shr 16 _
	Buffer[Offset + 6] = (Value2 and &H0000FF00) shr 8 _
	Buffer[Offset + 7] = (Value2 and &H000000FF)

 
 
 
  #define _SHIFTR( v, s, w ) _
    ((cast(ulong,v) shr ((&H01 shl w) - 1))
 
 
 
 #define _SHIFTL( v, s, w ) _
    ((cast(ulong,v) and ((&H01 shl w) - 1)) shl s)
    
 #define ArraySize(x)	ubound(x)  + 1
 
 #ifndef min
#define min(a, b)				iif(a < b, a, b)
#endif



#define GetPaddingSize(Filesize, Factor) _
	(((Filesize / Factor) + 1) * Factor) - Filesize

 
 

'// ----------------------------------------

 

'// ----------------------------------------

type  __zOptions 
	as integer DebugLevel 
	as bool EnableHUD 
	as bool EnableGrid 
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

extern as zstring ptr UCodeNames(2)

declare function DoMainKbdInput() as integer
declare  function  ScaleRange( in as double , oldMin as double ,  oldMax as double, newMin  as double, newMax  as double) as double
declare sub GetFilePath( FullPath as zstring ptr, Target as zstring ptr) 
declare sub  GetFileName( FullPath as zstring ptr, Target as zstring ptr) 
 'inline macro maybe?
declare sub dbgprintf cdecl (Level as integer , _Type as integer,  _Format as zstring ptr, ...)
 

declare sub gl_DrawScene2()
declare sub gl_SetupScene3D2(W as integer,H as integer)
