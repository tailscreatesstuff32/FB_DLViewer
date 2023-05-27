#include "globals.bi"
#include "misaka.bi"
'// ----------------------------------------

' Function definition
Sub RDP_F3DEX_Init ()
    RDP_UcodeCmd(F3D_MTX)               = @RDP_F3D_MTX
    RDP_UcodeCmd(F3D_MOVEMEM)           = @RDP_F3D_MOVEMEM
    RDP_UcodeCmd(F3D_VTX)               = @RDP_F3DEX_VTX
    RDP_UcodeCmd(F3D_DL)                = @RDP_F3D_DL
    RDP_UcodeCmd(F3DEX_LOAD_UCODE)      = @RDP_F3DEX_LOAD_UCODE
    RDP_UcodeCmd(F3DEX_BRANCH_Z)        = @RDP_F3DEX_BRANCH_Z
    RDP_UcodeCmd(F3DEX_TRI2)            = @RDP_F3DEX_TRI2
    RDP_UcodeCmd(F3DEX_MODIFYVTX)       = @RDP_F3DEX_MODIFYVTX
    RDP_UcodeCmd(F3D_RDPHALF_2)         = @RDP_F3D_RDPHALF_2
    RDP_UcodeCmd(F3D_RDPHALF_1)         = @RDP_F3D_RDPHALF_1
    RDP_UcodeCmd(F3D_CLEARGEOMETRYMODE) = @RDP_F3D_CLEARGEOMETRYMODE
    RDP_UcodeCmd(F3D_SETGEOMETRYMODE)   = @RDP_F3D_SETGEOMETRYMODE
    RDP_UcodeCmd(F3D_ENDDL)             = @RDP_F3D_ENDDL
    RDP_UcodeCmd(F3D_SETOTHERMODE_L)    = @RDP_F3D_SETOTHERMODE_L
    RDP_UcodeCmd(F3D_SETOTHERMODE_H)    = @RDP_F3D_SETOTHERMODE_H
    RDP_UcodeCmd(F3D_TEXTURE)           = @RDP_F3D_TEXTURE
    RDP_UcodeCmd(F3D_MOVEWORD)          = @RDP_F3D_MOVEWORD
    RDP_UcodeCmd(F3D_POPMTX)            = @RDP_F3D_POPMTX
    RDP_UcodeCmd(F3D_CULLDL)            = @RDP_F3DEX_CULLDL
    RDP_UcodeCmd(F3D_TRI1)              = @RDP_F3DEX_TRI1

End Sub




' Function definitions
Sub RDP_F3DEX_VTX ()
       msk_consoleprint(0,"G_VTX")
End Sub

Sub RDP_F3DEX_LOAD_UCODE ()
    ' Function implementation goes here
End Sub

Sub RDP_F3DEX_BRANCH_Z ()
    if(RDP_CheckAddressValidity(Gfx.Store_RDPHalf1) = 0) then return

	dim as integer Vtx = _SHIFTR(w0, 1, 11)
	dim as integer ZVal = cast(integer,w1)

	if(Vertex(Vtx).Vtx.Z < ZVal) then
		Gfx.DLStack(Gfx.DLStackPos) = DListAddress
		Gfx.DLStackPos+=1

		RDP_ParseDisplayList(Gfx.Store_RDPHalf1, false)
	end if
End Sub

Sub RDP_F3DEX_TRI2 ()
  msk_consoleprint(0,"G_TRI2")
  
End Sub

Sub RDP_F3DEX_MODIFYVTX ()
    ' Function implementation goes here
End Sub

Sub RDP_F3DEX_CULLDL ()
    ' Function implementation goes here
End Sub

Sub RDP_F3DEX_TRI1 ()
    ' Function implementation goes here
End Sub

