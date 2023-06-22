#include "globals.bi"
#include "misaka.bi"

extern as boolean do_arb 
static shared as uinteger TexAddr = 0

Sub gDP_TexRect(w0 As Unsigned integer, w1 As Unsigned integer, w2 As Unsigned integer, w3 As Unsigned integer)
    ' Function implementation goes here
End Sub

Sub gDP_FillRect(w0 As Unsigned integer, w1 As Unsigned integer, w2 As Unsigned integer, w3 As Unsigned integer)
    ' Function implementation goes here
End Sub

sub gDP_LoadTLUT(w0 as uinteger, w1 as uinteger)
    if not RDP_CheckAddressValidity(TexAddr) then return

    memset(@_palette(0), &H00, ArraySize(_palette))

    dim as ubyte PalSegment = TexAddr shr 24
    dim as uinteger PalOffset = (TexAddr and &H00FFFFFF)

    ' dim as unsigned integer PalSize = ((w1 and &H00FFF000) shr 14) + 1
    dim as uinteger PalSize = (((w1 and &H00FF0000) shr 16) + 1) * 4

    dim as ushort Raw
    dim as uinteger R, G, B, A

    dim as uinteger PalLoop

    for PalLoop = 0 to PalSize - 1
        if PalSegment <> &H80 then
            Raw = (RAM(PalSegment)._Data[PalOffset] shl 8)  or RAM(PalSegment)._Data[PalOffset + 1]
        else
            Raw = (RDRAM._Data[PalOffset] shl 8) or RDRAM._Data[PalOffset + 1]
        end if

        R = (Raw and &HF800) shr 8
        G = ((Raw and &H07C0) shl 5) shr 8
        B = ((Raw and &H003E) shl 18) shr 16

        if (Raw and &H0001) then
            A = &HFF
        else
            A = &H00
        end if

        _palette(PalLoop).R = R
        _palette(PalLoop).G = G
        _palette(PalLoop).B = B
        _palette(PalLoop).A = A

        PalOffset += 2
    next PalLoop
end sub


Sub gDP_SetTileSize(w0 As uinteger, w1 As uinteger)

	RDP_ChangeTileSize(_SHIFTR(w1, 24, 3), _SHIFTR(w0, 12, 12), _SHIFTR(w0, 0, 12), _SHIFTR(w1, 12, 12), _SHIFTR(w1, 0, 12))
End Sub

Sub gDP_SetTile(w0 As Unsigned integer, w1 As Unsigned integer)
	 If (((w1 And &HFF000000) Shr 24) = &H07) Then Return

	If isMacro Then Texture(Gfx.CurrentTexture).Offset = TexAddr

	Texture(Gfx.CurrentTexture)._format = (w0 And &H00FF0000) Shr 16
	Texture(Gfx.CurrentTexture).CMT =  _SHIFTR(w1, 18, 2)
	Texture(Gfx.CurrentTexture).CMS =  _SHIFTR(w1, 8, 2)
	Texture(Gfx.CurrentTexture).LineSize = _SHIFTR(w0, 9, 9)
	Texture(Gfx.CurrentTexture).Palette =  _SHIFTR(w1, 20, 4)
	Texture(Gfx.CurrentTexture).ShiftT = _SHIFTR(w1, 10, 4)
	Texture(Gfx.CurrentTexture).ShiftS = _SHIFTR(w1, 0, 4)
	Texture(Gfx.CurrentTexture).MaskT = _SHIFTR(w1, 14, 4)
	Texture(Gfx.CurrentTexture).MaskS = _SHIFTR(w1, 4, 4)

	'If (Texture(Gfx.CurrentTexture).MaskT = 0) Then Texture(Gfx.CurrentTexture).CMT And= G_TX_CLAMP
	'If (Texture(Gfx.CurrentTexture).MaskS = 0) Then Texture(Gfx.CurrentTexture).CMS And= G_TX_CLAMP

	Texture(Gfx.CurrentTexture).IsTexRect = FALSE
	
	/'   MSK_ConsolePrint(1, "IsTexRect: %i",Texture(Gfx.CurrentTexture).IsTexRect)
	MSK_ConsolePrint(1, "CURRENT: %i", Gfx.CurrentTexture)
	MSK_ConsolePrint(1, "FORMAT: %02X", Texture(Gfx.CurrentTexture)._format)
	MSK_ConsolePrint(1, "CMT: %i", Texture(Gfx.CurrentTexture).CMT)
	MSK_ConsolePrint(1, "CMS: %i", Texture(Gfx.CurrentTexture).CMS)
	MSK_ConsolePrint(1, "clamps: %i", Texture(Gfx.CurrentTexture).clamps)
	MSK_ConsolePrint(1, "clampt: %i", Texture(Gfx.CurrentTexture).clampt)
	
	MSK_ConsolePrint(1, "LineSize: %i", Texture(Gfx.CurrentTexture).LineSize)
	MSK_ConsolePrint(1, "Palette: %i", Texture(Gfx.CurrentTexture).Palette)
	MSK_ConsolePrint(1, "ShiftT: %i", Texture(Gfx.CurrentTexture).ShiftT)
	MSK_ConsolePrint(1, "ShiftS: %i", Texture(Gfx.CurrentTexture).ShiftS)
	MSK_ConsolePrint(1, "MaskT: %i", Texture(Gfx.CurrentTexture).MaskT)
	MSK_ConsolePrint(1, "MaskS: %i", Texture(Gfx.CurrentTexture).MaskS)
        MSK_ConsolePrint(1, " ")    '/

End Sub

Sub gDP_SetFillColor(w0 As Unsigned integer, w1 As Unsigned integer)
    ' Function implementation goes here
End Sub

Sub gDP_SetFogColor(w0 As Unsigned integer, w1 As Unsigned integer)
    ' Function implementation goes here
End Sub

Sub gDP_SetBlendColor(w0 As Unsigned integer, w1 As Unsigned integer)
    ' Function implementation goes here
End Sub

Sub gDP_SetPrimColor(w0 As Unsigned integer, w1 As Unsigned integer)
    ' Function implementation goes here
End Sub

Sub gDP_SetEnvColor(w0 As Unsigned integer, w1 As Unsigned integer)
    ' Function implementation goes here
End Sub

Sub gDP_SetCombine(w0 As Unsigned integer, w1 As Unsigned integer)
	Gfx.Combiner0 = (w0 and &H00FFFFFF)
	Gfx.Combiner1 = w1

	if(OpenGL.Ext_FragmentProgram andalso (_System.Options and BRDP_COMBINER)) then RDP_CheckFragmentCache() 
End Sub

Sub gDP_SetTImg(w0 As Unsigned integer, w1 As Unsigned integer)
if(isMacro) then 
TexAddr = w1
	'MSK_ConsolePrint(1, "%#10X", w1)
else 
Texture(Gfx.CurrentTexture).Offset = w1
end if

'MSK_ConsolePrint(1, "TEXADDR: %#10X",TexAddr)
End Sub

