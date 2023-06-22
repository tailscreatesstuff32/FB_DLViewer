#include "globals.bi"
#include "misaka.bi"

'#include "crt/math.bi"
Function IsInfinite(value As Double) As Boolean
    Return value = INFINITY Orelse value = -INFINITY
End Function

'Function IsNan1(value As Double) As Boolean
'    Return value = NAN_ Orelse value = -NAN_
'End Function



#ifdef WIN32
dim shared as PFNGLMULTITEXCOORD1FARBPROC			glMultiTexCoord1fARB
dim shared as PFNGLMULTITEXCOORD2FARBPROC			glMultiTexCoord2fARB
dim shared as PFNGLMULTITEXCOORD3FARBPROC			glMultiTexCoord3fARB
dim shared as PFNGLMULTITEXCOORD4FARBPROC			glMultiTexCoord4fARB
dim shared as PFNGLACTIVETEXTUREARBPROC				glActiveTextureARB
dim shared as PFNGLCLIENTACTIVETEXTUREARBPROC			glClientActiveTextureARB
#endif /' WIN32 '/

dim shared as PFNGLGENPROGRAMSARBPROC				glGenProgramsARB
dim shared as PFNGLBINDPROGRAMARBPROC				glBindProgramARB
dim shared as PFNGLDELETEPROGRAMSARBPROC			glDeleteProgramsARB
dim shared as PFNGLPROGRAMSTRINGARBPROC				glProgramStringARB
dim shared as PFNGLPROGRAMENVPARAMETER4FARBPROC			glProgramEnvParameter4fARB
dim shared as PFNGLPROGRAMLOCALPARAMETER4FARBPROC		glProgramLocalParameter4fARB

dim shared as __System _System
dim shared as __Matrix Matrix
dim shared as __Palette _Palette(256)
dim shared as  __Vertex Vertex(32)
dim shared as __Texture Texture(2)
dim shared as __FragmentCache FragmentCache(CACHE_FRAGMENT)
dim shared as __TextureCache TextureCache(CACHE_TEXTURES)
dim shared as __Gfx Gfx
dim shared as __OpenGL OpenGL

Dim Shared G_TEXTURE_ENABLE As Uinteger
Dim Shared G_SHADING_SMOOTH As Uinteger
Dim Shared G_CULL_FRONT As Uinteger
Dim Shared G_CULL_BACK As Uinteger
Dim Shared G_CULL_BOTH As Uinteger
Dim Shared G_CLIPPING As Uinteger

Dim Shared G_MTX_STACKSIZE As Uinteger
Dim Shared G_MTX_MODELVIEW As Uinteger
Dim Shared G_MTX_PROJECTION As Uinteger
Dim Shared G_MTX_MUL As Uinteger
Dim Shared G_MTX_LOAD As Uinteger
Dim Shared G_MTX_NOPUSH As Uinteger
Dim Shared G_MTX_PUSH As Uinteger

G_TEXTURE_ENABLE = 0
G_SHADING_SMOOTH = 1
G_CULL_FRONT = 2
G_CULL_BACK = 3
G_CULL_BOTH = 4
G_CLIPPING = 5

G_MTX_STACKSIZE = 100
G_MTX_MODELVIEW = 101
G_MTX_PROJECTION = 102
G_MTX_MUL = 103
G_MTX_LOAD = 104
G_MTX_NOPUSH = 105
G_MTX_PUSH = 106

dim shared as boolean do_arb = true
dim shared as boolean isMacro



Dim Shared As RDPInstruction RDP_UcodeCmd(256)

Dim Shared As Uinteger DListAddress
Dim Shared As UByte Segment
Dim Shared As Uinteger Offset

Dim Shared As Uinteger wp0, wp1
Dim Shared As Uinteger w0, w1
Dim Shared As Uinteger wn0, wn1


Function RDP_CheckTextureCache(TexID As Uinteger) As GLuint
 'beep
Dim As GLuint GLID = 0

Dim As integer CacheCheck = 0
Dim As Boolean SearchingCache = True
Dim As Boolean NewTexture = False

Do While SearchingCache
    If (TextureCache(CacheCheck).Offset = Texture(TexID).Offset) Andalso _
       (TextureCache(CacheCheck).RealWidth = Texture(TexID).RealWidth) Andalso _
       (TextureCache(CacheCheck).RealHeight = Texture(TexID).RealHeight) Andalso _
       (TextureCache(CacheCheck).CRC32 = Texture(TexID).CRC32) Then
        SearchingCache = False
        NewTexture = False
    Else
        If CacheCheck <> CACHE_TEXTURES Then
            CacheCheck += 1
        Else
            SearchingCache = False
            NewTexture = True
        End If
    End If
Loop

If NewTexture Then
     GLID = RDP_LoadTexture(TexID)
      
     RDP_Dump_SelectMaterial(TextureCache(_system.TextureCachePosition).MaterialID)
     TextureCache(_system.TextureCachePosition).Offset = Texture(TexID).Offset
    TextureCache(_system.TextureCachePosition).RealWidth = Texture(TexID).RealWidth
    TextureCache(_system.TextureCachePosition).RealHeight = Texture(TexID).RealHeight
    TextureCache(_system.TextureCachePosition).CRC32 = Texture(TexID).CRC32
    TextureCache(_system.TextureCachePosition).TextureID = GLID
    _system.TextureCachePosition += 1
    
  '  msk_consoleprint(3,"NEWTEXTURE")
Else
 'msk_consoleprint(3,"NOTNEWTEXTURE")
   GLID = TextureCache(CacheCheck).TextureID
   RDP_Dump_SelectMaterial(TextureCache(CacheCheck).MaterialID)
End If

/'Do While _system.TextureCachePosition > CACHE_TEXTURES
    Dim As integer i = 0
    Static As const __TextureCache TextureCache_Empty
    i = 0
    Do While i < CACHE_TEXTURES
        TextureCache(i) = TextureCache_Empty
        i += 1
    Loop
    _system.TextureCachePosition = 0
