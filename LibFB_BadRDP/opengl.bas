'FINISHED////////////////////////////////////////////////////////////////////////////////////

#include "globals.bi"
#include "misaka.bi"

#inclib "FB_MISAKA"



'////////////////////////////////////////////////////////////////////////////////////////////


sub RDP_SetupOpenGL()

RDP_InitGLExtensions()
RDP_ResetOpenGL()

end sub

sub RDP_SetOpenGLDimensions(_Width As Integer, _Height As Integer)
	_System.DrawWidth = _Width
	_System.DrawHeight = _Height
end sub

sub RDP_ResetOpenGL()
glShadeModel(GL_SMOOTH)
glEnable(GL_POINT_SMOOTH)
glHint(GL_POINT_SMOOTH_HINT, GL_NICEST)

glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)

glClearColor(0.2f, 0.5f, 0.7f, 1.0f)
glClearDepth(5.0f)

glDepthFunc(GL_LEQUAL)
glEnable(GL_DEPTH_TEST)
glDepthMask(GL_TRUE)

glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)

dim as integer i
for i = 0 to 3
    Gfx.LightAmbient(i) = 1.0f
    Gfx.LightDiffuse(i) = 1.0f
    Gfx.LightSpecular(i) = 1.0f
    Gfx.LightPosition(i) = 1.0f
next i

glLightfv(GL_LIGHT0, GL_AMBIENT, @Gfx.LightAmbient(0))
glLightfv(GL_LIGHT0, GL_DIFFUSE, @Gfx.LightDiffuse(0))
glLightfv(GL_LIGHT0, GL_SPECULAR, @Gfx.LightSpecular(0))
glLightfv(GL_LIGHT0, GL_POSITION, @Gfx.LightPosition(0))
glEnable(GL_LIGHT0)

if (_System.Options and BRDP_DISABLESHADE) = 0 then
    glEnable(GL_LIGHTING)
    glEnable(GL_NORMALIZE)
end if

glEnable(GL_CULL_FACE)
glCullFace(GL_BACK)

glEnable(GL_BLEND)
glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

if OpenGL.Ext_FragmentProgram <> 0 then
    glProgramEnvParameter4fARB(GL_FRAGMENT_PROGRAM_ARB, 0, Gfx.EnvColor.R, Gfx.EnvColor.G, Gfx.EnvColor.B, Gfx.EnvColor.A)
    glProgramEnvParameter4fARB(GL_FRAGMENT_PROGRAM_ARB, 1, Gfx.PrimColor.R, Gfx.PrimColor.G, Gfx.PrimColor.B, Gfx.PrimColor.A)
    glProgramEnvParameter4fARB(GL_FRAGMENT_PROGRAM_ARB, 2, Gfx.PrimColor.L, Gfx.PrimColor.L, Gfx.PrimColor.L, Gfx.PrimColor.L)
end if

end sub

sub RDP_InitGLExtensions()

OpenGL.IsExtUnsupported = false


memset(@OpenGL.ExtSupported, &H00, sizeof(OpenGL.ExtSupported))



'OpenGL.ExtensionList = strdup(cast(const zstring ptr,glGetString(GL_EXTENSIONS)))
OpenGL.ExtensionList = strdup(Cast(const ZString Ptr, glGetString(GL_EXTENSIONS)))

MSK_ConsolePrint(1,"GL Version: %s",glGetString(GL_VERSION))
MSK_ConsolePrint(1,"GL Vendor: %s",glGetString(GL_VENDOR))
MSK_ConsolePrint(1,"GL Renderer: %s",glGetString(GL_RENDERER))
MSK_ConsolePrint(1,"GL Extensions: ")      ''%s", strdup(Cast(const ZString Ptr, glGetStringi(GL_EXTENSIONS,0))))    'Cast(const ZString Ptr, glGetString(GL_EXTENSIONS)))


'Dim As const GLubyte Ptr extensions = glGetString(GL_EXTENSIONS)
'If extensions <> NULL Then
'   Dim As const Byte Ptr extensionPtr = extensions
'   While *extensionPtr <> 0
'       ' Process each character or extension
'       Print Chr(*extensionPtr);
'       extensionPtr += 1
'   Wend
'End If  

 dim as integer i = 0
