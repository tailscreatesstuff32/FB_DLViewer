#include "globals.bi"
#include "misaka.bi"

#inclib "FB_MISAKA"

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

'////////////////////////////////////////////////////////////////////////////////////////////


sub RDP_SetupOpenGL()

RDP_InitGLExtensions()
RDP_ResetOpenGL()

end sub

sub RDP_SetOpenGLDimensions(_Width As Integer, _Height As Integer)

end sub

sub RDP_ResetOpenGL()
glShadeModel(GL_SMOOTH)
glEnable(GL_POINT_SMOOTH)
glHint(GL_POINT_SMOOTH_HINT, GL_NICEST)

glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)

glClearColor(0.2, 0.5, 0.7, 1.0)
glClearDepth(5.0)

glDepthFunc(GL_LEQUAL)
glEnable(GL_DEPTH_TEST)
glDepthMask(GL_TRUE)

glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)

dim as integer i
for i = 0 to 3
    Gfx.LightAmbient(i) = 1.0
    Gfx.LightDiffuse(i) = 1.0
    Gfx.LightSpecular(i) = 1.0
    Gfx.LightPosition(i) = 1.0
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

end sub

sub RDP_UpdateGLStates()

end sub

Function RDP_OpenGL_ExtFragmentProgram() As Boolean

end function