Loop '/

If _System.TextureCachePosition > CACHE_TEXTURES Then
    Dim i As integer = 0
     Static As __TextureCache TextureCache_Empty
    For i = 0 To CACHE_TEXTURES - 1
 
        TextureCache(i) = TextureCache_Empty
    Next i
    _System.TextureCachePosition = 0
End If



Return GLID
 

end function

sub RDP_CalcTextureSize(TextureID as integer)
Dim MaxTexel As Uinteger = 0, Line_Shift As Uinteger = 0

Select Case Texture(TextureID)._Format
    ' 4-bit
    Case &H00
        MaxTexel = 4096
        Line_Shift = 4
    Case &H40
        MaxTexel = 4096
        Line_Shift = 4
    Case &H60
        MaxTexel = 8192
        Line_Shift = 4
    Case &H80
        MaxTexel = 8192
        Line_Shift = 4

    ' 8-bit
    Case &H08
        MaxTexel = 2048
        Line_Shift = 3
    Case &H48
        MaxTexel = 2048
        Line_Shift = 3
    Case &H68
   ' beep
        MaxTexel = 4096
        Line_Shift = 3
    Case &H88
        MaxTexel = 4096
        Line_Shift = 3

    ' 16-bit
    Case &H10
        MaxTexel = 2048
        Line_Shift = 2
        
  '  Msk_ConsolePrint(1,"MAXTEXEL: %i",MaxTexel)
      '  Msk_ConsolePrint(1,"LINE_SHIFT: %i",Line_Shift)
          'Msk_ConsolePrint(1," ")
    Case &H50
        MaxTexel = 2048
        Line_Shift = 0
    Case &H70
        MaxTexel = 2048
        Line_Shift = 2
    Case &H90
        MaxTexel = 2048
        Line_Shift = 0

    ' 32-bit
    Case &H18
        MaxTexel = 1024
        Line_Shift = 2

    ' default case
    Case Else
   ' beep
        Return
End Select

Dim Line_Width As Uinteger = Texture(TextureID).LineSize Shl Line_Shift
' Msk_ConsolePrint(1,"LINE_WIDTH: %i",Line_Width)
 
Dim Tile_Width As Uinteger = (Texture(TextureID).LRS - Texture(TextureID).ULS) + 1
Dim Tile_Height As Uinteger = (Texture(TextureID).LRT - Texture(TextureID).ULT) + 1

'Msk_ConsolePrint(1,"TILE_WIDTH: %i",tile_Width)
 'Msk_ConsolePrint(1,"TILE_HEIGHT: %i",tile_height)
 
Dim Mask_Width As Uinteger = 1 Shl Texture(TextureID).MaskS
Dim Mask_Height As Uinteger = 1 Shl Texture(TextureID).MaskT
'Msk_ConsolePrint(1,"MASK_WIDTH: %i",Mask_Width)
'Msk_ConsolePrint(1,"MASK_HEIGHT: %i",Mask_height)

Dim Line_Height As Uinteger = 0
If Line_Width > 0 Then Line_Height = Min(MaxTexel \ Line_Width, Tile_Height)

' Msk_ConsolePrint(1,"LINE_HEIGHT: %i",Line_Height)

If Texture(TextureID).IsTexRect Then


'Msk_ConsolePrint(1,"ISTEXRECT")

'Msk_ConsolePrint(1," ")

    Dim TexRect_Width As UShort = Texture(TextureID).TexRectW - Texture(TextureID).ULS
    Dim TexRect_Height As UShort = Texture(TextureID).TexRectH - Texture(TextureID).ULT

    If Texture(TextureID).MaskS > 0 AndAlso (Mask_Width * Mask_Height) <= MaxTexel Then
        Texture(TextureID)._Width = Mask_Width
    ElseIf (Tile_Width * Tile_Height) <= MaxTexel Then
        Texture(TextureID)._Width = Tile_Width
    ElseIf (Tile_Width * TexRect_Height) <= MaxTexel Then
        Texture(TextureID)._Width = Tile_Width
    ElseIf (TexRect_Width * Tile_Height) <= MaxTexel Then
        Texture(TextureID)._Width = Texture(TextureID).TexRectW
    ElseIf (TexRect_Width * TexRect_Height) <= MaxTexel Then
        Texture(TextureID)._Width = Texture(TextureID).TexRectW
    Else
        Texture(TextureID)._Width = Line_Width
    End If

    If Texture(TextureID).MaskT > 0 AndAlso (Mask_Width * Mask_Height) <= MaxTexel Then
        Texture(TextureID)._Height = Mask_Height
    ElseIf (Tile_Width * Tile_Height) <= MaxTexel Then
        Texture(TextureID)._Height = Tile_Height
    ElseIf (Tile_Width * TexRect_Height) <= MaxTexel Then
        Texture(TextureID)._Height = Tile_Height
    ElseIf (TexRect_Width * Tile_Height) <= MaxTexel Then
        Texture(TextureID)._Height = Texture(TextureID).TexRectH
    ElseIf (TexRect_Width * TexRect_Height) <= MaxTexel Then
        Texture(TextureID)._Height = Texture(TextureID).TexRectH
    Else
        Texture(TextureID)._Height = Line_Height
    End If
Else

    If Texture(TextureID).MaskS > 0 AndAlso (Mask_Width * Mask_Height) <= MaxTexel Then
        Texture(TextureID)._Width = Mask_Width
    ElseIf (Tile_Width * Tile_Height) <= MaxTexel Then
        Texture(TextureID)._Width = Tile_Width
    Else
        Texture(TextureID)._Width = Line_Width
    End If
   ' Msk_ConsolePrint(1,"WIDTH: %i",  Texture(TextureID)._Width)



    If Texture(TextureID).MaskT > 0 AndAlso (Mask_Width * Mask_Height) <= MaxTexel Then
        Texture(TextureID)._Height = Mask_Height
    ElseIf (Tile_Width * Tile_Height) <= MaxTexel Then
        Texture(TextureID)._Height = Tile_Height
    Else
        Texture(TextureID)._Height = Line_Height
    End If
  '  Msk_ConsolePrint(1,"HEIGHT: %i",  Texture(TextureID)._height)
    
