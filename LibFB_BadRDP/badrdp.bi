#ifndef __BADRDP_H__
 #define __BADRDP_H__

#define MAX_SEGMENTS		16

Enum _RenderOpts
	BRDP_WIREFRAME = 1
	BRDP_TEXTURES = 1 SHL 1
	BRDP_COMBINER = 1 SHL 2
	BRDP_LOGMAX = 1 SHL 3
	BRDP_TEXCRC = 1 SHL 4
	BRDP_DISABLESHADE = 1 SHL 5
End Enum


enum  UcodeI 
F3D, F3DEX, F3DEX2
end enum

extern as _Renderopts renderopts

type __RAM 
	as integer IsSet
        as uinteger _Size
	as integer SourceCompType
	as uinteger SourceOffset
	as ubyte ptr _Data
end type

extern as __RAM RAM(MAX_SEGMENTS)

type __RDRAM
	as boolean IsSet
	as uinteger  _Size
	as ubyte ptr _Data
end type

extern as __RDRAM RDRAM

Declare Sub RDP_SetupOpenGL()
Declare Sub RDP_SetOpenGLDimensions(_Width As Integer, _Height As Integer)
Declare Sub RDP_InitParser(UcodeID As Integer)
Declare Sub RDP_LoadToSegment(Segment As UByte, Buffer As UByte Ptr, Offset As Integer, Size As Integer)
Declare Sub RDP_LoadToRDRAM(Buffer As UByte Ptr, Size As Integer)
Declare Function RDP_SaveSegment(Segment As UByte, Buffer As UByte Ptr) As Boolean
Declare Sub RDP_Yaz0Decode(_Input As UByte Ptr, _Output As UByte Ptr, DecSize As Integer)
Declare Sub RDP_MIO0Decode(_Input As UByte Ptr, _Output As UByte Ptr, DecSize As Integer)
Declare Function RDP_CheckAddressValidity(Address As Integer) As Boolean
Declare Function RDP_GetPhysicalAddress(VAddress As Integer) As Integer
Declare Sub RDP_ClearSegment(Segment As UByte)
Declare Sub RDP_ClearRDRAM()
Declare Sub RDP_ClearTextures()
Declare Sub RDP_ClearStructures(Full As Boolean)
Declare Sub RDP_ParseDisplayList(Address As Integer, ResetStack As Boolean)
Declare Sub RDP_CreateCombinerProgram(Cmb0 As Integer, Cmb1 As Integer)
Declare Sub RDP_Dump_InitModelDumping(Path As ZString Ptr, ObjFilename As ZString Ptr, MtlFilename As ZString Ptr)
Declare Sub RDP_Dump_StopModelDumping()
Declare Function RDP_OpenGL_ExtFragmentProgram() As Boolean
Declare Sub RDP_SetRendererOptions(Options As UByte)
Declare Function RDP_GetRendererOptions() As UByte
Declare Sub RDP_Matrix_ModelviewLoad(Matrix As Single Ptr)
Declare Sub RDP_Matrix_ProjectionLoad(Matrix As Single Ptr)
Declare Sub RDP_Matrix_ModelviewPush()
Declare sub RDP_SetCycleType(_Type as uinteger)
Declare Sub RDP_SetPrimColor(R As UByte, G As UByte, B As UByte, A As UByte)
Declare Sub RDP_SetEnvColor(R As UByte, G As UByte, B As UByte, A As UByte)
Declare Sub RDP_ToggleMatrixHack()
Declare Sub RDP_DisableARB()
Declare Sub RDP_EnableARB()


#endif