do while i < len(*OpenGL.ExtensionList)
    If OpenGL.ExtensionList[i] = " " Then OpenGL.ExtensionList[i] = !"\n"
    i+=1
loop

If strstr(OpenGL.ExtensionList, "GL_ARB_texture_mirrored_repeat") <> 0 Then

    OpenGL.Ext_TexMirroredRepeat = True
    sprintf(OpenGL.ExtSupported, !"%sGL_ARB_texture_mirrored_repeat\n", @OpenGL.ExtSupported)
    'MSK_ConsolePrint(1, !"%ssupported\n",OpenGL.ExtSupported)
Else
    OpenGL.IsExtUnsupported = True
    OpenGL.Ext_TexMirroredRepeat = False
    sprintf(OpenGL.ExtUnsupported, !"%sGL_ARB_texture_mirrored_repeat\n", @OpenGL.ExtUnsupported)
   ' MSK_ConsolePrint(0, !"%snot supported\n",OpenGL.ExtUnsupported)
End If

If strstr(OpenGL.ExtensionList, "GL_ARB_multitexture") <> Null Then
    OpenGL.Ext_MultiTexture = True
    #ifdef WIN32
    OpenGL.glMultiTexCoord1fARB = Cast(PFNGLMULTITEXCOORD1FARBPROC, wglGetProcAddress("glMultiTexCoord1fARB"))
    OpenGL.glMultiTexCoord2fARB = Cast(PFNGLMULTITEXCOORD2FARBPROC, wglGetProcAddress("glMultiTexCoord2fARB"))
    OpenGL.glMultiTexCoord3fARB = Cast(PFNGLMULTITEXCOORD3FARBPROC, wglGetProcAddress("glMultiTexCoord3fARB"))
    OpenGL.glMultiTexCoord4fARB = Cast(PFNGLMULTITEXCOORD4FARBPROC, wglGetProcAddress("glMultiTexCoord4fARB"))
    OpenGL.glActiveTextureARB = Cast(PFNGLACTIVETEXTUREARBPROC, wglGetProcAddress("glActiveTextureARB"))
    OpenGL.glClientActiveTextureARB = Cast(PFNGLCLIENTACTIVETEXTUREARBPROC, wglGetProcAddress("glClientActiveTextureARB"))
    #endif
    sprintf(OpenGL.ExtSupported, !"%sGL_ARB_multitexture\n", @OpenGL.ExtSupported)
       ' MSK_ConsolePrint(1, !"%ssupported\n",OpenGL.ExtSupported)
Else
    OpenGL.IsExtUnsupported = True
    OpenGL.Ext_MultiTexture = False
    sprintf(OpenGL.ExtUnsupported, !"%sGL_ARB_multitexture\n", @OpenGL.ExtUnsupported)
      '  MSK_ConsolePrint(0, !"%snot supported\n",OpenGL.ExtUnsupported)
End If

