#include "globals.bi"
#include "misaka.bi"






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

Dim Shared G_TEXTURE_ENABLE As UInteger
Dim Shared G_SHADING_SMOOTH As UInteger
Dim Shared G_CULL_FRONT As UInteger
Dim Shared G_CULL_BACK As UInteger
Dim Shared G_CULL_BOTH As UInteger
Dim Shared G_CLIPPING As UInteger

Dim Shared G_MTX_STACKSIZE As UInteger
Dim Shared G_MTX_MODELVIEW As UInteger
Dim Shared G_MTX_PROJECTION As UInteger
Dim Shared G_MTX_MUL As UInteger
Dim Shared G_MTX_LOAD As UInteger
Dim Shared G_MTX_NOPUSH As UInteger
Dim Shared G_MTX_PUSH As UInteger

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

dim shared as boolean do_arb 
dim shared as boolean isMacro



Dim Shared As RDPInstruction RDP_UcodeCmd(256)

Dim Shared As UInteger DListAddress
Dim Shared As UByte Segment
Dim Shared As UInteger Offset

Dim Shared As UInteger wp0, wp1
Dim Shared As UInteger w0, w1
Dim Shared As UInteger wn0, wn1


Sub RDP_InitLoadTexture()
	If OpenGL.Ext_MultiTexture And do_arb Then
		If Texture(0).Offset <> &H00 Then
			'RDP_CalcTextureSize(0)
			glEnable(GL_TEXTURE_2D)
			glActiveTextureARB(GL_TEXTURE0_ARB)
			'glBindTexture(GL_TEXTURE_2D, RDP_CheckTextureCache(0))
		End If
		
		If Gfx.IsMultiTexture And Texture(1).Offset <> &H00 Then
			'RDP_CalcTextureSize(1)
			glEnable(GL_TEXTURE_2D)
			glActiveTextureARB(GL_TEXTURE1_ARB)
			'glBindTexture(GL_TEXTURE_2D, RDP_CheckTextureCache(1))
		Else
			glActiveTextureARB(GL_TEXTURE1_ARB)
			glDisable(GL_TEXTURE_2D)
			'glActiveTextureARB(GL_TEXTURE0_ARB)
		End If
	Else
		If Texture(0).Offset <> &H00 Then
			'RDP_CalcTextureSize(0)
			glEnable(GL_TEXTURE_2D)
			'glBindTexture(GL_TEXTURE_2D, RDP_CheckTextureCache(0))
		End If
	End If
End Sub



sub RDP_InitParser(UcodeID as integer)
Dim As Integer i
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

Sub RDP_LoadToSegment(Segment As UByte, Buffer As UByte Ptr, Offset As Integer, _Size As Integer)
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

Sub RDP_LoadToRDRAM(Buffer As UByte Ptr, Size As Integer)

end sub

Function RDP_SaveSegment(Segment As UByte, Buffer As UByte Ptr) As Boolean

end function

 Sub RDP_Yaz0Decode(_Input As UByte Ptr, _Output As UByte Ptr, DecSize As Integer)
 
 end sub
 
 Sub RDP_MIO0Decode(_Input As UByte Ptr, _Output As UByte Ptr, DecSize As Integer)
 
 
 end sub
 
Function RDP_CheckAddressValidity(Address As Integer) As Boolean
 	 
 
	
	
	dim as ubyte segment = Address shr 24
	dim offset as uinteger = (Address and &H00FFFFFF)
	
	

	if((Segment >= MAX_SEGMENTS) andalso (Segment <> &H80)) then return false

	if(Segment <> &H80) then
		if((RAM(Segment).IsSet = false) orelse (RAM(Segment)._Size < Offset)) then return false 
	 else 
		if((RDRAM.IsSet = false) orelse (RDRAM._Size < Offset))then  return false
	end if

	return true
 end function
 
 Function RDP_GetPhysicalAddress(VAddress As Integer) As Integer
 
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
 
 Sub RDP_ClearStructures(Full As Boolean)
 
 
 end sub
 
Sub RDP_ParseDisplayList(Address As Integer, ResetStack As Boolean)
    If RDP_CheckAddressValidity(Address) = 0 Then
        Return
    End If

    DListAddress = Address

    RDP_SetRenderMode(0, 0)
    ' Gfx.OtherMode.cycleType = G_CYC_2CYCLE

    If ResetStack Then
        Gfx.DLStackPos = 0

        glDisable(GL_TEXTURE_2D)
        If OpenGL.Ext_MultiTexture And do_arb Then
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

    RDP_Dump_BeginGroup(Address)

    

    Do While Gfx.DLStackPos >= 0
    Dim OldAddr As UInteger = DListAddress
    OldAddr = DListAddress
     'DListAddress = RDP_Macro_DetectMacro(DListAddress)
    
    If OldAddr = DListAddress Then
  
        Dim Segment As UInteger = DListAddress Shr 24
        Dim Offset As UInteger = DListAddress And &H00FFFFFF

        If Segment <> &H80 Then
            w0 = Read32(RAM(Segment)._Data, Offset)
            w1 = Read32(RAM(Segment)._Data, Offset + 4)

            wp0 = Read32(RAM(Segment)._Data, Offset - 8)
            wp1 = Read32(RAM(Segment)._Data, Offset - 4)

            wn0 = Read32(RAM(Segment)._Data, Offset + 8)
            wn1 = Read32(RAM(Segment)._Data, Offset + 12)
          msk_consoleprint(3, "%#010X%08X",w0,w1)
        Else
            w0 = Read32(RDRAM._Data, Offset)
            w1 = Read32(RDRAM._Data, Offset + 4)

            wp0 = Read32(RDRAM._Data, Offset - 8)
            wp1 = Read32(RDRAM._Data, Offset - 4)

            wn0 = Read32(RDRAM._Data, Offset + 8)
            wn1 = Read32(RDRAM._Data, Offset + 12)
    msk_consoleprint(3, "%#010X%08X",w0,w1)
        End If

        DListAddress += 8

       
        RDP_UcodeCmd(w0 Shr 24)()
    End If
    Loop
            msk_consoleprint(3, "OUTOFLOOP")
     
    
End Sub

 
 sub RDP_DrawTriangle(Vtx as integer ptr)
 
 end sub
 
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
	
	'else
	
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