End If


Dim Clamp_Width As Uinteger = IIf(Texture(TextureID).clamps, Tile_Width, Texture(TextureID)._Width)
Dim Clamp_Height As Uinteger = IIf(Texture(TextureID).clampt, Tile_Height, Texture(TextureID)._Height)

If Clamp_Width > 256 Then Texture(TextureID).clamps = 0
If Clamp_Height > 256 Then Texture(TextureID).clampt = 0

  '  Msk_ConsolePrint(1,"CLAMP_WIDTH %i", Clamp_Width)
  '   Msk_ConsolePrint(1,"CLAMP_HEIGHT: %i", Clamp_Height)

If Mask_Width > Texture(TextureID)._Width Then
    Texture(TextureID).MaskS = RDP_PowOf(Texture(TextureID)._Width)
    Mask_Width = 1 Shl Texture(TextureID).MaskS
   ' Msk_ConsolePrint(1,"MASKWIDTH %i",Mask_Width)
End If




If Mask_Height > Texture(TextureID)._Height Then
    Texture(TextureID).MaskT = RDP_PowOf(Texture(TextureID)._Height)
    Mask_Height = 1 Shl Texture(TextureID).MaskT
  '   Msk_ConsolePrint(1,"MASKHEIGHT %i", Mask_Height)
End If

If Texture(TextureID).clamps Then
    Texture(TextureID).RealWidth = RDP_Pow2(Clamp_Width)
ElseIf Texture(TextureID).mirrors Then
    Texture(TextureID).RealWidth = RDP_Pow2(Mask_Width)
Else
    Texture(TextureID).RealWidth = RDP_Pow2(Texture(TextureID)._Width)
End If

 ' Msk_ConsolePrint(1,"REALWIDTH %i",  Texture(TextureID).RealWidth)




If Texture(TextureID).clampt Then
    Texture(TextureID).RealHeight = RDP_Pow2(Clamp_Height)
ElseIf Texture(TextureID).mirrort Then
    Texture(TextureID).RealHeight = RDP_Pow2(Mask_Height)
Else
    Texture(TextureID).RealHeight = RDP_Pow2(Texture(TextureID)._Height)
End If

 ' Msk_ConsolePrint(1,"REALHEIGHT %i",  Texture(TextureID).RealHeight)

Texture(TextureID).ShiftScaleS = 1.0f
Texture(TextureID).ShiftScaleT = 1.0f

If Texture(TextureID).ShiftS > 10 Then
    Texture(TextureID).ShiftScaleS = (1 Shl (16 - Texture(TextureID).ShiftS))
ElseIf Texture(TextureID).ShiftS > 0 Then
    Texture(TextureID).ShiftScaleS \= (1 Shl Texture(TextureID).ShiftS)
End If
' Msk_ConsolePrint(1,"ShiftS %i",   Texture(TextureID).ShiftS)
 
 ' Msk_ConsolePrint(1,"SHIFTSCALE_S %f",   Texture(TextureID).ShiftScaleS)


If Texture(TextureID).ShiftT > 10 Then
'beep
    Texture(TextureID).ShiftScaleT = (1 Shl (16 - Texture(TextureID).ShiftT))
ElseIf Texture(TextureID).ShiftT > 0 Then
'beep
    Texture(TextureID).ShiftScaleT \= (1 Shl Texture(TextureID).ShiftT)
End If

' Msk_ConsolePrint(1,"ShiftT %i",   Texture(TextureID).ShiftT)
'  Msk_ConsolePrint(1,"SHIFTSCALE_T %f",   Texture(TextureID).ShiftScaleT)


'Msk_ConsolePrint(1," ")

end sub

Function RDP_LoadTexture(TextureID As integer) As GLuint
 

 
	Dim As UByte TexSegment = Texture(TextureID).Offset Shr 24
	Dim As Uinteger TexOffset = (Texture(TextureID).Offset And &H00FFFFFF)

	Dim As integer i = 0, j = 0

	Dim As Uinteger BytesPerPixel = &H08
	Select Case Texture(TextureID)._Format
	    ' 4bit, 8bit
	    Case &H00, &H40, &H60, &H80, &H08, &H48, &H68, &H88
		BytesPerPixel = &H04
	    ' 16bit
	    Case &H10, &H50, &H70, &H90
		BytesPerPixel = &H08
	    ' 32bit
	    Case &H18
		BytesPerPixel = &H10
	End Select
 
Dim As Uinteger BufferSize = (Texture(TextureID).RealHeight * Texture(TextureID).RealWidth) * BytesPerPixel
Dim As UByte Ptr TextureData = cast(UByte Ptr, Malloc(BufferSize))

MemSet(TextureData, &HFF, BufferSize)

Dim As Uinteger GLTexPosition = 0

Dim As UByte Ptr SourceBuffer = NULL
Dim As Uinteger SourceSize = 0

If TexSegment <> &H80 Then
    SourceBuffer = RAM(TexSegment)._Data
    SourceSize = RAM(TexSegment)._Size
Else
    SourceBuffer = RDRAM._Data
    SourceSize = RDRAM._Size
End If

 	'if(System.Options & BRDP_TEXCRC) {
	'	Texture[TextureID].CRC32 = crc_GenerateCRC(SourceBuffer, SourceSize);
	'} else {
	'	Texture[TextureID].CRC32 = 0;
	'}

 
	If RDP_CheckAddressValidity(Texture(TextureID).Offset) = 0 Then
	    i = 0
	    Do While i < BufferSize
		TextureData[i] = &HFF
		TextureData[i + 1] = &H00
		TextureData[i + 2] = &H00
		TextureData[i + 3] = &HFF
		i += 4
	    Loop
	    
	    
	    ElseIf (_system.Options And BRDP_TEXTURES) = 0 Then
                MemSet(TextureData, &HFF, BufferSize) 
                
                
 