If strstr(OpenGL.ExtensionList, "GL_ARB_fragment_program") <> Null Then
    OpenGL.Ext_FragmentProgram = True
    #ifdef WIN32
    glGenProgramsARB = Cast(PFNGLGENPROGRAMSARBPROC, wglGetProcAddress("glGenProgramsARB"))
    glBindProgramARB = Cast(PFNGLBINDPROGRAMARBPROC, wglGetProcAddress("glBindProgramARB"))
    glDeleteProgramsARB = Cast(PFNGLDELETEPROGRAMSARBPROC, wglGetProcAddress("glDeleteProgramsARB"))
    glProgramStringARB = Cast(PFNGLPROGRAMSTRINGARBPROC, wglGetProcAddress("glProgramStringARB"))
    glProgramEnvParameter4fARB = Cast(PFNGLPROGRAMENVPARAMETER4FARBPROC, wglGetProcAddress("glProgramEnvParameter4fARB"))
    glProgramLocalParameter4fARB = Cast(PFNGLPROGRAMLOCALPARAMETER4FARBPROC, wglGetProcAddress("glProgramLocalParameter4fARB"))
    #else
    glGenProgramsARB = Cast(PFNGLGENPROGRAMSARBPROC, glXGetProcAddressARB("glGenProgramsARB"))
    'if glXGetProcAddressARB("gl B") = null then MSK_ConsolePrint(1, !"no address glGenProgramsARB\n")
      	
    glBindProgramARB = Cast(PFNGLBINDPROGRAMARBPROC, glXGetProcAddressARB("glBindProgramARB" ))
    glDeleteProgramsARB = Cast(PFNGLDELETEPROGRAMSARBPROC, glXGetProcAddressARB("glDeleteProgramsARB"))
    glProgramStringARB = Cast(PFNGLPROGRAMSTRINGARBPROC, glXGetProcAddressARB("glProgramStringARB"))
    glProgramEnvParameter4fARB = Cast(PFNGLPROGRAMENVPARAMETER4FARBPROC, glXGetProcAddressARB("glProgramEnvParameter4fARB"))
    glProgramLocalParameter4fARB = Cast(PFNGLPROGRAMLOCALPARAMETER4FARBPROC, glXGetProcAddressARB("glProgramLocalParameter4fARB"))
    #endif
    sprintf(OpenGL.ExtSupported, !"%sGL_ARB_fragment_program\n", @OpenGL.ExtSupported)
    '   MSK_ConsolePrint(1, !"%ssupported\n",OpenGL.ExtSupported)
Else
    OpenGL.IsExtUnsupported = True
    OpenGL.Ext_FragmentProgram = False
    sprintf(OpenGL.ExtUnsupported, !"%sGL_ARB_fragment_program\n", @OpenGL.ExtUnsupported)
'    MSK_ConsolePrint(0, !"%sunsupported\n",OpenGL.ExtUnsupported)
End If 
  	
  	
  	'if glXGetProcAddressARB("gl B") <> null then MSK_ConsolePrint(3, !"no address glGenProgramsARB\n")
  	
if OpenGL.ExtUnsupported <> "" then  MSK_ConsolePrint(2, !"%sunsupported\n",OpenGL.ExtUnsupported)
 

if OpenGL.ExtSupported <> "" then MSK_ConsolePrint(1, !"%ssupported\n",OpenGL.ExtSupported)

end sub

sub RDP_ClearTextures()
if(Gfx.GLTextureID(0)) then glDeleteTextures(Gfx.GLTextureCount, @Gfx.GLTextureID(0))
	Gfx.GLTextureCount = 0

	glGenTextures(CACHE_TEXTURES, @Gfx.GLTextureID(0))
end sub





