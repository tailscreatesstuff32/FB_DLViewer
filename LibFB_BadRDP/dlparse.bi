#define RDP_InitFlags(Ucode) _
	G_TEXTURE_ENABLE	= Ucode##_TEXTURE_ENABLE _
	G_SHADING_SMOOTH	= Ucode##_SHADING_SMOOTH _
	G_CULL_FRONT		= Ucode##_CULL_FRONT _
	G_CULL_BACK			= Ucode##_CULL_BACK _
	G_CULL_BOTH			= Ucode##_CULL_BOTH _
	G_CLIPPING			= Ucode##_CLIPPING _
 _
	G_MTX_STACKSIZE		= Ucode##_MTX_STACKSIZE _
	G_MTX_MODELVIEW		= Ucode##_MTX_MODELVIEW _
	G_MTX_PROJECTION	= Ucode##_MTX_PROJECTION _
	G_MTX_MUL			= Ucode##_MTX_MUL _
	G_MTX_LOAD			= Ucode##_MTX_LOAD _
	G_MTX_NOPUSH		= Ucode##_MTX_NOPUSH _
	G_MTX_PUSH			= Ucode##_MTX_PUSH

Extern DListAddress As UInteger
'Extern Segment As UByte
'Extern Offset As UInteger

Extern w0 As UInteger, w1 As UInteger
Extern wp0 As UInteger, wp1 As UInteger
Extern wn0 As UInteger, wn1 As UInteger

Extern isMacro As Boolean
Extern do_arb As Boolean




#define CHANGED_GEOMETRYMODE	&H01
#define CHANGED_RENDERMODE		&H02
#define CHANGED_ALPHACOMPARE	&H04
#define CHANGED_MULT_MAT		&H08

Extern G_TEXTURE_ENABLE As UInteger
Extern G_SHADING_SMOOTH As UInteger
Extern G_CULL_FRONT As UInteger
Extern G_CULL_BACK As UInteger
Extern G_CULL_BOTH As UInteger
Extern G_CLIPPING As UInteger

Extern G_MTX_STACKSIZE As UInteger
Extern G_MTX_MODELVIEW As UInteger
Extern G_MTX_PROJECTION As UInteger
Extern G_MTX_MUL As UInteger
Extern G_MTX_LOAD As UInteger
Extern G_MTX_NOPUSH As UInteger
Extern G_MTX_PUSH As UInteger



Type RDPInstruction As sub()
extern as  RDPInstruction RDP_UcodeCmd(256)


Declare Sub RDP_DrawTriangle(Vtxs As Integer Ptr)
Declare Sub RDP_UpdateGeometryMode()
Declare Sub RDP_SetRenderMode(Mode1 As UInteger, Mode2 As UInteger)
Declare Sub RDP_ChangeTileSize(Tile As UInteger, ULS As UInteger, ULT As UInteger, LRS As UInteger, LRT As UInteger)
Declare Sub RDP_CalcTextureSize(TextureID As Integer)
Declare Function RDP_Pow2(dim As ULong) As ULong
Declare Function RDP_PowOf(dim As ULong) As ULong
Declare Sub RDP_InitLoadTexture()
Declare Function RDP_CheckTextureCache(TexID As UInteger) As GLuint
Declare Function RDP_LoadTexture(TextureID As Integer) As GLuint