Else
    Select Case Texture(TextureID)._Format
        Case &H00, &H08, &H10
            Dim As UShort Raw
            Dim As Uinteger _RGBA = 0

            For j As integer = 0 To Texture(TextureID)._Height - 1
                For i As integer = 0 To Texture(TextureID)._Width - 1
                    Raw = (SourceBuffer[TexOffset] Shl 8) Or SourceBuffer[TexOffset + 1]
                  '   msk_consoleprint(0,"RAWCOL: %#06X",Raw)
                    _RGBA = ((Raw And &HF800) Shr 8) Shl 24
                    _RGBA or= (((Raw And &H7C0) Shl 5) Shr 8) Shl 16
                    _RGBA or= (((Raw And &H3E) Shl 18) Shr 16) Shl 8
                    If (Raw And &H1) Then _RGBA or= &HFF
                    
                   ' msk_consoleprint(0,"FINALCOL: %#010X",_RGBA)
                    
                    Write32(TextureData, GLTexPosition, _RGBA)

                    TexOffset += 2
                    GLTexPosition += 4
		    
                    If TexOffset >= SourceSize Then Exit For
                Next
                TexOffset += Texture(TextureID).LineSize * 4 - Texture(TextureID)._Width
            Next
            
       Case &H18
            memcpy(TextureData, SourceBuffer , (Texture(TextureID)._Height * Texture(TextureID)._Width * 4))
            
            
        Case &H40, &H50
            Dim As Uinteger CI1, CI2
            Dim As Uinteger _RGBA = 0
 
            For j As integer = 0 To Texture(TextureID)._Height - 1
                For i As integer = 0 To Texture(TextureID)._Width \ 2 - 1
                    CI1 = (SourceBuffer[TexOffset] And &HF0) Shr 4
                    CI2 = SourceBuffer[TexOffset] And &HF

                    _RGBA =  (_Palette(CI1).R Shl 24)
                    _RGBA or= (_Palette(CI1).G Shl 16)
                    _RGBA or= (_Palette(CI1).B Shl 8)
                    _RGBA or= _Palette(CI1).A
                    Write32(TextureData, GLTexPosition, _RGBA)

                    _RGBA = (_Palette(CI2).R Shl 24)
                    _RGBA or= (_Palette(CI2).G Shl 16)
                    _RGBA or= (_Palette(CI2).B Shl 8)
                    _RGBA or=  _Palette(CI2).A
                    Write32(TextureData, GLTexPosition + 4, _RGBA)

                    TexOffset += 1
                    GLTexPosition += 8

                    If TexOffset >= SourceSize Then Exit For
                Next
                TexOffset += Texture(TextureID).LineSize * 8 - (Texture(TextureID)._Width \ 2)
            Next
            
            case &H68
            'beep
                       Dim As UShort Raw
            Dim As Uinteger _RGBA = 0

            For j As integer = 0 To Texture(TextureID)._Height - 1
                For i As integer = 0 To Texture(TextureID)._Width - 1
 
						Raw = SourceBuffer[TexOffset]
						_RGBA = (((Raw and &HF0) + &H0F) shl 24)
						_RGBA or= (((Raw and &HF0) + &H0F) shl 16)
						_RGBA or= (((Raw and &HF0) + &H0F) shl 8)
						_RGBA or= ((Raw and &H0F) shl 4)
						Write32(TextureData, GLTexPosition, _RGBA)

						TexOffset += 1
						GLTexPosition += 4

						if(TexOffset >= SourceSize) then exit select
					next
					TexOffset += Texture(TextureID).LineSize * 8 -Texture(TextureID)._Width
				next
            case &H48
                             Dim As UShort Raw
            Dim As Uinteger _RGBA = 0


            For j As integer = 0 To Texture(TextureID)._Height - 1
                For i As integer = 0 To Texture(TextureID)._Width - 1
						Raw = SourceBuffer[TexOffset]

						_RGBA = (_Palette(Raw).R shl 24)
						_RGBA or= (_Palette(Raw).G shl 16)
						_RGBA or= (_Palette(Raw).B shl 8)
						_RGBA or= _Palette(Raw).A
						Write32(TextureData, GLTexPosition, _RGBA)

						TexOffset += 1
						GLTexPosition += 4

						if(TexOffset >= SourceSize) then exit select
					next
					TexOffset += Texture(TextureID).LineSize * 8 - Texture(TextureID)._Width
				next
 
            
        Case Else
        'beep
     memset(TextureData, &HFF, BufferSize)
 end select
 
 end if
 

glBindTexture(GL_TEXTURE_2D, Gfx.GLTextureID(Gfx.GLTextureCount))

glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, IIf(Texture(TextureID).clamps, GL_CLAMP_TO_EDGE, GL_REPEAT))
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, IIf(Texture(TextureID).clampt, GL_CLAMP_TO_EDGE, GL_REPEAT))
 


 If Texture(TextureID).mirrors Andalso OpenGL.Ext_TexMirroredRepeat Then
     glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_MIRRORED_REPEAT_ARB)
 End If

 If Texture(TextureID).mirrort Andalso OpenGL.Ext_TexMirroredRepeat Then
     glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_MIRRORED_REPEAT_ARB)
 End If

glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, Texture(TextureID).RealWidth, Texture(TextureID).RealHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, TextureData)

	
	
	/'switch(Texture[TextureID].CMS) {
		case G_TX_CLAMP:
		case 3:
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
			break;
		case G_TX_MIRROR:
			if(OpenGL.Ext_TexMirroredRepeat) glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_MIRRORED_REPEAT_ARB);
			break;
		case G_TX_WRAP:
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
			break;
		default:
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
			break;
	}

	switch(Texture[TextureID].CMT) {
		case G_TX_CLAMP:
		case 3:
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
			break;
		case G_TX_MIRROR:
			if(OpenGL.Ext_TexMirroredRepeat) glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_MIRRORED_REPEAT_ARB);
			break;
		case G_TX_WRAP:
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
			break;
		default:
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
			break;
	}
