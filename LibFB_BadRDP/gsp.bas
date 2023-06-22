 #include "globals.bi"
 #include "misaka.bi"
 
Sub gSP_Vertex(ByVal Vtx As UInteger, ByVal N As Integer, ByVal V0 As Integer)
    ' "hack": if we didn't find a macro for texture loading, try it here manually, hoping we've got enough intel about it
    If isMacro = false Then
        RDP_InitLoadTexture()
    End If






    If RDP_CheckAddressValidity(Vtx) = 0 Then
        Return
    End If

    If N > 32 Orelse V0 > 32 Then
        Return
    End If

    If (Gfx.Update And CHANGED_MULT_MAT) <> 0 Then
        Gfx.Update xor= CHANGED_MULT_MAT
        RDP_Matrix_MulMatrices(@Matrix.Model(0, 0), @Matrix.Proj(0, 0), @Matrix.Comb(0, 0))
    End If

    Dim As UByte TempSegment = Vtx Shr 24
    Dim As UInteger TempOffset = Vtx And &H00FFFFFF

    Dim As UByte Ptr SourceBuffer = Null
    If TempSegment <> &H80 Then
        SourceBuffer = RAM(TempSegment)._Data
    Else
        SourceBuffer = RDRAM._Data
    End If

    Dim As Integer i = 0
      '	msk_consoleprint(2,"VERTADDR: %#010X",TempOffset )   
    For i = 0 To N - 1
        Vertex(V0 + i).Vtx.S = Read16(SourceBuffer, TempOffset + (i * 16) + 8)
        Vertex(V0 + i).Vtx.T = Read16(SourceBuffer, TempOffset + (i * 16) + 10)
        Vertex(V0 + i).Vtx.R = SourceBuffer[TempOffset + (i * 16) + 12]
        Vertex(V0 + i).Vtx.G = SourceBuffer[TempOffset + (i * 16) + 13]
        Vertex(V0 + i).Vtx.B = SourceBuffer[TempOffset + (i * 16) + 14]
        Vertex(V0 + i).Vtx.A = SourceBuffer[TempOffset + (i * 16) + 15]

        Dim As Short X = Read16(SourceBuffer, TempOffset + (i * 16))
        Dim As Short Y = Read16(SourceBuffer, TempOffset + (i * 16) + 2)
        Dim As Short Z = Read16(SourceBuffer, TempOffset + (i * 16) + 4)
        Dim As Short W = Read16(SourceBuffer, TempOffset + (i * 16) + 6)

        Vertex(V0 + i).Vtx.X = X 'X * Matrix.Comb(0, 0) + Y * Matrix.Comb(1, 0) + Z * Matrix.Comb(2, 0) + Matrix.Comb(3, 0)
        Vertex(V0 + i).Vtx.Y = Y 'X * Matrix.Comb(0, 1) + Y * Matrix.Comb(1, 1) + Z * Matrix.Comb(2, 1) + Matrix.Comb(3, 1)
        Vertex(V0 + i).Vtx.Z = Z 'X * Matrix.Comb(0, 2) + Y * Matrix.Comb(1, 2) + Z * Matrix.Comb(2, 2) + Matrix.Comb(3, 2)
        Vertex(V0 + i).Vtx.W = W
        
            'beep
       /'  msk_consoleprint(0,"VERT: %i",N )  
         msk_consoleprint(1,"S: %hi", Vertex(V0 + i).Vtx.S )
         msk_consoleprint(1,"T: %hi", Vertex(V0 + i).Vtx.T )
        msk_consoleprint(1,"R: %hi", Vertex(V0 + i).Vtx.R )
        msk_consoleprint(1,"G: %hi", Vertex(V0 + i).Vtx.G )
        msk_consoleprint(1,"B: %hi", Vertex(V0 + i).Vtx.B ) 
         msk_consoleprint(1,"A: %hi", Vertex(V0 + i).Vtx.A ) 
        msk_consoleprint(1,"X: %hi", Vertex(V0 + i).Vtx.X )
         msk_consoleprint(1,"Y: %hi", Vertex(V0 + i).Vtx.Y )
         msk_consoleprint(1,"Z: %hi", Vertex(V0 + i).Vtx.Z ) 
         msk_consoleprint(1,"W: %hi", Vertex(V0 + i).Vtx.W ) '/
    Next
 
 



    
End Sub
Sub gSP_Segment(ByVal Segment As UByte, ByVal BaseAddress As UInteger)
 
'//	if(RDRAM.IsSet) {
		RAM(Segment)._Data = @RDRAM._Data[BaseAddress]
		RAM(Segment).IsSet = _true
		RAM(Segment)._Size = RDRAM._Size - BaseAddress
		RAM(Segment).SourceOffset = BaseAddress
'//	}
end sub
