'FINISHED//////////////////////////////////




#include "globals.bi"

#include "macro_def.bi"
#include "misaka.bi"
Dim Shared As UByte Segment
Dim Shared As Uinteger Offset
Dim Shared As UByte NextCmds(32)
Dim Shared As Uinteger nw0(32), nw1(32)


Function RDP_Macro_DetectMacro(Addr as uinteger) as uinteger
    Dim as integer i, j, MaxMacroLen = 0

    i = 0
    Do While i < ArraySize(GfxMacros)
        If GfxMacros(i)._Len > MaxMacroLen Then
            MaxMacroLen = GfxMacros(i)._Len
        End If
        i += 1
    Loop
    
    'msk_consoleprint(1, "%#018X", MaxMacroLen)
	' msk_consoleprint(1, "%#018X",  Addr + (MaxMacroLen * 8))

	    
    If RDP_CheckAddressValidity(Addr + (MaxMacroLen * 8)) = 0 Then
    'beep
        Return Addr
    End If
    
'msk_consoleprint(1, "%#018X",  Addr)

    Segment = Addr shr 24
    Offset = (Addr and &H00FFFFFF)

    i = 0
    Do While i < MaxMacroLen
        If Segment <> &H80 Then
            NextCmds(i) = RAM(Segment)._Data[Offset + (i * 8)]
        Else
            NextCmds(i) = RDRAM._Data[Offset + (i * 8)]
        End If
        i += 1
    Loop



 


    i = 0
    Do While i < ArraySize(GfxMacros)
        If memcmp(@GfxMacros(i)._Cmd(0), @NextCmds(0), GfxMacros(i)._Len) = 0 Then
        
            j = 0
            Do While j < GfxMacros(i)._Len + 1
                If Segment <> &H80 Then
                    nw0(j) = Read32(RAM(Segment)._Data, Offset)
                    nw1(j) = Read32(RAM(Segment)._Data, Offset + 4)
                  '  msk_consoleprint(1, "%#010X%08X", nw0(j),nw1(j))
                Else
                    nw0(j) = Read32(RDRAM._Data, Offset)
                    nw1(j) = Read32(RDRAM._Data, Offset + 4)
                    'msk_consoleprint(1, "%#010X%08X", nw0(j),nw1(j))
                End If
                Offset += 8
                j += 1
            Loop
            isMacro = True
          
            GfxMacros(i).Func()

            Addr += GfxMacros(i)._Len * 8
            
 
            Return Addr
        End If
        i += 1
    Loop
     	
    isMacro = false
	
    Return Addr
    
    
End Function



sub RDP_Macro_LoadTLUT()
 ' msk_consoleprint(1, "TLUT" )
	 gDP_SetTImg(nw0(0), nw1(0))
	 gDP_LoadTLUT(nw0(4), nw1(4))

	 RDP_InitLoadTexture()
end sub


sub RDP_Macro_LoadTextureSF64()
 
	Gfx.CurrentTexture = iif(nw0(1) and &H0F00,1,0) 
	Gfx.IsMultiTexture = Gfx.CurrentTexture
 
 'if do_arb = true then  msk_consoleprint(3,"do_arb = true") else msk_consoleprint(3,"do_arb = false")
'if  Gfx.IsMultiTexture = true then  msk_consoleprint(3,"Gfx.IsMultiTexture = true")  else msk_consoleprint(3,"IsMultiTexture = false")
	
	 gDP_SetTImg(nw0(3), nw1(3))
	 gDP_SetTile(nw0(1), nw1(1))
         gDP_SetTileSize(nw0(2), nw1(2))

	if(Gfx.IsMultiTexture) then
		Gfx.EnvColor = type<__RGBA>(0.5f,0.5f,0.5f,0.5f)
	 else 
		Gfx.EnvColor = type<__RGBA>(1.0f,1.0f,0.5f,0.75f)
	end if
	if(OpenGL.Ext_FragmentProgram) then glProgramEnvParameter4fARB(GL_FRAGMENT_PROGRAM_ARB, 0, Gfx.EnvColor.R, Gfx.EnvColor.G, Gfx.EnvColor.B, Gfx.EnvColor.A)
	'beep
	 RDP_InitLoadTexture()
end sub

sub RDP_Macro_LoadTextureBlock()

	Gfx.CurrentTexture = iif(nw0(1) and &H0F00,1,0) 
	Gfx.IsMultiTexture = Gfx.CurrentTexture
 
'if do_arb = true then  msk_consoleprint(3,"do_arb = true") else msk_consoleprint(3,"do_arb = false")
'if  Gfx.IsMultiTexture = true then  msk_consoleprint(3,"Gfx.IsMultiTexture = true")  else msk_consoleprint(3,"IsMultiTexture = false")



	 gDP_SetTImg(nw0(0), nw1(0))
	  gDP_SetTile(nw0(5), nw1(5))
	  gDP_SetTileSize(nw0(6), nw1(6))

	'// texture is CI and palette will be loaded after this!
	if((Texture(Gfx.CurrentTexture)._Format = &H40) orelse (Texture(Gfx.CurrentTexture)._Format = &H48) orelse (Texture(Gfx.CurrentTexture)._Format = &H50))  then
		if((nw0(7) shr 24) = G_SETTIMG) then return
	end if
/'
	if(Gfx.IsMultiTexture) then
		Gfx.EnvColor = type<__RGBA>(0.5f,0.5f,0.5f,0.5f)
	 else 
		Gfx.EnvColor =type<__RGBA>(1.0f,1.0f,0.5f,0.75f)
	end if
	if(OpenGL.Ext_FragmentProgram) glProgramEnvParameter4fARB(GL_FRAGMENT_PROGRAM_ARB, 0, Gfx.EnvColor.R, Gfx.EnvColor.G, Gfx.EnvColor.B, Gfx.EnvColor.A);
'/
	 RDP_InitLoadTexture()
end sub