'/
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)

	'if(TextureID == 0) 
	 TextureCache(_System.TextureCachePosition).MaterialID = RDP_Dump_CreateMaterial(TextureData, Texture(TextureID)._Format, Texture(TextureID).Offset, Texture(TextureID).RealWidth, Texture(TextureID).RealHeight, (Texture(TextureID).CMS and G_TX_MIRROR), (Texture(TextureID).CMT and G_TX_MIRROR))

	free(TextureData)

/'	if(RDP_GetPhysicalAddress(Texture[TextureID].Offset) > 0x80260000) {
		dbgprintf(0,0,"%s -> %08x (phy:%08x), h:%i, w:%i (v?:%i)",
			__FUNCTION__,Texture[TextureID].Offset,RDP_GetPhysicalAddress(Texture[TextureID].Offset),
			Texture[TextureID].RealHeight,Texture[TextureID].RealWidth,
			RDP_CheckAddressValidity(Texture[TextureID].Offset));
	}'/

	
	
	
	
	dim oldcount as GLuint = Gfx.GLTextureCount
	Gfx.GLTextureCount+=1
	return Gfx.GLTextureID(oldcount)
	
end function

'maybe inline?
Function RDP_Pow2(_dim As Uinteger) As Uinteger
    Dim i As Uinteger = 1

    Do While i < _dim
        i = i Shl 1
    Loop

    Return i
End Function

'maybe inline?
Function RDP_PowOf(_dim As Uinteger) As Uinteger
    Dim num As Uinteger = 1
    Dim i As Uinteger = 0

    Do While num < _dim
        num = num Shl 1
        i = i + 1
    Loop

    Return i
End Function
 
 
Sub RDP_InitLoadTexture()

   
	If OpenGL.Ext_MultiTexture Andalso do_arb Then
	' beep
 	If Texture(0).Offset <> &H00 Then
		
		 	RDP_CalcTextureSize(0)
			'beep
			glEnable(GL_TEXTURE_2D)
			'glDisable(GL_TEXTURE_2D)
			glActiveTextureARB(GL_TEXTURE0_ARB)
			glBindTexture(GL_TEXTURE_2D, RDP_CheckTextureCache(0))
		End If
		
		If Gfx.IsMultiTexture Andalso Texture(1).Offset <> &H00 Then
		'beep
			RDP_CalcTextureSize(1)
			'beep
			glEnable(GL_TEXTURE_2D)
			glActiveTextureARB(GL_TEXTURE1_ARB)
			glBindTexture(GL_TEXTURE_2D, RDP_CheckTextureCache(1))
		Else
		 'beep
			glActiveTextureARB(GL_TEXTURE1_ARB)
			glDisable(GL_TEXTURE_2D)
			glActiveTextureARB(GL_TEXTURE0_ARB)
			'glDisable(GL_TEXTURE_2D)
			
		End If 
	Else
	'beep
		If Texture(0).Offset <> &H00 Then
			  RDP_CalcTextureSize(0)
			'//'beep
			 glEnable(GL_TEXTURE_2D)
			 glBindTexture(GL_TEXTURE_2D, RDP_CheckTextureCache(0))
			' msk_consoleprint(0,"TEX0: %i",RDP_CheckTextureCache(0))
		End If
		
	    '   If If Gfx.IsMultiTexture andalso Texture(1).Offset <> &H00 Then
			'   RDP_CalcTextureSize(1)
			''beep
			'  glenable(GL_TEXTURE_2D)
			''msk_consoleprint(0,"TEX1: %i",RDP_CheckTextureCache(1))
			
	                ' glBindTexture(GL_TEXTURE_2D, RDP_CheckTextureCache(1))
		' End If
	 End If
	 
End Sub


Sub RDP_ChangeTileSize(Tile As Uinteger, ULS As Uinteger, ULT As Uinteger, LRS As Uinteger, LRT As Uinteger)
	Texture(Gfx.CurrentTexture).Tile = Tile
	Texture(Gfx.CurrentTexture).ULS = _SHIFTR(ULS, 2, 10)
	Texture(Gfx.CurrentTexture).ULT = _SHIFTR(ULT, 2, 10)
	Texture(Gfx.CurrentTexture).LRS = _SHIFTR(LRS, 2, 10)
	Texture(Gfx.CurrentTexture).LRT = _SHIFTR(LRT, 2, 10)

end sub

sub RDP_InitParser(UcodeID as integer)
Dim As integer i
For i = 0 To 255
    RDP_UcodeCmd(i) = @RDP_UnemulatedCmd
Next

