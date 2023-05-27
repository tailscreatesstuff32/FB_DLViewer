#include "globals.bi"


Sub RDP_Dump_InitModelDumping(Path As ZString Ptr, ObjFilename As ZString Ptr, MtlFilename As ZString Ptr)

end sub

Sub RDP_Dump_StopModelDumping()

end sub

sub RDP_Dump_BeginGroup(Address as uinteger)
 
	if( _System.FileWavefrontObj = 0 orelse _System.FileWavefrontMtl  = 0 orelse _System.ObjDumpingEnabled = 0) then return

	fprintf(_System.FileWavefrontObj, !"g DList_%08X\n", Address)
end sub
