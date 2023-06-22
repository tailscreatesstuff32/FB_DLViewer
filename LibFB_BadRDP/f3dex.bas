#include "globals.bi"
#include "misaka.bi"
'// ----------------------------------------

' Function definition
Sub RDP_F3DEX_Init ()

    RDP_InitFlags(F3DEX)

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
       ' msk_consoleprint(0,"G_VTX")
      gSP_Vertex(w1, _SHIFTR(w0, 10, 6), _SHIFTR(w0, 17, 7))
End Sub

Sub RDP_F3DEX_LOAD_UCODE ()
        ' //
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

Sub RDP_F3DEX_TRI2()
    ' msk_consoleprint(0, "G_TRI2")
    Dim As integer Vtxs1(0 To ...) = { _SHIFTR(w0, 17, 7), _SHIFTR(w0, 9, 7), _SHIFTR(w0, 1, 7) }
    RDP_DrawTriangle(@Vtxs1(0))

    Dim As integer Vtxs2(0 To ...) = { _SHIFTR(w1, 17, 7), _SHIFTR(w1, 9, 7), _SHIFTR(w1, 1, 7) }
    RDP_DrawTriangle(@Vtxs2(0))
End Sub


Sub RDP_F3DEX_MODIFYVTX ()
     ' //
End Sub

Sub RDP_F3DEX_CULLDL ()
    ' //
End Sub

Sub RDP_F3DEX_TRI1 ()
   	Dim As integer Vtxs(0 To ...) = { _SHIFTR( w1, 17, 7 ), _SHIFTR( w1, 9, 7 ), _SHIFTR( w1, 1, 7 ) }
	RDP_DrawTriangle(@Vtxs(0))
End Sub