RDP_UcodeCmd(G_SETCIMG)         = @RDP_G_SETCIMG
RDP_UcodeCmd(G_SETZIMG)         = @RDP_G_SETZIMG
RDP_UcodeCmd(G_SETTIMG)         = @RDP_G_SETTIMG
RDP_UcodeCmd(G_SETCOMBINE)      = @RDP_G_SETCOMBINE
RDP_UcodeCmd(G_SETENVCOLOR)     = @RDP_G_SETENVCOLOR
RDP_UcodeCmd(G_SETPRIMCOLOR)    = @RDP_G_SETPRIMCOLOR
RDP_UcodeCmd(G_SETBLENDCOLOR)   = @RDP_G_SETBLENDCOLOR
RDP_UcodeCmd(G_SETFOGCOLOR)     = @RDP_G_SETFOGCOLOR
RDP_UcodeCmd(G_SETFILLCOLOR)    = @RDP_G_SETFILLCOLOR
RDP_UcodeCmd(G_FILLRECT)        = @RDP_G_FILLRECT
RDP_UcodeCmd(G_SETTILE)         = @RDP_G_SETTILE
RDP_UcodeCmd(G_LOADTILE)        = @RDP_G_LOADTILE
RDP_UcodeCmd(G_LOADBLOCK)       = @RDP_G_LOADBLOCK
RDP_UcodeCmd(G_SETTILESIZE)     = @RDP_G_SETTILESIZE
RDP_UcodeCmd(G_LOADTLUT)        = @RDP_G_LOADTLUT
RDP_UcodeCmd(G_RDPSETOTHERMODE) = @RDP_G_RDPSETOTHERMODE
RDP_UcodeCmd(G_SETPRIMDEPTH)    = @RDP_G_SETPRIMDEPTH
RDP_UcodeCmd(G_SETSCISSOR)      = @RDP_G_SETSCISSOR
RDP_UcodeCmd(G_SETCONVERT)      = @RDP_G_SETCONVERT
RDP_UcodeCmd(G_SETKEYR)         = @RDP_G_SETKEYR
RDP_UcodeCmd(G_SETKEYGB)        = @RDP_G_SETKEYGB
RDP_UcodeCmd(G_RDPFULLSYNC)     = @RDP_G_RDPFULLSYNC
RDP_UcodeCmd(G_RDPTILESYNC)     = @RDP_G_RDPTILESYNC
RDP_UcodeCmd(G_RDPPIPESYNC)     = @RDP_G_RDPPIPESYNC
RDP_UcodeCmd(G_RDPLOADSYNC)     = @RDP_G_RDPLOADSYNC
RDP_UcodeCmd(G_TEXRECTFLIP)     = @RDP_G_TEXRECTFLIP
RDP_UcodeCmd(G_TEXRECT)         = @RDP_G_TEXRECT


Select Case UcodeID
     Case F3D
         RDP_F3D_Init()
     Case F3DEX
        RDP_F3DEX_Init()
     Case F3DEX2
       RDP_F3DEX2_Init()
    Case Else
End Select

Matrix.ModelStackSize = G_MTX_STACKSIZE

Gfx.Update Or= CHANGED_MULT_MAT

'crc_GenerateTable()

Matrix.UseMatrixHack = False
end sub

Sub RDP_LoadToSegment(Segment As UByte, Buffer As UByte Ptr, Offset As integer, _Size As integer)
	if(Segment >= MAX_SEGMENTS) then return

	RAM(segment).SourceOffset = Offset
	RAM(segment).SourceCompType = 0

	RAM(segment)._Data = cast(ubyte ptr, malloc (sizeof(byte) * _Size))
       
       ' MSK_consoleprint(0,"%i",segment)
        
	dim as uinteger ID = Read32(Buffer, Offset)
	if(ID = &H59617A30) then
		RAM(Segment).SourceCompType = 1
		'RDP_Yaz0Decode(&Buffer[Offset], RAM[Segment].Data, Size);
	  elseif(ID = &H4D494F30) then
		RAM(Segment).SourceCompType = 2
		'RDP_MIO0Decode(&Buffer[Offset], RAM[Segment].Data, Size);
	  else 
 
		memcpy(RAM(Segment)._Data, @Buffer[offset], _Size)
	end if

	RAM(Segment).IsSet = true
	RAM(Segment)._Size = _Size
end sub

Sub RDP_LoadToRDRAM(Buffer As UByte Ptr, Size As integer)

end sub

Function RDP_SaveSegment(Segment As UByte, Buffer As UByte Ptr) As Boolean

end function

 Sub RDP_Yaz0Decode(_Input As UByte Ptr, _Output As UByte Ptr, DecSize As integer)
 
 end sub
 
 Sub RDP_MIO0Decode(_Input As UByte Ptr, _Output As UByte Ptr, DecSize As integer)
 
 
 end sub
 
