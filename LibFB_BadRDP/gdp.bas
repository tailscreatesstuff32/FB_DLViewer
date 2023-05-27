#include "globals.bi"


extern as boolean do_arb 
static shared as uinteger TexAddr = 0

Sub gDP_TexRect(w0 As Unsigned Integer, w1 As Unsigned Integer, w2 As Unsigned Integer, w3 As Unsigned Integer)
    ' Function implementation goes here
End Sub

Sub gDP_FillRect(w0 As Unsigned Integer, w1 As Unsigned Integer, w2 As Unsigned Integer, w3 As Unsigned Integer)
    ' Function implementation goes here
End Sub

Sub gDP_LoadTLUT(w0 As Unsigned Integer, w1 As Unsigned Integer)
    ' Function implementation goes here
End Sub

Sub gDP_SetTileSize(w0 As Unsigned Integer, w1 As Unsigned Integer)
    ' Function implementation goes here
End Sub

Sub gDP_SetTile(w0 As Unsigned Integer, w1 As Unsigned Integer)
    ' Function implementation goes here
End Sub

Sub gDP_SetFillColor(w0 As Unsigned Integer, w1 As Unsigned Integer)
    ' Function implementation goes here
End Sub

Sub gDP_SetFogColor(w0 As Unsigned Integer, w1 As Unsigned Integer)
    ' Function implementation goes here
End Sub

Sub gDP_SetBlendColor(w0 As Unsigned Integer, w1 As Unsigned Integer)
    ' Function implementation goes here
End Sub

Sub gDP_SetPrimColor(w0 As Unsigned Integer, w1 As Unsigned Integer)
    ' Function implementation goes here
End Sub

Sub gDP_SetEnvColor(w0 As Unsigned Integer, w1 As Unsigned Integer)
    ' Function implementation goes here
End Sub

Sub gDP_SetCombine(w0 As Unsigned Integer, w1 As Unsigned Integer)
    ' Function implementation goes here
End Sub

Sub gDP_SetTImg(w0 As Unsigned Integer, w1 As Unsigned Integer)
if(isMacro) then 
TexAddr = w1
else 
Texture(Gfx.CurrentTexture).Offset = w1
end if
End Sub

