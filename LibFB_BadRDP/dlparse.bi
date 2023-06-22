Type RDPInstruction As sub()
extern as  RDPInstruction RDP_UcodeCmd(256)

Extern DListAddress As Uinteger
'Extern Segment As UByte
'Extern Offset As Uinteger

Extern w0 As Uinteger, w1 As Uinteger
Extern wp0 As Uinteger, wp1 As Uinteger
Extern wn0 As Uinteger, wn1 As Uinteger

Extern isMacro As Boolean
Extern do_arb As Boolean

Extern G_TEXTURE_ENABLE As Uinteger
Extern G_SHADING_SMOOTH As Uinteger
Extern G_CULL_FRONT As Uinteger
Extern G_CULL_BACK As Uinteger
Extern G_CULL_BOTH As Uinteger
Extern G_CLIPPING As Uinteger

Extern G_MTX_STACKSIZE As Uinteger
Extern G_MTX_MODELVIEW As Uinteger
Extern G_MTX_PROJECTION As Uinteger
Extern G_MTX_MUL As Uinteger
Extern G_MTX_LOAD As Uinteger
Extern G_MTX_NOPUSH As Uinteger
Extern G_MTX_PUSH As Uinteger


#define RDP_InitFlags(Ucode) _
	G_TEXTURE_ENABLE	= Ucode##_TEXTURE_ENABLE: _
	G_SHADING_SMOOTH	= Ucode##_SHADING_SMOOTH: _
	G_CULL_FRONT		= Ucode##_CULL_FRONT: _
	G_CULL_BACK			= Ucode##_CULL_BACK: _
	G_CULL_BOTH			= Ucode##_CULL_BOTH: _
	G_CLIPPING			= Ucode##_CLIPPING: _
 _
	G_MTX_STACKSIZE		= Ucode##_MTX_STACKSIZE: _
	G_MTX_MODELVIEW		= Ucode##_MTX_MODELVIEW: _
	G_MTX_PROJECTION	= Ucode##_MTX_PROJECTION: _
	G_MTX_MUL			= Ucode##_MTX_MUL: _
	G_MTX_LOAD			= Ucode##_MTX_LOAD: _
	G_MTX_NOPUSH		= Ucode##_MTX_NOPUSH: _
	G_MTX_PUSH			= Ucode##_MTX_PUSH

Declare Sub RDP_DrawTriangle(Vtxs As integer Ptr)
Declare Sub RDP_UpdateGeometryMode()
Declare Sub RDP_SetRenderMode(Mode1 As Uinteger, Mode2 As Uinteger)
Declare Sub RDP_ChangeTileSize(Tile As Uinteger, ULS As Uinteger, ULT As Uinteger, LRS As Uinteger, LRT As Uinteger)
Declare Sub RDP_CalcTextureSize(TextureID As integer)
Declare Function RDP_Pow2(_dim As Uinteger) As Uinteger
Declare Function RDP_PowOf(_dim As Uinteger) As Uinteger
Declare Sub RDP_InitLoadTexture()
Declare Function RDP_CheckTextureCache(TexID As Uinteger) As GLuint
Declare Function RDP_LoadTexture(TextureID As integer) As GLuint


#define CHANGED_GEOMETRYMODE	&H01
#define CHANGED_RENDERMODE		&H02
#define CHANGED_ALPHACOMPARE	&H04
#define CHANGED_MULT_MAT		&H08

