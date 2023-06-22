#include "globals.bi"
#include "misaka.bi"

Sub RDP_F3D_Init ()
	RDP_InitFlags(F3D)

	RDP_UcodeCmd(F3D_SPNOOP)            = @RDP_F3D_SPNOOP
	RDP_UcodeCmd(F3D_MTX)               = @RDP_F3D_MTX
	RDP_UcodeCmd(F3D_RESERVED0)         = @RDP_F3D_RESERVED0
	RDP_UcodeCmd(F3D_MOVEMEM)           = @RDP_F3D_MOVEMEM
	RDP_UcodeCmd(F3D_VTX)               = @RDP_F3D_VTX
	RDP_UcodeCmd(F3D_RESERVED1)         = @RDP_F3D_RESERVED1
	RDP_UcodeCmd(F3D_DL)                = @RDP_F3D_DL
	RDP_UcodeCmd(F3D_RESERVED2)         = @RDP_F3D_RESERVED2
	RDP_UcodeCmd(F3D_RESERVED3)         = @RDP_F3D_RESERVED3
	RDP_UcodeCmd(F3D_SPRITE2D_BASE)     = @RDP_F3D_SPRITE2D_BASE
	RDP_UcodeCmd(F3D_TRI4)              = @RDP_F3D_TRI4
	RDP_UcodeCmd(F3D_RDPHALF_CONT)      = @RDP_F3D_RDPHALF_CONT
	RDP_UcodeCmd(F3D_RDPHALF_2)         = @RDP_F3D_RDPHALF_2
	RDP_UcodeCmd(F3D_RDPHALF_1)         = @RDP_F3D_RDPHALF_1
	RDP_UcodeCmd(F3D_QUAD)              = @RDP_F3D_QUAD
	RDP_UcodeCmd(F3D_CLEARGEOMETRYMODE) = @RDP_F3D_CLEARGEOMETRYMODE
	RDP_UcodeCmd(F3D_SETGEOMETRYMODE)   = @RDP_F3D_SETGEOMETRYMODE
	RDP_UcodeCmd(F3D_ENDDL)             = @RDP_F3D_ENDDL
	RDP_UcodeCmd(F3D_SETOTHERMODE_L)    = @RDP_F3D_SETOTHERMODE_L
	RDP_UcodeCmd(F3D_SETOTHERMODE_H)    = @RDP_F3D_SETOTHERMODE_H
	RDP_UcodeCmd(F3D_TEXTURE)           = @RDP_F3D_TEXTURE
	RDP_UcodeCmd(F3D_MOVEWORD)          = @RDP_F3D_MOVEWORD
	RDP_UcodeCmd(F3D_POPMTX)            = @RDP_F3D_POPMTX
	RDP_UcodeCmd(F3D_CULLDL)            = @RDP_F3D_CULLDL
	RDP_UcodeCmd(F3D_TRI1)              = @RDP_F3D_TRI1
end sub



' Function definitions
Sub RDP_F3D_SPNOOP ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_MTX ()
'    	gSP_Matrix(w1, _SHIFTR(w0, 16, 8))

/'	int i = 0, j = 0;
	signed integer MtxTemp1 = 0, MtxTemp2 = 0;

	unsigned char Segment = w1 >> 24;
	unsigned int Offset = (w1 & 0x00FFFFFF);

	GLfloat Matrix[4][4];
	float fRecip = 1.0f / 65536.0f;

	switch(Segment) {
		case 0x01:
		case 0x0C:
		case 0x0D:
			return;
		case 0x80:
			glPopMatrix();
			return;
	}

	for(i = 0; i < 4; i++) {
		for(j = 0; j < 4; j++) {
			MtxTemp1 = ((RAM[Segment].Data[Offset		] * 0x100) + RAM[Segment].Data[Offset + 1		]);
			MtxTemp2 = ((RAM[Segment].Data[Offset + 32	] * 0x100) + RAM[Segment].Data[Offset + 33	]);
			Matrix[i][j] = ((MtxTemp1 << 16) | MtxTemp2) * fRecip;

			Offset += 2;
		}
	}

	glPushMatrix();
	glMultMatrixf(*Matrix);'/
End Sub

Sub RDP_F3D_RESERVED0 ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_MOVEMEM ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_VTX ()
  
    ' msk_consoleprint(0,"G_VTX")
gSP_Vertex(w1, _SHIFTR(w0, 10, 6), _SHIFTR(w0, 17, 7))
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
'msk_consoleprint(0,"G_ENDDL")
    Gfx.DLStackPos-=1
    DListAddress = Gfx.DLStack(Gfx.DLStackPos)
End Sub

Sub RDP_F3D_SETOTHERMODE_L ()
  Select Case (_SHIFTR(w0, 8, 8)) And 255
    Case G_MDSFT_RENDERMODE
        RDP_SetRenderMode(w1 And &HCCCCFFFF, w1 And &H3333FFFF)
 
    Case Else
        Dim As Uinteger _shift = _SHIFTR(w0, 8, 8) And 255
        Dim As Uinteger _length = _SHIFTR(w0, 0, 8) And 255
        Dim As Uinteger mask = ((1 Shl _length) - 1) Shl _shift

        Gfx.OtherMode.L = Gfx.OtherMode.L And Not mask
        Gfx.OtherMode.L = Gfx.OtherMode.L Or (w1 And mask)

        Gfx.Update or= (CHANGED_RENDERMODE Or CHANGED_ALPHACOMPARE)
End Select

End Sub

Sub RDP_F3D_SETOTHERMODE_H ()
'msk_consoleprint(0,"G_SetOtherMode_H")

Select Case (_SHIFTR(w0, 8, 8)) 
    Case Else
        Dim As Uinteger _shift = _SHIFTR(w0, 8, 8)
        Dim As Uinteger _length = _SHIFTR(w0, 0, 8)
        Dim As Uinteger mask = ((1 Shl _length) - 1) Shl _shift

        Gfx.OtherMode.H and= Not mask
        Gfx.OtherMode.H or= (w1 And mask)
End Select
    
    
End Sub

Sub RDP_F3D_TEXTURE ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_MOVEWORD ()
   	select case (_SHIFTR(w0, 0, 8)) 
		case G_MW_SEGMENT 
		 beep 
			gSP_Segment(_SHIFTR(w0, 8, 16) shr 2, w1 and &H00FFFFFF) 
			
		case else
		
	end select
End Sub

Sub RDP_F3D_POPMTX ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_CULLDL ()
    ' Function implementation goes here
End Sub

Sub RDP_F3D_TRI1 ()
	Dim As integer Vtxs(0 To ...) = { _SHIFTR(w1, 16, 8) / 10, _SHIFTR(w1, 8, 8) / 10, _SHIFTR(w1, 0, 8) / 10 }
	RDP_DrawTriangle(@Vtxs(0))
End Sub
