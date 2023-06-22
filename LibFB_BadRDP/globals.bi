 


#include "crt/stdio.bi"
#include "crt/stdlib.bi"
#include "crt/string.bi"
#include "crt/stdint.bi"
#include "crt/math.bi"
#include "crt/stdarg.bi"
#include "crt/time.bi"
#include "GL/gl.bi"
#include "GL/glx.bi"
#include "GL/mesa/glext.bi"

 

#ifdef WIN32
#include "windows.bi"
#else
#include "GL/glx.bi"
#include "X11/X.bi"
#include "crt/limits.bi"
#define MAX_PATH	PATH_MAX
#endif

#include "png12.bi"



#ifndef EXIT_FAILURE
#define EXIT_FAILURE 1

#endif

extern "c"
Declare Function strdup (ByVal source As const zString ptr) As  zString ptr
end extern

type as ubyte bool
enum _bool
  _true = 1, _false = 0 
end enum

union u
    as ulong ul
    as single f
end union



#define CACHE_TEXTURES		4096
#define CACHE_FRAGMENT		1024


#ifdef WIN32
extern as PFNGLMULTITEXCOORD1FARBPROC			glMultiTexCoord1fARB
extern as PFNGLMULTITEXCOORD2FARBPROC			glMultiTexCoord2fARB
extern as PFNGLMULTITEXCOORD3FARBPROC			glMultiTexCoord3fARB
extern as PFNGLMULTITEXCOORD4FARBPROC			glMultiTexCoord4fARB
extern as PFNGLACTIVETEXTUREARBPROC		        glActiveTextureARB
extern as PFNGLCLIENTACTIVETEXTUREARBPROC		glClientActiveTextureARB
#endif /' WIN32 '/

extern as PFNGLGENPROGRAMSARBPROC				glGenProgramsARB
extern as PFNGLBINDPROGRAMARBPROC				glBindProgramARB
extern as PFNGLDELETEPROGRAMSARBPROC			glDeleteProgramsARB
extern as PFNGLPROGRAMSTRINGARBPROC			glProgramStringARB
extern as PFNGLPROGRAMENVPARAMETER4FARBPROC	glProgramEnvParameter4fARB
extern as PFNGLPROGRAMLOCALPARAMETER4FARBPROC	glProgramLocalParameter4fARB



 
 #define _SHIFTL( v, s, w ) _
    ((cast(ulong,v) and ((&H01 shl w) - 1)) shl s)
    	
  #define _SHIFTR( v, s, w ) _
    ((cast(ulong,v)shr s) and ((&H01 shl w) - 1))
 
 

declare Function IsInfinite(value As Double) As Boolean

'declare Function IsNan1(value As Double) As Boolean

extern "c"
declare function __isnan (byval _x as double) as long
end extern

