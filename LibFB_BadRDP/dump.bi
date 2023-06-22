declare sub RDP_Dump_BeginGroup(Address as uinteger)
Declare Sub RDP_Dump_DumpTriangle (Vtx As __Vertex Ptr, VtxID As integer Ptr)
Declare  Function RDP_Dump_CreateMaterial(TextureData As UByte Ptr, TexFormat As UByte, TexOffset As UInteger, _Width As Integer, _Height As Integer, SMirror As Boolean, TMirror As Boolean) As Integer
Declare Sub RDP_Dump_SelectMaterial(MatID as integer)
Declare Sub RDP_Dump_StopModelDumping()
Declare Sub RDP_Dump_InitModelDumping(Path As ZString Ptr, ObjFilename As ZString Ptr, MtlFilename As ZString Ptr)
declare Function RDP_Dump_SavePNG(Buffer As UByte Ptr, _Width As Integer, _Height As Integer, ByRef Filename As ZString Ptr, SMirror As Boolean, TMirror As Boolean) As Integer
