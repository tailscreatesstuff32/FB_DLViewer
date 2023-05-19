#include "globals.bi"



sub RDP_SetRendererOptions(options as ubyte)

	'System.Options = Options
	'if((System.Options and BRDP_DISABLESHADE) = 0) then
	
	'	glEnable(GL_LIGHTING)
	'	glEnable(GL_NORMALIZE)
	
	'else
	
	'	glDisable(GL_LIGHTING)
	'	glDisable(GL_NORMALIZE)
	'end if
end sub

sub RDP_InitParser(UcodeID as integer)

end sub

Sub RDP_LoadToSegment(Segment As UByte, Buffer As UByte Ptr, Offset As Integer, Size As Integer)

end sub

Sub RDP_LoadToRDRAM(Buffer As UByte Ptr, Size As Integer)

end sub

Function RDP_SaveSegment(Segment As UByte, Buffer As UByte Ptr) As Boolean

end function

 Sub RDP_Yaz0Decode(_Input As UByte Ptr, _Output As UByte Ptr, DecSize As Integer)
 
 end sub
 
 Sub RDP_MIO0Decode(_Input As UByte Ptr, _Output As UByte Ptr, DecSize As Integer)
 
 
 end sub
 
Function RDP_CheckAddressValidity(Address As Integer) As Boolean
 
 end function
 
 Function RDP_GetPhysicalAddress(VAddress As Integer) As Integer
 
 end function
 
 Sub RDP_ClearSegment(Segment As UByte)
 
 end sub
 
 Sub RDP_ClearRDRAM()
 
 end sub
 
 Sub RDP_ClearStructures(Full As Boolean)
 
 
 end sub
 
 Sub RDP_ParseDisplayList(Address As Integer, ResetStack As Boolean)
 
 end sub
 
 sub RDP_DrawTriangle(Vtx as integer ptr)
 
 end sub
 
sub RDP_SetRenderMode(Mode1 as uinteger,Mode2  as uinteger)

end sub

sub RDP_SetCycleType(_Type as uinteger)
 
 end sub
 
 Sub RDP_SetPrimColor(R As UByte, G As UByte, B As UByte, A As UByte)
 
 end sub
 
Sub RDP_ToggleMatrixHack()

 end sub
 
Sub RDP_DisableARB()

 end sub

Sub RDP_EnableARB()


 end sub