Function RDP_CheckAddressValidity(Address As integer) As Boolean
 	 
 
	
	
	dim as ubyte segment = Address shr 24
	dim offset as uinteger = (Address and &H00FFFFFF)
	
	'msk_consoleprint(4,"%i",RAM(Segment)._Size)

	if((Segment >= MAX_SEGMENTS) andalso (Segment <> &H80)) then return false

	if(Segment <> &H80) then
		if((RAM(Segment).IsSet = false) orelse (RAM(Segment)._Size < Offset)) then return false 
	 else 
		if((RDRAM.IsSet = false) orelse (RDRAM._Size < Offset))then  return false
	end if

	return true
 end function
 
 Function RDP_GetPhysicalAddress(VAddress As integer) As integer
 
 end function
 
 Sub RDP_ClearSegment(Segment As UByte)
 	if(RAM(Segment).IsSet = true) then
		free(RAM(Segment)._Data)
		RAM(Segment).IsSet = false
		RAM(Segment)._Size = 0
	end if
 end sub
 
 Sub RDP_ClearRDRAM()
 	if(RDRAM.IsSet = true) then
		free(RDRAM._Data) 
		RDRAM.IsSet = false
		RDRAM._Size = 0
	end if
 end sub
 

 Sub RDP_ClearStructures(_Full As boolean)
 
 	dim as integer i = 0
 static Vertex_Empty as const __Vertex   = ( ( 0, 0, 0, 0, 0, 0, 0, 0, 0 ), 0.0f, 0.0f, 0.0f, 0.0f )
 	i = 0
	Do While i < ArraySize(Vertex)
	    Vertex(i) = Vertex_Empty
	    i +=1
	Loop
 
  static  Palette_Empty  as const __palette = (0,0,0,0)
  
   	i = 0
	Do While i < ArraySize(_palette)
	    _palette(i) =  Palette_Empty
	    i +=1
	Loop
  
  	'static Texture_Empty as  const __Texture  = ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ((0, 0, 0, 0, 0, 0)), 0.0f, 0.0f, 0.0f, 0.0f )
	'Texture(0) = Texture_Empty
	'Texture(1) = Texture_Empty
	
 	Gfx.BlendColor =	type<__RGBA>( 0.0f, 0.0f, 0.0f, 0.0f )
	Gfx.FogColor   =	type<__RGBA>( 0.0f, 0.0f, 0.0f, 0.0f )
	Gfx.EnvColor =		type<__RGBA>( 0.5f, 0.5f, 0.5f, 0.5f )
	Gfx.FillColor =		type<__FillColor>( 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f )
	Gfx.PrimColor =		type<__PrimColor>( 0.5f, 0.5f, 0.5f, 0.5f, 0.0f, 0 )


	if(OpenGL.Ext_FragmentProgram) then
		glProgramEnvParameter4fARB(GL_FRAGMENT_PROGRAM_ARB, 0, Gfx.EnvColor.R, Gfx.EnvColor.G, Gfx.EnvColor.B, Gfx.EnvColor.A)
		glProgramEnvParameter4fARB(GL_FRAGMENT_PROGRAM_ARB, 1, Gfx.PrimColor.R, Gfx.PrimColor.G, Gfx.PrimColor.B, Gfx.PrimColor.A)
		glProgramEnvParameter4fARB(GL_FRAGMENT_PROGRAM_ARB, 2, Gfx.PrimColor.L, Gfx.PrimColor.L, Gfx.PrimColor.L, Gfx.PrimColor.L)
	end if

        Gfx.DLStackPos = 0

	Gfx.Update = &HFFFFFFFF
	Gfx.GeometryMode = 0
	Gfx.OtherMode.L = 0
	Gfx.OtherMode.H = 0
	Gfx.Store_RDPHalf1 = 0: Gfx.Store_RDPHalf2 = 0
	Gfx.Combiner0 = 0: Gfx.Combiner1 = 0

	Gfx.CurrentTexture = 0
	Gfx.IsMultiTexture = false

	Texture(0).ScaleS = 1.0f
	Texture(0).ScaleT = 1.0f
	Texture(1).ScaleS = 1.0f
	Texture(1).ScaleT = 1.0f

	Texture(0).ShiftScaleS = 1.0f
	Texture(0).ShiftScaleT = 1.0f
	Texture(1).ShiftScaleS = 1.0f
	Texture(1).ShiftScaleT = 1.0f





    	if(_Full) then
           static   FragmentCache_Empty  as  const __FragmentCache = (0,0,-1)
 
		i = 0
		Do While i < ArraySize(FragmentCache)
		    If OpenGL.Ext_FragmentProgram Then glDeleteProgramsARB(1, @FragmentCache(i).ProgramID)
		    FragmentCache(i) = FragmentCache_Empty
		    i += 1
		Loop
_System.FragCachePosition = 0
    static  TextureCache_Empty as const  __TextureCache  = (0,0,0,-1)
		i = 0
		Do While i < ArraySize(TextureCache)
		    TextureCache(i) = TextureCache_Empty
		    i += 1
		Loop
		
	end if
	_System.TextureCachePosition = 0
	
End Sub

 
Sub RDP_ParseDisplayList(Address As integer, ResetStack As Boolean)
 
    If RDP_CheckAddressValidity(Address) = 0 Then
        Return
    End If

    DListAddress = Address

    RDP_SetRenderMode(0, 0)
   Gfx.OtherMode.cycleType = G_CYC_2CYCLE

    If ResetStack Then
        Gfx.DLStackPos = 0

        glDisable(GL_TEXTURE_2D)
        If OpenGL.Ext_MultiTexture Andalso do_arb Then
            glActiveTextureARB(GL_TEXTURE0_ARB)
            glDisable(GL_TEXTURE_2D)
            glActiveTextureARB(GL_TEXTURE1_ARB)
            glDisable(GL_TEXTURE_2D)
            glActiveTextureARB(GL_TEXTURE0_ARB)
        End If
    End If

    glPolygonMode(GL_FRONT_AND_BACK, IIf((_System.Options And BRDP_WIREFRAME) <> 0, GL_LINE, GL_FILL))

    If OpenGL.Ext_FragmentProgram Then
        glDisable(GL_FRAGMENT_PROGRAM_ARB)
    End If
    
  '  RDP_Dump_InitModelDumping(".","Dlist_0x" + hex(Address,8) + ".obj","Dlist_0x" + hex(Address,8) + ".mtl")
    RDP_Dump_BeginGroup(Address)

    Do While Gfx.DLStackPos >= 0
    Dim OldAddr As Uinteger = DListAddress
    OldAddr = DListAddress
    DListAddress = RDP_Macro_DetectMacro(DListAddress)
    
    If OldAddr = DListAddress Then
  
        Dim Segment As Uinteger = DListAddress Shr 24
        Dim Offset As Uinteger = DListAddress And &H00FFFFFF

        If Segment <> &H80 Then
            w0 = Read32(RAM(Segment)._Data, Offset)
            w1 = Read32(RAM(Segment)._Data, Offset + 4)

            wp0 = Read32(RAM(Segment)._Data, Offset - 8)
            wp1 = Read32(RAM(Segment)._Data, Offset - 4)

            wn0 = Read32(RAM(Segment)._Data, Offset + 8)
            wn1 = Read32(RAM(Segment)._Data, Offset + 12)
            
           ' msk_consoleprint(3, "RAM: %#010X%08X",w0,w1)
        Else
            w0 = Read32(RDRAM._Data, Offset)
            w1 = Read32(RDRAM._Data, Offset + 4)

            wp0 = Read32(RDRAM._Data, Offset - 8)
            wp1 = Read32(RDRAM._Data, Offset - 4)

            wn0 = Read32(RDRAM._Data, Offset + 8)
            wn1 = Read32(RDRAM._Data, Offset + 12)
            
         '   msk_consoleprint(3, "RDAM: %#010X%08X",w0,w1)
        End If

        DListAddress += 8

      '   MSK_ConsolePrint(3, "ucode: %#04X",w0 shr 24)
        RDP_UcodeCmd(w0 Shr 24)()
    End If
    
    
    
    Loop
          '  msk_consoleprint(3, "OUTOFLOOP")
     
   ' RDP_Dump_StopModelDumping()