#define FIXED2FLOATRECIP1	0.5f
#define FIXED2FLOATRECIP2	0.25f
#define FIXED2FLOATRECIP3	0.125f
#define FIXED2FLOATRECIP4	0.0625f
#define FIXED2FLOATRECIP5	0.03125f
#define FIXED2FLOATRECIP6	0.015625f
#define FIXED2FLOATRECIP7	0.0078125f
#define FIXED2FLOATRECIP8	0.00390625f
#define FIXED2FLOATRECIP9	0.001953125f
#define FIXED2FLOATRECIP10	0.0009765625f
#define FIXED2FLOATRECIP11	0.00048828125f
#define FIXED2FLOATRECIP12	0.00024414063f
#define FIXED2FLOATRECIP13	0.00012207031f
#define FIXED2FLOATRECIP14	6.1035156e-05f
#define FIXED2FLOATRECIP15	3.0517578e-05f
#define FIXED2FLOATRECIP16	1.5258789e-05f

 #define _FIXED2FLOAT( v, b ) _
	(cast(single,v) * FIXED2FLOATRECIP##b)
	

   #define Read16(Buffer, Offset) _
	(Buffer[Offset] shl 8) or Buffer[(Offset) + 1]
 
 #define Read32(Buffer, Offset) _
	(Buffer[Offset] shl 24) or (Buffer[(Offset) + 1] shl 16) or (Buffer[(Offset) + 2] shl 8) or Buffer[(Offset) + 3]
	
#define Write32(Buffer, Offset, Value1)  _
	Buffer[Offset] = (Value1 and &HFF000000) shr 24: _
	Buffer[Offset + 1] = (Value1 and &H00FF0000) shr 16: _
	Buffer[Offset + 2] = (Value1 and &H0000FF00) shr 8: _
	Buffer[Offset + 3] = (Value1 and &H000000FF)

    
#ifndef isnan
#define isnan(x) ((x) <> (x))
#endif
    extern "c"
Declare Function isinf (_value As Single) As Integer
end extern

    
 #define ArraySize(x)	ubound(x)  + 1
 


type __System
    DrawWidth as long
    DrawHeight as long

    FragCachePosition as ulong
    TextureCachePosition as ulong

    ObjDumpingEnabled as boolean
    WavefrontObjPath as string * MAX_PATH
    FileWavefrontObj as FILE ptr
    FileWavefrontMtl as FILE ptr
    WavefrontObjVertCount as ulong
    WavefrontObjMaterialCnt as ulong

    Options as ubyte
end type

type __Matrix
	as single Comb(4,4)
	as single Model(4,4)
	as single Proj(4,4)
	as single ModelStack(32,4,4)
	as long ModelStackSize
	as long ModelIndex

	as boolean UseMatrixHack
end type

type __VtxRaw
	as short X
	as short Y
	as short Z
	as short W
	as short S
	as short T
	as ubyte R
	as ubyte G
	as ubyte B
	as ubyte A
end type  

type __Vertex
	as __VtxRaw Vtx
	as single RealS0
	as single RealT0
	as single RealS1
	as single RealT1
end type

type __Palette
	as ubyte R
	as ubyte G
	as ubyte B
	as ubyte A
end type

type __Texture
	as ulong Offset

	as ulong _Format
	as ulong Tile
	as ulong _Width
	as ulong RealWidth
	as ulong _Height
	as ulong RealHeight
	as ulong  ULT, ULS
	as ulong LRT, LRS
	as ulong LineSize, Palette
	as ulong MaskT, MaskS
	as ulong ShiftT, ShiftS
	union 
		type
			as ulong mirrort : 1
			as ulong clampt : 1
			as ulong pad0 : 30
			as ulong mirrors : 1
			as ulong clamps : 1
			as ulong pad1 : 30
		end type
		type
			as ulong CMT, CMS
		end type
	end union
	as single ScaleT, ScaleS
	as single ShiftScaleT, ShiftScaleS

	as boolean IsTexRect
	as ulong TexRectW
	as ulong TexRectH

	as ulong CRC32
end type

type __RGBA
	as single R
	as single G
	as single B
	as single A
end type
 
type __fillcolor
	as single R
	as single G
	as single B
	as single A
	as single Z
	as single DZ
end type


type __primcolor
	as single R
	as single G
	as single B
	as single A
	as single L
	as ushort M
end type




type __FragmentCache
	as ulong Combiner0
	as ulong Combiner1
	as GLuint ProgramID
end type

type __TextureCache 
	as ulong Offset
	as ulong RealWidth
	as ulong RealHeight
	as ulong CRC32
	as GLuint TextureID

	as long MaterialID
end type



type _othermode
  union
	   	type
	   	
	   			as ulong alphaCompare : 2 
	   			as ulong AAEnable : 1
				as ulong depthCompare : 1
				as ulong depthUpdate : 1
				as ulong imageRead : 1
				as ulong clearOnCvg : 1

				as ulong cvgDest : 2
				as ulong depthMode : 2

				as ulong cvgXAlpha : 1
				as ulong alphaCvgSel : 1
				as ulong forceBlender : 1
				as ulong textureEdge : 1

				as ulong c2_m2b : 2
				as ulong c1_m2b : 2
				as ulong c2_m2a : 2
				as ulong c1_m2a : 2
				as ulong c2_m1b : 2
				as ulong c1_m1b : 2
				as ulong c2_m1a : 2
				as ulong c1_m1a : 2

				as ulong blendMask : 4
				as ulong alphaDither : 2
				as ulong colorDither : 2

				as ulong combineKey : 1
				as ulong textureConvert : 3
				as ulong textureFilter : 2
				as ulong textureLUT : 2

				as ulong textureLOD : 1
				as ulong textureDetail : 2
				as ulong texturePersp : 1
				as ulong cycleType : 2
				as ulong pipelineMode : 1

				as ulong pad : 8

end type

	   	as uint64_t _u64 

			type
				as ulong L, H 
			end type

end union
end type


type __Gfx
public:
        as long DLStack(16)
	as long DLStackPos

	as ulong Update
	as ulong GeometryMode

	OtherMode as _OtherMode

	as GLfloat LightAmbient(4)
	as GLfloat LightDiffuse(4)
	as GLfloat LightSpecular(4)
	as GLfloat LightPosition(4)
	as ulong Store_RDPHalf1, Store_RDPHalf2
	as ulong Combiner0, Combiner1

	as __RGBA BlendColor
	as __RGBA EnvColor
	as __RGBA FogColor
	as __FillColor FillColor
	as __PrimColor PrimColor

	as boolean IsMultiTexture
	as long CurrentTexture

	as GLuint GLTextureID(CACHE_TEXTURES)
	as long GLTextureCount
	


end type

Type __OpenGL
    ExtensionList As ZString Ptr
    ExtSupported As ZString * 256
    ExtUnsupported As ZString * 256
    IsExtUnsupported As Boolean
    Ext_MultiTexture As Boolean
    Ext_TexMirroredRepeat As Boolean
    Ext_FragmentProgram As Boolean
End Type


extern as __System _System
extern as __Matrix Matrix
extern as __Palette _Palette(256)
extern as  __Vertex Vertex(32)
extern as __Texture Texture(2)
extern as __FragmentCache FragmentCache(CACHE_FRAGMENT)
extern as __TextureCache TextureCache(CACHE_TEXTURES)
extern as __Gfx Gfx
extern as __OpenGL OpenGL





#include "badrdp.bi"
#include "opengl.bi"
#include "dlparse.bi"
#include "gbi.bi"

#include "dump.bi"
#include "rdp.bi"
#include "macro.bi"
#include "f3dex.bi"
#include "f3d.bi"

#include "gdp.bi"
#include "gsp.bi"

#include "combine.bi"

 #include "matrix.bi"
/'#include "f3dex2.bi"

#include "crc.bi" '/

#ifndef max
  #define max(a, b)	iif(a > b,a,b)
#endif
#ifndef min
  #define min(a, b)	iif(a < b,a,b)
#endif



