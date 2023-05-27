#include "globals.bi"
#include "misaka.bi"

Sub RDP_F3D_Init ()

end sub



' Function definitions
Sub RDP_F3D_SPNOOP ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_MTX ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_RESERVED0 ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_MOVEMEM ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_VTX ()
  
     msk_consoleprint(0,"G_VTX")
End Sub

Sub RDP_F3D_RESERVED1 ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_DL ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_RESERVED2 ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_RESERVED3 ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_SPRITE2D_BASE ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_TRI4 ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_RDPHALF_CONT ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_RDPHALF_2 ()
Gfx.Store_RDPHalf2 = w1
End Sub

Sub RDP_F3D_RDPHALF_1 ()
   Gfx.Store_RDPHalf1 = w1
End Sub

Sub RDP_F3D_QUAD ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_CLEARGEOMETRYMODE ()
   Gfx.GeometryMode or= not(w1)
   Gfx.Update or= CHANGED_GEOMETRYMODE
End Sub

Sub RDP_F3D_SETGEOMETRYMODE ()
   Gfx.GeometryMode or= w1
   Gfx.Update or= CHANGED_GEOMETRYMODE
End Sub

Sub RDP_F3D_ENDDL ()
msk_consoleprint(0,"G_ENDDL")
    Gfx.DLStackPos-=1
    DListAddress = Gfx.DLStack(Gfx.DLStackPos)
End Sub

Sub RDP_F3D_SETOTHERMODE_L ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_SETOTHERMODE_H ()
msk_consoleprint(0,"G_SetOtherMode_H")
    ' Function implementation goes here
End Sub

Sub RDP_F3D_TEXTURE ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_MOVEWORD ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_POPMTX ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_CULLDL ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_TRI1 ()
    ' Function implementation goes here
End Sub