End Sub

 
  


Sub RDP_DrawTriangle(Vtxs As integer Ptr)
    If Gfx.Update Then RDP_UpdateGLStates()
 
 
    glBegin(GL_TRIANGLES)
    Dim As integer i = 0
    For i = 0 To 3 - 1
      ' // Vertex(Vtxs[i]).RealS0 = Vertex(Vtxs[i]).Vtx.X / 64.0
      ' // Vertex(Vtxs[i]).RealT0 = Vertex(Vtxs[i]).Vtx.Y / 16.0

     '  // If isnan(Vertex(Vtxs[i]).RealS0) Then Vertex(Vtxs[i]).RealS0 = 0.0
      ' // If isnan(Vertex(Vtxs[i]).RealT0) Then Vertex(Vtxs[i]).RealT0 = 0.0

        Vertex(Vtxs[i]).RealS0 = _FIXED2FLOAT(Vertex(Vtxs[i]).Vtx.S, 16) * (Texture(0).ScaleS * Texture(0).ShiftScaleS) / 32.0f / _FIXED2FLOAT(Texture(0).RealWidth, 16)
        Vertex(Vtxs[i]).RealT0 = _FIXED2FLOAT(Vertex(Vtxs[i]).Vtx.T, 16) * (Texture(0).ScaleT * Texture(0).ShiftScaleT) / 32.0f / _FIXED2FLOAT(Texture(0).RealHeight, 16)
        Vertex(Vtxs[i]).RealS1 = _FIXED2FLOAT(Vertex(Vtxs[i]).Vtx.S, 16) * (Texture(1).ScaleS * Texture(1).ShiftScaleS) / 32.0f / _FIXED2FLOAT(Texture(1).RealWidth, 16)
        Vertex(Vtxs[i]).RealT1 = _FIXED2FLOAT(Vertex(Vtxs[i]).Vtx.T, 16) * (Texture(1).ScaleT * Texture(1).ShiftScaleT) / 32.0f / _FIXED2FLOAT(Texture(1).RealHeight, 16)
 
        If IsInfinite(Vertex(Vtxs[i]).RealS0) orelse __IsNan(Vertex(Vtxs[i]).RealS0) Then Vertex(Vtxs[i]).RealS0 = 0.0f
        If IsInfinite(Vertex(Vtxs[i]).RealT0)  orelse __IsNan(Vertex(Vtxs[i]).RealT0) Then Vertex(Vtxs[i]).RealT0 = 0.0f
        If IsInfinite(Vertex(Vtxs[i]).RealS1)  orelse __IsNan(Vertex(Vtxs[i]).RealS1) Then Vertex(Vtxs[i]).RealS1 = 0.0f
        If IsInfinite(Vertex(Vtxs[i]).RealT1) orelse __IsNan(Vertex(Vtxs[i]).RealT1) Then Vertex(Vtxs[i]).RealT1 = 0.0f

 

        If (Gfx.GeometryMode And G_TEXTURE_GEN_LINEAR) = 0 Then
            If OpenGL.Ext_MultiTexture Andalso do_arb Then
              glMultiTexCoord2fARB(GL_TEXTURE0_ARB, Vertex(Vtxs[i]).RealS0, Vertex(Vtxs[i]).RealT0)
             glMultiTexCoord2fARB(GL_TEXTURE1_ARB, Vertex(Vtxs[i]).RealS1, Vertex(Vtxs[i]).RealT1)
            Else
           glTexCoord2f(Vertex(Vtxs[i]).RealS0, Vertex(Vtxs[i]).RealT0)
            End If
        End If
        
     
        glNormal3b(Vertex(Vtxs[i]).Vtx.R, Vertex(Vtxs[i]).Vtx.G, Vertex(Vtxs[i]).Vtx.B)
     ' glColor4f(1.0, 1.0, 1.0, 1.0)
        If (Gfx.GeometryMode And G_LIGHTING) = 0 Then
          glColor4ub(Vertex(Vtxs[i]).Vtx.R, Vertex(Vtxs[i]).Vtx.G, Vertex(Vtxs[i]).Vtx.B, Vertex(Vtxs[i]).Vtx.A)
        End If

        glVertex3d(Vertex(Vtxs[i]).Vtx.X, Vertex(Vtxs[i]).Vtx.Y, Vertex(Vtxs[i]).Vtx.Z)
    Next 
          RDP_Dump_DumpTriangle(@Vertex(0), Vtxs)
    glEnd()
End Sub




sub RDP_SetRenderMode(Mode1 as uinteger,Mode2  as uinteger)
	Gfx.OtherMode.L and= &H00000007
	Gfx.OtherMode.L or= Mode1 or Mode2

	Gfx.Update or= CHANGED_RENDERMODE
end sub

sub RDP_SetCycleType(_Type as uinteger)
 	Gfx.OtherMode.cycleType = _Type
 end sub
 
 Sub RDP_SetPrimColor(R As UByte, G As UByte, B As UByte, A As UByte)
 	dim as uinteger  _Color = (R shl 24) or (G shl 16) or (B shl 8) or A
	'gDP_SetPrimColor(0, _Color)
 end sub
 


 sub RDP_SetRendererOptions(options as ubyte)

	_System.Options = Options
	if((_System.Options and BRDP_DISABLESHADE) = 0) then
	
		glEnable(GL_LIGHTING)
		glEnable(GL_NORMALIZE)
	
	else
	
		glDisable(GL_LIGHTING)
		glDisable(GL_NORMALIZE)
	end if
end sub

function RDP_GetRendererOptions() as ubyte

	return _System.Options
end function
 
Sub RDP_ToggleMatrixHack()
Matrix.UseMatrixHack xor= 1
 end sub
 
Sub RDP_DisableARB()
do_arb = false
 end sub

Sub RDP_EnableARB()

do_arb = true
 end sub