sub RDP_UpdateGLStates()
	if(Gfx.Update and CHANGED_GEOMETRYMODE) then
		if(Gfx.GeometryMode and G_CULL_BOTH) then
			glEnable(GL_CULL_FACE)

			if(Gfx.GeometryMode and G_CULL_BACK) then
				glCullFace(GL_BACK)
			else
				glCullFace(GL_FRONT)
			end if
		  else 
			glDisable(GL_CULL_FACE)
		end if
		
		
		if((Gfx.GeometryMode and G_TEXTURE_GEN_LINEAR) andalso (Gfx.GeometryMode and G_LIGHTING) = 0 andalso (_System.Options and BRDP_DISABLESHADE)) then
			glShadeModel(GL_FLAT)
		  else 
			glShadeModel(GL_SMOOTH)
		end if

		if(Gfx.GeometryMode and G_TEXTURE_GEN) then
			glTexGeni(GL_S, GL_TEXTURE_GEN_MODE, GL_SPHERE_MAP)
			glTexGeni(GL_T, GL_TEXTURE_GEN_MODE, GL_SPHERE_MAP)
			glEnable(GL_TEXTURE_GEN_S)
			glEnable(GL_TEXTURE_GEN_T)
		 else
			glDisable(GL_TEXTURE_GEN_S)
			glDisable(GL_TEXTURE_GEN_T)
		end if
		
		/'
		if((Gfx.GeometryMode and G_SHADING_SMOOTH) orelse (Gfx.GeometryMode and G_TEXTURE_GEN_LINEAR) = 0) then
			glShadeModel(GL_SMOOTH)
		else
			glShadeModel(GL_FLAT)
		end if
                '/
                
                if(Gfx.GeometryMode and G_LIGHTING andalso (_System.Options and BRDP_DISABLESHADE)) then
			glEnable(GL_LIGHTING)
			glEnable(GL_NORMALIZE)
		else
			glDisable(GL_LIGHTING)
			glDisable(GL_NORMALIZE)
		end if

		Gfx.Update and= not(CHANGED_GEOMETRYMODE)
		
	 /'
	if(Gfx.GeometryMode & G_ZBUFFER) {
		glEnable(GL_DEPTH_TEST);
	} else {
		glDisable(GL_DEPTH_TEST);
	}
        '/
        
        if(Gfx.Update and CHANGED_RENDERMODE) then
 		if(Gfx.OtherMode.depthCompare) then
			glDepthFunc(GL_LEQUAL)
		 else 
			glDepthFunc(GL_ALWAYS)
		end if

		if(Gfx.OtherMode.depthUpdate) then
			glDepthMask(GL_TRUE)
		 else 
			glDepthMask(GL_FALSE)
		end if
 
		if(Gfx.OtherMode.depthMode = ZMODE_DEC) then
			glEnable(GL_POLYGON_OFFSET_FILL)
			glPolygonOffset(-3.0f, -3.0f)
		  else
			glDisable(GL_POLYGON_OFFSET_FILL)
		end if
	endif

	if((Gfx.Update and CHANGED_ALPHACOMPARE) orelse (Gfx.Update and CHANGED_RENDERMODE)) then
		if((Gfx.OtherMode.L and ALPHA_CVG_SEL) = 0) then
			glEnable(GL_ALPHA_TEST)
			glAlphaFunc(iif(Gfx.BlendColor.A > 0.0f, GL_GEQUAL, GL_GREATER), Gfx.BlendColor.A)

		  elseif(Gfx.OtherMode.L and CVG_X_ALPHA) then
			glEnable(GL_ALPHA_TEST)
			glAlphaFunc(GL_GEQUAL, 0.5f)

		  else
			glDisable(GL_ALPHA_TEST)
		 end if
	end if

	if(Gfx.Update and CHANGED_RENDERMODE) then
		if((Gfx.OtherMode.L and FORCE_BL) andalso (Gfx.OtherMode.L and ALPHA_CVG_SEL) = 0) then
			glEnable(GL_BLEND)

			select case(Gfx.OtherMode.L shr 16)
				case &H0448 '// Add
				        glBlendFunc(GL_ONE, GL_ONE)
				case &H055A:
					glBlendFunc(GL_ONE, GL_ONE)
					
				case &H0C08  '// 1080 Sky
				        glBlendFunc(GL_ONE, GL_ZERO)
				case &H0F0A '// Used LOTS of places
					glBlendFunc(GL_ONE, GL_ZERO)
					 
				case &HC810 '// Blends fog
				glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
				case &HC811 '// Blends fog
				glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
				case &H0C18 '// Standard interpolated blend
				glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
				case &H0C19 '// Used for antialiasing
				glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
				case &H0050 '// Standard interpolated blend
				glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
				case &H0055 '// Used for antialiasing
					glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
				case &H0FA5 '// Seems to be doing just blend color - maybe combiner can be used for this?
				glBlendFunc(GL_ZERO, GL_ONE)
				case &H5055 '// Used in Paper Mario intro, I'm not sure if this is right...
					glBlendFunc(GL_ZERO, GL_ONE)
					

				case else
					glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
				
			end select
		  else
			glDisable(GL_BLEND)
		end if

		Gfx.Update and= not(CHANGED_RENDERMODE)
	end if
	        
end if




end sub

Function RDP_OpenGL_ExtFragmentProgram() As Boolean
return OpenGL.Ext_FragmentProgram
end function
